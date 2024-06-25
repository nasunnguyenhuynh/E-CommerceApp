from rest_framework import viewsets, generics
from .serializers import *
from .models import *


class CategoryViewset(viewsets.ViewSet, generics.ListAPIView):  # GET method
    queryset = Category.objects.filter(active=True)
    serializer_class = CategorySerializer
