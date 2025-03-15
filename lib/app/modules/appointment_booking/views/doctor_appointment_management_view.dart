import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_button_widget.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../controllers/doctor_appointment_management_controller.dart';

class DoctorAppointmentManagementView
    extends GetView<DoctorAppointmentManagementController> {
  const DoctorAppointmentManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText(
              'appointments_title_massage'.tr,
              fontFamily: 'Lama Sans',
              fontSize: 20.sp,
              color: AppColors.textgray,
            ),
            Obx(() => Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  width: 350.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.gray, // Border color
                    ),
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}',
                        fontFamily: 'Lama Sans',
                        fontSize: 16.sp,
                        color: AppColors.textgray,
                      ),
                      IconButton(
                        onPressed: () => controller.selectDate(context),
                        icon: SvgPicture.asset(
                          IconAssets.date,
                        ),
                      )
                    ],
                  ),
                )),
            30.height,
            Obx(() => SizedBox(
                  width: 350.w,
                  height: 65.h,
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedTime.value,
                    items: controller.availableTimes
                        .map((time) => DropdownMenuItem<String>(
                              value: time,
                              child: CustomText(
                                time,
                                fontFamily: 'Lama Sans',
                                fontSize: 14.sp,
                                color: AppColors.textgray,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateSelectedTime(value);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                )),
            30.height,
            CustomButton(
              width: 298.h,
              text: 'add'.tr,
              color: AppColors.primary,
              isDisable: controller.isloading.value,
              onPressed: () async {
                await controller.addAppointment();
              },
            ),
            32.height,
            Expanded(
              child: Obx(() => GridView.builder(
                    key: ValueKey(controller.appointments.hashCode),
                    itemCount: controller.appointments.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      mainAxisSpacing: 5, // Spacing between rows
                      crossAxisSpacing: 10, // Spacing between columns
                      childAspectRatio:
                          1.25, // Width-to-height ratio for each grid item
                    ),
                    itemBuilder: (context, index) {
                      final appointment = controller.appointments[index];
                      return Card(
                        color: AppColors.background,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: AppColors.gray),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                controller.getFormatedDate(appointment.date),
                                fontSize: 15,
                              ),
                              const SizedBox(height: 5),
                              CustomText(
                                appointment.startTime,
                                fontSize: 12,
                              ),
                              const Spacer(),
                              Align(
                                alignment: Get.locale?.languageCode == 'en'
                                    ? Alignment.bottomRight
                                    : Alignment.bottomLeft,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: AppColors.accent,
                                  ),
                                  onPressed: () =>
                                      controller.deleteAppointment(index),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ));
  }
}
