from django.contrib import admin
from django.urls import path, include, re_path
from rest_framework import routers
from .views import *

r = routers.DefaultRouter()

r.register('users', UserViewSet, basename='users')
r.register('categories', CategoryViewset, basename='categories')
r.register('payment-method', PaymentMethodViewset, basename='payment-method')
r.register('shipping-unit', ShippingViewset, basename='shipping-unit')
r.register('vouchers', VoucherViewset, basename='vouchers')
r.register('voucher-conditions', VoucherConditionViewset, basename='voucher-conditions')
r.register('shops', ShopViewset, basename='shops')
r.register('products', ProductViewSet, basename='products')

urlpatterns = [
    path('', include(r.urls)),

    path('accounts/login/', user_login, name='login'),
    path('accounts/login-with-sms/', login_with_sms, name='login_with_sms'),
    path('accounts/login-with-google/', login_with_google, name='login_with_google'),
    path('accounts/signup/', user_signup, name='signup'),
    path('accounts/logout/', log_out, name='logout'),
    path('accounts/verify-otp/', verify_otp, name='verify_otp'),
    path('vouchers/<int:voucher_id>/condition/<int:condition_id>/',
         UpdateVoucherConditionRemainView.as_view(), name='update-voucher-condition-remain'),

    # vn pay api
    path('index', index, name='index'),
    path('payment/', payment, name='payment'),
    path('payment_ipn', payment_ipn, name='payment_ipn'),
    path('payment_return', payment_return, name='payment_return'),
    path('query', query, name='query'),
    path('refund', refund, name='refund'),
]
