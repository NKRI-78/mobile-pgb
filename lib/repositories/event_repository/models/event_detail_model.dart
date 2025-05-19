class EventDetailModel {
  String? message;
  Data? data;

  EventDetailModel({this.message, this.data});

  EventDetailModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  int? neighborhoodId;
  String? title;
  String? imageUrl;
  String? description;
  String? start;
  String? end;
  String? address;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  User? user;
  List<UserJoins>? userJoins;
  bool? isJoin;
  bool? isExpired;

  Data(
      {this.id,
      this.userId,
      this.neighborhoodId,
      this.title,
      this.imageUrl,
      this.description,
      this.start,
      this.end,
      this.address,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.userJoins,
      this.isJoin,
      this.isExpired});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    neighborhoodId = json['neighborhood_id'];
    title = json['title'];
    imageUrl = json['image_url'];
    description = json['description'];
    start = json['start'];
    end = json['end'];
    address = json['address'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['user_joins'] != null) {
      userJoins = <UserJoins>[];
      json['user_joins'].forEach((v) {
        userJoins!.add(UserJoins.fromJson(v));
      });
    }
    isJoin = json['isJoin'];
    isExpired = json['isExpired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['neighborhood_id'] = neighborhoodId;
    data['title'] = title;
    data['image_url'] = imageUrl;
    data['description'] = description;
    data['start'] = start;
    data['end'] = end;
    data['address'] = address;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (userJoins != null) {
      data['user_joins'] = userJoins!.map((v) => v.toJson()).toList();
    }
    data['isJoin'] = isJoin;
    data['isExpired'] = isExpired;
    return data;
  }
}

class User {
  String? email;
  String? phone;
  int? id;
  Profile? profile;

  User({
    this.email,
    this.phone,
    this.id,
    this.profile,
  });

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
    id = json['id'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['phone'] = phone;
    data['id'] = id;

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
  String? detailAddress;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Profile(
      {this.id,
      this.fullname,
      this.avatarLink,
      this.detailAddress,
      this.userId,
      this.createdAt,
      this.updatedAt});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    avatarLink = json['avatar_link'];
    detailAddress = json['detail_address'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullname'] = fullname;
    data['avatar_link'] = avatarLink;
    data['detail_address'] = detailAddress;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class UserJoins {
  int? id;
  int? userId;
  int? eventId;
  String? createdAt;
  String? updatedAt;
  User? user;

  UserJoins(
      {this.id,
      this.userId,
      this.eventId,
      this.createdAt,
      this.updatedAt,
      this.user});

  UserJoins.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    eventId = json['event_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['event_id'] = eventId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
