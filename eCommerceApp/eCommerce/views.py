from rest_framework import viewsets, generics, status, parsers, permissions
from rest_framework.decorators import action, api_view
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

    @action(methods=['post', 'get'], url_path='orders', detail=True)  # /users/{user_id}/orders/
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
                        storage_products = StorageProduct.objects.filter(product_id=product['id'])  # Shop 1-n Storage
                        if not storage_products:  # product_id is existed ?
                            return Response({'error': 'product not found'}, status=status.HTTP_400_BAD_REQUEST)
                        for storage_product in storage_products:  # remain in store enough?
                            if storage_product.remain >= product['quantity']:
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
                                storage_product.remain -= product['quantity']
                                storage_product.save()
                                break
                        if not OrderDetail.objects.filter(order_id=order.id):
                            order.delete()
                            return Response({'error': f'product {product} out of stock'},
                                            status=status.HTTP_400_BAD_REQUEST)
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
                return Response({'success': "Your order has been created"}, status=status.HTTP_201_CREATED)
        if request.method == "GET":
            orders = self.get_object().order_set.select_related('user')
            print(orders)
            return Response(OrderSerializer(orders, many=True).data, status=status.HTTP_200_OK)


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
        order_id = request.data.get('order_id')
        amount = request.data.get('amount')
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
