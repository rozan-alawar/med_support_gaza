class AppointmentModel {
  String status;
  List<Appointment> appointments;

  AppointmentModel({
    required this.status,
    required this.appointments,
  });

  AppointmentModel copyWith({
    String? status,
    List<Appointment>? appointments,
  }) =>
      AppointmentModel(
        status: status ?? this.status,
        appointments: appointments ?? this.appointments,
      );


  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
    status: json['status'],
    appointments: json['appointments'] != null
        ? List<Appointment>.from(
            json['appointments'].map((x) => Appointment.fromJson(x)))
        : [],
  );


}

class Appointment {
  int id;
  int? patientId;
  int doctorId;
  DateTime date;
  String period;
  String startTime;
  String endTime;
  String status;
  String? patientName;
  DateTime createdAt;
  DateTime updatedAt;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.period,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.patientName,
    required this.createdAt,
    required this.updatedAt,
  });

  Appointment copyWith({
    int? id,
    int? patientId,
    int? doctorId,
    DateTime? date,
    String? period,
    String? startTime,
    String? endTime,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Appointment(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        doctorId: doctorId ?? this.doctorId,
        date: date ?? this.date,
        period: period ?? this.period,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        status: status ?? this.status,
        patientName: patientName ?? this.patientName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
      id: json["id"],
      patientId: json["patient_id"],
      doctorId: json["doctor_id"],
      date: DateTime.parse(json["date"]),
      period: json["period"],
      startTime: json["start_time"],
      endTime: json["end_time"],
      patientName: json["patient_name"],
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]));
}
