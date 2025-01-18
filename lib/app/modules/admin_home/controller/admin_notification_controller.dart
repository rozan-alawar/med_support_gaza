import 'package:get/get.dart';
import 'package:med_support_gaza/app/data/models/notification_model.dart';

class AdminNotificationController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedDate = 'Today'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      // Simulated API call - Replace with actual API integration
      await Future.delayed(const Duration(seconds: 1));

      final mockNotifications = [
        NotificationModel(
          id: '1',
          message: 'أرسل الطبيب طلب قبول',
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
          type: 'request',
        ),
        NotificationModel(
          id: '2',
          message: 'تم نشر المقال',
          timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
          type: 'article',
        ),
        // Add more mock notifications as needed
      ];

      notifications.value = mockNotifications;
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<NotificationModel> getFilteredNotifications() {
    final now = DateTime.now();
    switch (selectedDate.value) {
      case 'Today':
        return notifications.where((n) =>
        n.timestamp.year == now.year &&
            n.timestamp.month == now.month &&
            n.timestamp.day == now.day
        ).toList();
      case 'Yesterday':
        final yesterday = now.subtract(const Duration(days: 1));
        return notifications.where((n) =>
        n.timestamp.year == yesterday.year &&
            n.timestamp.month == yesterday.month &&
            n.timestamp.day == yesterday.day
        ).toList();
      default:
        return notifications;
    }
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final updatedNotification = notifications[index].copyWith(isRead: true);
      notifications[index] = updatedNotification;
    }
  }

  void clearAllNotifications() {
    notifications.clear();
  }

  void changeSelectedDate(String date) {
    selectedDate.value = date;
  }
}

