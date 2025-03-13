import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultationModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String? speciality;
  final String patientId;
  final String patientName;
  final Timestamp startTime;
  final Timestamp endTime;
  final String status;

  ConsultationModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    this.speciality,
    required this.patientId,
    required this.patientName,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory ConsultationModel.fromMap(String id, Map<String, dynamic> map) {
    return ConsultationModel(
      id: id,
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? 'Doctor',
      speciality: map['speciality'],
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? 'Patient',
      startTime: map['startTime'] ?? Timestamp.now(),
      endTime: map['endTime'] ?? Timestamp.now(),
      status: map['status'] ?? 'past',
    );
  }
}

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final Timestamp timestamp;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isRead,
  });

  factory MessageModel.fromMap(String id, Map<String, dynamic> map) {
    return MessageModel(
      id: id,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      isRead: map['isRead'] ?? false,
    );
  }
}