class DetailOrderModel {
  int? id;
  String? orderNumber;
  int? price;
  int? totalPrice;
  int? otherPrice;
  Data? data;
  String? type;
  String? status;
  String? finishAt;
  int? storeId;
  int? paymentId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Store? store;
  Payment? payment;
  List<Items>? items;
  bool? needReview;
  bool? isStore;

  DetailOrderModel(
      {this.id,
      this.orderNumber,
      this.price,
      this.totalPrice,
      this.otherPrice,
      this.data,
      this.type,
      this.status,
      this.finishAt,
      this.storeId,
      this.paymentId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.store,
      this.payment,
      this.items,
      this.needReview,
      this.isStore});

  DetailOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    price = json['price'];
    totalPrice = json['total_price'];
    otherPrice = int.parse(json['other_price'].toString());
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    type = json['type'];
    status = json['status'];
    finishAt = json['finish_at'];
    storeId = json['store_id'];
    paymentId = json['payment_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    payment =
        json['payment'] != null ? Payment.fromJson(json['payment']) : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    needReview = json['need_review'];
    isStore = json['isStore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_number'] = orderNumber;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['other_price'] = otherPrice;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['type'] = type;
    data['status'] = status;
    data['finish_at'] = finishAt;
    data['store_id'] = storeId;
    data['payment_id'] = paymentId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (payment != null) {
      data['payment'] = payment!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['need_review'] = needReview;
    data['isStore'] = isStore;
    return data;
  }
}

class Data {
  Shipping? shipping;
  String? noTracking;
  StoreAddress? storeAddress;
  ShippingAddress? shippingAddress;

  Data(
      {this.shipping,
      this.noTracking,
      this.storeAddress,
      this.shippingAddress});

  Data.fromJson(Map<String, dynamic> json) {
    shipping =
        json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
    noTracking = json['no_tracking'];
    storeAddress = json['store_address'] != null
        ? StoreAddress.fromJson(json['store_address'])
        : null;
    shippingAddress = json['shipping_address'] != null
        ? ShippingAddress.fromJson(json['shipping_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shipping != null) {
      data['shipping'] = shipping!.toJson();
    }
    data['no_tracking'] = noTracking;
    if (storeAddress != null) {
      data['store_address'] = storeAddress!.toJson();
    }
    if (shippingAddress != null) {
      data['shipping_address'] = shippingAddress!.toJson();
    }
    return data;
  }
}

class Shipping {
  String? etd;
  String? code;
  int? cost;
  String? note;
  String? service;

  Shipping({this.etd, this.code, this.cost, this.note, this.service});

  Shipping.fromJson(Map<String, dynamic> json) {
    etd = json['etd'];
    code = json['code'];
    cost = int.tryParse(json['cost']?.toString() ?? '') ?? 0;
    note = json['note'];
    service = json['service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['etd'] = etd;
    data['code'] = code;
    data['cost'] = cost;
    data['note'] = note;
    data['service'] = service;
    return data;
  }
}

class StoreAddress {
  int? id;
  String? city;
  String? district;
  double? latitude;
  String? province;
  double? longitude;
  int? postalCode;
  String? nameAddress;
  String? subDistrict;
  String? detailAddress;

  StoreAddress(
      {this.id,
      this.city,
      this.district,
      this.latitude,
      this.province,
      this.longitude,
      this.postalCode,
      this.nameAddress,
      this.subDistrict,
      this.detailAddress});

  StoreAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
    district = json['district'];
    latitude = (json['latitude'] as num?)?.toDouble();
    province = json['province'];
    longitude = (json['longitude'] as num?)?.toDouble();
    postalCode = json['postal_code'];
    nameAddress = json['name_address'];
    subDistrict = json['sub_district'];
    detailAddress = json['detail_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['city'] = city;
    data['district'] = district;
    data['latitude'] = latitude;
    data['province'] = province;
    data['longitude'] = longitude;
    data['postal_code'] = postalCode;
    data['name_address'] = nameAddress;
    data['sub_district'] = subDistrict;
    data['detail_address'] = detailAddress;
    return data;
  }
}

class ShippingAddress {
  int? id;
  String? name;
  String? label;
  Address? address;
  int? userId;
  int? addressId;
  bool? isSelected;
  String? phoneNumber;

  ShippingAddress(
      {this.id,
      this.name,
      this.label,
      this.address,
      this.userId,
      this.addressId,
      this.isSelected,
      this.phoneNumber});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    label = json['label'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    userId = json['user_id'];
    addressId = json['address_id'];
    isSelected = json['is_selected'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['label'] = label;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['user_id'] = userId;
    data['address_id'] = addressId;
    data['is_selected'] = isSelected;
    data['phone_number'] = phoneNumber;
    return data;
  }
}

class Address {
  int? id;
  String? city;
  String? district;
  double? latitude;
  String? province;
  double? longitude;
  int? postalCode;
  String? nameAddress;
  String? subDistrict;
  String? detailAddress;

  Address(
      {this.id,
      this.city,
      this.district,
      this.latitude,
      this.province,
      this.longitude,
      this.postalCode,
      this.nameAddress,
      this.subDistrict,
      this.detailAddress});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
    district = json['district'];
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
    province = json['province'];
    postalCode = json['postal_code'];
    nameAddress = json['name_address'];
    subDistrict = json['sub_district'];
    detailAddress = json['detail_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['city'] = city;
    data['district'] = district;
    data['latitude'] = latitude;
    data['province'] = province;
    data['longitude'] = longitude;
    data['postal_code'] = postalCode;
    data['name_address'] = nameAddress;
    data['sub_district'] = subDistrict;
    data['detail_address'] = detailAddress;
    return data;
  }
}

class Store {
  String? name;
  String? linkPhoto;
  int? id;
  User? user;

  Store({this.name, this.linkPhoto, this.id, this.user});

  Store.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    linkPhoto = json['link_photo'];
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['link_photo'] = linkPhoto;
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? email;
  String? phone;

  User({this.email, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}

class Payment {
  String? type;
  String? name;
  String? code;
  int? fee;
  int? userId;

  Payment({this.type, this.name, this.code, this.fee, this.userId});

  Payment.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    code = json['code'];
    fee = json['fee'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['code'] = code;
    data['fee'] = fee;
    data['user_id'] = userId;
    return data;
  }
}

class Items {
  int? id;
  int? productId;
  int? quantity;
  int? price;
  int? totalPrice;
  String? note;
  Product? product;

  Items(
      {this.id,
      this.productId,
      this.quantity,
      this.price,
      this.totalPrice,
      this.note,
      this.product});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    price = json['price'];
    totalPrice = json['total_price'];
    note = json['note'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['note'] = note;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  String? name;
  List<Pictures>? pictures;

  Product({this.name, this.pictures});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pictures {
  String? link;

  Pictures({this.link});

  Pictures.fromJson(Map<String, dynamic> json) {
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link'] = link;
    return data;
  }
}
