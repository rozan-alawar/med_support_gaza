import 'package:get/get.dart';
import '../../../data/models/notification_model.dart';

class DoctorNotificationController extends GetxController {
  final notifications = <NotificationModel>[
    NotificationModel(
      id: '1',
      message: 'saja send you a message',
      timestamp: DateTime.now(),
      type: 'message',
      isRead: true
    ),
    NotificationModel(
      id: '2',
      message: 'session started',
      timestamp: DateTime.now(),
      type: 'session_started',
    ),
  ].obs;

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
    }
  }
}
