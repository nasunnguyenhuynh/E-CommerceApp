from .models import *
from rest_framework import serializers


class UserSerializer(serializers.ModelSerializer):
    def create(self, validated_data):  # hash password be4 store in database
        data = validated_data.copy()
        user = User(**data)  # unpacking dict and pass them as arg into init model User
        user.set_password(user.password)
        user.save()

        return user

    class Meta:
        model = User
        fields = ['id', 'username', 'password', 'avatar', 'first_name', 'last_name', 'email', 'birthday', 'is_vendor']
        extra_kwargs = {  # prevent the password field returned when creating a new user
            'password': {
                'write_only': 'true'
            }
        }

    def to_representation(self, instance):  # Override a field
        rep = super().to_representation(instance)
        rep['avatar'] = instance.avatar.url if instance.avatar and hasattr(instance.avatar, 'url') else None
        return rep


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'


#                                              >>> ShopSerializer <<<
class ShopSerializer(serializers.ModelSerializer):
    class Meta:
        model = Shop
        fields = ['id', 'name', 'image', 'following', 'followed', 'rated']

    def to_representation(self, instance):
        rep = super().to_representation(instance)
        rep['image'] = instance.image.url

        return rep


class ShopConfirmationSerializer(serializers.ModelSerializer):
    class Meta:
        model = ShopConfirmation
        fields = ['citizen_identification_image', 'shop_name', 'shop_image', 'shop_description']

    def to_representation(self, instance):
        rep = super().to_representation(instance)
        rep['created_date'] = instance.created_date
        rep['updated_date'] = instance.updated_date
        rep['status'] = instance.status.status  # status is a ForeignKey to the ShopConfirmationStatus model
        rep['user'] = instance.user.username  # user is a ForeignKey to the User model
        rep['shop_description'] = instance.shop_description
        rep['citizen_identification_image'] = instance.citizen_identification_image.url
        rep['shop_name'] = instance.shop_name
        rep['shop_image'] = instance.shop_image.url
        return rep


#                                              >>> ProductSerializer <<<
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


class ProductInfoSerializer(serializers.ModelSerializer):
    details = ProductDetailSerializer(source='product_detail')  # used for OneToOne
    images = ProductImageSerializer(source='product_image', many=True)  # used for ManyToOne
    colors = ProductColorSerializer(source='product_color', many=True)  # used for ManyToOne
    videos = ProductVideoSerializer(source='product_video', many=True)  # used for ManyToOne

    class Meta:
        model = Product
        fields = ["id", "name", "price", "sold", "product_rating", "category", "shop_id", "details", "images", "colors",
                  "videos"]


class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ["id", "name", "price", "sold", "product_rating", "category", "shop_id"]


#                                              >>> OrderSerializer <<<
class OrderDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderDetail
        fields = ['id', 'quantity', 'price', 'order_id', 'product_id', 'color_id']


class OrderSerializer(serializers.ModelSerializer):
    status = serializers.CharField(source='status.status')
    payment_method = serializers.CharField(source='payment_method.name')
    shipping = serializers.CharField(source='shipping.name')
    product_review = serializers.SerializerMethodField()
    shop_review = serializers.SerializerMethodField()

    class Meta:
        model = Order
        fields = ['id', 'total_amount', 'user', 'status', 'payment_method', 'shipping', 'product_review', 'shop_review']

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if self.context.get('detail', False):
            self.fields['order_details'] = serializers.SerializerMethodField()

    def get_product_review(self, obj):  # All products in order rated? (Review can be only rating)
        return True if Rating.objects.filter(order=obj, is_shop=False).count() == OrderDetail.objects.filter(
            order=obj).count() else False

    def get_shop_review(self, obj):
        return True if Rating.objects.filter(order=obj, is_shop=True).count() == OrderDetail.objects.filter(
            order=obj).count() else False

    def get_order_details(self, obj):
        order_details = OrderDetail.objects.filter(order=obj)
        return OrderDetailSerializer(order_details, many=True).data


class OrderVoucherSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderVoucher
        fields = ['voucher']


#                                              >>> ReviewSerializer <<<
class CommentSerializer(serializers.ModelSerializer):  # POST, PATCH reviews
    class Meta:
        model = Comment
        fields = ['content', 'is_shop', 'parent_comment', 'is_parent']
        extra_kwargs = {
            'is_shop': {'required': False, 'default': False},
            'parent_comment': {'required': False},
            'is_parent': {'required': False, 'default': True}
        }


class RatingSerializer(serializers.ModelSerializer):  # POST, PATCH reviews
    class Meta:
        model = Rating
        fields = ['star', 'is_shop']
        extra_kwargs = {
            'is_shop': {'required': False, 'default': False},
        }


class ProductReviewSerializer(serializers.Serializer):  # Custom serializer for POST reviews
    comment = serializers.CharField(allow_blank=True)
    rating = serializers.IntegerField(max_value=5, min_value=1)
    order = serializers.IntegerField()
