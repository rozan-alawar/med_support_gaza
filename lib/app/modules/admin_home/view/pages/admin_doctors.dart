import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/admin_doctors_controller.dart';
import '../widgets/doctors_cards.dart';

class AdminDoctors extends StatelessWidget {
  const AdminDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminDoctorsController());

    return Scaffold(
      body: Obx(() {
        if (controller.doctors.isEmpty) {
          return const Center(
            child: Text('No unapproved doctors found'),
          );
        }

        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          padding: const EdgeInsets.all(20),
          itemCount: controller.doctors.length,
          itemBuilder: (context, index) {
            final doctor = controller.doctors[index];
            return DoctorCards(
              name: doctor.fullName,
              speciality: doctor.speciality,
              email: doctor.email,
              onAccept: () => controller.approveDoctor(doctor.id),
              onDecline: () => controller.declineDoctor(doctor.id),
            );
          },
        );
      }),
    );
  }
}
