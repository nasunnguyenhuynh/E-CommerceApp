from django.contrib import admin
from django.core.mail import EmailMessage
from django.utils.html import mark_safe
from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import Group
from .models import *
from django import forms
from ckeditor_uploader.widgets import CKEditorUploadingWidget
from django.utils import timezone


class UserAdmin(admin.ModelAdmin):
    list_display = ['id', 'user_img', 'username', 'email', 'birthday',
                    'is_active', 'is_vendor', 'is_staff', 'is_superuser', ]

    def get_search_fields(self, request):
        if request.user.is_superuser:
            return ['id', 'username']
        return []

    def get_list_filter(self, request):
        if request.user.is_superuser:
            return ['id', 'is_active', 'is_vendor', 'is_superuser']
        return []

    readonly_fields = ['user_img']  # display in view detail

    def get_readonly_fields(self, request, obj=None):
        readonly_fields = super(UserAdmin, self).get_readonly_fields(request, obj)
        if not request.user.is_superuser:
            readonly_fields = list(readonly_fields) + ['date_joined', 'last_login', 'is_superuser', 'is_staff',
                                                       'is_active', 'is_vendor', 'groups', 'user_permissions']
        return readonly_fields

    def user_img(self, user):
        if user.avatar:
            return mark_safe(f"<img width='100' height='100' src='{user.avatar.url}' />")

    def get_queryset(self, request):  # display current user's profile (exc Admin)
        qs = super(UserAdmin, self).get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(id=request.user.id)

    def save_model(self, request, obj, form, change):  # create user at admins site
        # Check if the password is being set or changed
        if obj.password and not obj.password.startswith('pbkdf2_sha256$'):
            # Hash the password before saving
            obj.password = make_password(obj.password)
        super().save_model(request, obj, form, change)


class UserAdressPhoneAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'address', 'phone', 'default', 'user']
    list_filter = ['default', 'user']


class CategoryAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'active']
    search_fields = ['id', 'name']
    list_filter = ['id', 'name']


#                                              >>> ShopAdmin <<<
class ShopConfirmationStatusAdmin(admin.ModelAdmin):
    list_display = ['id', 'status']
    search_fields = ['id', 'status']
    list_filter = ['id', 'status']


class ShopConfirmationAdmin(admin.ModelAdmin):
    list_display = ['id', 'shop_name', 'shop_img', 'user', 'status']
    search_fields = ['id', 'shop_name', 'status']
    list_filter = ['status']

    def shop_img(self, shopconfirmation):
        if shopconfirmation.shop_image:
            return mark_safe(f"<img width='100' height='100' src='{shopconfirmation.shop_image.url}' />")

    def ci_img(self, shopconfirmation):
        if shopconfirmation.citizen_identification_image:
            return mark_safe(
                f"<img width='100' height='100' src='{shopconfirmation.citizen_identification_image.url}' />")

    ci_img.short_description = 'citizen_identification_image'  # custom field_name display when view details

    def get_readonly_fields(self, request, obj=None):  # display in view detail
        if not request.user.is_superuser:
            if request.user.groups.filter(name='Shop Confirmation').exists():
                return ['user', 'ci_img', 'shop_name', 'shop_img']
        return super().get_readonly_fields(request, obj)

    def save_model(self, request, obj, form, change):
        print('obj ', obj.user)
        super().save_model(request, obj, form, change)
        vendor_group, created = Group.objects.get_or_create(name='Vendors')
        if obj.status.status == 'Successful' and obj.active:
            obj.user.groups.add(vendor_group)
            obj.user.is_staff = True
            obj.user.is_vendor = True

            if not hasattr(obj.user, 'user_shop'):  # Create new shop
                Shop.objects.create(
                    name=obj.shop_name,
                    image=obj.shop_image,
                    user=obj.user,
                    description=obj.shop_description
                )
                if obj.user.email:
                    # Email subject and message
                    subject = "Register shop successfully"
                    temp_password = generate_random_password()
                    message = f"Please access abc.com website and log in to your account with the password {temp_password} to view your shop."

                    # Send email using Gmail API
                    # send_gmail_email(subject, message, obj.user.email)
                    email = EmailMessage(subject=subject, body=message, from_email="from@example.com",
                                         to=["to@example.com"])
                    email.send()
        else:
            if obj.status.status == 'Failed':
                obj.active = False
            obj.user.groups.remove(vendor_group)
            obj.user.is_staff = False
            obj.user.is_vendor = False
        obj.user.save()


class ShopForm(forms.ModelForm):
    description = forms.CharField(widget=CKEditorUploadingWidget)


