from rest_framework import viewsets, generics, status, parsers, permissions
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action, api_view
from rest_framework.response import Response
from rest_framework.generics import get_object_or_404
from django.db.models import Q, Count
from django.db import transaction
from django.contrib.auth.hashers import make_password
from .serializers import *
from .models import *
from .pagination import *
import cloudinary.uploader
from oauth2_provider.models import AccessToken, RefreshToken
from django.utils import timezone  # Base on tz configured
from django.contrib.auth import logout, authenticate
from django.core.cache import cache
import os
from dotenv import load_dotenv

load_dotenv()  # take environment variables from .env.
from google.oauth2 import id_token
from google.auth.transport import requests as auth_requests

import secrets
import string


def generate_random_password(length=12):
    # Safe char collection
    characters = string.ascii_letters + string.digits + string.punctuation
    # Random password created
    password = ''.join(secrets.choice(characters) for _ in range(length))
    return password


def get_access_token_login(user):
    access_token = AccessToken.objects.filter(user_id=user.id).first()
    if access_token and access_token.expires > timezone.now():
        return access_token
    else:
        refresh_token = RefreshToken.objects.filter(user_id=user.id).first()
        if not access_token or not refresh_token:
            return None
        if refresh_token:
            access_token = AccessToken.objects.filter(id=refresh_token.access_token_id).first()
            access_token.expires = timezone.now() + timezone.timedelta(hours=1)
            access_token.save()
            return access_token


