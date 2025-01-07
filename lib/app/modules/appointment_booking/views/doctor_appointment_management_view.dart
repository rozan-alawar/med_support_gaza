import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../controllers/doctor_appointment_management_controller.dart';

class DoctorAppointmentManagementView
    extends GetView<DoctorAppointmentManagementController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: CustomText(
          'ما هي المواعيد المتاحة لديك؟',
          fontFamily: 'Lama Sans',
          fontSize: 20.sp,
          color: AppColors.textgray,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('اليوم'),
                Spacer(),
                Obx(() => Checkbox(
                      value: controller.morningSelected.value,
                      onChanged: (value) => controller.toggleMorning(),
                    )),
                Text('الفترة الصباحية'),
                Spacer(),
                Obx(() => Checkbox(
                      value: controller.eveningSelected.value,
                      onChanged: (value) => controller.toggleEvening(),
                    )),
                Text('الفترة المسائية'),
              ],
            ),
            ElevatedButton(
              onPressed: controller.addAppointment,
              child: Text('إضافة'),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = controller.appointments[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                              '${appointment['date']} - ${appointment['period']}'),
                          subtitle: Text(appointment['time']!),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                controller.deleteAppointment(index),
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
