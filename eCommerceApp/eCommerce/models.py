from django.db import models
from django.contrib.auth.models import AbstractUser
from ckeditor.fields import RichTextField
from cloudinary.models import CloudinaryField
from django.core.exceptions import ValidationError


# blank, null, default; ForeignKey


class User(AbstractUser):
    avatar = CloudinaryField('image',
                             default='https://res.cloudinary.com/diwxda8bi/image/upload/v1718958489'
                                     '/rylzc2jtcpgta2ilize3.jpg')
    is_vendor = models.BooleanField(default=False)
    birthday = models.DateField(null=True, blank=True)


class UserAddress(models.Model):
    address = models.CharField(max_length=150)
    default = models.BooleanField(default=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='user_address')


class UserPhone(models.Model):
    phone = models.CharField(max_length=10)
    default = models.BooleanField(default=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='user_phone')


class BaseModel(models.Model):
    created_date = models.DateField(auto_now_add=True)
    updated_date = models.DateField(auto_now=True)
    active = models.BooleanField(default=True)

    class Meta:
        abstract = True  # not created in database
        ordering = ['-id']


class Category(BaseModel):  # Category cant be duplicate
    name = models.CharField(max_length=50, unique=True)

    class Meta:  # For enhance display admin site
        verbose_name = "Category"
        verbose_name_plural = "Categories"

    def __str__(self):
        return self.name


class Shop(BaseModel):  # Shop cant be duplicate
    name = models.CharField(max_length=100, unique=True)
    image = CloudinaryField()
    description = RichTextField()
    following = models.IntegerField(default=0)
    followed = models.IntegerField(default=0)
    rated = models.FloatField(null=True, default=0)
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='user_shop')

    def __str__(self):
        return self.name


class ShopConfirmationStatus(models.Model):
    status = models.CharField(max_length=50)

    def __str__(self):
        return self.status


class ShopConfirmation(BaseModel):
    citizen_identification_image = CloudinaryField()
    shop_name = models.CharField(max_length=50)
    shop_image = CloudinaryField()
    shop_description = RichTextField(blank=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='user_shopconfirmation')
    status = models.ForeignKey(ShopConfirmationStatus, on_delete=models.CASCADE, related_name='shop_confirmationstatus')


class Product(BaseModel):  # Product can be duplicate
    name = models.CharField(max_length=150)
    price = models.FloatField(null=False)
    sold = models.IntegerField(default=0)
    rating = models.FloatField(default=0)
    category = models.ForeignKey(Category, on_delete=models.PROTECT, related_name='product_category')
    shop = models.ForeignKey(Shop, on_delete=models.CASCADE, related_name='product_shop')

    def __str__(self):
        return self.name


class ProductDetail(models.Model):
    material = models.CharField(max_length=50)
    manufactory = models.CharField(max_length=50)
    description = RichTextField()
    product = models.OneToOneField(Product, on_delete=models.CASCADE, related_name='product_detail')


class ProductColor(models.Model):  # ProductColor can be duplicate
    name = models.CharField(max_length=50)
    image = CloudinaryField()
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='product_color')


class ProductImage(models.Model):  # ProductImage can be duplicate
    image = CloudinaryField()
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='product_image')


def validate_video_size(value):
    max_size = 30 * 1024 * 1024  # 30MB
    if str(value).endswith(".mp4"):
        if value.size > max_size:
            raise ValidationError("Hông được đăng video quá 30MB !")


class ProductVideo(models.Model):
    video = CloudinaryField(resource_type='video', allowed_formats=['mp4', 'webm'],
                            validators=[validate_video_size])
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='product_video')


class Storage(BaseModel):
    address = models.CharField(max_length=100)
    shop = models.ForeignKey(Shop, on_delete=models.CASCADE, related_name='shop_storage')

    def __str__(self):
        return self.address


class StorageProduct(models.Model):
    storage = models.ForeignKey(Storage, on_delete=models.CASCADE, related_name='storage_product')
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='product_storage')
    remain = models.IntegerField(default=0)


class PaymentMethod(BaseModel):
    name = models.CharField(max_length=15)

    def __str__(self):
        return self.name


class Shipping(BaseModel):
    name = models.CharField(max_length=50)
    fee = models.FloatField()

    def __str__(self):
        return self.name


class VoucherType(models.Model):
    name = models.CharField(max_length=30, unique=True)
    key = models.CharField(max_length=10, unique=True)


class VoucherCondition(models.Model):
    min_order_amount = models.FloatField(null=True, blank=True, default=0)
    max_uses = models.IntegerField(null=True, blank=True, default=None)
    categories = models.OneToOneField(Category, on_delete=models.PROTECT, null=True, blank=True)
    payment_method = models.OneToOneField(PaymentMethod, on_delete=models.PROTECT, null=True, blank=True)
    shipping = models.OneToOneField(Shipping, on_delete=models.PROTECT, null=True, blank=True)


class Voucher(BaseModel):
    name = models.CharField(max_length=100)
    code = models.CharField(max_length=10, unique=True)
    discount = models.FloatField()
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()
    voucher_type = models.ForeignKey(VoucherType, on_delete=models.CASCADE, null=True, blank=True)
    voucher_condition = models.ForeignKey(VoucherCondition, on_delete=models.CASCADE, null=True, blank=True)


class UserVoucher(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    voucher = models.ForeignKey(Voucher, on_delete=models.CASCADE)


class OrderStatus(models.Model):
    status = models.CharField(max_length=20)

    def __str__(self):
        return self.status


class Order(BaseModel):
    total_amount = models.FloatField()
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    status = models.ForeignKey(OrderStatus, on_delete=models.PROTECT)
    payment_method = models.ForeignKey(PaymentMethod, on_delete=models.PROTECT)
    shipping = models.ForeignKey(Shipping, on_delete=models.PROTECT)

    # def __str__(self):
    #     return f"Order {self.id} - User {self.user}"


class OrderDetail(models.Model):
    quantity = models.IntegerField()
    price = models.FloatField()
    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    color = models.ForeignKey(ProductColor, on_delete=models.SET_NULL, null=True, blank=True)
    user_phone = models.ForeignKey(UserPhone, on_delete=models.PROTECT)
    user_address = models.ForeignKey(UserAddress, on_delete=models.PROTECT)

    # def __str__(self):
    #     return f"Order {self.order.id} - Product {self.product.name}"


class OrderVoucher(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    voucher = models.ForeignKey(Voucher, on_delete=models.CASCADE)

    # def __str__(self):
    #     return f"Order {self.order.id} - Voucher {self.voucher.code}"


class PaymentVNPAYDetail(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    amount = models.FloatField(null=False, default=0)
    order_desc = models.CharField(max_length=100)
    vnp_TransactionNo = models.CharField(max_length=20)
    vnp_ResponseCode = models.CharField(max_length=20)
    vnp_PayDate = models.CharField(max_length=20)
