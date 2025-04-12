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

import '../../../appointment_booking/controllers/appointment_booking_controller.dart';

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
    // final bookController= Get.find<AppointmentBookingController>();
    // print(bookController.)

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


