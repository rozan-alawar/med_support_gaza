import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import '../../../../data/firebase_services/chat_services.dart';
import '../../../../data/models/consultation_model.dart';
import '../../../profile/controllers/doctor_profile_controller.dart';
import '../../controllers/doctor_consultation_controller.dart';

class DoctorConsultationListView extends GetView<DoctorConsultationController> {
  DoctorConsultationListView({super.key});
  final doctorController = Get.find<DoctorProfileController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: AppColors.primary.withOpacity(0.4),
                ),
                unselectedLabelColor: Colors.grey[700],
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: 'Active'.tr),
                  Tab(text: 'Upcoming'.tr),
                  Tab(text: 'Past'.tr),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            //  controller.loadConsultations();
          },
          child: TabBarView(
            children: [
              _buildConsultationsList('active'),
              _buildConsultationsList('upcoming'),
              _buildConsultationsList('past'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsultationsList(String status) {
    final ChatService chatService = ChatService();

    return StreamBuilder<List<ConsultationModel>>(
      stream: chatService.getDoctorConsultations(
          doctorController.doctorData.value?.doctor?.id ?? 0, status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No $status consultations',
              style: TextStyle(color: Colors.black, fontSize: 14.sp),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final consultation = snapshot.data![index];

            return ConsultationCard(
              consultation: consultation,
              userId: doctorController.doctorData.value?.doctor?.id ?? 0,
              onTap: () {
                // Get.to(() =>
                //     ChatView(
                //       consultationId: consultation.id,
                //       userId: userId,
                //     ));
              },
            );
          },
        );
      },
    );
  }
}

class ConsultationCard extends StatelessWidget {
  final ConsultationModel consultation;
  final int userId;
  final VoidCallback onTap;

  const ConsultationCard({
    super.key,
    required this.consultation,
    required this.userId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.teal.shade100,
                    child: Text(
                      consultation.patient.firstName
                          .substring(0, 1)
                          .toUpperCase(),
                      style: const TextStyle(color: Colors.teal),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${consultation.patient.firstName} ${consultation.patient.lastName}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusIndicator(consultation.status),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                 const  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 8.w),
                  Text(
                    _formatDate(consultation.startTime),
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  SizedBox(width: 16.w),
                 const  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 8.w),
                  Text(
                    '${_formatTime(consultation.startTime)} - ${_formatTime(consultation.endTime)}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _buildActionButton(consultation),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color color;
    String text;

    switch (status) {
      case 'active':
        color = Colors.green;
        text = 'Active';
        break;
      case 'upcoming':
        color = Colors.blue;
        text = 'Upcoming';
        break;
      case 'past':
        color = Colors.grey;
        text = 'Past';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButton(ConsultationModel consultation) {
    if (consultation.status == 'active') {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon:const Icon(Icons.chat),
        label: const Text('Chat Now'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else if (consultation.status == 'upcoming') {
      return OutlinedButton.icon(
        onPressed: null, // Disabled
        icon: const Icon(Icons.event),
        label: Text('Starts at ${_formatTime(consultation.startTime)}'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue,
          side: const BorderSide(color: Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon:const Icon(Icons.history),
        label:const  Text('View History'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey,
          side:const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  String _formatDate(Timestamp timestamp) {
    return DateFormat('MMM dd, yyyy').format(timestamp.toDate());
  }

  String _formatTime(Timestamp timestamp) {
    return DateFormat('hh:mm a').format(timestamp.toDate());
  }
}
