
import 'dart:convert';

import 'package:med_support_gaza/app/data/models/doctor.dart';

class GetDoctorsResponse {
  final String status;
  final List<Doctor> doctors;

  GetDoctorsResponse({
    required this.status,
    required this.doctors,
  });

  factory GetDoctorsResponse.fromJson(String source) {
    final jsonData = json.decode(source);
    return GetDoctorsResponse(
      status: jsonData['status'],
      doctors: (jsonData['doctors'] as List)
          .map((doctor) => Doctor.fromJson(doctor))
          .toList(),
    );
  }

  String toJson() {
    return json.encode({
      'status': status,
      'doctors': doctors.map((doctor) => doctor.toJson()).toList(),
    });
  }
}