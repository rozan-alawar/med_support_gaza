import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_support_gaza/app/data/models/auth_response_model.dart';
import 'package:med_support_gaza/app/data/models/consultation_model.dart';
import 'package:med_support_gaza/app/data/models/doctor.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> bookAppointment({
    required Doctor doctor,
    required PatientModel patient,
    required Timestamp startTime,
    required Timestamp endTime,
  }) async {
    await _firestore.collection('consultations').add({
      'doctor': doctor.toJson(),
      'doctorId': doctor.id,
      'doctorName': '${doctor.firstName} ${doctor.lastName}',
      'speciality': doctor.major,
      'patient': patient.toJson(),
      'patientId': patient.id,
      'patientName': '${patient.firstName} ${patient.lastName}',
      'status': 'active',
      'startTime': startTime,
      'endTime': endTime,
    });
  }

  void monitorAppointmentsStatus() {
    _firestore.collection('consultations').snapshots().listen((snapshot) {
      final now = Timestamp.now();

      for (var doc in snapshot.docs) {
        final startTime = doc['startTime'] as Timestamp;
        final endTime = doc['endTime'] as Timestamp;
        final status = doc['status'] as String;

        if (now.seconds >= startTime.seconds &&
            now.seconds <= endTime.seconds &&
            status != 'active') {
          doc.reference.update({'status': 'active'});
        }

        if (now.seconds > endTime.seconds && status != 'past') {
          doc.reference.update({'status': 'past'});
        }
      }
    });
  }

  // Get consultations by status and user ID (patient)
  Stream<List<ConsultationModel>> getPatientConsultations(
      int patientId, String status) {
    return _firestore
        .collection('consultations')
        .where('patientId', isEqualTo: patientId)
        .where('status', isEqualTo: status)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {
        return ConsultationModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Get consultations by status and doctor ID
  Stream<List<ConsultationModel>> getDoctorConsultations(
      int doctorId, String status) {
    return _firestore
        .collection('consultations')
        .where('doctorId', isEqualTo: doctorId)
        .where('status', isEqualTo: status)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ConsultationModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Get consultation detail
  Stream<ConsultationModel> getConsultation(String consultationId) {
    return _firestore
        .collection('consultations')
        .doc(consultationId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return ConsultationModel.fromMap(snapshot.id, snapshot.data()!);
      } else {
        throw Exception('Consultation not found');
      }
    });
  }

  // Get messages for a consultation
  // In ChatService class
  Stream<QuerySnapshot> getMessages(String consultationId) {
    return _firestore
        .collection('consultations')
        .doc(consultationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Send a message
  Future<void> sendMessage(String consultationId, int senderId,
      String senderName, String message) async {
    await _firestore
        .collection('consultations')
        .doc(consultationId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'senderName': senderName,
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  // Update consultation status (active -> past)
  Future<void> updateConsultationStatus(
      String consultationId, String status) async {
    await _firestore
        .collection('consultations')
        .doc(consultationId)
        .update({'status': status});
  }

  Future<void> updateConsultationStatusByDoctor(
      String appointmentId, String status) async {
    // Search for the appointment id in the consultations collection and update the status
    final consultationsRef = _firestore.collection('consultations');
    final consultationQuery = await consultationsRef
        .where('appointmentId', isEqualTo: appointmentId)
        .get();
    if (consultationQuery.docs.isNotEmpty) {
      final consultationDocId = consultationQuery.docs.first.id;
      await consultationsRef.doc(consultationDocId).update({'status': status});
    } else {
      throw Exception('Consultation not found');
    }
  }

  // Check if consultation time is active
  bool isConsultationActive(Timestamp startTime, Timestamp endTime) {
    final now = Timestamp.now();
    return now.compareTo(startTime) >= 0 && now.compareTo(endTime) <= 0;
  }

  // Mark all messages as read
  Future<void> markAllMessagesAsRead(
      String consultationId, String currentUserId) async {
    final messagesRef = _firestore
        .collection('consultations')
        .doc(consultationId)
        .collection('messages');

    // Get all unread messages not sent by the current user
    final unreadMessages = await messagesRef
        .where('isRead', isEqualTo: false)
        .where('senderId', isNotEqualTo: currentUserId)
        .get();

    // Create a batch to update all messages efficiently
    final batch = _firestore.batch();

    for (var doc in unreadMessages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    // Commit the batch update
    await batch.commit();
  }

  // Get unread message count for a consultation
  Future<int> getUnreadMessageCount(
      String consultationId, String currentUserId) async {
    final messagesRef = _firestore
        .collection('consultations')
        .doc(consultationId)
        .collection('messages');

    final unreadMessages = await messagesRef
        .where('isRead', isEqualTo: false)
        .where('senderId', isNotEqualTo: currentUserId)
        .get();

    return unreadMessages.docs.length;
  }

  // Check if a consultation has any unread messages
  Future<bool> hasUnreadMessages(
      String consultationId, String currentUserId) async {
    final count = await getUnreadMessageCount(consultationId, currentUserId);
    return count > 0;
  }
}
