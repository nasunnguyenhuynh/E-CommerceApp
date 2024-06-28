from rest_framework import viewsets, generics, status, parsers, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.generics import get_object_or_404
from django.db.models import Q, Count
from django.contrib.auth.hashers import make_password
from .serializers import *
from .models import *
from .pagination import *
import cloudinary.uploader


class UserViewSet(viewsets.ViewSet, generics.CreateAPIView):
    queryset = User.objects.filter(is_active=True)

    def get_permissions(self):
        if self.action in ['current_user', 'shop_confirmation', 'orders']:
            return [permissions.IsAuthenticated()]

        return [permissions.AllowAny(), ]

    @action(methods=['get', 'patch'], url_path='current-user', detail=False)  # /users/current-user/
    def current_user(self, request):
        self.parser_classes = [parsers.MultiPartParser]
        user = request.user
        if request.method.__eq__('PATCH'):  # PATCH must be uppercase
            restricted_keys = ['is_superuser', 'is_staff', 'is_active', 'is_vendor']
            for k, v in request.data.items():
                if k not in restricted_keys:
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
                if Shop.objects.filter(name=shop_name).exists():  # Check if the shop_name is already taken
                    return Response({'error': 'Shop name already taken.'}, status=status.HTTP_400_BAD_REQUEST)
                if citizen_identification_image and shop_image:
                    res_cii = cloudinary.uploader.upload(citizen_identification_image)
                    res_si = cloudinary.uploader.upload(shop_image)

                    cii_url = res_cii.get('secure_url')  # get cii_url uploaded cloudinary
                    si_url = res_si.get('secure_url')  # get si_url uploaded cloudinary

                    shopconfirmation = ShopConfirmation.objects. \
                        create(citizen_identification_image=cii_url,
                               shop_name=shop_name, shop_image=si_url, user_id=request.user.id, status_id=1)
                    shopconfirmation.save()
                    return Response({'success': 'Your request has been sent'}, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        if request.method == 'PATCH':
            shop_confirmation = get_object_or_404(ShopConfirmation, user_id=pk)
            serializer = ShopConfirmationSerializer(shop_confirmation, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(methods=['post'], url_path='orders', detail=True)  # /users/{user_id}/orders/
    def orders(self, request, pk=None):
        if request.method == "POST":
            # Difference of get & filter
            # Require user provide phone&address be4 send Req
            # Check voucher expired | satisfied condition ?
            # total_amount = (product_price * product_quantity) + shipping + voucher

            """ Sample JSON sent from client
                {   
                    "total_amount": 1299000,
                    "products": [
                        {
                            "id": 1,
                            "color": 1,
                            "quantity": 2
                        },
                        {
                            "id": 1,
                            "color": 2,
                            "quantity": 3
                        },
                        {
                            "id": 6,
                            "color": null,
                            "quantity": 3 
                        }
                    ],
                    "vouchers": [1],
                    "payment_method": 1,
                    "shipping": 3
                }
            """

            try:
                # USER
                user = User.objects.get(id=pk, is_active=True)

                # USER ADDRESS
                user_address = UserAddress.objects.get(user_id=pk, default=True)

                user_phone = UserPhone.objects.get(user_id=pk, default=True)

                # ORDER STATUS
                order_status = OrderStatus.objects.get(id=1)

                # PAYMENT METHOD
                payment_method = PaymentMethod.objects.get(id=request.data.get('payment_method'))

                # SHIPPING
                shipping = Shipping.objects.get(id=request.data.get('shipping'))

                try:  # Create Order
                    order = Order.objects.create(total_amount=request.data.get('total_amount'),
                                                 user=user,
                                                 status=order_status,
                                                 payment_method=payment_method,
                                                 shipping=shipping)
                except Exception as e:
                    print(f"Error: {e}")
                    return Response({'error': "There was an error while creating Order, plz try again later"},
                                    status=status.HTTP_400_BAD_REQUEST)

                try:  # Create OrderDetail
                    for product in request.data.get('products'):
                        if product['color']:
                            OrderDetail.objects.create(quantity=product['quantity'],
                                                       price=Product.objects.get(id=product['id']).price,
                                                       order=order,
                                                       product=Product.objects.get(id=product['id']),
                                                       color=ProductColor.objects.get(id=product['color']),
                                                       user_phone=user_phone,
                                                       user_address=user_address)
                        else:
                            OrderDetail.objects.create(quantity=product['quantity'],
                                                       price=Product.objects.get(id=product['id']).price,
                                                       order=order,
                                                       product=Product.objects.get(id=product['id']),
                                                       user_phone=user_phone,
                                                       user_address=user_address)
                except Exception as e:
                    print(f"Error: {e}")
                    order.delete()  # Remove out of db
                    return Response({'error': "There was an error while creating OrderDetail, plz try again later"},
                                    status=status.HTTP_400_BAD_REQUEST)
                for voucher in request.data.get('vouchers'):
                    if Voucher.objects.filter(id=voucher).first():
                        OrderVoucher.objects.create(user=user, voucher=Voucher.objects.get(id=voucher))

            except Exception as e:
                print(f"Error: {e}")
                return Response({'error': "There was an error occurred, plz try again later"},
                                status=status.HTTP_400_BAD_REQUEST)
            else:
                return Response({'mee': "OKE"}, status=status.HTTP_201_CREATED)


class CategoryViewset(viewsets.ViewSet, generics.ListAPIView):  # GET /categories/
    queryset = Category.objects.filter(active=True)
    serializer_class = CategorySerializer


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


class ProductViewSet(viewsets.ViewSet, generics.ListAPIView):  # GET /products/
    pagination_class = ProductPaginator
    queryset = Product.objects.filter(active=True)

    def get_serializer_class(self):  # Change serializer_class base on request
        if self.action == 'retrieve':
            return ProductInfoSerializer
        return ProductSerializer

    def retrieve(self, request, pk=None):  # GET /products/{product_id}
        product = get_object_or_404(self.queryset, pk=pk)
        serializer = self.get_serializer(product)
        return Response(serializer.data, status=status.HTTP_200_OK)

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
