class SpecializationsResponse {
  final List<Specialization> specializations;

  SpecializationsResponse({
    required this.specializations,
  });

  factory SpecializationsResponse.fromJson(Map<String, dynamic> json) {
    return SpecializationsResponse(
      specializations: (json['specializations'] as List)
          .map((item) => Specialization.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specializations': specializations.map((item) => item.toJson()).toList(),
    };
  }
}
class Specialization {
   String major;
   int doctorCount;

  Specialization({
    required this.major,
    required this.doctorCount,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      major: json['major'] as String,
      doctorCount: json['doctor_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'major': major,
      'doctor_count': doctorCount,
    };
  }
}
