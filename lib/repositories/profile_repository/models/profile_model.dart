// ignore_for_file: unnecessary_new

class ProfileModel {
  int? id;
  String? username;
  String? email;
  String? phone;
  int? latitude;
  int? longitude;
  String? emailVerified;
  String? fcmToken;
  int? balance;
  String? role;
  String? storeId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Profile? profile;

  ProfileModel(
      {this.id,
      this.username,
      this.email,
      this.phone,
      this.latitude,
      this.longitude,
      this.emailVerified,
      this.fcmToken,
      this.balance,
      this.role,
      this.storeId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.profile});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    emailVerified = json['email_verified'];
    fcmToken = json['fcm_token'];
    balance = json['balance'];
    role = json['role'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['phone'] = phone;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['email_verified'] = emailVerified;
    data['fcm_token'] = fcmToken;
    data['balance'] = balance;
    data['role'] = role;
    data['store_id'] = storeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  int? id;
  String? fullname;
  String? avatarLink;
  String? address;
  String? gender;
  String? nik;
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
  int? userId;
  String? createdAt;
  String? updatedAt;

  Profile(
      {this.id,
      this.fullname,
      this.avatarLink,
      this.address,
      this.gender,
      this.nik,
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
      this.userId,
      this.createdAt,
      this.updatedAt});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    avatarLink = json['avatar_link'];
    address = json['address'];
    gender = json['gender'];
    nik = json['nik'];
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
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullname'] = fullname;
    data['avatar_link'] = avatarLink;
    data['address'] = address;
    data['gender'] = gender;
    data['nik'] = nik;
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
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
