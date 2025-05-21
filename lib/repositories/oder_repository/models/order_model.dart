class OrderModel {
  int? id;
  String? orderNumber;
  int? price;
  int? totalPrice;
  int? otherPrice;
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
  int? itemCount;
  bool? needReview;

  OrderModel(
      {this.id,
      this.orderNumber,
      this.price,
      this.totalPrice,
      this.otherPrice,
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
      this.itemCount,
      this.needReview});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    price = json['price'];
    totalPrice = json['total_price'];
    otherPrice = int.parse(json['other_price'].toString());
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
    itemCount = json['itemCount'];
    needReview = json['needReview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_number'] = orderNumber;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['other_price'] = otherPrice;
    data['type'] = type;
    data['status'] = status;
    data['finish_at'] = finishAt;
    data['store_id'] = storeId;
    data['payment_id'] = paymentId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (payment != null) {
      data['payment'] = payment!.toJson();
    }
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['itemCount'] = itemCount;
    data['needReview'] = needReview;
    return data;
  }
}

class Payment {
  int? id;
  String? paymentNumber;
  String? type;
  String? name;
  String? code;
  String? logoUrl;
  String? platform;
  int? price;
  int? totalPrice;
  int? fee;
  String? status;
  String? expireAt;
  String? userId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Payment(
      {this.id,
      this.paymentNumber,
      this.type,
      this.name,
      this.code,
      this.logoUrl,
      this.platform,
      this.price,
      this.totalPrice,
      this.fee,
      this.status,
      this.expireAt,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentNumber = json['payment_number'];
    type = json['type'];
    name = json['name'];
    code = json['code'];
    logoUrl = json['logo_url'];
    platform = json['platform'];
    price = json['price'];
    totalPrice = json['total_price'];
    fee = json['fee'];
    status = json['status'];
    expireAt = json['expire_at'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['payment_number'] = paymentNumber;
    data['type'] = type;
    data['name'] = name;
    data['code'] = code;
    data['logo_url'] = logoUrl;
    data['platform'] = platform;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['fee'] = fee;
    data['status'] = status;
    data['expire_at'] = expireAt;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class Store {
  String? name;
  String? linkPhoto;
  int? id;

  Store({this.name, this.linkPhoto, this.id});

  Store.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    linkPhoto = json['link_photo'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['link_photo'] = linkPhoto;
    data['id'] = id;
    return data;
  }
}

class Items {
  int? id;
  int? productId;
  int? quantity;
  Product? product;

  Items({this.id, this.productId, this.quantity, this.product});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['quantity'] = quantity;
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
