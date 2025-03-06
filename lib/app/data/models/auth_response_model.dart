class AuthResponseModel {
  final String message;
  final String token;
  final UserModel user;

  AuthResponseModel({
    required this.message,
    required this.token,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'],
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'token': token,
        'user': user.toJson(),
      };
}

class UserModel {
  final int id;
  final String username;
  final String email;
  final String role;
  final String? otpCode;
  final DateTime? otpExpiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PatientModel? patient;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.otpCode,
    this.otpExpiresAt,
    required this.createdAt,
    required this.updatedAt,
    this.patient,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        role: json['role'],
        otpCode: json['otp_code'],
        otpExpiresAt: json['otp_expires_at'] != null
            ? DateTime.parse(json['otp_expires_at'])
            : null,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        patient: json['patient'] != null
            ? PatientModel.fromJson(json['patient'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'role': role,
        'otp_code': otpCode,
        'otp_expires_at': otpExpiresAt?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'patient': patient?.toJson(),
      };
}

class PatientModel {
  final int id;
  final int userId;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String phoneNumber;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;

  PatientModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
        id: json['id'],
        userId: json['user_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        age: json['age'],
        gender: json['gender'],
        phoneNumber: json['phone_number'],
        address: json['address'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'age': age,
        'gender': gender,
        'phone_number': phoneNumber,
        'address': address,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
