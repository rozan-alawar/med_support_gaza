

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/data/models/doctor.dart';
import 'package:med_support_gaza/app/modules/admin_home/controller/admin_doctors_controller.dart';
import 'package:med_support_gaza/app/modules/admin_home/view/widgets/doctors_cards.dart';

class AdminDoctors extends GetView<AdminDoctorsController> {
  const AdminDoctors({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx(() {


        return controller.isLoading.value?Center(child: CircularProgressIndicator(color: AppColors.primary,)): RefreshIndicator(
          onRefresh: () async => controller.getPendingDoctors(),
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            padding: const EdgeInsets.all(20),
            itemCount: controller.pendingDoctors.length,
            itemBuilder: (context, index) {
              Doctor doctor = controller.pendingDoctors[index];
              return DoctorCards(
                doctor: doctor,
                name: "${doctor.firstName} ${doctor.lastName}",
                speciality: doctor.major.toString(),
                email: doctor.email.toString(),
                onAccept: () => controller.approveDoctor(doctor.id.toString()),
                onDecline: () => controller.declineDoctor(doctor.id.toString()),
              );
            },
          ),
        );
      }),
    );
  }
}
