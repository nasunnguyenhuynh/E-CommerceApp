from django.contrib import admin
from django.urls import path, include, re_path
from rest_framework import routers
from .views import *

r = routers.DefaultRouter()

r.register('users', UserViewSet, basename='users')
r.register('categories', CategoryViewset, basename='categories')
r.register('shops', ShopViewset, basename='shops')
r.register('products', ProductViewSet, basename='products')

urlpatterns = [
    path('', include(r.urls)),

    # vn pay api
    path('index', index, name='index'),
    path('payment/', payment, name='payment'),
    path('payment_ipn', payment_ipn, name='payment_ipn'),
    path('payment_return', payment_return, name='payment_return'),
    path('query', query, name='query'),
    path('refund', refund, name='refund'),
]
