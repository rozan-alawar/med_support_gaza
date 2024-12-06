class User {
  int? id;
  String? accessToken;
  String? firstName;
  String? lastName;
  String? dob;
  int? phoneCode;
  String? phoneNumber;
  String? status;
  String? phoneNumberFull;
  RoleType? roleType;
  bool? isExists;

  User({
    this.id,
    this.accessToken,
    this.firstName,
    this.lastName,
    this.dob,
    this.phoneCode,
    this.phoneNumber,
    this.status,
    this.phoneNumberFull,
    this.roleType,
    this.isExists,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accessToken = json['access_token'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    phoneCode = json['phone_code'];
    phoneNumber = json['phone_number'];
    status = json['status'];
    phoneNumberFull = json['phone_number_full'];
    roleType =
        json['role_type'] != null ? RoleType.fromJson(json['role_type']) : null;
    isExists = json['is_exists'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['access_token'] = accessToken;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['dob'] = dob;
    data['phone_code'] = phoneCode;
    data['phone_number'] = phoneNumber;
    data['status'] = status;
    data['phone_number_full'] = phoneNumberFull;
    if (roleType != null) {
      data['role_type'] = roleType!.toJson();
    }
    data['is_exists'] = isExists;
    return data;
  }
}

class RoleType {
  int? id;
  String? roleType;

  RoleType({this.id, this.roleType});

  RoleType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleType = json['role_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role_type'] = roleType;
    return data;
  }
}
