// lib/app/modules/chat/widgets/message_bubble.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/models/message_model.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isSystemMessage) {
      return _buildSystemMessage();
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getBubbleColor(),
                    borderRadius: _getBubbleRadius(),
                  ),
                  child: _buildMessageContent(),
                ),
                4.height,
                _buildTimestamp(),
              ],
            ),
          ),
          if (isMe) ...[
            8.width,
            _buildStatusIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildSystemMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: CustomText(
              message.text,
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    if (message.isFileMessage) {
      return _buildFileMessage();
    }
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        CustomText(
          message.text,
          color: isMe ? Colors.white : Colors.black87,
          fontSize: 14.sp,
        ),
      ],
    );
  }

  Widget _buildFileMessage() {
    final iconData = message.isPDF
        ? Icons.picture_as_pdf
        : message.isImage
            ? Icons.image
            : Icons.insert_drive_file;

    return Container(
      constraints: BoxConstraints(
        minWidth: 200.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                color: isMe ? Colors.white70 : Colors.grey[600],
                size: 24.sp,
              ),
              8.width,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      message.fileName ?? '',
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 14.sp,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.height,
                    CustomText(
                      message.formattedFileSize,
                      color: isMe ? Colors.white70 : Colors.grey[600],
                      fontSize: 12.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (message.isImage && message.fileUrl != null) ...[
            8.height,
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                message.fileUrl!,
                width: double.infinity,
                height: 150.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 150.h,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error_outline),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 16.r,
      backgroundColor: AppColors.primary.withOpacity(0.2),
      child: Text(
        message.senderId.substring(0, 1).toUpperCase(),
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildTimestamp() {
    return CustomText(
      DateFormat('hh:mm a').format(message.timestamp),
      fontSize: 10.sp,
      color: Colors.grey[600],
    );
  }

  Widget _buildStatusIndicator() {
    IconData icon;
    Color color;

    switch (message.status) {
      case MessageStatus.sending:
        icon = Icons.access_time;
        color = Colors.grey;
        break;
      case MessageStatus.sent:
        icon = Icons.check;
        color = Colors.grey;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = Colors.grey;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = Colors.blue;
        break;
      case MessageStatus.failed:
        icon = Icons.error_outline;
        color = Colors.red;
        break;
    }

    return Icon(
      icon,
      size: 16.sp,
      color: color,
    );
  }

  Color _getBubbleColor() {
    if (message.isSystemMessage) {
      return Colors.grey[200]!;
    }
    return isMe ? AppColors.primary : Colors.grey[100]!;
  }

  BorderRadius _getBubbleRadius() {
    return BorderRadius.only(
      topLeft: Radius.circular(12.r),
      topRight: Radius.circular(12.r),
      bottomLeft: Radius.circular(isMe ? 12.r : 0),
      bottomRight: Radius.circular(isMe ? 0 : 12.r),
    );
  }
}