class ShopAdmin(admin.ModelAdmin):
    form = ShopForm

    def get_list_display(self, request):
        if request.user.is_superuser:
            return ['id', 'name', 'following', 'followed', 'shop_rating', 'user_id', 'shop_image', 'active']
        return ['id', 'name', 'following', 'followed', 'shop_rating', 'shop_image', 'active']

    def get_search_fields(self, request):
        if request.user.is_superuser:
            return ['id', 'name']
        return []

    def get_list_filter(self, request):
        if request.user.is_superuser:
            return ['active', 'shop_rating']
        return []

    def get_readonly_fields(self, request, obj=None):  # display in view detail
        if request.user.is_superuser:
            return ['shop_image', 'following', 'followed', 'shop_rating']
        return ['active', 'user', 'shop_image', 'following', 'followed', 'shop_rating']

    def shop_image(self, shop):
        if shop.image:
            return mark_safe(f"<img width='100' height='100' src='{shop.image.url}' />")

    def get_queryset(self, request):
        qs = super(ShopAdmin, self).get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(user=request.user)

    def save_model(self, request, obj, form, change):
        if not obj.pk:  # need to check this for automatic creation for the approved shop
            obj.user = request.user
        super().save_model(request, obj, form, change)  # ex save_model of class ShopAdmin to store Shop to database


#                                              >>> StorageAdmin <<<
class StorageAdmin(admin.ModelAdmin):
    list_display = ['id', 'address', 'shop']

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(shop__user=request.user)

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "shop":  # FK field named shop
            if not request.user.is_superuser:  # Filter shop belongs to current user
                kwargs["queryset"] = Shop.objects.filter(user=request.user)
        return super().formfield_for_foreignkey(db_field, request, **kwargs)


class StorageProductAdmin(admin.ModelAdmin):
    def get_list_display(self, request):
        # Base fields to always show
        fields = ['storage', 'product_name_display', 'product_color', 'remain']

        # Add 'shop' field if the user is a superuser
        if request.user.is_superuser:
            fields.append('shop')

        return fields

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(storage__shop__user=request.user)

    def shop(self, obj):
        return obj.storage.shop.name

    shop.short_description = 'Shop'

    def product_name_display(self, obj):
        product_name = obj.product.name
        # Truncate product name if longer than 50 characters
        if len(product_name) > 50:
            product_name = product_name[:50] + '...'
        return format_html('<span title="{}">{}</span>', obj.product.name, product_name)

    product_name_display.short_description = 'Product Name'

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "storage":  # Filter storage belongs to current user
            if not request.user.is_superuser:
                kwargs["queryset"] = Storage.objects.filter(shop__user=request.user)
        if db_field.name == "product":  # Filter product belongs to current user
            if not request.user.is_superuser:
                kwargs["queryset"] = Product.objects.filter(shop__user=request.user)
        if db_field.name == "product_color":  # Filter product_color belongs to current user
            if not request.user.is_superuser:
                kwargs["queryset"] = ProductColor.objects.filter(product__shop__user=request.user)
        return super().formfield_for_foreignkey(db_field, request, **kwargs)


#                                              >>> ProductAdmin <<<
class ProductDetailInline(admin.StackedInline):
    model = ProductDetail
    min_num = 1
    max_num = 1


class ProductImageInline(admin.StackedInline):
    model = ProductImage
    min_num = 1
    extra = 1
    max_num = 20


class ProductColorInline(admin.StackedInline):
    model = ProductColor
    extra = 1
    max_num = 20


class ProductVideoInline(admin.StackedInline):
    model = ProductVideo
    extra = 1
    max_num = 3


class ProductAdmin(admin.ModelAdmin):
    inlines = [ProductDetailInline, ProductImageInline, ProductColorInline, ProductVideoInline]

    def get_list_display(self, request):
        if request.user.is_superuser:
            return ["id", "name", "get_image", "price", "sold", "product_rating", 'category', 'shop', 'active']
        return ["id", "name", "get_image", "price", "sold", "product_rating", 'category', 'active']

    def get_search_fields(self, request):
        if request.user.is_superuser:
            return ['id', 'name']
        return []

    def get_list_filter(self, request):
        if request.user.is_superuser:
            return ['active', 'name', 'category', 'shop']
        return ['category']

    def get_readonly_fields(self, request, obj=None):  # display in view detail
        if request.user.is_superuser:
            return ['product_rating', 'sold', "get_image"]
        return ['product_rating', 'sold', "get_image", "active", "shop"]

    def get_image(self, obj):
        first_image = obj.product_image.first()  # Get img by reverse query
        if first_image:
            return mark_safe(f'<img src="{first_image.image.url}" width="50" height="50" />')
        return 'No Image'

    get_image.short_description = 'Image'

    def get_queryset(self, request):
        qs = super(ProductAdmin, self).get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(shop__user=request.user)  # join shop & user table

    def save_model(self, request, obj, form, change):
        if request.user.is_vendor:  # Fix shop_id is null when create new product at vendor_site
            obj.shop = Shop.objects.get(user_id=request.user.id)
        super().save_model(request, obj, form, change)
        # ex save_model of class ProductAdmin to store Product to database


