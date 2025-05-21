class PaymentModel {
  Map? data;
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
  int? userId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Orders>? orders;
  String? paymentType;
  List<Invoices>? invoices;

  PaymentModel({
    this.data,
    this.id,
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
    this.deletedAt,
    this.orders,
    this.paymentType,
    this.invoices,
  });

  PaymentModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
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
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
    paymentType = json['payment_type'];
    if (json['invoices'] != null) {
      invoices = <Invoices>[];
      json['invoices'].forEach((v) {
        invoices!.add(Invoices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data;
    }
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
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    data['payment_type'] = paymentType;
    if (invoices != null) {
      data['invoices'] = invoices!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Invoices {
  int? id;
  String? name;
  String? invoiceNumber;
  String? invoiceDate;
  String? dueDate;
  String? paidDate;
  int? totalAmount;
  int? paidAmount;
  String? note;
  String? status;
  int? userId;
  int? neighborhoodId;
  int? familyId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Invoices(
      {this.id,
      this.name,
      this.invoiceNumber,
      this.invoiceDate,
      this.dueDate,
      this.paidDate,
      this.totalAmount,
      this.paidAmount,
      this.note,
      this.status,
      this.userId,
      this.neighborhoodId,
      this.familyId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Invoices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    invoiceNumber = json['invoice_number'];
    invoiceDate = json['invoice_date'];
    dueDate = json['due_date'];
    paidDate = json['paid_date'];
    totalAmount = json['total_amount'];
    paidAmount = json['paid_amount'];
    note = json['note'];
    status = json['status'];
    userId = json['user_id'];
    neighborhoodId = json['neighborhood_id'];
    familyId = json['family_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['invoice_number'] = invoiceNumber;
    data['invoice_date'] = invoiceDate;
    data['due_date'] = dueDate;
    data['paid_date'] = paidDate;
    data['total_amount'] = totalAmount;
    data['paid_amount'] = paidAmount;
    data['note'] = note;
    data['status'] = status;
    data['user_id'] = userId;
    data['neighborhood_id'] = neighborhoodId;
    data['family_id'] = familyId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class Orders {
  String? orderNumber;
  int? price;
  int? totalPrice;
  int? otherPrice;
  Data? data;
  String? type;
  Store? store;
  List<Items>? items;

  Orders(
      {this.orderNumber,
      this.price,
      this.totalPrice,
      this.otherPrice,
      this.data,
      this.type,
      this.store,
      this.items});

  Orders.fromJson(Map<String, dynamic> json) {
    orderNumber = json['order_number'];
    price = json['price'];
    totalPrice = json['total_price'];
    otherPrice = int.parse(json['other_price'].toString());
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    type = json['type'];
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_number'] = orderNumber;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['other_price'] = otherPrice;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['type'] = type;
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? wight;
  Shipping? shipping;
  StoreAddress? storeAddress;
  ShippingAddress? shippingAddress;

  Data({this.wight, this.shipping, this.storeAddress, this.shippingAddress});

  Data.fromJson(Map<String, dynamic> json) {
    wight = json['wight'];
    shipping = json['shipping'] != null
        ? Shipping.fromJson(json['shipping'])
        : null;
    storeAddress = json['store_address'] != null
        ? StoreAddress.fromJson(json['store_address'])
        : null;
    shippingAddress = json['shipping_address'] != null
        ? ShippingAddress.fromJson(json['shipping_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wight'] = wight;
    if (shipping != null) {
      data['shipping'] = shipping!.toJson();
    }
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
  String? cost;
  String? note;
  String? service;

  Shipping({this.etd, this.code, this.cost, this.note, this.service});

  Shipping.fromJson(Map<String, dynamic> json) {
    etd = json['etd'];
    code = json['code'];
    cost = json['cost'].toString();
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
      this.longitude,
      this.province,
      this.postalCode,
      this.nameAddress,
      this.subDistrict,
      this.detailAddress});

  StoreAddress.fromJson(Map<String, dynamic> json) {
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

class ShippingAddress {
  int? id;
  String? name;
  String? label;
  StoreAddress? address;
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
    address = json['address'] != null
        ? StoreAddress.fromJson(json['address'])
        : null;
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
  int? quantity;
  int? price;
  int? totalPrice;
  String? note;
  Product? product;

  Items({this.quantity, this.price, this.totalPrice, this.note, this.product});

  Items.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    price = json['price'];
    totalPrice = json['total_price'];
    note = json['note'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
        pictures!.add(new Pictures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.pictures != null) {
      data['pictures'] = this.pictures!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    return data;
  }
}