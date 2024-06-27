from django.contrib import admin
from django.utils.html import mark_safe
from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import Group
from .models import *
from django import forms
from ckeditor_uploader.widgets import CKEditorUploadingWidget


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

    def get_queryset(self, request):  # display all things belonging to the user
        qs = super(UserAdmin, self).get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(id=request.user.id)

    def save_model(self, request, obj, form, change):
        # Check if the password is being set or changed
        if obj.password and not obj.password.startswith('pbkdf2_sha256$'):
            # Hash the password before saving
            obj.password = make_password(obj.password)
        super().save_model(request, obj, form, change)


class CategoryAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'active']
    search_fields = ['id', 'name']
    list_filter = ['id', 'name']


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
        super().save_model(request, obj, form, change)
        vendor_group, created = Group.objects.get_or_create(name='Vendors')
        if obj.status.status == 'Successful' and obj.active:
            obj.user.groups.add(vendor_group)
            obj.user.is_staff = True
            obj.user.is_vendor = True
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
            return ['id', 'name', 'following', 'followed', 'rated', 'user_id', 'shop_image', 'active']
        return ['id', 'name', 'following', 'followed', 'rated', 'shop_image', 'active']

    def get_search_fields(self, request):
        if request.user.is_superuser:
            return ['id', 'name']
        return []

    def get_list_filter(self, request):
        if request.user.is_superuser:
            return ['active', 'rated']
        return []

    def get_readonly_fields(self, request, obj=None):  # display in view detail
        if request.user.is_superuser:
            return ['shop_image', 'following', 'followed', 'rated']
        return ['active', 'user', 'shop_image', 'following', 'followed', 'rated']

    def shop_image(self, shop):
        if shop.image:
            return mark_safe(f"<img width='100' height='100' src='{shop.image.url}' />")

    def get_queryset(self, request):
        qs = super(ShopAdmin, self).get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(user=request.user)

    def save_model(self, request, obj, form, change):
        if not obj.pk:
            obj.user = request.user
        super().save_model(request, obj, form, change)  # ex save_model of class ShopAdmin to store Shop to database


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
            return ["id", "name", "get_image", "price", "sold", "rating", 'category', 'shop', 'active']
        return ["id", "name", "get_image", "price", "sold", "rating", 'category', 'active']

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
            return ['rating', 'sold', "get_image"]
        return ['rating', 'sold', "get_image", "active", "shop"]

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
        if request.user.is_superuser:
            obj.shop = Shop.objects.get(id=obj.shop_id)
        # Get shop from current user
        obj.shop = Shop.objects.get(user_id=request.user.id)
        super().save_model(request, obj, form, change)
        # ex save_model of class ProductAdmin to store Product to database


class ProductDetailAdmin(admin.ModelAdmin):
    list_display = ["id", "material", "manufactory", "product_id", "product"]
    list_filter = ["id", "product_id"]

    def get_readonly_fields(self, request, obj=None):  # display in view detail
        if request.user.is_superuser:
            return super(ProductDetailAdmin, self).get_readonly_fields(request)
        return ["product"]

    def get_queryset(self, request):
        qs = super(ProductDetailAdmin, self).get_queryset(request)
        if request.user.is_superuser:
            return qs
        return qs.filter(product__shop__user=request.user)  # join product & shop & user table

    def save_model(self, request, obj, form, change):
        if not obj.pk:
            obj.user = request.user
        super().save_model(request, obj, form, change)
        # ex save_model of class ProductDetailAdmin to store ProductDetail to database


class ProductImageAdmin(admin.ModelAdmin):
    list_display = ["id", "get_image", "product_id", "product"]
    list_filter = ["id", "product_id"]

    def get_readonly_fields(self, request, obj=None):  # display in view detail
        if request.user.is_superuser:
            return ["get_image"]
        return ["product", "get_image"]

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

    def save_model(self, request, obj, form, change):
        if not obj.pk:
            obj.user = request.user
        super().save_model(request, obj, form, change)


class ProductColorAdmin(admin.ModelAdmin):
    list_display = ["id", "name", "get_image", "product_id", "product"]
    list_filter = ["name", "product_id"]

    def get_readonly_fields(self, request, obj=None):  # display in view detail
        if request.user.is_superuser:
            return ["get_image"]
        return ["product", "get_image"]

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

    def save_model(self, request, obj, form, change):
        if not obj.pk:
            obj.user = request.user
        super().save_model(request, obj, form, change)


class ProductVideoAdmin(admin.ModelAdmin):
    list_display = ["id", "get_video", "product_id", "product", ]
    list_filter = ["id", "product_id"]

    def get_readonly_fields(self, request, obj=None):  # display in view detail
        if request.user.is_superuser:
            return ["get_video"]
        return ["product", "get_video"]

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

    def save_model(self, request, obj, form, change):
        if not obj.pk:
            obj.user = request.user
        super().save_model(request, obj, form, change)


admin.site.register(User, UserAdmin)
admin.site.register(Category, CategoryAdmin)
admin.site.register(Shop, ShopAdmin)
admin.site.register(ShopConfirmationStatus, ShopConfirmationStatusAdmin)
admin.site.register(ShopConfirmation, ShopConfirmationAdmin)

admin.site.register(Product, ProductAdmin)
admin.site.register(ProductDetail, ProductDetailAdmin)
admin.site.register(ProductImage, ProductImageAdmin)
admin.site.register(ProductColor, ProductColorAdmin)
admin.site.register(ProductVideo, ProductVideoAdmin)

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