class ProductDetailAdmin(admin.ModelAdmin):
    list_display = ["id", "material", "manufactory", "product_id", "product"]
    list_filter = ["id", "product_id"]

    def get_queryset(self, request):
        qs = super(ProductDetailAdmin, self).get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(product__shop__user=request.user)  # join product & shop & user table

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "product":
            if not request.user.is_superuser:
                kwargs["queryset"] = Product.objects.filter(shop__user=request.user)
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    def save_model(self, request, obj, form, change):
        if not obj.pk:
            obj.user = request.user
        super().save_model(request, obj, form, change)
        # ex save_model of class ProductDetailAdmin to store ProductDetail to database


class ProductImageAdmin(admin.ModelAdmin):
    list_display = ["id", "get_image", "product_id", "product"]
    list_filter = ["id", "product_id"]

    def get_readonly_fields(self, request, obj=None):  # display in view detail
        return ["get_image"]

    def get_image(self, obj):
        if obj:
            return mark_safe(f'<img src="{obj.image.url}" width="50" height="50" />')
        return 'No Image'

    get_image.short_description = 'Image'

    def get_queryset(self, request):
        qs = super(ProductImageAdmin, self).get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(product__shop__user=request.user)  # join product & shop & user table

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "product":
            if not request.user.is_superuser:
                kwargs["queryset"] = Product.objects.filter(shop__user=request.user)
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    def save_model(self, request, obj, form, change):
        if not obj.pk:
            obj.user = request.user
        super().save_model(request, obj, form, change)


class ProductColorAdmin(admin.ModelAdmin):
    list_display = ["id", "name", "get_image", "product_id", "product"]
    list_filter = ["name", "product_id"]

    def get_readonly_fields(self, request, obj=None):  # display in view detail
        return ["get_image"]

    def get_image(self, obj):
        if obj:
            return mark_safe(f'<img src="{obj.image.url}" width="50" height="50" />')
        return 'No Image'

    get_image.short_description = 'Image'

    def get_queryset(self, request):
        qs = super(ProductColorAdmin, self).get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(product__shop__user=request.user)  # join product & shop & user table

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "product":
            if not request.user.is_superuser:
                kwargs["queryset"] = Product.objects.filter(shop__user=request.user)
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    def save_model(self, request, obj, form, change):
        if not obj.pk:
            obj.user = request.user
        super().save_model(request, obj, form, change)


class ProductVideoAdmin(admin.ModelAdmin):
    list_display = ["id", "get_video", "product_id", "product", ]
    list_filter = ["id", "product_id"]

    def get_readonly_fields(self, request, obj=None):  # display in view detail
        return ["get_video"]

    def get_video(self, obj):
        if obj:
            return mark_safe(f'<video width="200" height="100" controls>'
                             f'<source src="{obj.video.url} type="video/mp4">'
                             f'</video')
        return 'No Video'

    get_video.short_description = 'Video'

    def get_queryset(self, request):
        qs = super(ProductVideoAdmin, self).get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(product__shop__user=request.user)  # join product & shop & user table

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "product":
            if not request.user.is_superuser:
                kwargs["queryset"] = Product.objects.filter(shop__user=request.user)
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    def save_model(self, request, obj, form, change):
        if not obj.pk:
            obj.user = request.user
        super().save_model(request, obj, form, change)


#                                              >>> PaymentAdmin <<<
class PaymentMethodAdmin(admin.ModelAdmin):
    list_display = ['id', 'name']


#                                              >>> ShippingAdmin <<<
class ShippingAdmin(admin.ModelAdmin):
    list_display = ['name', 'fee']


#                                              >>> VoucherAdmin <<<
class VoucherTypeAdmin(admin.ModelAdmin):
    list_display = ['id', 'name']
    list_filter = ['name']


class VoucherConditionAdmin(admin.ModelAdmin):
    list_display = ['id', 'min_order_amount', 'remain', 'discount']


class VoucherAdmin(admin.ModelAdmin):
    list_display = ['id', 'created_date', 'updated_date', 'active',
                    'name', 'code', 'start_date', 'end_date', 'voucher_type', 'get_voucher_conditions']
    list_filter = ['active', 'voucher_type', 'end_date']

    def get_voucher_conditions(self, obj):
        return ", ".join([str(vc) for vc in obj.voucher_conditions.all()])

    get_voucher_conditions.short_description = 'Voucher Conditions'

    def save_model(self, request, obj, form, change):
        # Check if end_date is less than the current date
        if obj.end_date <= timezone.now():
            obj.active = False
        else:
            obj.active = True
        super().save_model(request, obj, form, change)


class OrderStatusAdmin(admin.ModelAdmin):
    list_display = ['id', 'status']


