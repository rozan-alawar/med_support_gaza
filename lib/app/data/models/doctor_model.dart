import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
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
  final bool isApproved;

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
    this.isApproved = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastSeen = lastSeen ?? DateTime.now();

  // Get full name
  String get fullName => '$firstName $lastName';

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': id,
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
      'isApproved': isApproved,
    };
  }

  // Create from JSON
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['uid'] ?? '',
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
              .toList() ??
          [],
      about: json['about'] ?? '',
      expertise: List<String>.from(json['expertise'] ?? []),
      isApproved: json['isApproved'] ?? false,
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
    bool? isApproved,
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
      medicalCertificateUrl:
          medicalCertificateUrl ?? this.medicalCertificateUrl,
      rating: rating ?? this.rating,
      experience: experience ?? this.experience,
      languages: languages ?? this.languages,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      isVerified: isVerified ?? this.isVerified,
      workingHours: workingHours ?? this.workingHours,
      about: about ?? this.about,
      expertise: expertise ?? this.expertise,
      isApproved: isApproved ?? this.isApproved,
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



Doctor doctorFromJson(String str) => Doctor.fromJson(json.decode(str));

String doctorToJson(Doctor data) => json.encode(data.toJson());

class Doctor {
    String firstName;
    String lastName;
    String email;
    String password;
    String country;
    String phoneNumber;
    String gender;
    String major;
    dynamic certificate;
    String passwordConfirmation;

    Doctor({
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.password,
        required this.country,
        required this.phoneNumber,
        required this.gender,
        required this.major,
        required this.certificate,
        required this.passwordConfirmation,
    });

    Doctor copyWith({
        String? firstName,
        String? lastName,
        String? email,
        String? password,
        String? country,
        String? phoneNumber,
        String? gender,
        String? major,
        dynamic certificate,
        String? passwordConfirmation,
    }) => 
        Doctor(
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            email: email ?? this.email,
            password: password ?? this.password,
            country: country ?? this.country,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            gender: gender ?? this.gender,
            major: major ?? this.major,
            certificate: certificate ?? this.certificate,
            passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
        );

    factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        password: json["password"],
        country: json["country"],
        phoneNumber: json["phone_number"],
        gender: json["gender"],
        major: json["major"],
        certificate: json["certificate"],
        passwordConfirmation: json["password_confirmation"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "country": country,
        "phone_number": phoneNumber,
        "gender": gender,
        "major": major,
        "certificate": certificate,
        "password_confirmation": passwordConfirmation,
    };
}

