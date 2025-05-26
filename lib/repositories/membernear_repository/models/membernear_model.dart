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
  String? id;
  String? email;
  String? username;
  String? phone;
  int? status;
  int? role;
  int? otp;
  String? password;
  int? balance;
  String? verifiedEmail;
  double? lastLat;
  double? lastLng;
  String? fcm;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? storeId;
  String? fullname;
  String? linkAvatar;
  String? profileAddress;
  String? tigerYear;
  String? clubName;
  String? clubShortName;
  double? distance;

  MemberNearData(
      {this.id,
      this.email,
      this.username,
      this.phone,
      this.status,
      this.role,
      this.otp,
      this.password,
      this.balance,
      this.verifiedEmail,
      this.lastLat,
      this.lastLng,
      this.fcm,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.storeId,
      this.fullname,
      this.linkAvatar,
      this.profileAddress,
      this.tigerYear,
      this.clubName,
      this.clubShortName,
      this.distance});

  MemberNearData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    phone = json['phone'];
    status = json['status'];
    role = json['role'];
    otp = json['otp'];
    password = json['password'];
    balance = json['balance'];
    verifiedEmail = json['verified_email'];
    lastLat = json['last_lat'];
    lastLng = json['last_lng'];
    fcm = json['fcm'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    storeId = json['store_id'];
    fullname = json['fullname'];
    linkAvatar = json['link_avatar'];
    profileAddress = json['profile_address'];
    tigerYear = json['tiger_year'];
    clubName = json['club_name'];
    clubShortName = json['club_short_name'];
    distance = (json['distance'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['username'] = username;
    data['phone'] = phone;
    data['status'] = status;
    data['role'] = role;
    data['otp'] = otp;
    data['password'] = password;
    data['balance'] = balance;
    data['verified_email'] = verifiedEmail;
    data['last_lat'] = lastLat;
    data['last_lng'] = lastLng;
    data['fcm'] = fcm;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['store_id'] = storeId;
    data['fullname'] = fullname;
    data['link_avatar'] = linkAvatar;
    data['profile_address'] = profileAddress;
    data['tiger_year'] = tigerYear;
    data['club_name'] = clubName;
    data['club_short_name'] = clubShortName;
    data['distance'] = distance;
    return data;
  }
}