class OrderAdmin(admin.ModelAdmin):
    list_display = ['id', 'total_amount', 'user', 'status', 'payment_method', 'shipping', 'user_address_phone']


class OrderDetailAdmin(admin.ModelAdmin):
    list_display = ['id', 'quantity', 'price', 'order', 'product', 'color']


from django.urls import path
from .views import *
from django.utils.html import format_html
from django.conf import settings
from django.conf.urls.static import static
from django.template.response import TemplateResponse
from django.db.models import Count, Sum, F, ExpressionWrapper, DecimalField
from django.db.models.functions import ExtractYear, ExtractMonth, ExtractDay, ExtractQuarter
from django.utils.decorators import method_decorator
from django.contrib.auth.decorators import user_passes_test


class MyAdminStatsSite(admin.AdminSite):
    site_header = 'E-Commerce Administrator'

    def is_admin(user):
        return user.is_active and user.is_superuser

    def is_vendor_user(user):
        return user.is_active and user.is_vendor

    def get_urls(self):
        return [path('statistic/', self.stats_view)] + super().get_urls()

    @method_decorator(user_passes_test(is_admin))
    def stats_view(self, request):
        selected_shop = request.GET.get('shop')
        start_date = request.GET.get('start_date')
        end_date = request.GET.get('end_date')

        shops = Shop.objects.all()
        orders = Order.objects.all()

        if start_date and end_date:
            print(start_date)
            orders = orders.filter(created_date__range=[start_date, end_date])

        if selected_shop:
            # Fetch and print the selected shop for debugging
            print(f"Selected Shop ID: {selected_shop}")

            # Fetch all products in the selected shop
            products_in_shop = Product.objects.filter(shop_id=selected_shop)
            # Aggregate revenue for each product in the selected shop
            revenue_by_product = OrderDetail.objects.filter(
                product__in=products_in_shop, order__in=orders
            ).values(
                'product__name'
            ).annotate(
                revenue=Sum(
                    ExpressionWrapper(
                        F('quantity') * F('product__price'),
                        output_field=DecimalField()
                    )
                )
            )
            context = {
                'stats': revenue_by_product,
                'shops': shops,
                'selected_shop': selected_shop,
                'is_specific_shop': True
            }
        else:
            # Aggregate revenue by shop if no specific shop is selected
            revenue_by_shop = (OrderDetail.objects
                               .filter(order__in=orders)
                               .select_related('product')
                               .values('product__shop_id', 'product__shop__name')
                               .annotate(
                total_revenue=Sum(F('quantity') * F('product__price'), output_field=DecimalField())
            )
                               .order_by('-total_revenue')
                               )
            context = {
                'stats': revenue_by_shop,
                'shops': shops,
                'is_specific_shop': False
            }

        return TemplateResponse(request, 'admin/statistic.html', context)


admin.site = MyAdminStatsSite(name='eCommerceApp')

admin.site.register(User, UserAdmin)
admin.site.register(UserAddressPhone, UserAdressPhoneAdmin)
admin.site.register(Category, CategoryAdmin)

admin.site.register(Shop, ShopAdmin)
admin.site.register(ShopConfirmationStatus, ShopConfirmationStatusAdmin)
admin.site.register(ShopConfirmation, ShopConfirmationAdmin)

admin.site.register(Storage, StorageAdmin)
admin.site.register(StorageProduct, StorageProductAdmin)

admin.site.register(Product, ProductAdmin)
admin.site.register(ProductDetail, ProductDetailAdmin)
admin.site.register(ProductImage, ProductImageAdmin)
admin.site.register(ProductColor, ProductColorAdmin)
admin.site.register(ProductVideo, ProductVideoAdmin)

admin.site.register(PaymentMethod, PaymentMethodAdmin)
admin.site.register(Shipping, ShippingAdmin)
admin.site.register(VoucherType, VoucherTypeAdmin)
admin.site.register(VoucherCondition, VoucherConditionAdmin)
admin.site.register(Voucher, VoucherAdmin)

admin.site.register(OrderStatus, OrderStatusAdmin)
admin.site.register(Order, OrderAdmin)
admin.site.register(OrderDetail, OrderDetailAdmin)

# from django.contrib.auth.models import Group
#
# vendors_group, created = Group.objects.get_or_create(name='Vendors')
#
# # Add users to the Vendors group
# user = User.objects.get(username='vendor_username')
# user.groups.add(vendors_group)

# from django.contrib.auth.models import Permission
#
# vendors_group.permissions.add(Permission.objects.get(codename='add_product'))
# vendors_group.permissions.add(Permission.objects.get(codename='change_product'))
# vendors_group.permissions.add(Permission.objects.get(codename='delete_product'))
# vendors_group.permissions.add(Permission.objects.get(codename='view_product'))
