class DetailProductModel {
  String? message;
  DetailProductData? data;

  DetailProductModel({this.message, this.data});

  DetailProductModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? DetailProductData.fromJson(json['data']) : null;
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

class DetailProductData {
  int? id;
  String? name;
  String? description;
  int? price;
  int? weight;
  int? stock;
  bool? status;
  String? itemCondition;
  bool? isLimitedEdition;
  int? storeId;
  int? categoryId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Category? category;
  Store? store;
  List<Pictures>? pictures;
  List<Reviews>? reviews;

  DetailProductData(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.weight,
      this.stock,
      this.status,
      this.itemCondition,
      this.isLimitedEdition,
      this.storeId,
      this.categoryId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.category,
      this.store,
      this.pictures,
      this.reviews});

  DetailProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    weight = json['weight'];
    stock = json['stock'];
    status = json['status'];
    itemCondition = json['item_condition'];
    isLimitedEdition = json['is_limited_edition'];
    storeId = json['store_id'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['weight'] = weight;
    data['stock'] = stock;
    data['status'] = status;
    data['item_condition'] = itemCondition;
    data['is_limited_edition'] = isLimitedEdition;
    data['store_id'] = storeId;
    data['category_id'] = categoryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? description;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.id,
      this.name,
      this.description,
      this.imageUrl,
      this.createdAt,
      this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image_url'] = imageUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Store {
  int? id;
  String? name;
  String? linkBanner;
  String? linkPhoto;
  bool? statusOpen;
  String? type;
  String? verified;
  int? addressId;
  String? createdAt;
  String? updatedAt;
  Address? address;
  User? user;

  Store(
      {this.id,
      this.name,
      this.linkBanner,
      this.linkPhoto,
      this.statusOpen,
      this.type,
      this.verified,
      this.addressId,
      this.createdAt,
      this.updatedAt,
      this.address,
      this.user});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    linkBanner = json['link_banner'];
    linkPhoto = json['link_photo'];
    statusOpen = json['status_open'];
    type = json['type'];
    verified = json['verified'];
    addressId = json['address_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['link_banner'] = linkBanner;
    data['link_photo'] = linkPhoto;
    data['status_open'] = statusOpen;
    data['type'] = type;
    data['verified'] = verified;
    data['address_id'] = addressId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Address {
  int? id;
  String? nameAddress;
  String? detailAddress;
  String? province;
  String? city;
  String? district;
  String? subDistrict;
  int? postalCode;
  double? latitude;
  double? longitude;
  String? createdAt;
  String? updatedAt;

  Address(
      {this.id,
      this.nameAddress,
      this.detailAddress,
      this.province,
      this.city,
      this.district,
      this.subDistrict,
      this.postalCode,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAddress = json['name_address'];
    detailAddress = json['detail_address'];
    province = json['province'];
    city = json['city'];
    district = json['district'];
    subDistrict = json['sub_district'];
    postalCode = json['postal_code'];
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_address'] = nameAddress;
    data['detail_address'] = detailAddress;
    data['province'] = province;
    data['city'] = city;
    data['district'] = district;
    data['sub_district'] = subDistrict;
    data['postal_code'] = postalCode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class User {
  int? id;
  Artist? artist;

  User({this.id, this.artist});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    artist =
        json['artist'] != null ? Artist.fromJson(json['artist']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (artist != null) {
      data['artist'] = artist!.toJson();
    }
    return data;
  }
}

class Artist {
  int? id;
  String? name;
  String? linkBanner;
  String? linkProfile;
  int? userId;
  String? verified;
  int? myIdArtist;
  String? createdAt;
  String? updatedAt;

  Artist(
      {this.id,
      this.name,
      this.linkBanner,
      this.linkProfile,
      this.userId,
      this.verified,
      this.myIdArtist,
      this.createdAt,
      this.updatedAt});

  Artist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    linkBanner = json['link_banner'];
    linkProfile = json['link_profile'] ?? "-";
    userId = json['user_id'];
    verified = json['verified'];
    myIdArtist = json['my_id_artist'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['link_banner'] = linkBanner;
    data['link_profile'] = linkProfile;
    data['user_id'] = userId;
    data['verified'] = verified;
    data['my_id_artist'] = myIdArtist;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Pictures {
  int? id;
  String? link;
  int? productId;
  String? createdAt;
  String? updatedAt;

  Pictures(
      {this.id, this.link, this.productId, this.createdAt, this.updatedAt});

  Pictures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['link'] = link;
    data['product_id'] = productId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Reviews {
  int? id;
  String? message;
  int? rating;
  int? orderItemId;
  int? userId;
  String? createdAt;
  String? updatedAt;
  List<Images>? images;
  UserProfile? userProfile;

  Reviews(
      {this.id,
      this.message,
      this.rating,
      this.orderItemId,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.images,
      this.userProfile});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    rating = json['rating'];
    orderItemId = json['order_item_id'];
    userId = json['userId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    userProfile = json['user'] != null ? UserProfile.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['rating'] = rating;
    data['order_item_id'] = orderItemId;
    data['userId'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (userProfile != null) {
      data['user'] = userProfile!.toJson();
    }
    return data;
  }
}

class Images {
  int? id;
  String? link;
  int? reviewOrderItemId;
  String? createdAt;
  String? updatedAt;

  Images(
      {this.id,
      this.link,
      this.reviewOrderItemId,
      this.createdAt,
      this.updatedAt});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    reviewOrderItemId = json['review_order_item_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['link'] = link;
    data['review_order_item_id'] = reviewOrderItemId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class UserProfile {
  String? email;
  Profile? profile;

  UserProfile({this.email, this.profile});

  UserProfile.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? fullname;
  String? linkAvatar;

  Profile({this.fullname, this.linkAvatar});

  Profile.fromJson(Map<String, dynamic> json) {
    fullname = json['fullname'];
    linkAvatar = json['link_avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullname'] = fullname;
    data['link_avatar'] = linkAvatar;
    return data;
  }
}
