import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/controllers/appointment_booking_controller.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/views/doctor_card_widget.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/views/specialization_widget.dart';

class AppointmentBookingView extends GetView<AppointmentBookingController> {
  const AppointmentBookingView({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: CustomText('BookAppointment'.tr,
            fontSize: 16.sp, fontWeight: FontWeight.bold),
        centerTitle: true,
        backgroundColor: AppColors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.height,
            _buildHeader(),
            Expanded(
              child: Obx(() => _buildStepContent()),
            ),
            30.height,
            CustomButton(
              color: AppColors.accent,
              onPressed: controller.nextStep,
              text:
                  controller.currentStep.value == 3 ? 'Confirm'.tr : 'Next'.tr,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'BookAppointment'.tr,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        10.height,
        Obx(() => Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16.r,
                        backgroundColor: index <= controller.currentStep.value
                            ? AppColors.primary
                            : Colors.grey[300],
                        child: Icon(
                          Icons.check,
                          size: 14.sp,
                          color: index <= controller.currentStep.value
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                      if (index < 3)
                        Expanded(
                          child: Container(
                            height: 2.h,
                            color: index < controller.currentStep.value
                                ? AppColors.primary
                                : Colors.grey[300],
                          ),
                        ),
                    ],
                  ),
                );
              }),
            )),
        40.height,
        Obx(() => CustomText(
              controller.stepTitles[controller.currentStep.value].tr,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            )),
        10.height,
      ],
    );
  }

  Widget _buildStepContent() {
    switch (controller.currentStep.value) {
      case 0:
        return _buildSpecializationStep();
      case 1:
        return _buildDoctorSelectionStep();
      case 2:
        return const _buildTimeSelectionStep();
      case 3:
        return _buildConfirmationStep();
      default:
        return Container();
    }
  }

  Widget _buildSpecializationStep() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.4,
      ),
      itemCount: controller.specializations.length,
      itemBuilder: (context, index) {
        final specialization = controller.specializations[index];
        final isSelected = controller.selectedSpecialization.value == specialization.name;

        return GestureDetector(
          onTap: () => controller.selectSpecialization(specialization.name),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade200,
                width: 2.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  specialization.icon,
                  width: 32.w,
                  height: 32.w,
                  color: isSelected ? AppColors.primary : Colors.grey.shade600,
                ),
                12.height,
                CustomText(
                  specialization.name,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.primary : Colors.black,
                ),
                4.height,
                CustomText(
                  '${specialization.availableDoctors} doctors'.tr,
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // Widget _buildSpecializationStep() {
  //   final specializations = controller.getSpecializations();
  //   return GridView.builder(
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       crossAxisSpacing: 16.w,
  //       mainAxisSpacing: 16.h,
  //       childAspectRatio: 1.6,
  //     ),
  //     itemCount: specializations.length,
  //     itemBuilder: (context, index) {
  //       final specialization = specializations[index];
  //       return SpecializationWidget(
  //         onTap: () => controller.selectSpecialization(specialization['title']),
  //         title: specialization['title'],
  //         availableDoctors: specialization['availableDoctors'],
  //       );
  //     },
  //   );
  // }

  Widget _buildDoctorSelectionStep() {
    final doctors = controller.getDoctors();
    if (doctors.isEmpty) {
      // Show a message when no doctors are available
      return Align(
        alignment: Alignment.center,
        child: CustomText(
          'No doctors available for this specialization.'.tr,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
        ),
      );
    }
    return ListView.separated(
      itemCount: doctors.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) => 12.height,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return DoctorCard(
          name: doctor['name'],
          specialization: doctor['specialization'],
          rating: doctor['rating'],
          experience: doctor['experience'],
          onTap: () => controller.selectDoctor(doctor['name']),
        );
      },
    );
  }

  Widget _buildConfirmationStep() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.fact_check_rounded,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),
                  12.width,
                  CustomText(
                    'Appointment Summary'.tr,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              20.height,

              // Appointment Details
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _buildConfirmationItem(
                      'Specialization'.tr,
                      controller.selectedSpecialization.value,
                      Icons.local_hospital_rounded,
                    ),
                    Divider(height: 24.h, color: Colors.grey[200]),
                    _buildConfirmationItem(
                      'Doctor'.tr,
                      controller.selectedDoctor.value,
                      Icons.person_rounded,
                    ),
                    Divider(height: 24.h, color: Colors.grey[200]),
                    _buildConfirmationItem(
                      'Date & Time'.tr,
                      controller.selectedTime.value?.format(Get.context!) ??
                          'Not selected'.tr,
                      Icons.access_time_rounded,
                    ),
                  ],
                ),
              ),

              24.height,
              // Additional Information
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 18.sp,
                    ),
                    12.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'Please verify your appointment details'.tr,
                            fontSize: 12.sp,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                          4.height,
                          CustomText(
                            'You can manage your appointments from the home screen'
                                .tr,
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildConfirmationItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: Colors.grey[200]!,
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 18.sp,
          ),
        ),
        16.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                label,
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
              4.height,
              CustomText(
                value,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _buildTimeSelectionStep extends GetView<AppointmentBookingController> {
  const _buildTimeSelectionStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.height,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.access_time_rounded,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),
                  12.width,
                  CustomText(
                    'AvailableTimes'.tr,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ],
              ),
              16.height,
              CustomText(
                'Select your preferred time slot'.tr,
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
              24.height,

              // Time Slots Section
              Obx(() => Wrap(
                    spacing: 12.w,
                    runSpacing: 16.h,
                    children: List.generate(
                      controller.getAvailableTimes().length,
                      (index) {
                        final time = controller.getAvailableTimes()[index];
                        final isSelected =
                            controller.selectedTime.value == time;

                        return InkWell(
                          onTap: () => controller.selectTime(time),
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 1.5.w,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 16.sp,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primary,
                                ),
                                6.height,
                                CustomText(
                                  time.format(context),
                                  fontSize: 13.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[800],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )),

              // Additional Info Section
              24.height,
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                      size: 18.sp,
                    ),
                    12.width,
                    Expanded(
                      child: CustomText(
                        'Appointment duration is 30 minutes'.tr,
                        fontSize: 12.sp,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
