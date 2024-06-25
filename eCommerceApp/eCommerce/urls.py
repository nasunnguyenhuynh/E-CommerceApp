from django.contrib import admin
from django.urls import path, include, re_path
from rest_framework import routers
from .views import *

r = routers.DefaultRouter()

r.register('categories', CategoryViewset, basename='categories')
r.register('shops', ShopViewset, basename='shops')
r.register('products', ProductViewSet, basename='products')

urlpatterns = [
    path('', include(r.urls))
]
