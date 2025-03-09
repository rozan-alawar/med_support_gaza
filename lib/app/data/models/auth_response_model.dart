class AuthResponseModel {
  final String message;
  final String token;
  final PatientModel patient;

  AuthResponseModel({
    required this.message,
    required this.token,
    required this.patient,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'],
      token: json['token'],
      patient: PatientModel.fromJson(json['patient']),
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'token': token,
    'patient': patient.toJson(),
  };
}

class PatientModel {
  final int id;
   int userId;
  final String firstName;
  final String lastName;
  final String email;
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
    lastName: json['last_name'],
    email: json['email'] ?? "rosanalawer2002@gmail.com",
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
    'email': email,
    'age': age,
    'gender': gender,
    'phone_number': phoneNumber,
    'address': address,
  };
}
