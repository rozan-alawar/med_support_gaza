// login_response_model.dart

class AdminLoginResponseModel {
  final String message;
  final String token;
  final AdminModel admin;

  AdminLoginResponseModel({
    required this.message,
    required this.token,
    required this.admin,
  });

  factory AdminLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return AdminLoginResponseModel(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      admin: AdminModel.fromJson(json['admin'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
      'admin': admin.toJson(),
    };
  }
}

class AdminModel {
  final int id;
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String number;
  final String jobTitle;

  AdminModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.number,
    required this.jobTitle,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      number: json['number'] ?? '',
      jobTitle: json['job_title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'number': number,
      'job_title': jobTitle,
    };
  }

  // Helper method to get full name
  String get fullName => '$firstName $lastName';
}