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
    final Map<String, dynamic> data = {};
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
  IdentityCard? identityCard;
  double? distance;

  MemberNearData({
    this.id,
    this.email,
    this.latitude,
    this.longitude,
    this.phone,
    this.profile,
    this.identityCard,
    this.distance,
  });

  MemberNearData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
    phone = json['phone'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    identityCard = json['identity_card'] != null
        ? IdentityCard.fromJson(json['identity_card'])
        : null;
    distance = (json['distance'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['email'] = email;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['phone'] = phone;
    if (profile != null) data['profile'] = profile!.toJson();
    if (identityCard != null) data['identity_card'] = identityCard!.toJson();
    data['distance'] = distance;
    return data;
  }
}

class Profile {
  int? id;
  String? fullname;
  String? kta;
  String? avatarLink;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Profile({
    this.id,
    this.fullname,
    this.kta,
    this.avatarLink,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    kta = json['kta'];
    avatarLink = json['avatar_link'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['fullname'] = fullname;
    data['kta'] = kta;
    data['avatar_link'] = avatarLink;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class IdentityCard {
  int? id;
  String? name;
  String? address;
  String? gender;
  String? nik;
  String? birthPlaceAndDate;
  String? villageUnit;
  String? administrativeVillage;
  String? province;
  String? regencyCity;
  String? subDistrict;
  String? religion;
  String? maritalStatus;
  String? occupation;
  String? citizenship;
  String? bloodType;
  String? validUntil;
  String? kta;
  String? linkImage;
  bool? statusActive;
  String? createdAt;
  int? userId;
  String? updatedAt;

  IdentityCard({
    this.id,
    this.name,
    this.address,
    this.gender,
    this.nik,
    this.birthPlaceAndDate,
    this.villageUnit,
    this.administrativeVillage,
    this.province,
    this.regencyCity,
    this.subDistrict,
    this.religion,
    this.maritalStatus,
    this.occupation,
    this.citizenship,
    this.bloodType,
    this.validUntil,
    this.kta,
    this.linkImage,
    this.statusActive,
    this.createdAt,
    this.userId,
    this.updatedAt,
  });

  IdentityCard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    gender = json['gender'];
    nik = json['nik'];
    birthPlaceAndDate = json['birth_place_and_date'];
    villageUnit = json['village_unit'];
    administrativeVillage = json['administrative_village'];
    province = json['province'];
    regencyCity = json['regency_city'];
    subDistrict = json['sub_district'];
    religion = json['religion'];
    maritalStatus = json['marital_status'];
    occupation = json['occupation'];
    citizenship = json['citizenship'];
    bloodType = json['blood_type'];
    validUntil = json['valid_until'];
    kta = json['kta'];
    linkImage = json['link_image'];
    statusActive = json['status_active'];
    createdAt = json['created_at'];
    userId = json['user_id'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['gender'] = gender;
    data['nik'] = nik;
    data['birth_place_and_date'] = birthPlaceAndDate;
    data['village_unit'] = villageUnit;
    data['administrative_village'] = administrativeVillage;
    data['province'] = province;
    data['regency_city'] = regencyCity;
    data['sub_district'] = subDistrict;
    data['religion'] = religion;
    data['marital_status'] = maritalStatus;
    data['occupation'] = occupation;
    data['citizenship'] = citizenship;
    data['blood_type'] = bloodType;
    data['valid_until'] = validUntil;
    data['kta'] = kta;
    data['link_image'] = linkImage;
    data['status_active'] = statusActive;
    data['created_at'] = createdAt;
    data['user_id'] = userId;
    data['updated_at'] = updatedAt;
    return data;
  }
}
