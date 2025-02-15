import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../../../data/models/notification_model.dart';
import '../controllers/doctor_notification_controller.dart';

class DoctorNotificationView extends GetView<DoctorNotificationController> {
  const DoctorNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Obx(
          () => ListView.separated(
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) {
              // Check if we need a date divider
              if (index > 0) {
                final currentDate = controller.notifications[index].timestamp;
                final previousDate =
                    controller.notifications[index - 1].timestamp;

                if (!_isSameDay(currentDate, previousDate)) {
                  return _buildDateDivider(currentDate);
                }
              } else if (index == 0) {
                return _buildDateDivider(controller.notifications[0].timestamp);
              }
              return Divider(height: 1, color: Colors.grey[200]);
            },
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return _buildNotificationItem(notification);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return GestureDetector(
      onTap: () => controller.markAsRead(notification.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.grey.shade100 : Colors.white,
          border: Border.symmetric(
              horizontal: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              IconAssets.notification,
            ),
            10.width,
            CustomText(
              fontSize: 14.sp,
              notification.message,
              color: notification.isRead ? Colors.grey : Colors.black,
              fontWeight: FontWeight.w500,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: CustomText(
                _formatTime(notification.timestamp),
                fontSize: 11.sp,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
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
