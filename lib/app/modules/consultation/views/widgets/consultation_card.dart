import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/data/models/consultation_model.dart';

class ConsultationCard extends StatelessWidget {
  final ConsultationModel consultation;
  final int userId;
  final VoidCallback onTap;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;

  ConsultationCard({
    required this.consultation,
    required this.userId,
    required this.onTap,
    this.onReschedule,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    // Get appropriate colors based on status
    final Map<String, dynamic> statusData = _getStatusData(consultation.status);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Card Header with avatar, name and specialty
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Enhanced avatar with gradient background
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          statusData['gradientStart'],
                          statusData['gradientEnd'],
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        consultation.doctor.firstName!
                            .substring(0, 1)
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  15.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${consultation.doctor.firstName} ${consultation.doctor.lastName}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.grey.shade800,
                          ),
                        ),
                       4.height,
                        Text(
                          consultation.doctor.major ?? 'Specialist',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusData['bgColor'],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusData['dotColor'],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          statusData['text'],
                          style: TextStyle(
                            color: statusData['textColor'],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Divider
            Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
            // Card Details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date with icon
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 20, color: Colors.grey.shade600),
                      SizedBox(width: 8),
                      Text(
                        _formatDate(consultation.startTime),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Time with icon
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 20, color: Colors.grey.shade600),
                      SizedBox(width: 8),
                      Text(
                        '${_formatTime(consultation.startTime)} - ${_formatTime(consultation.endTime)}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
                  SizedBox(height: 12),
                  // Action buttons
                  _buildActionButtons(consultation, statusData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      ConsultationModel consultation, Map<String, dynamic> statusData) {
    // Different actions based on status
    if (consultation.status == 'active') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onTap,
              child: Text('Check In'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: onReschedule,
              child: Text('Reschedule'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.grey.shade700,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: onCancel,
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (consultation.status == 'upcoming') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onTap,
              child: Text('Confirm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: onReschedule,
              child: Text('Reschedule'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.grey.shade700,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: onCancel,
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Past consultations
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(Icons.history),
              label: Text('View History'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.grey.shade700,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Map<String, dynamic> _getStatusData(String status) {
    switch (status) {
      case 'active':
        return {
          'text': 'Confirmed',
          'dotColor': Colors.green,
          'bgColor': Colors.green.withOpacity(0.1),
          'textColor': Colors.green,
          'gradientStart': Colors.green.shade300,
          'gradientEnd': Colors.teal,
        };
      case 'upcoming':
        return {
          'text': 'Pending',
          'dotColor': Colors.orange,
          'bgColor': Colors.orange.withOpacity(0.1),
          'textColor': Colors.orange,
          'gradientStart': Colors.purple.shade300,
          'gradientEnd': Colors.blue,
        };
      case 'past':
      default:
        return {
          'text': 'Past',
          'dotColor': Colors.grey,
          'bgColor': Colors.grey.withOpacity(0.1),
          'textColor': Colors.grey,
          'gradientStart': Colors.grey.shade400,
          'gradientEnd': Colors.grey.shade600,
        };
    }
  }

  String _formatDate(Timestamp timestamp) {
    return DateFormat('MMM dd, yyyy').format(timestamp.toDate());
  }

  String _formatTime(Timestamp timestamp) {
    return DateFormat('hh:mm a').format(timestamp.toDate());
  }
}
