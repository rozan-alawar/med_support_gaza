class LoginResponse {
  String? successMessage;
  String? status;
  Login? login;

  LoginResponse({this.successMessage, this.status, this.login});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    successMessage = json['success_message'];
    status = json['status'];
    login = json['data'] != null ? Login.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success_message'] = successMessage;
    data['status'] = status;
    if (login != null) {
      data['data'] = login!.toJson();
    }
    return data;
  }
}

class Login {
  String? phoneCode;
  String? phoneNumber;
  bool? isExists;

  Login({this.phoneCode, this.phoneNumber, this.isExists});

  Login.fromJson(Map<String, dynamic> json) {
    phoneCode = json['phone_code'];
    phoneNumber = json['phone_number'];
    isExists = json['is_exists'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_code'] = phoneCode;
    data['phone_number'] = phoneNumber;
    data['is_exists'] = isExists;
    return data;
  }
}
