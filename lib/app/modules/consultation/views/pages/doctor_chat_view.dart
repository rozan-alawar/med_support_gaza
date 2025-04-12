import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../data/models/consultation_model.dart';
import '../../controllers/doctor_chat_controller.dart';
import '../../controllers/doctor_consultation_controller.dart';

class DoctorChatView extends GetView<DoctorChatController> {
  final int userId;
  final String consultationId;
  TextEditingController messageController = TextEditingController();
  DoctorChatView({required this.consultationId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              "${controller.consultation.value?.patient.firstName} ${controller.consultation.value?.patient.lastName} " ??
                  'Consultation',
              style: const TextStyle(color: Colors.white),
            )),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Show consultation details
              _showConsultationDetails(context, controller.consultation.value);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Status banner
            _buildStatusBanner(controller),

            // Messages list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isUser = message.senderId == userId;

                  return _buildMessageBubble(message, isUser);
                },
              ),
            ),

            // Input field - only visible for active consultations
            if (controller.canSendMessage) _buildMessageInput(controller),

            // Past consultation notice
            if (controller.isConsultationPast)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.grey.shade200,
                child: Text(
                  'This consultation has ended',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

            // Upcoming consultation notice
            if (controller.isConsultationUpcoming)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade100,
                child: Text(
                  'This consultation will start at ${_formatTime(controller.consultation.value?.startTime)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildStatusBanner(DoctorChatController _controller) {
    final consultation = _controller.consultation.value;
    if (consultation == null) return const SizedBox();

    Color backgroundColor;
    String statusText;

    switch (consultation.status) {
      case 'active':
        backgroundColor = Colors.green.shade100;
        statusText = controller.remainingTime.value;
        break;
      case 'upcoming':
        backgroundColor = Colors.blue.shade100;
        statusText = 'Upcoming - ${_formatDate(consultation.startTime)}';
        break;
      case 'past':
        backgroundColor = Colors.grey.shade200;
        statusText = 'Consultation ended';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        statusText = '';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: backgroundColor,
      child: Row(
        children: [
          Icon(
            consultation.status == 'active'
                ? Icons.timer
                : consultation.status == 'upcoming'
                    ? Icons.event
                    : Icons.event_busy,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? Colors.teal : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        constraints: const BoxConstraints(maxWidth: 250),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _formatTime(message.timestamp) ?? '',
              style: TextStyle(
                fontSize: 10,
                color: isUser ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(DoctorChatController _controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 2,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              onChanged: (value) => _controller.message.value = value,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.teal),
            onPressed: ()async {
               _controller.sendMessage(messageController.text);
                 messageController.clear();
            },
          ),
        ],
      ),
    );
  }

  void _showConsultationDetails(
      BuildContext context, ConsultationModel? consultation) {
    if (consultation == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Consultation Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Patient',
                "${consultation.patient.firstName} ${consultation.patient.lastName} "),
            const SizedBox(height: 8),
            _detailRow('Date', _formatDate(consultation.startTime)),
            const SizedBox(height: 8),
            _detailRow('Time',
                '${_formatTime(consultation.startTime)} - ${_formatTime(consultation.endTime)}'),
            const SizedBox(height: 8),
            _detailRow('Status', consultation.status.toUpperCase()),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value ?? 'N/A')),
      ],
    );
  }

  String? _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return null;
    return DateFormat('hh:mm a').format(timestamp.toDate());
  }

  String? _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return null;
    return DateFormat('MMM dd, yyyy').format(timestamp.toDate());
  }
}
