// class PatientModel {
//   final String? id;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String phoneNo;
//   final String age;
//   final String gender;
//   final String country;
//   final DateTime createdAt;
//
//   PatientModel({
//     this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.phoneNo,
//     required this.age,
//     required this.gender,
//     required this.country,
//     DateTime? createdAt,
//   }) : createdAt = createdAt ?? DateTime.now();
//
//   factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
//         id: json['id'],
//         firstName: json['firstName'],
//         lastName: json['lastName'],
//         email: json['email'],
//         phoneNo: json['phoneNo'],
//         age: json['age'],
//         gender: json['gender'],
//         country: json['country'],
//         createdAt: DateTime.parse(json['createdAt']),
//       );
//
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'firstName': firstName,
//         'lastName': lastName,
//         'email': email,
//         'phoneNo': phoneNo,
//         'age': age,
//         'gender': gender,
//         'country': country,
//         'createdAt': createdAt.toIso8601String(),
//       };
//
//   PatientModel copyWith({
//     String? id,
//     String? firstName,
//     String? lastName,
//     String? email,
//     String? phoneNo,
//     String? age,
//     String? gender,
//     String? country,
//     DateTime? createdAt,
//   }) =>
//       PatientModel(
//         id: id ?? this.id,
//         firstName: firstName ?? this.firstName,
//         lastName: lastName ?? this.lastName,
//         email: email ?? this.email,
//         phoneNo: phoneNo ?? this.phoneNo,
//         age: age ?? this.age,
//         gender: gender ?? this.gender,
//         country: country ?? this.country,
//         createdAt: createdAt ?? this.createdAt,
//       );
// }
