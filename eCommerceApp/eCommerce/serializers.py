from .models import *
from rest_framework import serializers
from django.db.models import Sum


class UserLoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField()

    def validate(self, data):
        username = data.get('username')
        password = data.get('password')

        if not username:
            raise serializers.ValidationError("Username is required.")
        if not password:
            raise serializers.ValidationError("Password is required.")

        return data


class UserLoginWithSMSSerializer(serializers.Serializer):
    phone = serializers.CharField()

    def validate(self, data):
        phone = data.get('phone')
        if not phone:
            raise serializers.ValidationError("Phone number is required.")
        return data


class VerifyOTPSerializer(serializers.Serializer):
    otp = serializers.CharField()

    def validate(self, data):
        otp = data.get('otp')
        if not otp:
            raise serializers.ValidationError("OTP is required.")
        return data


class UserLoginWithGoogleSerializer(serializers.Serializer):
    email = serializers.EmailField()

    def validate(self, data):
        email = data.get('email')
        if not email:
            raise serializers.ValidationError("Email required.")
        return data


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


class UserAddressPhoneSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserAddressPhone
        fields = ['id', 'name', 'address', 'phone', 'default']


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name']


#                                              >>> ShopSerializer <<<
class ShopSerializer(serializers.ModelSerializer):
    total_product = serializers.SerializerMethodField()

    class Meta:
        model = Shop
        fields = ['id', 'name', 'image', 'following', 'followed', 'shop_rating', 'total_product']

    def get_total_product(self, obj):
        return Product.objects.filter(shop=obj).count()

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

    def to_representation(self, instance):  # Override a field
        rep = super().to_representation(instance)
        rep['image'] = instance.image.url if instance.image and hasattr(instance.image, 'url') else None
        return rep


class ProductImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductImage
        exclude = ['product']

    def to_representation(self, instance):  # Override a field
        rep = super().to_representation(instance)
        rep['image'] = instance.image.url if instance.image and hasattr(instance.image, 'url') else None
        return rep


class ProductVideoSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductVideo
        exclude = ['product']

    def to_representation(self, instance):  # Override a field
        rep = super().to_representation(instance)
        rep['video'] = instance.video.url if instance.video and hasattr(instance.video, 'url') else None
        return rep


class ProductDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductDetail
        exclude = ['product']


class ProductInfoSerializer(serializers.ModelSerializer):
    details = ProductDetailSerializer(source='product_detail')  # used for OneToOne
    images = ProductImageSerializer(source='product_image', many=True)  # used for ManyToOne
    colors = ProductColorSerializer(source='product_color', many=True)  # used for ManyToOne
    videos = ProductVideoSerializer(source='product_video', many=True)  # used for ManyToOne
    remain = serializers.SerializerMethodField()

    class Meta:
        model = Product
        fields = ["id", "name", "remain", "price", "sold", "product_rating", "category",
                  "shop_id", "details", "images", "colors", "videos"]

    def get_remain(self, obj):
        total_remain = StorageProduct.objects.filter(product=obj).aggregate(total=Sum('remain'))['total']
        return total_remain or 0


class ProductSerializer(serializers.ModelSerializer):
    images = ProductImageSerializer(source='product_image', many=True)  # used for ManyToOne

    class Meta:
        model = Product
        fields = ["id", "name", "price", "sold", "product_rating", "category", "shop_id", "images"]


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

    def get_product_review(self, obj):  # All products in order rated?
        return True if Rating.objects.filter(order=obj, is_shop=False).count() == OrderDetail.objects.filter(
            order=obj).count() else False

    def get_shop_review(self, obj):  # All shops in order rated? (Only need 1 product from that shop to review)
        return True \
            if OrderDetail.objects.filter(order=obj). \
                   values('product__shop').distinct().count() == Rating.objects.filter(order=obj, is_shop=True). \
                   values('product__shop').distinct().count() else False

    def get_order_details(self, obj):
        order_details = OrderDetail.objects.filter(order=obj)
        return OrderDetailSerializer(order_details, many=True).data


#                                              >>> PaymentMethodSerializer <<<
class PaymentMethodSerializer(serializers.ModelSerializer):
    class Meta:
        model = PaymentMethod
        fields = ['id', 'name']


class ShippingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Shipping
        fields = ['id', 'name', 'fee']


#                                              >>> VoucherSerializer <<<
class TinyProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ["id", "name"]


class VoucherConditionSerializer(serializers.ModelSerializer):
    categories = CategorySerializer(many=True)
    products = TinyProductSerializer(many=True)
    payment_methods = PaymentMethodSerializer(many=True)
    shippings = ShippingSerializer(many=True)

    class Meta:
        model = VoucherCondition
        fields = ['id', 'min_order_amount', 'discount', 'remain',
                  'products', 'categories', 'payment_methods', 'shippings']


class VoucherSerializer(serializers.ModelSerializer):
    start_date = serializers.SerializerMethodField()
    end_date = serializers.SerializerMethodField()
    voucher_type_name = serializers.CharField(source='voucher_type.name', read_only=True)  # Change to voucher_type_name
    conditions = VoucherConditionSerializer(many=True, source='voucher_conditions')

    class Meta:
        model = Voucher
        fields = ['id', 'name', 'code', 'is_multiple', 'start_date', 'end_date', 'voucher_type_name', 'conditions']

    def get_start_date(self, obj):
        return obj.start_date.strftime('%d/%m/%Y %H:%M:%S')

    def get_end_date(self, obj):
        return obj.end_date.strftime('%d/%m/%Y %H:%M:%S')


#                                              >>> ReviewSerializer <<<
class CommentSerializer(serializers.ModelSerializer):  # POST, PATCH reviews
    class Meta:
        model = Comment
        fields = ['id', 'content', 'is_shop', 'parent_comment', 'is_parent']
        extra_kwargs = {
            'is_shop': {'required': False, 'default': False},
            'parent_comment': {'required': False},
            'is_parent': {'required': False, 'default': True}
        }


class RatingSerializer(serializers.ModelSerializer):  # POST, PATCH reviews
    class Meta:
        model = Rating
        fields = ['id', 'star', 'is_shop']
        extra_kwargs = {
            'is_shop': {'required': False, 'default': False},
        }


class ProductReviewSerializer(serializers.Serializer):  # Custom serializer for POST reviews
    comment = serializers.CharField(allow_blank=False)
    rating = serializers.IntegerField(max_value=5, min_value=1)
    order = serializers.IntegerField()


class ShopReviewSerializer(serializers.Serializer):  # Custom serializer for POST reviews
    comment = serializers.CharField(allow_blank=False)
    rating = serializers.IntegerField(max_value=5, min_value=1)
    order = serializers.IntegerField()
    product = serializers.IntegerField()
