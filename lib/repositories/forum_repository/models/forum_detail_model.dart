import '../../auth_repository/models/user_model.dart';

class ForumDetailModel {
  int? id;
  String? description;
  int? userId;
  int? latitude;
  int? longitude;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  List<ForumComment>? forumComment;
  User? user;
  List<ForumMedia>? forumMedia;
  List<ForumLikes>? forumLikes;
  List<ForumComments>? forumComments;
  int? likeCount;
  bool? isLike;
  int? commentCount;

  ForumDetailModel(
      {this.id,
      this.description,
      this.userId,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.forumComment,
      this.user,
      this.forumMedia,
      this.forumLikes,
      this.forumComments,
      this.likeCount,
      this.isLike,
      this.commentCount});

  ForumDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    userId = json['user_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['forum_comment'] != null) {
      forumComment = <ForumComment>[];
      json['forum_comment'].forEach((v) {
        forumComment!.add(ForumComment.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['forum_media'] != null) {
      forumMedia = <ForumMedia>[];
      json['forum_media'].forEach((v) {
        forumMedia!.add(ForumMedia.fromJson(v));
      });
    }
    if (json['forum_likes'] != null) {
      forumLikes = <ForumLikes>[];
      json['forum_likes'].forEach((v) {
        forumLikes!.add(ForumLikes.fromJson(v));
      });
    }
    if (json['forumComments'] != null) {
      forumComments = <ForumComments>[];
      json['forumComments'].forEach((v) {
        forumComments!.add(ForumComments.fromJson(v));
      });
    }
    likeCount = json['likeCount'];
    isLike = json['isLike'];
    commentCount = json['commentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['user_id'] = userId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (forumComment != null) {
      data['forum_comment'] = forumComment!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (forumMedia != null) {
      data['forum_media'] = forumMedia!.map((v) => v.toJson()).toList();
    }
    if (forumLikes != null) {
      data['forum_likes'] = forumLikes!.map((v) => v.toJson()).toList();
    }
    if (forumComments != null) {
      data['forumComments'] = forumComments!.map((v) => v.toJson()).toList();
    }
    data['likeCount'] = likeCount;
    data['isLike'] = isLike;
    data['commentCount'] = commentCount;
    return data;
  }
}

class ForumComment {
  int? id;
  String? comment;
  int? userId;
  int? forumId;
  Null? commentId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  User? user;
  List<Replies>? replies;

  ForumComment(
      {this.id,
      this.comment,
      this.userId,
      this.forumId,
      this.commentId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.user,
      this.replies});

  ForumComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    userId = json['user_id'];
    forumId = json['forum_id'];
    commentId = json['comment_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['user_id'] = userId;
    data['forum_id'] = forumId;
    data['comment_id'] = commentId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? phone;
  String? email;
  String? username;
  ProfileUser? profile;

  User({this.phone, this.email, this.username, this.profile});

  User.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    email = json['email'];
    username = json['username'];
    profile =
        json['profile'] != null ? ProfileUser.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['email'] = email;
    data['username'] = username;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class ProfileUser {
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

  ProfileUser(
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

  ProfileUser.fromJson(Map<String, dynamic> json) {
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

class Replies {
  int? id;
  String? comment;
  int? userId;
  int? forumId;
  int? commentId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  User? user;

  Replies(
      {this.id,
      this.comment,
      this.userId,
      this.forumId,
      this.commentId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.user});

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    userId = json['user_id'];
    forumId = json['forum_id'];
    commentId = json['comment_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['user_id'] = userId;
    data['forum_id'] = forumId;
    data['comment_id'] = commentId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class RepliesComment {
  int? id;
  String? comment;
  int? userId;
  int? forumId;
  int? commentId;
  String? createdAt;
  String? updatedAt;
  UserModel? user;

  RepliesComment(
      {this.id,
      this.comment,
      this.userId,
      this.forumId,
      this.commentId,
      this.createdAt,
      this.updatedAt,
      this.user});

  RepliesComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    userId = json['user_id'];
    forumId = json['forum_id'];
    commentId = json['comment_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['user_id'] = userId;
    data['forum_id'] = forumId;
    data['comment_id'] = commentId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class ForumMedia {
  int? id;
  String? link;
  String? type;
  int? forumId;
  String? createdAt;
  String? updatedAt;

  ForumMedia(
      {this.id,
      this.link,
      this.type,
      this.forumId,
      this.createdAt,
      this.updatedAt});

  ForumMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    type = json['type'];
    forumId = json['forum_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['link'] = link;
    data['type'] = type;
    data['forum_id'] = forumId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ForumLikes {
  int? id;
  int? userId;
  int? forumId;
  String? createdAt;
  String? updatedAt;
  User? user;

  ForumLikes(
      {this.id,
      this.userId,
      this.forumId,
      this.createdAt,
      this.updatedAt,
      this.user});

  ForumLikes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    forumId = json['forum_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['forum_id'] = forumId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class ForumComments {
  int? id;
  String? comment;
  int? userId;
  int? forumId;
  Null? commentId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  User? user;
  List<Null>? forumCommentLikes;
  List<Replies>? replies;
  int? likeCount;
  bool? isLike;

  ForumComments(
      {this.id,
      this.comment,
      this.userId,
      this.forumId,
      this.commentId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.user,
      this.forumCommentLikes,
      this.replies,
      this.likeCount,
      this.isLike});

  ForumComments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    userId = json['user_id'];
    forumId = json['forum_id'];
    commentId = json['comment_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(Replies.fromJson(v));
      });
    }
    likeCount = json['likeCount'];
    isLike = json['isLike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['user_id'] = userId;
    data['forum_id'] = forumId;
    data['comment_id'] = commentId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    data['likeCount'] = likeCount;
    data['isLike'] = isLike;
    return data;
  }
}
