import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';
import 'package:med_support_gaza/app/modules/admin_home/controller/admin_content_controller.dart';
import 'package:med_support_gaza/app/modules/admin_home/view/widgets/content_card.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class AdminContentManagementView extends GetView<ContentController> {
  const AdminContentManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(

        body: RefreshIndicator(
          onRefresh: ()async {
            controller.loadContent();
          },
            child: _buildContentList()),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.ADD_CONTENT),
          backgroundColor: AppColors.primary,
          child: const Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildContentList() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: CustomTextField(
            hintText: 'search'.tr,
            controller: controller.searchController,
            prefixIcon: Icons.search,
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredContent.isEmpty) {
              return Center(
                child: CustomText(
                  'no_content'.tr,
                  fontSize: 16.sp,
                  color: AppColors.textLight,
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: controller.filteredContent.length,
              separatorBuilder: (_, __) => 12.height,
              itemBuilder: (context, index) {
                final content = controller.filteredContent[index];
                return ContentCard(content: content);
              },
            );
          }),
        ),
      ],
    );
  }
}


