import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';
import '../../../../core/widgets/custom_textfield_widget.dart';
import '../../controllers/doctor_consultation_controller.dart';

class DoctorConsultationListView extends GetView<DoctorConsultationController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
              suffixIcon:
                  IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              hintText: 'search'.tr,
              controller: TextEditingController()),
        ),
        Expanded(
          child: Obx(() => ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return GestureDetector(
                    onTap: () {
                    //  Get.toNamed(Routes.DOCTOR_CHAT);
                    },
                    child: Container(
                      //color: AppColors.background,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.gray),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.r))),
                      width: 160.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                      margin: EdgeInsets.symmetric(
                          vertical: 5.0.h, horizontal: 10.0.w),
                      child: ListTile(
                        leading: Container(
                          height: 70,
                          width: 70,
                          child: CircleAvatar(
                            backgroundColor: Color(0xffEEEEEE),
                            child: Icon(
                              Icons.person,
                              color: AppColors.textLight,
                              size: 45.sp,
                            ),
                          ),
                        ),
                        title: CustomText(
                          message['name'] ?? '',
                          fontSize: 14.sp,
                        ),
                        subtitle: CustomText(
                          message['message'] ?? '',
                          fontSize: 12.sp,
                        ),
                        trailing: Column(
                          children: [
                            5.height,
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  border: Border.all(color: AppColors.primary),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.r))),
                              width: 20.h,
                              height: 20.h,
                              child: CustomText(
                                '2',
                                fontSize: 8.sp,
                                color: AppColors.background,
                              ),
                            ),
                            5.height,
                            CustomText(
                              message['time'] ?? '',
                              fontSize: 10.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )),
        ),
      ],
    );
  }
}
