
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';
import 'package:med_support_gaza/app/modules/admin_home/controller/admin_content_controller.dart';

class AddNewArticle extends GetView<ContentController> {
  const AddNewArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 20.height,
              _buildImageUpload(),
              20.height,
              CustomText(
                'article_title'.tr,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              8.height,
              CustomTextField(
                hintText: 'enter_article_title'.tr,
                controller: controller.titleController,
                validator: controller.validateTitle,
              ),
              16.height,
              CustomText(
                'article_content'.tr,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              8.height,
              Container(
                height: 250.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  // border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: TextFormField(
                  controller: controller.contentController,
                  validator: controller.validateContent,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'write_article_content'.tr,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),
              24.height,
              Obx(() => CustomButton(
                text: 'publish'.tr,
                color: AppColors.primary,
                isDisable: controller.isLoading.value,
                onPressed: controller.saveContent,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'article_image'.tr,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        8.height,
        Obx(() => GestureDetector(
          onTap: controller.pickImage,
          child: Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
            child: controller.selectedImage.value != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.file(
                File(controller.selectedImage.value!.path??""),
                fit: BoxFit.cover,
              ),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 48.sp,
                  color: AppColors.primary,
                ),
                8.height,
                CustomText(
                  'tap_to_upload_image'.tr,
                  fontSize: 14.sp,
                  color: AppColors.textLight,
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}