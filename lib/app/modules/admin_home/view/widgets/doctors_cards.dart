import 'dart:io';

import 'package:flutter/material.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import 'package:med_support_gaza/app/data/models/doctor.dart';
import 'package:med_support_gaza/app/data/network_helper/dio_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_text_widget.dart';

class DoctorCards extends StatelessWidget {
  final String name;
  final String speciality;
  final String email;
  final Doctor doctor;
  final Function() onAccept;
  final Function() onDecline;

  const DoctorCards({
    super.key,
    required this.name,
    required this.speciality,
    required this.email,
    required this.onAccept,
    required this.onDecline, required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gray,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            CustomText(
              name,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
            8.height,
            CustomText(
              speciality,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
            8.height,
            CustomText(
              email,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
            8.height,
            TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                onPressed: () =>
                    downloadCertificate(this.doctor.certificate.toString()),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      'Download certificate',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    Icon(
                      Icons.download,
                      color: Colors.grey,
                    ),
                  ],
                )),
            16.height,
            Row(
              children: [
                ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const CustomText(
                    'Accept',
                    fontSize: 12,
                    color: AppColors.white,
                  ),
                ),
                16.width,
                ElevatedButton(
                  onPressed: onDecline,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const CustomText(
                    'Decline',
                    fontSize: 12,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void downloadCertificate(String certificateUrl) async {
    final Uri url = Uri.parse(certificateUrl);
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not open certificate URL';
    }
  }
}