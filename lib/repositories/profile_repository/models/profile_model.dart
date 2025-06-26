class ProfileModel {
  int? id;
  String? username;
  String? email;
  String? phone;
  double? latitude;
  double? longitude;
  String? emailVerified;
  String? fcmToken;
  int balance; // tidak nullable, default 0
  String? role;
  String? storeId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Profile? profile;
  IdentityCard? identityCard;

  ProfileModel({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.latitude,
    this.longitude,
    this.emailVerified,
    this.fcmToken,
    this.balance = 0,
    this.role,
    this.storeId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.profile,
    this.identityCard,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      latitude: (json['latitude'] is int)
          ? (json['latitude'] as int).toDouble()
          : json['latitude'] ?? 0.0,
      longitude: (json['longitude'] is int)
          ? (json['longitude'] as int).toDouble()
          : json['longitude'] ?? 0.0,
      emailVerified: json['email_verified'],
      fcmToken: json['fcm_token'],
      balance: json['balance'] ?? 0,
      role: json['role'],
      storeId: json['store_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      identityCard: json['identity_card'] != null
          ? IdentityCard.fromJson(json['identity_card'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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
    if (identityCard != null) {
      data['identity_card'] = identityCard!.toJson();
    }
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

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullname: json['fullname'],
      kta: json['kta'],
      avatarLink: json['avatar_link'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'kta': kta,
      'avatar_link': avatarLink,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
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
  String? linkImage;
  int? userId;
  String? createdAt;
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
    this.linkImage,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory IdentityCard.fromJson(Map<String, dynamic> json) {
    return IdentityCard(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      gender: json['gender'],
      nik: json['nik'],
      birthPlaceAndDate: json['birth_place_and_date'],
      villageUnit: json['village_unit'],
      administrativeVillage: json['administrative_village'],
      province: json['province'],
      regencyCity: json['regency_city'],
      subDistrict: json['sub_district'],
      religion: json['religion'],
      maritalStatus: json['marital_status'],
      occupation: json['occupation'],
      citizenship: json['citizenship'],
      bloodType: json['blood_type'],
      validUntil: json['valid_until'],
      linkImage: json['link_image'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'gender': gender,
      'nik': nik,
      'birth_place_and_date': birthPlaceAndDate,
      'village_unit': villageUnit,
      'administrative_village': administrativeVillage,
      'province': province,
      'regency_city': regencyCity,
      'sub_district': subDistrict,
      'religion': religion,
      'marital_status': maritalStatus,
      'occupation': occupation,
      'citizenship': citizenship,
      'blood_type': bloodType,
      'valid_until': validUntil,
      'link_image': linkImage,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
