import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/models/notification_model.dart';
import 'package:med_support_gaza/app/modules/admin_home/controller/admin_notification_controller.dart';

class AdminNotificationView extends GetView<AdminNotificationController> {
  const AdminNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          'notifications'.tr,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),

      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final notifications = controller.getFilteredNotifications();
        if (notifications.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: notifications.length,
          separatorBuilder: (context, index) {
            // Check if we need a date divider
            if (index > 0) {
              final currentDate = notifications[index].timestamp;
              final previousDate = notifications[index - 1].timestamp;

              if (!_isSameDay(currentDate, previousDate)) {
                return _buildDateDivider(currentDate);
              }
            } else if (index == 0) {
              return _buildDateDivider(notifications[0].timestamp);
            }
            return Divider(height: 1, color: Colors.grey[200]);
          },
          itemBuilder: (context, index) => _buildNotificationItem(notifications[index]),
        );
      }),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          // Time Column
          SizedBox(
            width: 50.w,
            child: CustomText(
              _formatTime(notification.timestamp),
              fontSize: 11.sp,
              color: Colors.grey[600],
              textAlign: TextAlign.center,
            ),
          ),
          16.horizontalSpace,
          // Icon
          GestureDetector(
            onTap:()=> controller.markAsRead(notification.id),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
          ),
          16.horizontalSpace,
          // Message
          Expanded(
            child: CustomText(
              notification.message.tr,
              fontSize: 12.sp,
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDivider(DateTime date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey[200],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomText(
              _isToday(date) ? 'today'.tr : 'yesterday'.tr,
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          16.verticalSpace,
          CustomText(
            'no_notifications'.tr,
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }
}