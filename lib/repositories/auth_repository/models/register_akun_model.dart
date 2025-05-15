class RegisterAkunModel {
  int? latitude;
  int? longitude;
  int? balance;
  String? role;
  int? id;
  String? email;
  String? username;
  String? phone;
  String? updatedAt;
  String? createdAt;
  Profile? profile;
  bool? authorized;
  String? token;
  String? refreshToken;

  RegisterAkunModel(
      {this.latitude,
      this.longitude,
      this.balance,
      this.role,
      this.id,
      this.email,
      this.username,
      this.phone,
      this.updatedAt,
      this.createdAt,
      this.profile,
      this.authorized,
      this.token,
      this.refreshToken});

  RegisterAkunModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    balance = json['balance'];
    role = json['role'];
    id = json['id'];
    email = json['email'];
    username = json['username'];
    phone = json['phone'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    authorized = json['authorized'];
    token = json['token'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['balance'] = balance;
    data['role'] = role;
    data['id'] = id;
    data['email'] = email;
    data['username'] = username;
    data['phone'] = phone;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['authorized'] = authorized;
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    return data;
  }
}

class Profile {
  int? id;
  String? fullname;
  int? userId;
  String? nik;
  String? avatarLink;
  String? gender;
  String? birthPlaceAndDate;
  String? villageUnit;
  String? administrativeVillage;
  String? subDistrict;
  String? religion;
  String? maritalStatus;
  String? occupation;
  String? citizenship;
  String? bloodType;
  String? validUntil;
  String? updatedAt;
  String? createdAt;

  Profile(
      {this.id,
      this.fullname,
      this.userId,
      this.nik,
      this.avatarLink,
      this.gender,
      this.birthPlaceAndDate,
      this.villageUnit,
      this.administrativeVillage,
      this.subDistrict,
      this.religion,
      this.maritalStatus,
      this.occupation,
      this.citizenship,
      this.bloodType,
      this.validUntil,
      this.updatedAt,
      this.createdAt});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    userId = json['user_id'];
    nik = json['nik'];
    avatarLink = json['avatar_link'];
    gender = json['gender'];
    birthPlaceAndDate = json['birth_place_and_date'];
    villageUnit = json['village_unit'];
    administrativeVillage = json['administrative_village'];
    subDistrict = json['sub_district'];
    religion = json['religion'];
    maritalStatus = json['marital_status'];
    occupation = json['occupation'];
    citizenship = json['citizenship'];
    bloodType = json['blood_type'];
    validUntil = json['valid_until'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullname'] = fullname;
    data['user_id'] = userId;
    data['nik'] = nik;
    data['avatar_link'] = avatarLink;
    data['gender'] = gender;
    data['birth_place_and_date'] = birthPlaceAndDate;
    data['village_unit'] = villageUnit;
    data['administrative_village'] = administrativeVillage;
    data['sub_district'] = subDistrict;
    data['religion'] = religion;
    data['marital_status'] = maritalStatus;
    data['occupation'] = occupation;
    data['citizenship'] = citizenship;
    data['blood_type'] = bloodType;
    data['valid_until'] = validUntil;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}
