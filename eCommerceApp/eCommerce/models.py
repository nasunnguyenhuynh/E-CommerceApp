from django.db import models
from django.contrib.auth.models import AbstractUser
from ckeditor.fields import RichTextField
from cloudinary.models import CloudinaryField
from django.core.exceptions import ValidationError


class User(AbstractUser):
    avatar = CloudinaryField('image',
                             default='https://res.cloudinary.com/diwxda8bi/image/upload/v1718958489'
                                     '/rylzc2jtcpgta2ilize3.jpg')
    is_vendor = models.BooleanField(default=False)
    birthday = models.DateField(null=True, blank=True)
    phone = models.CharField(max_length=10, null=True, blank=True)


class UserAddressPhone(models.Model):
    name = models.CharField(max_length=100)
    address = models.CharField(max_length=150)
    phone = models.CharField(max_length=10)
    default = models.BooleanField(default=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)


class BaseModel(models.Model):
    created_date = models.DateTimeField(auto_now_add=True)
    updated_date = models.DateTimeField(auto_now=True)
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
    shop_rating = models.FloatField(default=0)
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
    product_rating = models.FloatField(default=0)
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

    def __str__(self):
        return f"product_id:{self.product.id} / {self.name}"


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
    product_color = models.ForeignKey(ProductColor, on_delete=models.CASCADE, blank=True, null=True,
                                      related_name='product_color_storage')
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

    def __str__(self):
        return f"{self.name}"


class VoucherCondition(models.Model):
    min_order_amount = models.FloatField(null=True, blank=True, default=0)
    remain = models.IntegerField(null=True, blank=True, default=1)
    categories = models.ManyToManyField(Category, blank=True)
    products = models.ManyToManyField(Product, blank=True)
    payment_methods = models.ManyToManyField(PaymentMethod, blank=True)
    shippings = models.ManyToManyField(Shipping, blank=True)
    discount = models.FloatField(default=0, null=True, blank=True)

    def __str__(self):
        return f"{self.pk}"


class Voucher(BaseModel):
    name = models.CharField(max_length=100)
    code = models.CharField(max_length=10, unique=True)
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()
    voucher_type = models.ForeignKey(VoucherType, on_delete=models.CASCADE)
    voucher_conditions = models.ManyToManyField(VoucherCondition)
    is_multiple = models.BooleanField(default=False)


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
    user_address_phone = models.ForeignKey(UserAddressPhone, on_delete=models.PROTECT)
    order_voucher_condition = models.ManyToManyField(VoucherCondition, blank=True)
    # order_voucher_condition = models.ManyToManyField(Voucher.voucher_conditions, blank=True)

    def __str__(self):
        return f"{self.pk}"


class OrderDetail(models.Model):
    quantity = models.IntegerField()
    price = models.FloatField()
    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    color = models.ForeignKey(ProductColor, on_delete=models.SET_NULL, null=True, blank=True)


class PaymentVNPAYDetail(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    amount = models.FloatField(null=False, default=0)
    order_desc = models.CharField(max_length=100)
    vnp_TransactionNo = models.CharField(max_length=20)
    vnp_ResponseCode = models.CharField(max_length=20)
    vnp_PayDate = models.CharField(max_length=20)


class Interaction(BaseModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)

    class Meta:
        abstract = True


class Rating(Interaction):
    star = models.IntegerField()
    is_shop = models.BooleanField(default=False)
    order = models.ForeignKey(Order, on_delete=models.CASCADE)


class Comment(Interaction):
    content = RichTextField()
    is_shop = models.BooleanField(default=False, blank=True)
    parent_comment = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True)
    is_parent = models.BooleanField(default=False, blank=True)
    order = models.ForeignKey(Order, on_delete=models.CASCADE, null=True, blank=True)
