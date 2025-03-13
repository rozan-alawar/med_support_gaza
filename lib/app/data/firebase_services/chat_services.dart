import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';


class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> bookAppointment({
    required String doctorId,
    required String patientId,
    required Timestamp startTime,
    required Timestamp endTime,
  }) async {
    // إنشاء سجل استشارة جديد مع الحالة "upcoming"
    await _firestore.collection('consultations').add({
      'doctorId': doctorId,
      'patientId': patientId,
      'status': 'upcoming',
      'startTime': startTime,
      'endTime': endTime,
    });
  }

  // Get consultations by status and user ID
  Stream<QuerySnapshot> getConsultations(String userId, String status) {
    return _firestore
        .collection('consultations')
        .where('patientId', isEqualTo: userId)
        .where('status', isEqualTo: status)
        .orderBy('startTime', descending: true)
        .snapshots();
  }

  // Get consultation detail
  Stream<DocumentSnapshot> getConsultation(String consultationId) {
    return _firestore
        .collection('consultations')
        .doc(consultationId)
        .snapshots();
  }

  // Get messages for a consultation
  Stream<QuerySnapshot> getMessages(String consultationId) {
    return _firestore
        .collection('consultations')
        .doc(consultationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Send a message
  Future<void> sendMessage(String consultationId, String senderId, String message) async {
    await _firestore
        .collection('consultations')
        .doc(consultationId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  // Update consultation status (active -> past)
  Future<void> updateConsultationStatus(String consultationId, String status) async {
    await _firestore
        .collection('consultations')
        .doc(consultationId)
        .update({'status': status});
  }

  // Check if consultation time is active
  bool isConsultationActive(Timestamp startTime, Timestamp endTime) {
    final now = Timestamp.now();
    return now.compareTo(startTime) >= 0 && now.compareTo(endTime) <= 0;
  }
}