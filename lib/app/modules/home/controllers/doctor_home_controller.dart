import 'package:get/get.dart';
import 'package:med_support_gaza/app/data/firebase_services/chat_services.dart';

class DoctorHomeController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final _chatService = ChatService();

  void changeBottomNavIndex(int index) {
    currentIndex.value = index;
  }

  var unreadMessages = 0.obs;

  void updateUnreadMessages(String consultationId, String currentUserId) async {
    bool isreaded =
        await _chatService.hasUnreadMessages(consultationId, currentUserId);
    if (isreaded) {
      unreadMessages.value = await _chatService.getUnreadMessageCount(
          consultationId, currentUserId);
    }
  }
}
