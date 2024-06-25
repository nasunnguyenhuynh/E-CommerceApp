from .models import *
from rest_framework import serializers


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'


class ShopSerializer(serializers.ModelSerializer):
    class Meta:
        model = Shop
        fields = ['id', 'name', 'image', 'following', 'followed', 'rated']

    def to_representation(self, instance):
        rep = super().to_representation(instance)
        rep['image'] = instance.image.url

        return rep


class ProductColorSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductColor
        exclude = ['product']


class ProductImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductImage
        exclude = ['product']


class ProductVideoSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductVideo
        exclude = ['product']


class ProductDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductDetail
        exclude = ['product']


class ProductSerializer(serializers.ModelSerializer):
    details = ProductDetailSerializer(source='product_detail')  # used for OneToOne
    images = ProductImageSerializer(source='product_image', many=True)  # used for ManyToOne
    colors = ProductColorSerializer(source='product_color', many=True)  # used for ManyToOne
    videos = ProductVideoSerializer(source='product_video', many=True)  # used for ManyToOne

    class Meta:
        model = Product
        fields = ["id", "name", "price", "sold", "rating", "category", "details", "images", "colors", "videos"]
