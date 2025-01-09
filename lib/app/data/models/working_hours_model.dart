class WorkingHours {
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final String startTime;
  final String endTime;
  bool isAvailable;
  final int maxAppointments;
  final int appointmentDuration; // in minutes
  final Map<String, dynamic>? breakTime;

  WorkingHours({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
    this.maxAppointments = 20,
    this.appointmentDuration = 30,
    this.breakTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'isAvailable': isAvailable,
      'maxAppointments': maxAppointments,
      'appointmentDuration': appointmentDuration,
      'breakTime': breakTime,
    };
  }

  factory WorkingHours.fromJson(Map<String, dynamic> json) {
    return WorkingHours(
      dayOfWeek: json['dayOfWeek'] ?? 1,
      startTime: json['startTime'] ?? '09:00',
      endTime: json['endTime'] ?? '17:00',
      isAvailable: json['isAvailable'] ?? true,
      maxAppointments: json['maxAppointments'] ?? 20,
      appointmentDuration: json['appointmentDuration'] ?? 30,
      breakTime: json['breakTime'],
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

  // Get available time slots
  List<String> getTimeSlots() {
    List<String> slots = [];
    DateTime start = _parseTime(startTime);
    DateTime end = _parseTime(endTime);

    while (start.isBefore(end)) {
      slots.add(_formatTime(start));
      start = start.add(Duration(minutes: appointmentDuration));
    }

    return slots;
  }

  // Check if a specific time is available
  bool isTimeSlotAvailable(String timeSlot) {
    if (!isAvailable) return false;

    DateTime time = _parseTime(timeSlot);
    DateTime start = _parseTime(startTime);
    DateTime end = _parseTime(endTime);

    // Check if time is within working hours
    if (time.isBefore(start) || time.isAfter(end)) return false;

    // Check if time is during break
    if (breakTime != null) {
      DateTime breakStart = _parseTime(breakTime!['start']);
      DateTime breakEnd = _parseTime(breakTime!['end']);
      if (time.isAfter(breakStart) && time.isBefore(breakEnd)) return false;
    }

    return true;
  }

  // Helper function to parse time string
  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  // Helper function to format time
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Copy with
  WorkingHours copyWith({
    int? dayOfWeek,
    String? startTime,
    String? endTime,
    bool? isAvailable,
    int? maxAppointments,
    int? appointmentDuration,
    Map<String, dynamic>? breakTime,
  }) {
    return WorkingHours(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      maxAppointments: maxAppointments ?? this.maxAppointments,
      appointmentDuration: appointmentDuration ?? this.appointmentDuration,
      breakTime: breakTime ?? this.breakTime,
    );
  }

  // Check if two working hours are equal
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkingHours &&
        other.dayOfWeek == dayOfWeek &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.isAvailable == isAvailable &&
        other.maxAppointments == maxAppointments &&
        other.appointmentDuration == appointmentDuration;
  }

  @override
  int get hashCode {
    return dayOfWeek.hashCode ^
    startTime.hashCode ^
    endTime.hashCode ^
    isAvailable.hashCode ^
    maxAppointments.hashCode ^
    appointmentDuration.hashCode;
  }
}

// Helper class for managing doctor schedules
class DoctorSchedule {
  static List<WorkingHours> getDefaultSchedule() {
    return List.generate(7, (index) {
      return WorkingHours(
        dayOfWeek: index + 1,
        startTime: '09:00',
        endTime: '17:00',
        isAvailable: true,
        breakTime: {
          'start': '13:00',
          'end': '14:00',
        },
      );
    });
  }

  static bool isHoliday(DateTime date) {
    // Add your holiday logic here
    return false;
  }

  static List<String> getAvailableSlots(WorkingHours workingHours, List<String> bookedSlots) {
    if (!workingHours.isAvailable) return [];

    final allSlots = workingHours.getTimeSlots();
    return allSlots.where((slot) =>
    !bookedSlots.contains(slot) && workingHours.isTimeSlotAvailable(slot)
    ).toList();
  }

  static bool isSlotAvailable(
      WorkingHours workingHours,
      String timeSlot,
      List<String> bookedSlots,
      ) {
    return workingHours.isTimeSlotAvailable(timeSlot) &&
        !bookedSlots.contains(timeSlot);
  }
}