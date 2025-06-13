class MemberNearModel {
  String? message;
  List<MemberNearData>? data;

  MemberNearModel({this.message, this.data});

  MemberNearModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <MemberNearData>[];
      json['data'].forEach((v) {
        data!.add(MemberNearData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MemberNearData {
  int? id;
  String? email;
  double? latitude;
  double? longitude;
  String? phone;
  Profile? profile;
  double? distance;

  MemberNearData(
      {this.id,
      this.email,
      this.latitude,
      this.longitude,
      this.phone,
      this.profile,
      this.distance});

  MemberNearData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phone = json['phone'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    distance = (json['distance'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['phone'] = phone;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['distance'] = distance;
    return data;
  }
}

class Profile {
  int? id;
  String? fullname;
  String? kta;
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
      this.kta,
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
    kta = json['kta'];
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
    data['kta'] = kta;
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
