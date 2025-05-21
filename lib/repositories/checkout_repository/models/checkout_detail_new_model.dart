class CheckoutDetailNowModel {
  String? type;
  String? qty;
  int? totalPrice;
  Data? data;

  CheckoutDetailNowModel({this.type, this.qty, this.totalPrice, this.data});

  CheckoutDetailNowModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    qty = json['qty'];
    totalPrice = json['total_price'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['qty'] = qty;
    data['total_price'] = totalPrice;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? description;
  int? price;
  int? weight;
  int? stock;
  bool? status;
  String? itemCondition;
  int? storeId;
  int? categoryId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Store? store;
  List<Pictures>? pictures;

  Data(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.weight,
      this.stock,
      this.status,
      this.itemCondition,
      this.storeId,
      this.categoryId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.store,
      this.pictures});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    weight = json['weight'];
    stock = json['stock'];
    status = json['status'];
    itemCondition = json['item_condition'];
    storeId = json['store_id'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
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
    data['store_id'] = storeId;
    data['category_id'] = categoryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
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
      this.address});

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
