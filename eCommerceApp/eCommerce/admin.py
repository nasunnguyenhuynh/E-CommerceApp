from django.contrib import admin
from django.utils.html import mark_safe
from django.contrib.auth.hashers import make_password
from .models import *
from django import forms
from ckeditor_uploader.widgets import CKEditorUploadingWidget


class UserAdmin(admin.ModelAdmin):
    list_display = ['id', 'username', 'email', 'birthday', 'is_active', 'is_vendor', 'is_superuser', 'user_img']
    search_fields = ['id', 'username']
    list_filter = ['id', 'is_active', 'is_vendor', 'is_superuser']
    readonly_fields = ['user_img']  # display in view detail

    def user_img(self, user):
        if user.avatar:
            return mark_safe(f"<img width='100' height='100' src='{user.avatar.url}' />")

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


class ShopForm(forms.ModelForm):
    description = forms.CharField(widget=CKEditorUploadingWidget)


class ShopAdmin(admin.ModelAdmin):
    form = ShopForm
    list_display = ['id', 'name', 'following', 'followed', 'rated', 'user_id', 'shop_image', 'active']
    search_fields = ['id', 'name']
    list_filter = ['active', 'rated']
    readonly_fields = ['shop_image', 'following', 'followed', 'rated']  # display in view detail

    def shop_image(self, shop):
        if shop.image:
            return mark_safe(f"<img width='100' height='100' src='{shop.image.url}' />")


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
    list_display = ["id", "name", "price", "sold", "rating", 'category', 'shop']
    search_fields = ['id', 'name']
    list_filter = ['active', 'name', 'category', 'shop']
    readonly_fields = ['rating', 'sold']

    inlines = [ProductDetailInline, ProductImageInline, ProductColorInline, ProductVideoInline]


admin.site.register(User, UserAdmin)
admin.site.register(Category, CategoryAdmin)
admin.site.register(Shop, ShopAdmin)
admin.site.register(Product, ProductAdmin)
