class MemberNearModel {
  String? message;
  List<MemberNearData>? data;

  MemberNearModel({this.message, this.data});

  MemberNearModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <MemberNearData>[];
      json['data'].forEach((v) {
        data!.add(new MemberNearData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
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
  int? distance;

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
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['phone'] = this.phone;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    data['distance'] = this.distance;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['kta'] = this.kta;
    data['avatar_link'] = this.avatarLink;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['nik'] = this.nik;
    data['birth_place_and_date'] = this.birthPlaceAndDate;
    data['village_unit'] = this.villageUnit;
    data['administrative_village'] = this.administrativeVillage;
    data['sub_district'] = this.subDistrict;
    data['religion'] = this.religion;
    data['marital_status'] = this.maritalStatus;
    data['occupation'] = this.occupation;
    data['citizenship'] = this.citizenship;
    data['blood_type'] = this.bloodType;
    data['valid_until'] = this.validUntil;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
