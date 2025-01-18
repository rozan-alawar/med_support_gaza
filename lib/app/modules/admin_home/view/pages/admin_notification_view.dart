import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/models/notification_model.dart';
import 'package:med_support_gaza/app/modules/admin_home/controller/admin_notification_controller.dart';

class AdminNotificationView extends GetView<AdminNotificationController> {
  const AdminNotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          'Notifications',
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, size: 24.sp),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateFilter(),
          Expanded(
            child: Obx(() {
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
                separatorBuilder: (context, index) => _buildDateDivider(notifications, index),
                itemBuilder: (context, index) => _buildNotificationItem(notifications[index]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter() {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildDateFilterChip('Today'),
          12.horizontalSpace,
          _buildDateFilterChip('Yesterday'),
        ],
      ),
    );
  }

  Widget _buildDateFilterChip(String date) {
    return Obx(() {
      final isSelected = controller.selectedDate.value == date;
      return GestureDetector(
        onTap: () => controller.changeSelectedDate(date),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey[300]!,
            ),
          ),
          child: CustomText(
            date,
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 14.sp,
          ),
        ),
      );
    });
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: AppColors.primary,
            size: 20.sp,
          ),
        ),
        title: CustomText(
          notification.message,
          fontSize: 14.sp,
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
        subtitle: CustomText(
          _formatTime(notification.timestamp),
          fontSize: 12.sp,
          color: Colors.grey[600],
        ),
        onTap: () => controller.markAsRead(notification.id),
      ),
    );
  }

  Widget _buildDateDivider(List<NotificationModel> notifications, int index) {
    if (index == 0) return SizedBox.shrink();

    final currentDate = notifications[index].timestamp;
    final previousDate = notifications[index - 1].timestamp;

    if (currentDate.day != previousDate.day) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: CustomText(
                _formatDate(currentDate),
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
      );
    }
    return SizedBox.shrink();
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
            'No notifications',
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text('Mark all as read'),
              onTap: () {
                // Implement mark all as read
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text('Clear all notifications'),
              onTap: () {
                controller.clearAllNotifications();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'request':
        return Icons.person_add_outlined;
      case 'article':
        return Icons.article_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
      return 'Yesterday';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}