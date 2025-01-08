class AppointmentModel {
  final String id;
  final String userId;
  final String doctorName;
  final String specialization;
  final DateTime date;
  final String time;
  final String status;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.doctorName,
    required this.specialization,
    required this.date,
    required this.time,
    this.status = 'upcoming',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'doctorName': doctorName,
      'specialization': specialization,
      'date': date.toIso8601String(),
      'time': time,
      'status': status,
    };
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      userId: json['userId'],
      doctorName: json['doctorName'],
      specialization: json['specialization'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      status: json['status'] ?? 'upcoming',
    );
  }
}