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
        fields = ["id", "name", "price", "sold", "rating", "category", "shop_id", "details", "images", "colors",
                  "videos"]


class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ["id", "name", "price", "sold", "rating", "category", "shop_id"]


class OrderDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderDetail
        fields = ['product', 'color', 'quantity']


class OrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = ['total_amount', 'user', 'status', 'payment_method', 'shipping']


class OrderVoucherSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderVoucher
        fields = ['voucher']

# Lấy thông tin sản phẩm và voucher từ dữ liệu yêu cầu.
# Lấy thông tin UserPhone và UserAddress mặc định từ cơ sở dữ liệu.
# Tạo đối tượng Order.
# Tính tổng số tiền (total_amount) dựa trên giá và số lượng của các sản phẩm.
# Tạo các đối tượng OrderDetail cho mỗi sản phẩm và màu sắc.
# Tạo các đối tượng OrderVoucher cho mỗi voucher.
