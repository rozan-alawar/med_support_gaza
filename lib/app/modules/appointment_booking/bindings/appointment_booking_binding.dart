import 'package:get/get.dart';

import '../controllers/appointment_booking_controller.dart';

class AppointmentBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentBookingController>(
      () => AppointmentBookingController(),
    );
  }
}
