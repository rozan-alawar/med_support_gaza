// appointment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum AppointmentStatus {
  upcoming,
  completed,
  cancelled,
  rescheduled,
  noShow
}

class AppointmentModel {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String patientName;
  final String specialization;
  final DateTime dateTime;
  final AppointmentStatus status;
  final String? notes;
  final DateTime createdAt;

  // Computed properties to maintain backwards compatibility
  String get time => "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  String get date => "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.patientName,
    required this.specialization,
    required this.dateTime,
    this.status = AppointmentStatus.upcoming,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Factory constructor to handle both old and new format
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // Handle old format where date and time were separate strings
    DateTime parsedDateTime;
    if (json['dateTime'] != null) {
      parsedDateTime = json['dateTime'] is Timestamp
          ? (json['dateTime'] as Timestamp).toDate()
          : DateTime.parse(json['dateTime']);
    } else {
      // Combine old date and time format
      final date = json['date'] as String;
      final time = json['time'] as String;
      final dateTimeString = "$date $time";
      parsedDateTime = DateTime.parse(dateTimeString);
    }

    return AppointmentModel(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? json['userId'] ?? '', // Handle old userId field
      doctorId: json['doctorId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      patientName: json['patientName'] ?? '',
      specialization: json['specialization'] ?? '',
      dateTime: parsedDateTime,
      status: _parseStatus(json['status']),
      notes: json['notes'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'patientName': patientName,
      'specialization': specialization,
      'dateTime': dateTime,
      'status': status.toString().split('.').last,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      // Include old format fields for backwards compatibility
      'date': date,
      'time': time,
    };
  }

  // Helper method to parse status
  static AppointmentStatus _parseStatus(dynamic status) {
    if (status == null) return AppointmentStatus.upcoming;

    if (status is String) {
      return AppointmentStatus.values.firstWhere(
            (e) => e.toString().split('.').last == status,
        orElse: () => AppointmentStatus.upcoming,
      );
    }

    return AppointmentStatus.upcoming;
  }

  // Create a copy with updated fields
  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? doctorName,
    String? patientName,
    String? specialization,
    DateTime? dateTime,
    AppointmentStatus? status,
    String? notes,
    DateTime? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      patientName: patientName ?? this.patientName,
      specialization: specialization ?? this.specialization,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper methods
  bool get isUpcoming => status == AppointmentStatus.upcoming;
  bool get isCancelled => status == AppointmentStatus.cancelled;
  bool get isCompleted => status == AppointmentStatus.completed;

  bool get isWithin24Hours {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    return difference.inHours <= 24 && difference.inHours > 0;
  }

  // Format methods for display
  String getFormattedTime() => time;
  String getFormattedDate() => date;

  // Format for specific date display (Today, Tomorrow, or date)
  String getDisplayDate() {
    final now = DateTime.now();
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'Today';
    }

    if (dateTime.year == tomorrow.year &&
        dateTime.month == tomorrow.month &&
        dateTime.day == tomorrow.day) {
      return 'Tomorrow';
    }

    return date;
  }

  // Validation methods
  bool get canBeCancelled {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    return difference.inHours > 2 && !isCancelled && !isCompleted;
  }

  bool get canBeRescheduled {
    return !isCancelled && !isCompleted;
  }
}