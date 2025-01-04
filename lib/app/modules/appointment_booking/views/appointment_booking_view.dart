import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/controllers/appointment_booking_controller.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/views/doctor_card_widget.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/views/specialization_widget.dart';

class AppointmentBookingView extends GetView<AppointmentBookingController> {
  const AppointmentBookingView({Key? key}) : super(key: key);

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
        return _buildTimeSelectionStep();
      case 3:
        return _buildConfirmationStep();
      default:
        return Container();
    }
  }

  Widget _buildSpecializationStep() {
    final specializations = controller.getSpecializations();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.6,
      ),
      itemCount: specializations.length,
      itemBuilder: (context, index) {
        final specialization = specializations[index];
        return SpecializationWidget(
          onTap: () => controller.selectSpecialization(specialization['title']),
          title: specialization['title'],
          availableDoctors: specialization['availableDoctors'],
        );
      },
    );
  }

  Widget _buildDoctorSelectionStep() {
    final doctors = controller.getDoctors();
    return ListView.separated(
      itemCount: doctors.length,
      physics: BouncingScrollPhysics(),
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
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfirmationItem(
              'Specialization',
              controller.selectedSpecialization.value,
            ),
            _buildConfirmationItem(
              'Doctor',
              controller.selectedDoctor.value,
            ),
            _buildConfirmationItem(
              'Date',
              controller.selectedTime.value?.toString() ?? 'Not selected',
            ),
          ],
        ));
  }

  Widget _buildConfirmationItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
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
          ),
        ],
      ),
    );
  }
}

class _buildTimeSelectionStep extends GetView<AppointmentBookingController> {
  const _buildTimeSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    20.height,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              spreadRadius: 4,
              offset: Offset(0, 2),
            )
          ], color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'AvailableTimes'.tr,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              16.height,
              Obx(() => Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: List.generate(
                      controller.getAvailableTimes().length,
                      (index) {
                        final time = controller.getAvailableTimes()[index];
                        return GestureDetector(
                          onTap: () => controller.selectTime(time),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: controller.selectedTime.value == time
                                    ? AppColors.primary
                                    : Colors.grey[300]!,
                                width: 2.w,
                              ),
                            ),
                            child: CustomText(
                              time.format(context),
                              fontSize: 14.sp,
                              color: controller.selectedTime.value == time
                                  ? AppColors.primary
                                  : Colors.grey[600],
                            ),
                          ),
                        );
                      },
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
