class DoctorModel {
    DoctorModel({
        required this.message,
        required this.token,
        required this.doctor,
    });

    final String? message;
    final String? token;
    final Doctor? doctor;

    DoctorModel copyWith({
        String? message,
        String? token,
        Doctor? doctor,
    }) {
        return DoctorModel(
            message: message ?? this.message,
            token: token ?? this.token,
            doctor: doctor ?? this.doctor,
        );
    }

    factory DoctorModel.fromJson(Map<String, dynamic> json){ 
        return DoctorModel(
            message: json["message"],
            token: json["token"],
            doctor: json["doctor"] == null ? null : Doctor.fromJson(json["doctor"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
        "doctor": doctor?.toJson(),
    };

}

class Doctor {
    Doctor({
        required this.id,
        required this.userId,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.major,
        required this.country,
        required this.phoneNumber,
        required this.averageRating,
        required this.image,
        required this.certificate,
        required this.gender,
    });

    final int? id;
    final int? userId;
    final String? firstName;
    final String? lastName;
    final String? email;
    final String? major;
    final String? country;
    final String? phoneNumber;
    final String? averageRating;
    final String? image;
    final String? certificate;
    final String? gender;

    Doctor copyWith({
        int? id,
        int? userId,
        String? firstName,
        String? lastName,
        String? email,
        String? major,
        String? country,
        String? phoneNumber,
        String? averageRating,
        String? image,
        String? certificate,
        String? gender,
    }) {
        return Doctor(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            email: email ?? this.email,
            major: major ?? this.major,
            country: country ?? this.country,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            averageRating: averageRating ?? this.averageRating,
            image: image ?? this.image,
            certificate: certificate ?? this.certificate,
            gender: gender ?? this.gender,
        );
    }

    factory Doctor.fromJson(Map<String, dynamic> json){ 
        return Doctor(
            id: json["id"],
            userId: json["user_id"],
            firstName: json["first_name"],
            lastName: json["last_name"],
            email: json["email"],
            major: json["major"],
            country: json["country"],
            phoneNumber: json["phone_number"],
            averageRating: json["average_rating"],
            image: json["image"],
            certificate: json["certificate"],
            gender: json["gender"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "major": major,
        "country": country,
        "phone_number": phoneNumber,
        "average_rating": averageRating,
        "image": image,
        "certificate": certificate,
        "gender": gender,
    };

}

/*
{
	"message": "Login successful.",
	"token": "52|k665WyQR9rpqcIeS6kKtUSlRo0lb8swlXNcqpBz525f9e735",
	"doctor": {
		"id": 2,
		"user_id": 14,
		"first_name": "John",
		"last_name": "Doe",
		"email": "doctor1@gmail.com",
		"major": "Cardiology",
		"country": "Germany",
		"phone_number": "123456789",
		"average_rating": "4.50",
		"image": "http://medsupport-gaza-cfd5c72a1744.herokuapp.com/storage",
		"certificate": "http://medsupport-gaza-cfd5c72a1744.herokuapp.com/storage/cert123.pdf",
		"gender": "male"
	}
}*/