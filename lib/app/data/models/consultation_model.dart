
class ConsultationModel {
   String id;
   String doctorName;
   String specialty;
   DateTime date;
   String time;
   String status; // 'upcoming', 'active', 'completed'

  ConsultationModel({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.status,
  });

  // Get doctor initials
  String get doctorInitials {
    final nameParts = doctorName.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return doctorName.substring(0, 2).toUpperCase();
  }

  // Format date
  String get formattedDate {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  // Check if consultation is happening now
  bool get isActive => status == 'active';

  // Check if consultation can be joined
  bool get canJoin {
    if (status != 'upcoming' && status != 'active') return false;

    final now = DateTime.now();
    final consultationHour = int.parse(time.split(':')[0]);
    final consultationMinute = int.parse(time.split(':')[1]);

    final consultationTime = DateTime(
      date.year,
      date.month,
      date.day,
      consultationHour,
      consultationMinute,
    );

    // Can join 5 minutes before until 30 minutes after start time
    return now.isAfter(consultationTime.subtract(const Duration(minutes: 5))) &&
        now.isBefore(consultationTime.add(const Duration(minutes: 30)));
  }
}