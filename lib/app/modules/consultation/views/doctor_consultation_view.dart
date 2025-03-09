import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';

import '../../../core/utils/app_colors.dart';
import '../controllers/doctor_consultation_controller.dart';

class DoctorConsultationView extends GetView<DoctorConsultationController> {
  const DoctorConsultationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            CircleAvatar(
                radius: 20.r,
                backgroundColor: const Color(0xffEEEEEE),
                child: Icon(
                  Icons.person,
                  color: AppColors.textLight,
                  size: 25.sp,
                )),
           12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "saja",
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  "Online",
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    bool isDoctor = message['name'] == 'saja';
                    return _buildMessageBubble(
                        message['message'] ?? "", message['time'] ?? "",
                        isDoctor: isDoctor);
                  },
                )),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }


  Widget _buildMessageBubble(String message, String time,
      {bool isDoctor = true}) {
    return Align(
      alignment: isDoctor ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
         decoration:BoxDecoration(
              color: isDoctor ? AppColors.primary : Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(isDoctor ? 16.r : 0),
                bottomRight: Radius.circular(isDoctor ? 0 : 16.r),
              ),
            ),
        // BoxDecoration(
        //   color: isDoctor ? Colors.teal : Colors.grey[200],
        //   borderRadius: BorderRadius.circular(8.0),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(color: isDoctor ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 4.0),
            Text(
              time,
              style: TextStyle(
                  color: isDoctor ? Colors.white70 : Colors.black54,
                  fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          10.width,
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'مراسلة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {},
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

}
