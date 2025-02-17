import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';

import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/consultation/controllers/consultation_controller.dart';
import 'package:med_support_gaza/app/modules/consultation/views/widgets/active_chat_card.dart';
import 'package:med_support_gaza/app/modules/consultation/views/widgets/consultation_card.dart';

class ConsultationView extends GetView<ConsultationController> {
  const ConsultationView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: TabBar(
                    labelColor: AppColors.primary,
                    unselectedLabelColor: Colors.grey[600],
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                    dividerColor: Colors.transparent,
                    tabs: [
                      _buildTab('Active'),
                      _buildTab('Upcoming  '),
                      _buildTab('Past'),
                    ],
                  ),
                ),
              ),

              10.verticalSpace,

              // Tab= Bar View
              Obx(
                () => Expanded(
                  child: TabBarView(
                    children: [
                      // Active Tab
                      controller.getConsultationsByStatus('upcoming').isEmpty
                          ? _buildEmptyState('No active consultations')
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              itemCount: controller
                                  .getConsultationsByStatus('active')
                                  .length,
                              itemBuilder: (context, index) {
                                final consultation = controller
                                    .getConsultationsByStatus('active');
                                return ActiveConsultationCard(
                                  consultation: consultation[index],
                                  onStartChat: () =>
                                      controller.startChat(consultation[index]),
                                );
                              },
                            ),
                      // Upcoming Tab
                      controller.getConsultationsByStatus('upcoming').isEmpty
                          ? _buildEmptyState('No upcoming consultations')
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              itemCount: controller
                                  .getConsultationsByStatus('upcoming')
                                  .length,
                              itemBuilder: (context, index) {
                                final consultation = controller
                                    .getConsultationsByStatus('upcoming');
                                return ConsultationCard(
                                    consultation: consultation[index]);
                              },
                            ),
                      // Past Tab
                      controller.getConsultationsByStatus('past').isEmpty
                          ? _buildEmptyState('No past consultations')
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              itemCount: controller
                                  .getConsultationsByStatus('past')
                                  .length,
                              itemBuilder: (context, index) {
                                final consultation =
                                    controller.getConsultationsByStatus('past');
                                return ConsultationCard(
                                    consultation: consultation[index]);
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text) {
    return Tab(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64.sp,
            color: Colors.grey[300],
          ),
          16.verticalSpace,
          CustomText(
            message,
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }
}
