import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/cached_image.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/data/models/doctor.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetailsView extends StatelessWidget {
  final Doctor doctor = Get.arguments;

  DoctorDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    print(doctor.email);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          'DoctorProfile'.tr,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: CustomButton(
          text: 'BookAppointment'.tr,
          color: AppColors.primary,
          onPressed: () => Get.toNamed(
            Routes.APPOINTMENT_BOOKING,
            arguments: {'doctor': doctor},
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorHeader(),
            16.height,
            _buildInfoSection(),
            16.height,
            _buildAboutSection(),
            16.height,
            // _buildCertificateSection(),
            16.height,
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: doctor.image != null && doctor.image!.isNotEmpty
                  ? ImageWithAnimatedShader(imageUrl: doctor.image.toString())
                  : Icon(
                      doctor.gender == "male" ? Icons.person : Icons.person_2,
                      size: 50.r,
                      color: AppColors.primary,
                    ),
            ),
          ),
          16.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Dr. ${doctor.firstName} ${doctor.lastName}',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                8.height,
                CustomText(
                  doctor.major ?? "Specialist",
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
                8.height,
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16.r),
                    4.width,
                    CustomText(
                      doctor.averageRating ?? "0.0",
                      fontSize: 14.sp,
                      color: Colors.grey[800],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildInfoItem(
              Icons.email_outlined,
              'Email'.tr,
              doctor.email.toString() ,
            ),
          ),
          8.width,
          _buildInfoItem(
              Icons.phone_outlined,
              'Phone'.tr,
              doctor.phoneNumber ?? "N/A",
            ),
          8.width,

          _buildInfoItem(
            Icons.location_on_outlined,
            'Location'.tr,
            doctor.country ?? "N/A",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value,
      {Color? iconColor}) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? AppColors.primary, size: 24.r),
        8.height,
        CustomText(
          title,
          fontSize: 12.sp,
          color: Colors.grey[600],
        ),
        4.height,
        CustomText(
          value,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'About'.tr,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          12.height,
          CustomText(
            'Dr. ${doctor.firstName} ${doctor.lastName} is a dedicated ${doctor.major} specialist with extensive experience in their field. They are currently offering medical consultations and support through our platform.',
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Certification'.tr,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          12.height,
          doctor.certificate != null && doctor.certificate!.isNotEmpty
              ?    InkWell(
            onTap: _launchCertificateUrl,
                child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side:  BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                onPressed: () {},
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      'Download certificate',
                      fontSize: 12.sp,

                      color: AppColors.primary,
                    ),
                    Icon(
                      Icons.download,
                      color: AppColors.primary,
                    ),
                  ],
                )
                          ),
              )


              : CustomText(
                  'NoCertificateAvailable'.tr,
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
        ],
      ),
    );
  }

  Future<void> _launchCertificateUrl() async {
    if (doctor.certificate == null || doctor.certificate!.isEmpty) return;

    final Uri url = Uri.parse(doctor.certificate!);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error'.tr,
          'CouldNotOpenCertificate'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'CouldNotOpenCertificate'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

}
