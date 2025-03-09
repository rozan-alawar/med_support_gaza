
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
  final String id;
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
        id: json['id'].toString(),
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
  final String email;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String phoneNumber;
  final String address;


  PatientModel({
    required this.id,
     this.userId = 1,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.address,

  });

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
    id: json['id'],
    userId: json['user_id'],
    firstName: json['first_name'],
    email: json['email']??"rosanalawer2002@gmail.com",
    lastName: json['last_name'],
    age: json['age'],
    gender: json['gender'],
    phoneNumber: json['phone_number'],
    address: json['address'],

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

  };
}
