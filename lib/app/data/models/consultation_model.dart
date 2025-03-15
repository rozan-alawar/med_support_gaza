import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_support_gaza/app/data/models/auth_response_model.dart';
import 'package:med_support_gaza/app/data/models/doctor.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/controllers/appointment_booking_controller.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/controllers/appointment_chat_controller.dart';

class ConsultationModel {
  final String id;
  final Doctor doctor;
  final PatientModel patient;
  final Timestamp startTime;
  final Timestamp endTime;
  final String status;

  ConsultationModel({
    required this.id,
    required this.doctor,
    required this.patient,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory ConsultationModel.fromMap(String id, Map<String, dynamic> map) {
    // Create doctor object from embedded data
    Doctor doctor;
    if (map['doctor'] is Map) {
      doctor = Doctor.fromJson(Map<String, dynamic>.from(map['doctor']));
    } else {
      // Try to create doctor with minimal data
      doctor = Doctor(
        id: map['doctorId'],
        userId: null,
        firstName: map['doctorName']?.split(' ').first,
        lastName: map['doctorName']?.split(' ').length > 1 ? map['doctorName'].split(' ').last : '',
        email: null,
        major: map['speciality'],
        country: null,
        phoneNumber: null,
        averageRating: null,
        image: null,
        certificate: null,
        gender: null,
      );
    }

    // Create patient object from embedded data
    PatientModel patient;
    if (map['patient'] is Map) {
      patient = PatientModel.fromJson(Map<String, dynamic>.from(map['patient']));
    } else {
      // Try to create patient with minimal data (using default values where needed)
      patient = PatientModel(
        id: map['patientId'] ?? 0,
        userId: 1,
        firstName: map['patientName']?.split(' ').first ?? 'Unknown',
        lastName: map['patientName']?.split(' ').length > 1 ? map['patientName'].split(' ').last : '',
        email: map['patientEmail'] ?? 'unknown@example.com',
        age: 0,
        gender: 'Unknown',
        phoneNumber: '',
        address: '',
      );
    }

    return ConsultationModel(
      id: id,
      doctor: doctor,
      patient: patient,
      startTime: map['startTime'] ?? Timestamp.now(),
      endTime: map['endTime'] ?? Timestamp.now(),
      status: map['status'] ?? 'past',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctor': doctor.toJson(),
      'doctorId': doctor.id,
      'doctorName': '${doctor.firstName} ${doctor.lastName}',
      'speciality': doctor.major,
      'patient': patient.toJson(),
      'patientId': patient.id,
      'patientName': '${patient.firstName} ${patient.lastName}',
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
    };
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