@api_view(['POST'])
def user_login(request):
    if request.method == 'POST':
        serializer = UserLoginSerializer(data=request.data)
        if serializer.is_valid():
            username = serializer.validated_data.get('username')
            password = serializer.validated_data.get('password')

            user = authenticate(request, username=username, password=password)
            if user is not None:
                access_token = get_access_token_login(user)
                return Response({'success': 'Login successfully', 'access_token': access_token.token},
                                status=status.HTTP_200_OK)

            return Response({'error': 'Invalid username/phone or password.'}, status=status.HTTP_401_UNAUTHORIZED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# OTP expires after 5 minutes
OTP_EXPIRY_SECONDS = 300


def generate_otp():
    return str(random.randint(100000, 999999))


@api_view(['POST'])
def login_with_sms(request):
    if request.method == 'POST':  # post phone + generate otp
        serializer = UserLoginWithSMSSerializer(data=request.data)
        if serializer.is_valid():
            phone = serializer.validated_data.get('phone')
            request.session['phone'] = phone  # Create session_phone_loginWithSms to verify
            otp = generate_otp()
            cache.set(phone, otp, timeout=OTP_EXPIRY_SECONDS)  # Create cache with key is phone to save OTP
            cache.set('is_login', True, timeout=OTP_EXPIRY_SECONDS)  # Create cache_is_login to verify
            # Send OTP to phone by Twilio
            # account_sid = 'ACf3bd63d2afda19fdcb1a7ab22793a8b8'
            # auth_token = '[AuthToken]'
            # client = Client(account_sid, auth_token)
            # message_body = f'DJANGO: Enter {otp} to verify account. OTP expires after 5 minutes.'
            # message = client.messages.create(
            # from_='+12513090557',
            # body=message_body,
            # to=phone_number
            # )
            return Response({'message': f'Your OTP is {otp}.'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def verify_otp(request):
    if request.method == 'POST':  # post phone + otp
        serializer = VerifyOTPSerializer(data=request.data)
        if serializer.is_valid():
            phone = request.session.get('phone')
            otp = serializer.validated_data.get('otp')

            cached_otp = cache.get(phone)  # Get OTP from cache
            if cached_otp is None:
                return Response({'message': 'OTP has expired.'}, status=status.HTTP_400_BAD_REQUEST)
            print('otp_cotp', otp == cached_otp)
            if otp == cached_otp:
                cache.delete(phone)  # Delete OTP cache after used
                if cache.get('is_login'):  # Delete cache_is_login
                    cache.delete('is_login')
                    user = User.objects.get(phone=phone, is_active=True)
                    del request.session['phone']  # Delete session phone
                    access_token = get_access_token_login(user)
                    return Response({'success': 'Login successfully', 'access_token': access_token.token},
                                    status=status.HTTP_200_OK)
            else:
                return Response({'message': 'OTP is not valid.'}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def login_with_google(request):
    if request.method == 'POST':
        try:
            # decodeIdToken
            decodeIdToken = id_token.verify_oauth2_token(request.data['idToken'], auth_requests.Request(),
                                                         os.getenv('WEB_CLIENT_ID'))

            # Check expiredToken
            if int(timezone.now().timestamp()) > decodeIdToken['exp']:
                return Response({'error': 'Token has expired'}, status=status.HTTP_400_BAD_REQUEST)
            # Compare tokenInfo & userInfo
            id_token_user_info = {
                "email": decodeIdToken['email'],
                "familyName": decodeIdToken.get('family_name', ''),
                "givenName": decodeIdToken.get('given_name', ''),
                "id": decodeIdToken['sub'],
                "name": decodeIdToken['name'],
                "photo": decodeIdToken.get('picture', '')
            }
            request_user_info = request.data['user']
            if id_token_user_info != request_user_info:
                return Response({'error': 'User information mismatch'}, status=status.HTTP_400_BAD_REQUEST)

            # Serialize and validate the email
            serializer = UserLoginWithGoogleSerializer(data={'email': request_user_info['email']})
            if serializer.is_valid():
                email = serializer.validated_data.get('email')

                users_with_email = User.objects.filter(email=email, is_active=1)
                if users_with_email.exists():
                    access_token = get_access_token_login(users_with_email.first())
                    return Response({'success': 'Login successfully', 'access_token': access_token.token},
                                    status=status.HTTP_200_OK)
                else:
                    # Register new account with email GG
                    username = secrets.token_hex(8)  # Generate random username
                    password = generate_random_password()
                    first_name = decodeIdToken.get('given_name', '')
                    last_name = decodeIdToken.get('family_name', '')
                    avatar = decodeIdToken.get('picture', '')

                    user = User.objects.create_user(
                        username=username,
                        password=password,
                        email=email,
                        first_name=first_name,
                        last_name=last_name,
                        avatar=avatar,
                        is_active=True
                    )
                    user.save()

                    # Generate access_token
                    access_token = create_access_token(username, password)

                    return Response({'success': 'Your account has been created, please login again.',
                                     'access_token': access_token}, status=status.HTTP_200_OK)
        except ValueError as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

    return Response({'error': 'Login with Google failed'}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def log_out(request):
    if request.method == 'POST':
        logout(request)
    return Response({'success': 'Logout successfully'}, status=status.HTTP_200_OK)


def create_access_token(username, password):
    data = {
        'grant_type': 'password',
        'username': username,
        'password': password,
        'client_id': os.getenv('APP_CLIENT_ID'),
        'client_secret': os.getenv('APP_CLIENT_SECRET')
    }

    response = requests.post('http://127.0.0.1:8000/o/token/', data=data)

    if response.status_code == 200:
        access_token = response.json().get('access_token')
        return access_token
    else:
        return None


@api_view(['POST'])
def user_signup(request):  # Signup with username + password -> Create Access_token
    if request.method == 'POST':
        serializer = UserLoginSerializer(data=request.data)
        if serializer.is_valid():
            username = serializer.validated_data.get('username')
            password = serializer.validated_data.get('password')

            # Check username used?
            existing_user = User.objects.filter(username=username).exists()
            if existing_user:
                return Response({'error': 'Username already used.'}, status=status.HTTP_400_BAD_REQUEST)

            user = User.objects.create_user(username=username, password=password)
            user.is_active = 1
            user.save()
            create_access_token(username, password)
            return Response({'success': 'Your account has been created, plz login again.'}, status=status.HTTP_200_OK)
    return Response({'error': 'Invalid username or password.'}, status=status.HTTP_401_UNAUTHORIZED)


class UserViewSet(viewsets.ViewSet, generics.CreateAPIView):
    queryset = User.objects.filter(is_active=True)

    def get_permissions(self):
        if self.action in ['current_user', 'shop_confirmation', 'orders']:
            return [permissions.IsAuthenticated()]

        return [permissions.AllowAny()]

    @action(methods=['get', 'patch'], url_path='current-user', detail=False)  # /users/current-user/
    def current_user(self, request):
        self.parser_classes = [parsers.MultiPartParser]
        user = request.user
        if request.method.__eq__('PATCH'):  # PATCH must be uppercase
            restricted_keys = ['is_superuser', 'is_staff', 'is_active', 'is_vendor']
            for k, v in request.data.items():
                if k not in restricted_keys:
                    if k == 'username':
                        # Check if the username already exists
                        if User.objects.filter(username=v).exclude(pk=user.pk).exists():
                            return Response({"error": "Username has been registered"},
                                            status=status.HTTP_400_BAD_REQUEST)
                    if k == 'password':
                        v = make_password(v)
                    setattr(user, k, v)
            user.save()

        return Response(UserSerializer(user).data, status=status.HTTP_200_OK)

    @action(methods=['get', 'post', 'patch'], url_path='shop-confirmation', detail=True)
    # /users/{user_id}/shop-confirmation/
    def shop_confirmation(self, request, pk=None):  # POST, GET, PATCH;
        self.parser_classes = [parsers.MultiPartParser]
        if int(pk) != request.user.id:  # Check user_id at url and user_id of request are match?
            return Response({'detail': 'You do not have permission to perform this action.'},
                            status=status.HTTP_403_FORBIDDEN)
        if request.method == 'GET':
            shop_confirmation = get_object_or_404(ShopConfirmation, user_id=pk, active=True)
            serializer = ShopConfirmationSerializer(shop_confirmation)
            return Response(serializer.data, status=status.HTTP_200_OK)
        if request.method == 'POST':
            serializer = ShopConfirmationSerializer(data=request.data)
            if serializer.is_valid():
                existed_form = ShopConfirmation.objects.filter(user_id=request.user.id, active=True).first()
                if existed_form:  # Check ShopConfirmation sent be4
                    if existed_form.status_id == 1:
                        return Response({'message': 'Your request is being reviewed.'},
                                        status=status.HTTP_400_BAD_REQUEST)
                    elif existed_form.status_id == 2:
                        return Response({'error': 'You cannot create a new shop.'}, status=status.HTTP_400_BAD_REQUEST)
                    elif existed_form.status_id == 3:
                        return Response({'message': 'Please update your information.'}, status=status.HTTP_200_OK)

                citizen_identification_image = serializer.validated_data.get('citizen_identification_image')
                shop_name = serializer.validated_data.get('shop_name')
                shop_image = serializer.validated_data.get('shop_image')
                shop_description = serializer.validated_data.get('shop_description')
                if Shop.objects.filter(name=shop_name).exists():  # Check if the shop_name is already taken
                    return Response({'error': 'Shop name already taken.'}, status=status.HTTP_400_BAD_REQUEST)
                if citizen_identification_image and shop_image:
                    res_cii = cloudinary.uploader.upload(citizen_identification_image)
                    res_si = cloudinary.uploader.upload(shop_image)

                    cii_url = res_cii.get('secure_url')  # get cii_url uploaded cloudinary
                    si_url = res_si.get('secure_url')  # get si_url uploaded cloudinary

                    shopconfirmation = ShopConfirmation.objects. \
                        create(citizen_identification_image=cii_url,
                               shop_name=shop_name, shop_image=si_url,
                               shop_description=shop_description,
                               user_id=request.user.id, status_id=1)
                    shopconfirmation.save()
                    return Response({'success': 'Your request has been sent'}, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        if request.method == 'PATCH':
            shop_confirmation = get_object_or_404(ShopConfirmation, user_id=pk)
            new_status = get_object_or_404(ShopConfirmationStatus, id=1)
            shop_confirmation.status = new_status
            serializer = ShopConfirmationSerializer(shop_confirmation, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(methods=['post', 'get'], url_path='orders', detail=True)  # /users/{user_id}/orders/
    def orders(self, request, pk=None):
        if int(pk) != request.user.id:  # Check user_id at url and user_id of request are match?
            return Response({'detail': 'You do not have permission to perform this action.'},
                            status=status.HTTP_403_FORBIDDEN)
        if request.method == "POST":
            try:  # Create Order
                with transaction.atomic():  # Ensure that all operations are atomic
                    # USER
                    user = User.objects.get(id=pk, is_active=True)

                    # USER ADDRESS PHONE
                    user_address_phone = UserAddressPhone.objects.get(user_id=pk, default=True)

                    # ORDER STATUS
                    order_status = OrderStatus.objects.get(id=1)

                    # PAYMENT METHOD
                    payment_method = PaymentMethod.objects.get(id=request.data.get('payment_method'))

                    # SHIPPING
                    shipping = Shipping.objects.get(id=request.data.get('shipping'))

                    # Create Order
                    order = Order.objects.create(total_amount=request.data.get('total_amount'),
                                                 user=user,
                                                 status=order_status,
                                                 payment_method=payment_method,
                                                 shipping=shipping,
                                                 user_address_phone=user_address_phone)

                    for product in request.data.get('products'):
                        storage_products = StorageProduct.objects.filter(product_id=product['id'])  # Shop 1-n Storage
                        if not storage_products:  # product_id is existed ?
                            order.delete()
                            return Response({'error': 'product not found'}, status=status.HTTP_400_BAD_REQUEST)
                        total = 0
                        for storage_product in storage_products:
                            total += storage_product.remain
                        if total < product['quantity']:
                            order.delete()
                            return Response({'error': f'product {product} out of stock'},
                                            status=status.HTTP_400_BAD_REQUEST)
                        product_quantity = product['quantity']
                        for storage_product in storage_products:  # Update storage_product & product_quantity
                            if storage_product.remain >= product_quantity:
                                storage_product.remain -= product_quantity
                                product_quantity = 0
                                print('storage_product.remain ', storage_product.remain)
                                storage_product.save()
                                break
                            else:
                                product_quantity -= storage_product.remain
                                storage_product.remain = 0
                                print('storage_product.remain ', storage_product.remain)
                                storage_product.save()

                        if product['color']:
                            OrderDetail.objects.create(quantity=product['quantity'],
                                                       price=Product.objects.get(id=product['id']).price,
                                                       order=order,
                                                       product=Product.objects.get(id=product['id']),
                                                       color=ProductColor.objects.get(id=product['color']))
                        else:
                            OrderDetail.objects.create(quantity=product['quantity'],
                                                       price=Product.objects.get(id=product['id']).price,
                                                       order=order,
                                                       product=Product.objects.get(id=product['id']))

                    # Validate Vouchers and Associate with Order
                    voucher_condition_ids = request.data.get('vouchers', [])
                    for voucher_condition_id in voucher_condition_ids:
                        try:
                            # Retrieve VoucherCondition
                            voucher_condition = VoucherCondition.objects.get(id=voucher_condition_id)

                            # Validate VoucherCondition
                            if voucher_condition.min_order_amount and order.total_amount < voucher_condition.min_order_amount:
                                order.delete()
                                return Response({
                                    'error': f'Order amount is less than the minimum required for VoucherCondition {voucher_condition_id}'},
                                    status=status.HTTP_400_BAD_REQUEST)

                            if voucher_condition.remain <= 0:
                                order.delete()
                                return Response({'error': f'VoucherCondition {voucher_condition_id} is out of stock'},
                                                status=status.HTTP_400_BAD_REQUEST)

                            # Associate VoucherCondition with Order
                            order.order_voucher_condition.add(voucher_condition)

                            # Update VoucherCondition remain
                            voucher_condition.remain -= 1
                            voucher_condition.save()

                            return Response({'order_id': f"{order.id}", 'total_amount': f"{order.total_amount}"},
                                            status=status.HTTP_201_CREATED)

                        except VoucherCondition.DoesNotExist:
                            order.delete()
                            return Response({'error': f'VoucherCondition {voucher_condition_id} does not exist'},
                                            status=status.HTTP_400_BAD_REQUEST)
            except Exception as e:
                print(f"Error: {e}")
                return Response({'error': "There was an error occurred, plz try again later"},
                                status=status.HTTP_400_BAD_REQUEST)
            return Response({'order_id': f"{order.id}", 'total_amount': f"{order.total_amount}"},
                            status=status.HTTP_201_CREATED)
        if request.method == "GET":
            orders = self.get_object().order_set.select_related('user')
            return Response(OrderSerializer(orders, many=True).data, status=status.HTTP_200_OK)

    @action(methods=['get'], url_path='orders/(?P<order_id>[^/.]+)', detail=True)  # /users/{user_id}/orders/{order_id}/
    def order_detail(self, request, pk=None, order_id=None):
        if int(pk) != request.user.id:
            return Response({'detail': 'You do not have permission to perform this action.'},
                            status=status.HTTP_403_FORBIDDEN)
        order = get_object_or_404(Order, pk=order_id, user_id=pk)
        serializer = OrderSerializer(order, context={'detail': True})
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(methods=['get', 'post', 'delete', 'patch'], url_path='address-phone', detail=True)
    # users/{user_id}/address-phone/
    def addresses(self, request, pk=None):
        if int(pk) != request.user.id:
            return Response({'detail': 'You do not have permission to perform this action.'},
                            status=status.HTTP_403_FORBIDDEN)
        if request.method == 'GET':
            address_phone = UserAddressPhone.objects.filter(user_id=pk).order_by('-default', '-id')
            serializer = UserAddressPhoneSerializer(address_phone, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        if request.method == 'POST':
            # Check if the user has any address-phone
            user_has_address_phone = UserAddressPhone.objects.filter(user=request.user).exists()

            # If the user has no address-phone, set 'default' to True
            data = request.data.copy()
            if not user_has_address_phone:
                data['default'] = True
            print('user_has_address_phone ', user_has_address_phone)
            serializer = UserAddressPhoneSerializer(data=data)
            if serializer.is_valid():
                # Save the new address-phone with the current user
                serializer.save(user=request.user)
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        if request.method == 'DELETE':
            address_phone_id = request.data.get('id')
            try:
                address_phone = UserAddressPhone.objects.get(id=address_phone_id, user_id=pk)

                # Check if the address-phone is the default
                if address_phone.default:
                    # Find another address-phone to set as default
                    other_address_phone = UserAddressPhone.objects.filter(user_id=pk).exclude(
                        id=address_phone_id).first()
                    if other_address_phone:
                        other_address_phone.default = True
                        other_address_phone.save()

                # Set the user field to null instead of deleting the address
                address_phone.user = None
                address_phone.save()
                return Response({'detail': 'Address-Phone disassociated successfully.'},
                                status=status.HTTP_204_NO_CONTENT)
            except UserAddressPhone.DoesNotExist:
                return Response({'detail': 'Address-Phone not found.'}, status=status.HTTP_404_NOT_FOUND)
        if request.method == 'PATCH':
            address_phone_id = request.data.get('id')
            try:
                address_phone = UserAddressPhone.objects.get(id=address_phone_id, user_id=pk)

                # Update the address/phone field if provided
                if 'address' in request.data:
                    address_phone.address = request.data['address']
                if 'phone' in request.data:
                    address_phone.phone = request.data['phone']
                if 'name' in request.data:
                    address_phone.name = request.data['name']
                # If 'default' is set to true, update other address-phone to set their 'default' to false
                if request.data.get('default'):
                    UserAddressPhone.objects.filter(user=request.user, default=True).update(default=False)
                    address_phone.default = True

                address_phone.save()
                return Response({'detail': 'AddressPhone updated successfully.'}, status=status.HTTP_200_OK)
            except UserAddressPhone.DoesNotExist:
                return Response({'detail': 'AddressPhone not found.'}, status=status.HTTP_404_NOT_FOUND)


class CategoryViewset(viewsets.ViewSet, generics.ListAPIView):  # GET /categories/
    queryset = Category.objects.filter(active=True)
    serializer_class = CategorySerializer

    @action(methods=['get'], url_path="products", detail=True)
    def get_products_by_category(self, request, pk):
        print(self.queryset)
        products = Product.objects.filter(category_id=pk, active=True)
        serializer = ProductSerializer(products, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class PaymentMethodViewset(viewsets.ViewSet, generics.ListAPIView):  # GET /payment-method/
    queryset = PaymentMethod.objects.filter(active=True)
    serializer_class = PaymentMethodSerializer


class ShippingViewset(viewsets.ViewSet, generics.ListAPIView):  # GET /shipping-unit/
    queryset = Shipping.objects.filter(active=True)
    serializer_class = ShippingSerializer


class VoucherViewset(viewsets.ViewSet, generics.ListAPIView):  # GET /vouchers/
    queryset = Voucher.objects.filter(active=True)
    serializer_class = VoucherSerializer


class UpdateVoucherConditionRemainView(APIView):  # PATCH /vouchers/{voucher_id}/condition/{condition_id}/
    permission_classes = [IsAuthenticated]  # Ensure user is authenticated

    def patch(self, request, voucher_id, condition_id):
        # Check if the authenticated user has the right to perform this action
        if int(request.user.id) != request.user.id:  # This condition is a placeholder; update with actual logic
            return Response({'detail': 'You do not have permission to perform this action.'},
                            status=status.HTTP_403_FORBIDDEN)

        try:
            # Retrieve the voucher
            voucher = Voucher.objects.get(id=voucher_id, active=True)
        except Voucher.DoesNotExist:
            return Response({"detail": "Voucher not found."}, status=status.HTTP_404_NOT_FOUND)

        try:
            # Retrieve the condition associated with the voucher
            condition = voucher.voucher_conditions.get(id=condition_id)
        except VoucherCondition.DoesNotExist:
            return Response({"detail": "VoucherCondition not found."}, status=status.HTTP_404_NOT_FOUND)

        # Decrement the 'remain' value by 1
        if condition.remain > 0:
            condition.remain -= 1
            condition.save()
            # Serialize and return the updated voucher
            serializer = VoucherSerializer(voucher)
            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            return Response({"detail": "Remain value is already at 0."}, status=status.HTTP_400_BAD_REQUEST)


class VoucherConditionViewset(viewsets.ViewSet, generics.ListAPIView):  # GET /voucher-conditions/
    queryset = VoucherCondition.objects.all()
    serializer_class = VoucherConditionSerializer


class ShopViewset(viewsets.ViewSet, generics.ListAPIView):  # GET /shops/
    queryset = Shop.objects.filter(active=True)
    serializer_class = ShopSerializer

    def retrieve(self, request, pk=None):  # GET /shops/{shop_id}
        shop = get_object_or_404(self.queryset, pk=pk)
        serializer = self.get_serializer(shop)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(methods=['get'], detail=True, url_path='products')  # GET /shops/{shop_id}/products/
    def get_products(self, request, pk=None):
        shop = get_object_or_404(Shop, pk=pk, active=True)
        products = Product.objects.filter(shop=shop)
        serializer = ProductSerializer(products, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(methods=['post', 'patch', 'get'], detail=True, url_path='reviews')  # /shops/{shop_id}/reviews/
    def create_update_retrieve_shop_review(self, request, pk=None):  # used by customer
        if request.method == 'POST':
            shop = get_object_or_404(self.queryset, pk=pk)
            serializer = ShopReviewSerializer(data=request.data)

            if serializer.is_valid():
                order = get_object_or_404(Order, pk=serializer.validated_data['order'])
                if order.user != request.user:
                    return Response({"error": "You do not have permission to review this order."},
                                    status=status.HTTP_403_FORBIDDEN)

                if str(order.status) != 'Order Delivered':
                    return Response({"error": "Cannot review without \'Order Delivered\' status"},
                                    status=status.HTTP_400_BAD_REQUEST)
                # Check if Product in Order
                product = get_object_or_404(Product, pk=serializer.validated_data['product'])
                if not OrderDetail.objects.filter(order=order, product=product).exists():
                    return Response({"error": "Product not in order."}, status=status.HTTP_400_BAD_REQUEST)

                # Check if Shop exists in Order through OrderDetail
                if not OrderDetail.objects.filter(order=order, product__shop=shop).exists():
                    return Response({"error": "Shop not in order."}, status=status.HTTP_400_BAD_REQUEST)

                # Check if shop_review exists in this order
                if Rating.objects.filter(order=order, product__shop=shop, is_shop=True).exists() or \
                        Comment.objects.filter(order=order, product__shop=shop, is_shop=True).exists():
                    return Response({"error": "Shop has already been reviewed for this order."},
                                    status=status.HTTP_400_BAD_REQUEST)

                if serializer.validated_data['comment']:
                    comment = Comment.objects.create(
                        user=request.user,
                        product=product,
                        order=order,
                        content=serializer.validated_data['comment'],
                        is_shop=True
                    )

                if serializer.validated_data['rating']:
                    rating = Rating.objects.create(
                        user=request.user,
                        product=product,
                        order=order,
                        star=serializer.validated_data['rating'],
                        is_shop=True
                    )
                # Update shop_rating
                ratings = Rating.objects.filter(product__shop=shop, is_shop=True)

                total_stars = sum(r.star for r in ratings)
                total_reviews = ratings.count()
                shop.shop_rating = round(total_stars / total_reviews, 1) if total_reviews > 0 else 0
                shop.save()

                return Response({
                    "comment": CommentSerializer(comment).data if serializer.validated_data['comment'] else None,
                    "rating": RatingSerializer(rating).data
                }, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        if request.method == 'PATCH':
            comment_data = request.data.get('comment')
            rating_data = request.data.get('rating')
            if comment_data:
                comment_id = comment_data.get('id')
                comment = get_object_or_404(Comment, id=comment_id)
                if comment.user != request.user or not comment.is_shop:
                    return Response({"error": "You do not have permission to edit this comment."},
                                    status=status.HTTP_403_FORBIDDEN)
                comment_serializer = CommentSerializer(comment, data=comment_data, partial=True)
                if comment_serializer.is_valid():
                    comment_serializer.save()
                else:
                    return Response(comment_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

            if rating_data:
                rating_id = rating_data.get('id')
                rating = get_object_or_404(Rating, id=rating_id)
                if rating.user != request.user or not rating.is_shop:
                    return Response({"error": "You do not have permission to edit this rating."},
                                    status=status.HTTP_403_FORBIDDEN)
                rating_serializer = RatingSerializer(rating, data=rating_data, partial=True)
                if rating_serializer.is_valid():
                    rating_serializer.save()
                else:
                    return Response(rating_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

            return Response({"message": "Review updated successfully."}, status=status.HTTP_200_OK)

        if request.method == 'GET':
            shop = get_object_or_404(self.queryset, pk=pk)
            # Retrieve the products associated with the shop
            products_in_shop = Product.objects.filter(shop=shop)
            # Get comments and ratings for products in this shop with is_shop=True
            comments = Comment.objects.filter(product__in=products_in_shop, is_shop=True)
            ratings = Rating.objects.filter(product__in=products_in_shop, is_shop=True)

            reviews = []
            for rating in ratings:
                comment = comments.filter(product=rating.product, is_shop=True, order=rating.order)
                if comment.count() == 2:  # 2nd comment belongs to shop owner
                    reviews.append({
                        "user": {
                            "id": comment[0].user.id,
                            "username": comment[0].user.username,
                            "avatar": f"{comment[0].user.avatar.url}"
                        },
                        "comment": {
                            "id": comment[0].id,
                            "content": comment[0].content,
                            "is_parent": comment[0].is_parent,
                            "parent_comment": comment[0].parent_comment,

                            "children": {
                                "user": {
                                    "id": comment[1].user.id,
                                    "username": comment[1].user.username,
                                    "avatar": f"{comment[1].user.avatar.url}"
                                },

                                "comment": {
                                    "id": comment[1].id,
                                    "content": comment[1].content,
                                    "is_parent": comment[1].is_parent,
                                    "parent_comment": comment[1].parent_comment.id,
                                }
                            }
                        },
                        "rating": {
                            "id": rating.id,
                            "star": rating.star
                        }
                    })

                if comment.count() == 1:
                    comment = comment.first()
                    reviews.append({
                        "user": {
                            "id": rating.user.id,
                            "username": rating.user.username,
                            "avatar": f"{rating.user.avatar.url}"
                        },
                        "comment": {
                            "id": comment.id,
                            "content": comment.content,
                            "is_parent": comment.is_parent,
                            "parent_comment": comment.parent_comment
                        },
                        "rating": {
                            "id": rating.id,
                            "star": rating.star
                        }
                    })

            return Response(reviews, status=status.HTTP_200_OK)


class ProductViewSet(viewsets.ViewSet, generics.ListAPIView, generics.UpdateAPIView):  # GET /products/
    pagination_class = ProductPaginator
    queryset = Product.objects.filter(active=True)
    serializer_class = ProductSerializer

    def get_permissions(self):
        if self.action in ['create_update_retrieve_product_review', 'comment']:
            return [permissions.IsAuthenticated()]

        return [permissions.AllowAny()]

    def retrieve(self, request, pk=None):  # GET /products/{product_id}
        product = get_object_or_404(self.queryset, pk=pk)
        return Response(ProductInfoSerializer(product).data, status=status.HTTP_200_OK)

    def get_queryset(self):  # query with product_name, shop_name, product_price
        queries = self.queryset

        product_name = self.request.query_params.get("product_name")  # name product
        pmn = self.request.query_params.get("pmn")  # price min
        pmx = self.request.query_params.get("pmx")  # price max
        opi = self.request.query_params.get("opi")  # order price increase
        opd = self.request.query_params.get("opd")  # order price decrease
        oni = self.request.query_params.get("oni")  # order name increase
        ond = self.request.query_params.get("ond")  # order name decrease
        cate_name = self.request.query_params.get('cate_name')  # filter by category name
        if self.action == 'list':
            if product_name:
                queries = queries.filter(Q(name__icontains=product_name) | Q(shop__name__icontains=product_name))
            if pmn:
                queries = queries.filter(price__gte=pmn)
            if pmx:
                queries = queries.filter(price__lte=pmx)
            if opi is not None:
                queries = queries.order_by('price')
            if opd is not None:
                queries = queries.order_by('-price')
            if oni is not None:
                queries = queries.order_by('name')
            if ond is not None:
                queries = queries.order_by('-name')
            if cate_name:
                queries = queries.filter(category__name__icontains=cate_name)

        return queries

    @action(methods=['post', 'patch', 'get'], url_path="reviews", detail=True)  # /products/{product_id}/reviews/
    def create_update_retrieve_product_review(self, request, pk=None):  # used by customer
        if request.method == 'POST':
            product = get_object_or_404(self.queryset, pk=pk)
            serializer = ProductReviewSerializer(data=request.data)

            if serializer.is_valid():
                order_id = serializer.validated_data['order']
                order = get_object_or_404(Order, pk=order_id)
                if order.user != request.user:
                    return Response({"error": "You do not have permission to review this order."},
                                    status=status.HTTP_403_FORBIDDEN)

                if str(order.status) != 'Order Delivered':
                    return Response({"error": "Cannot review without \'Order Delivered\' status"},
                                    status=status.HTTP_400_BAD_REQUEST)

                if not product.orderdetail_set.filter(order=order).exists():
                    return Response({"error": "Product not in order."}, status=status.HTTP_400_BAD_REQUEST)

                if Rating.objects.filter(order=order, is_shop=False, product=product).exists() or \
                        Comment.objects.filter(order=order, is_shop=False, product=product).exists():
                    print(Rating.objects.filter(order=order, is_shop=False, product=product).exists())
                    return Response({"error": "Product has been reviewed"}, status=status.HTTP_400_BAD_REQUEST)

                comment_data = serializer.validated_data['comment']
                rating_data = serializer.validated_data['rating']

                if comment_data:
                    comment = Comment.objects.create(
                        user=request.user,
                        product=product,
                        order=order,
                        content=comment_data,
                    )

                if rating_data:
                    rating = Rating.objects.create(
                        user=request.user,
                        product=product,
                        order=order,
                        star=rating_data
                    )
                #   Update product_sold & product_rating
                product.sold += 1
                ratings = Rating.objects.filter(product=product, is_shop=False)
                total_stars = sum(r.star for r in ratings)
                total_reviews = ratings.count()
                product.product_rating = round(total_stars / total_reviews, 1) if total_reviews > 0 else 0

                product.save()

                return Response({
                    "comment": CommentSerializer(comment).data if comment_data else None,
                    "rating": RatingSerializer(rating).data
                }, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        if request.method == 'PATCH':
            product = get_object_or_404(self.queryset, pk=pk)

            comment_data = request.data.get('comment')
            rating_data = request.data.get('rating')
            if comment_data:
                comment_id = comment_data.get('id')
                comment = get_object_or_404(Comment, id=comment_id)
                if comment.user != request.user or comment.is_shop:
                    return Response({"error": "You do not have permission to edit this comment."},
                                    status=status.HTTP_403_FORBIDDEN)
                comment_serializer = CommentSerializer(comment, data=comment_data, partial=True)
                if comment_serializer.is_valid():
                    comment_serializer.save()
                else:
                    return Response(comment_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

            if rating_data:
                rating_id = rating_data.get('id')
                rating = get_object_or_404(Rating, id=rating_id)
                if rating.user != request.user or rating.is_shop:
                    return Response({"error": "You do not have permission to edit this rating."},
                                    status=status.HTTP_403_FORBIDDEN)
                rating_serializer = RatingSerializer(rating, data=rating_data, partial=True)
                if rating_serializer.is_valid():
                    rating_serializer.save()
                else:
                    return Response(rating_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

            return Response({"message": "Review updated successfully."}, status=status.HTTP_200_OK)
        if request.method == 'GET':
            product = get_object_or_404(self.queryset, pk=pk)

            comments = Comment.objects.filter(product=product, is_shop=False)
            ratings = Rating.objects.filter(product=product, is_shop=False)

            reviews = []
            for rating in ratings:
                comment = comments.filter(product=product, is_shop=False, order=rating.order)
                if comment.count() == 2:  # 2nd comment belongs to shop owner
                    reviews.append({
                        "user": {
                            "id": comment[0].user.id,
                            "username": comment[0].user.username,
                            "avatar": f"{comment[0].user.avatar.url}"
                        },
                        "comment": {
                            "id": comment[0].id,
                            "content": comment[0].content,
                            "is_parent": comment[0].is_parent,
                            "parent_comment": comment[0].parent_comment,

                            "children": {
                                "user": {
                                    "id": comment[1].user.id,
                                    "username": comment[1].user.username,
                                    "avatar": f"{comment[1].user.avatar.url}"
                                },

                                "comment": {
                                    "id": comment[1].id,
                                    "content": comment[1].content,
                                    "is_parent": comment[1].is_parent,
                                    "parent_comment": comment[1].parent_comment.id,
                                }
                            }
                        },
                        "rating": {
                            "id": rating.id,
                            "star": rating.star
                        }
                    })

                if comment.count() == 1:
                    comment = comment.first()
                    reviews.append({
                        "user": {
                            "id": rating.user.id,
                            "username": rating.user.username,
                            "avatar": f"{rating.user.avatar.url}"
                        },
                        "comment": {
                            "id": comment.id,
                            "content": comment.content,
                            "is_parent": comment.is_parent,
                            "parent_comment": comment.parent_comment
                        },
                        "rating": {
                            "id": rating.id,
                            "star": rating.star
                        }
                    })
            return Response(reviews, status=status.HTTP_200_OK)

    @action(methods=['post', 'patch', 'delete', 'get'], url_path="comment", detail=True)
    # /products/{product_id}/comment/
    def comment(self, request, pk=None):  # used by customer, shop_owner
        if request.method == 'POST':
            product = get_object_or_404(self.queryset, pk=pk)
            serializer = CommentSerializer(data=request.data)
            if serializer.is_valid():  # Check parent_comment, content
                parent_comment = serializer.validated_data['parent_comment'] if request.data['parent_comment'] else None
                content = serializer.validated_data['content']

                if parent_comment:  # Update parent_comment
                    comment = get_object_or_404(Comment, id=parent_comment.id)
                    comment.is_parent = True
                    comment.save()

                comment = Comment.objects.create(
                    user=request.user,
                    product=product,
                    content=content,

                    parent_comment=parent_comment if parent_comment else None,
                    order=parent_comment.order if parent_comment and parent_comment.order else None,
                    is_shop=parent_comment.is_shop if parent_comment and parent_comment.is_shop else False
                )
                return Response(CommentSerializer(comment).data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        if request.method == 'PATCH':
            product = get_object_or_404(self.queryset, pk=pk)
            serializer = CommentSerializer(data=request.data)
            if serializer.is_valid():
                content = serializer.validated_data['content']
                comment = get_object_or_404(Comment, pk=request.data['comment_id'])
                if comment.user != request.user:
                    return Response({"error": "You do not have permission."},
                                    status=status.HTTP_403_FORBIDDEN)
                comment.content = content
                comment.save()

                return Response(CommentSerializer(comment).data, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        if request.method == 'DELETE':
            product = get_object_or_404(self.queryset, pk=pk)
            comment = get_object_or_404(Comment, pk=request.data['comment_id'])
            if comment.user != request.user:
                return Response({"error": "You do not have permission."},
                                status=status.HTTP_403_FORBIDDEN)

            if comment.parent_comment:  # Has parent ?
                if Comment.objects.filter(parent_comment=comment.parent_comment).count() < 2:  # Parent has one child?
                    parent_comment = Comment.objects.filter(id=comment.parent_comment.id).first()
                    parent_comment.is_parent = False
                    parent_comment.save()

            comment.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)

        if request.method == 'GET':
            product = get_object_or_404(self.queryset, pk=pk)
            comments = Comment.objects. \
                filter(product=product, is_shop=False, order_id=None, parent_comment=None).order_by('-id')

            comments_detail = []
            for comment in comments:
                comments_detail.append({
                    "user": {
                        "id": comment.user.id,
                        "username": comment.user.username,
                        "avatar": f"{comment.user.avatar.url}"
                    },
                    "comment": {
                        "id": comment.id,
                        "content": comment.content,
                        "is_shop": comment.is_shop,
                        "is_parent": comment.is_parent,
                        "parent_comment": comment.parent_comment.id if comment.parent_comment else None
                    }
                })
            return Response(comments_detail, status=status.HTTP_200_OK)

    @action(methods=['get'], url_path="comment/(?P<comment_id>[^/.]+)", detail=True)
    # /products/{product_id}/comment/{comment_id}
    def get_comment_by_parent_comment_id(self, request, pk=None, comment_id=None):
        if request.method == 'GET':
            product = get_object_or_404(self.queryset, pk=pk)
            comments = Comment.objects.filter(product=product, is_shop=False, parent_comment_id=comment_id)

            comments_detail = []
            for comment in comments:
                comments_detail.append({
                    "user": {
                        "id": comment.user.id,
                        "username": comment.user.username,
                        "avatar": f"{comment.user.avatar.url}"
                    },
                    "comment": {
                        "id": comment.id,
                        "content": comment.content,
                        "is_shop": comment.is_shop,
                        "is_parent": comment.is_parent,
                        "parent_comment": comment.parent_comment.id if comment.parent_comment else None
                    }
                })
            return Response(comments_detail, status=status.HTTP_200_OK)


import hashlib
import hmac
import json
import random
import requests
from datetime import datetime
from django.conf import settings
from django.http import JsonResponse
from django.shortcuts import render
from .vnpay import vnpay


def index(request):
    return render(request, "index.html", {"title": "Danh sách demo"})


def hmacsha512(key, data):
    byteKey = key.encode('utf-8')
    byteData = data.encode('utf-8')
    return hmac.new(byteKey, byteData, hashlib.sha512).hexdigest()


@api_view(['POST'])
def payment(request):
    if request.method == 'POST':
        # Process input data and build url payment
        order_id = int(request.data.get('order_id'))
        amount = int(request.data.get('amount'))
        order_type = "billpayment"
        order_desc = 'Order payment for eCommerceApp'
        bank_code = ""
        language = "vn"
        ipaddr = get_client_ip(request)
        # Build URL Payment
        vnp = vnpay()
        vnp.requestData['vnp_Version'] = '2.1.0'  # API version
        vnp.requestData['vnp_Command'] = 'pay'  # API code
        vnp.requestData['vnp_TmnCode'] = settings.VNPAY_TMN_CODE  # Website code
        vnp.requestData['vnp_Amount'] = amount * 100  # Remove decimal
        vnp.requestData['vnp_CurrCode'] = 'VND'
        vnp.requestData['vnp_TxnRef'] = order_id
        vnp.requestData['vnp_OrderInfo'] = order_desc
        vnp.requestData['vnp_OrderType'] = order_type
        # Check language, default: vn
        if language and language != '':
            vnp.requestData['vnp_Locale'] = language
        else:
            vnp.requestData['vnp_Locale'] = 'vn'
            # Check bank_code, if bank_code is empty, customer will be selected bank on VNPAY
        if bank_code and bank_code != "":
            vnp.requestData['vnp_BankCode'] = bank_code

        vnp.requestData['vnp_CreateDate'] = datetime.now().strftime('%Y%m%d%H%M%S')  # 20150410063022
        vnp.requestData['vnp_IpAddr'] = ipaddr
        vnp.requestData['vnp_ReturnUrl'] = settings.VNPAY_RETURN_URL
        vnpay_payment_url = vnp.get_payment_url(settings.VNPAY_PAYMENT_URL, settings.VNPAY_HASH_SECRET_KEY)
        print('vnpay_payment_url ', vnpay_payment_url)

        return Response({"url": vnpay_payment_url}, status=status.HTTP_200_OK)

    else:
        return Response({"error": "Method not allowed"}, status=status.HTTP_405_METHOD_NOT_ALLOWED)


def payment_ipn(request):
    inputData = request.GET
    if inputData:
        vnp = vnpay()
        vnp.responseData = inputData.dict()
        order_id = inputData['vnp_TxnRef']
        amount = inputData['vnp_Amount']
        order_desc = inputData['vnp_OrderInfo']
        vnp_TransactionNo = inputData['vnp_TransactionNo']
        vnp_ResponseCode = inputData['vnp_ResponseCode']
        vnp_TmnCode = inputData['vnp_TmnCode']
        vnp_PayDate = inputData['vnp_PayDate']
        vnp_BankCode = inputData['vnp_BankCode']
        vnp_CardType = inputData['vnp_CardType']
        if vnp.validate_response(settings.VNPAY_HASH_SECRET_KEY):
            # Check & Update Order Status in your Database
            # Your code here
            firstTimeUpdate = True
            totalamount = True
            if totalamount:
                if firstTimeUpdate:
                    if vnp_ResponseCode == '00':
                        print('Payment Success. Your code implement here')
                    else:
                        print('Payment Error. Your code implement here')

                    # Return VNPAY: Merchant update success
                    result = JsonResponse({'RspCode': '00', 'Message': 'Confirm Success'})
                else:
                    # Already Update
                    result = JsonResponse({'RspCode': '02', 'Message': 'Order Already Update'})
            else:
                # invalid amount
                result = JsonResponse({'RspCode': '04', 'Message': 'invalid amount'})
        else:
            # Invalid Signature
            result = JsonResponse({'RspCode': '97', 'Message': 'Invalid Signature'})
    else:
        result = JsonResponse({'RspCode': '99', 'Message': 'Invalid request'})

    return result


def payment_return(request):
    inputData = request.GET
    if inputData:
        vnp = vnpay()
        vnp.responseData = inputData.dict()
        order_id = inputData['vnp_TxnRef']
        amount = int(inputData['vnp_Amount']) / 100
        order_desc = inputData['vnp_OrderInfo']
        vnp_TransactionNo = inputData['vnp_TransactionNo']
        vnp_ResponseCode = inputData['vnp_ResponseCode']
        vnp_TmnCode = inputData['vnp_TmnCode']
        vnp_PayDate = inputData['vnp_PayDate']
        vnp_BankCode = inputData['vnp_BankCode']
        vnp_CardType = inputData['vnp_CardType']

        if vnp.validate_response(settings.VNPAY_HASH_SECRET_KEY):
            if vnp_ResponseCode == "00":
                # Update order_status
                order_ecommerce = Order.objects.filter(id=order_id).first()
                if not order_ecommerce:
                    return JsonResponse({"error": "order_id not found"}, status=status.HTTP_404_NOT_FOUND)
                order_ecommerce.status_id = 2  # Paid
                order_ecommerce.save()

                payment_vnpay_detail = PaymentVNPAYDetail.objects.create(order_id=order_id, amount=amount,
                                                                         order_desc=order_desc,
                                                                         vnp_TransactionNo=vnp_TransactionNo,
                                                                         vnp_ResponseCode=vnp_ResponseCode,
                                                                         vnp_PayDate=vnp_PayDate)
                payment_vnpay_detail.save()

                return render(request, "payment_return.html", {"title": "Kết quả thanh toán",
                                                               "result": "Thành công", "order_id": order_id,
                                                               "amount": amount,
                                                               "order_desc": order_desc,
                                                               "vnp_TransactionNo": vnp_TransactionNo,
                                                               "vnp_ResponseCode": vnp_ResponseCode})
            else:
                return render(request, "payment_return.html", {"title": "Kết quả thanh toán",
                                                               "result": "Lỗi", "order_id": order_id,
                                                               "amount": amount,
                                                               "order_desc": order_desc,
                                                               "vnp_TransactionNo": vnp_TransactionNo,
                                                               "vnp_ResponseCode": vnp_ResponseCode})
        else:
            return render(request, "payment_return.html",
                          {"title": "Kết quả thanh toán", "result": "Lỗi", "order_id": order_id, "amount": amount,
                           "order_desc": order_desc, "vnp_TransactionNo": vnp_TransactionNo,
                           "vnp_ResponseCode": vnp_ResponseCode, "msg": "Sai checksum"})
    else:
        return render(request, "payment_return.html", {"title": "Kết quả thanh toán", "result": ""})


def get_client_ip(request):
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0]
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip


n = random.randint(10 ** 11, 10 ** 12 - 1)
n_str = str(n)
while len(n_str) < 12:
    n_str = '0' + n_str


def query(request):
    if request.method == 'GET':
        return render(request, "query.html", {"title": "Kiểm tra kết quả giao dịch"})

    url = settings.VNPAY_API_URL
    secret_key = settings.VNPAY_HASH_SECRET_KEY
    vnp_TmnCode = settings.VNPAY_TMN_CODE
    vnp_Version = '2.1.0'

    vnp_RequestId = n_str
    vnp_Command = 'querydr'
    vnp_TxnRef = request.POST['order_id']
    vnp_OrderInfo = 'kiem tra gd'
    vnp_TransactionDate = request.POST['trans_date']
    vnp_CreateDate = datetime.now().strftime('%Y%m%d%H%M%S')
    vnp_IpAddr = get_client_ip(request)

    hash_data = "|".join([
        vnp_RequestId, vnp_Version, vnp_Command, vnp_TmnCode,
        vnp_TxnRef, vnp_TransactionDate, vnp_CreateDate,
        vnp_IpAddr, vnp_OrderInfo
    ])

    secure_hash = hmac.new(secret_key.encode(), hash_data.encode(), hashlib.sha512).hexdigest()

    data = {
        "vnp_RequestId": vnp_RequestId,
        "vnp_TmnCode": vnp_TmnCode,
        "vnp_Command": vnp_Command,
        "vnp_TxnRef": vnp_TxnRef,
        "vnp_OrderInfo": vnp_OrderInfo,
        "vnp_TransactionDate": vnp_TransactionDate,
        "vnp_CreateDate": vnp_CreateDate,
        "vnp_IpAddr": vnp_IpAddr,
        "vnp_Version": vnp_Version,
        "vnp_SecureHash": secure_hash
    }

    headers = {"Content-Type": "application/json"}

    response = requests.post(url, headers=headers, data=json.dumps(data))

    if response.status_code == 200:
        response_json = json.loads(response.text)
    else:
        response_json = {"error": f"Request failed with status code: {response.status_code}"}

    return render(request, "query.html", {"title": "Kiểm tra kết quả giao dịch", "response_json": response_json})


def refund(request):
    if request.method == 'GET':
        return render(request, "refund.html", {"title": "Hoàn tiền giao dịch"})

    url = settings.VNPAY_API_URL
    secret_key = settings.VNPAY_HASH_SECRET_KEY
    vnp_TmnCode = settings.VNPAY_TMN_CODE
    vnp_RequestId = n_str
    vnp_Version = '2.1.0'
    vnp_Command = 'refund'
    vnp_TransactionType = request.POST['TransactionType']
    vnp_TxnRef = request.POST['order_id']
    vnp_Amount = request.POST['amount']
    vnp_OrderInfo = request.POST['order_desc']
    vnp_TransactionNo = '0'
    vnp_TransactionDate = request.POST['trans_date']
    vnp_CreateDate = datetime.now().strftime('%Y%m%d%H%M%S')
    vnp_CreateBy = 'user01'
    vnp_IpAddr = get_client_ip(request)

    hash_data = "|".join([
        vnp_RequestId, vnp_Version, vnp_Command, vnp_TmnCode, vnp_TransactionType, vnp_TxnRef,
        vnp_Amount, vnp_TransactionNo, vnp_TransactionDate, vnp_CreateBy, vnp_CreateDate,
        vnp_IpAddr, vnp_OrderInfo
    ])

    secure_hash = hmac.new(secret_key.encode(), hash_data.encode(), hashlib.sha512).hexdigest()

    data = {
        "vnp_RequestId": vnp_RequestId,
        "vnp_TmnCode": vnp_TmnCode,
        "vnp_Command": vnp_Command,
        "vnp_TxnRef": vnp_TxnRef,
        "vnp_Amount": vnp_Amount,
        "vnp_OrderInfo": vnp_OrderInfo,
        "vnp_TransactionDate": vnp_TransactionDate,
        "vnp_CreateDate": vnp_CreateDate,
        "vnp_IpAddr": vnp_IpAddr,
        "vnp_TransactionType": vnp_TransactionType,
        "vnp_TransactionNo": vnp_TransactionNo,
        "vnp_CreateBy": vnp_CreateBy,
        "vnp_Version": vnp_Version,
        "vnp_SecureHash": secure_hash
    }

    headers = {"Content-Type": "application/json"}

    response = requests.post(url, headers=headers, data=json.dumps(data))

    if response.status_code == 200:
        response_json = json.loads(response.text)
    else:
        response_json = {"error": f"Request failed with status code: {response.status_code}"}

    return render(request, "refund.html", {"title": "Kết quả hoàn tiền giao dịch", "response_json": response_json})
