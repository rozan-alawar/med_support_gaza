import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';

import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/firebase_services/chat_services.dart';
import 'package:med_support_gaza/app/data/models/consultation_model.dart';
import 'package:med_support_gaza/app/modules/consultation/controllers/consultation_controller.dart';
import 'package:med_support_gaza/app/modules/consultation/views/pages/chat_view.dart';
import 'package:med_support_gaza/app/modules/consultation/views/widgets/active_chat_card.dart';
import 'package:med_support_gaza/app/modules/consultation/views/widgets/consultation_card.dart';

class ConsultationsView extends GetView<ConsultationsController> {
  final int userId;

  ConsultationsView({required this.userId});

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
                  // color: Colors.teal,
                  // borderRadius: BorderRadius.circular(30.r),
                  borderRadius: BorderRadius.circular(50.r),
                  color: AppColors.primary.withOpacity(0.4),

                ),
                // labelColor: AppColors.primary,

                unselectedLabelColor: Colors.grey[700],
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(color: Colors.black,fontSize: 15.sp,fontWeight: FontWeight.bold,),
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
    onRefresh:() async {
    controller.loadConsultations();
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
      stream: chatService.getPatientConsultations(userId, status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
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
              userId: userId,
              onTap: () {
                Get.to(() =>
                    ChatView(
                      consultationId: consultation.id,
                      userId: userId,
                    ));
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

  ConsultationCard({
    required this.consultation,
    required this.userId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.teal.shade100,
                    child: Text(
                      consultation.doctor.firstName!.substring(0, 1).toUpperCase(),
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${consultation.doctor.firstName} ${consultation.doctor.lastName}",

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          consultation.doctor.major ?? 'Specialist',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusIndicator(consultation.status),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    _formatDate(consultation.startTime),
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    '${_formatTime(consultation.startTime)} - ${_formatTime(consultation.endTime)}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
              SizedBox(height: 12),
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
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        icon: Icon(Icons.chat),
        label: Text('Chat Now'),
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
        icon: Icon(Icons.event),
        label: Text('Starts at ${_formatTime(consultation.startTime)}'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue,
          side: BorderSide(color: Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(Icons.history),
        label: Text('View History'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey,
          side: BorderSide(color: Colors.grey),
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
