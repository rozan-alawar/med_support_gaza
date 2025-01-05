// lib/app/data/models/doctor_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNo;
  final String speciality;
  final String country;
  final String? profileImage;
  final String gender;
  final bool isOnline;
  final bool isAvailable;
  final String medicalCertificateUrl;
  final double rating;
  final int experience;
  final List<String> languages;
  final DateTime createdAt;
  final DateTime lastSeen;
  final bool isVerified;
  final List<WorkingHours> workingHours;
  final String about;
  final List<String> expertise;

  DoctorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNo,
    required this.speciality,
    required this.country,
    this.profileImage,
    required this.gender,
    this.isOnline = false,
    this.isAvailable = true,
    required this.medicalCertificateUrl,
    this.rating = 0.0,
    this.experience = 0,
    this.languages = const ['Arabic', 'English'],
    DateTime? createdAt,
    DateTime? lastSeen,
    this.isVerified = false,
    this.workingHours = const [],
    this.about = '',
    this.expertise = const [],
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.lastSeen = lastSeen ?? DateTime.now();

  // Get full name
  String get fullName => '$firstName $lastName';

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNo': phoneNo,
      'speciality': speciality,
      'country': country,
      'profileImage': profileImage,
      'gender': gender,
      'isOnline': isOnline,
      'isAvailable': isAvailable,
      'medicalCertificateUrl': medicalCertificateUrl,
      'rating': rating,
      'experience': experience,
      'languages': languages,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSeen': Timestamp.fromDate(lastSeen),
      'isVerified': isVerified,
      'workingHours': workingHours.map((wh) => wh.toJson()).toList(),
      'about': about,
      'expertise': expertise,
    };
  }

  // Create from JSON
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      speciality: json['speciality'] ?? '',
      country: json['country'] ?? '',
      profileImage: json['profileImage'],
      gender: json['gender'] ?? '',
      isOnline: json['isOnline'] ?? false,
      isAvailable: json['isAvailable'] ?? true,
      medicalCertificateUrl: json['medicalCertificateUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      experience: json['experience'] ?? 0,
      languages: List<String>.from(json['languages'] ?? []),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      lastSeen: (json['lastSeen'] as Timestamp?)?.toDate(),
      isVerified: json['isVerified'] ?? false,
      workingHours: (json['workingHours'] as List?)
          ?.map((wh) => WorkingHours.fromJson(wh))
          .toList() ?? [],
      about: json['about'] ?? '',
      expertise: List<String>.from(json['expertise'] ?? []),
    );
  }

  // Copy with
  DoctorModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNo,
    String? speciality,
    String? country,
    String? profileImage,
    String? gender,
    bool? isOnline,
    bool? isAvailable,
    String? medicalCertificateUrl,
    double? rating,
    int? experience,
    List<String>? languages,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isVerified,
    List<WorkingHours>? workingHours,
    String? about,
    List<String>? expertise,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      speciality: speciality ?? this.speciality,
      country: country ?? this.country,
      profileImage: profileImage ?? this.profileImage,
      gender: gender ?? this.gender,
      isOnline: isOnline ?? this.isOnline,
      isAvailable: isAvailable ?? this.isAvailable,
      medicalCertificateUrl: medicalCertificateUrl ?? this.medicalCertificateUrl,
      rating: rating ?? this.rating,
      experience: experience ?? this.experience,
      languages: languages ?? this.languages,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      isVerified: isVerified ?? this.isVerified,
      workingHours: workingHours ?? this.workingHours,
      about: about ?? this.about,
      expertise: expertise ?? this.expertise,
    );
  }
}

// Working Hours Model
class WorkingHours {
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final String startTime;
  final String endTime;
  final bool isAvailable;

  WorkingHours({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'isAvailable': isAvailable,
    };
  }

  factory WorkingHours.fromJson(Map<String, dynamic> json) {
    return WorkingHours(
      dayOfWeek: json['dayOfWeek'] ?? 1,
      startTime: json['startTime'] ?? '09:00',
      endTime: json['endTime'] ?? '17:00',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  // Get day name
  String get dayName {
    switch (dayOfWeek) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}

// Example Firebase Service for Doctor
class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get doctor by ID
  Future<DoctorModel?> getDoctorById(String doctorId) async {
    try {
      final doc = await _firestore.collection('doctors').doc(doctorId).get();
      if (doc.exists) {
        return DoctorModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting doctor: $e');
      return null;
    }
  }

  // Update doctor availability
  Future<void> updateDoctorAvailability(String doctorId, bool isAvailable) async {
    try {
      await _firestore.collection('doctors').doc(doctorId).update({
        'isAvailable': isAvailable,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating doctor availability: $e');
    }
  }

  // Update doctor working hours
  Future<void> updateWorkingHours(
      String doctorId,
      List<WorkingHours> workingHours
      ) async {
    try {
      await _firestore.collection('doctors').doc(doctorId).update({
        'workingHours': workingHours.map((wh) => wh.toJson()).toList(),
      });
    } catch (e) {
      print('Error updating working hours: $e');
    }
  }

  // Get all doctors by specialty
  Stream<List<DoctorModel>> getDoctorsBySpecialty(String specialty) {
    return _firestore
        .collection('doctors')
        .where('speciality', isEqualTo: specialty)
        .where('isVerified', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => DoctorModel.fromJson(doc.data()))
          .toList();
    });
  }

  // Get all available doctors
  Stream<List<DoctorModel>> getAvailableDoctors() {
    return _firestore
        .collection('doctors')
        .where('isAvailable', isEqualTo: true)
        .where('isVerified', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => DoctorModel.fromJson(doc.data()))
          .toList();
    });
  }
}