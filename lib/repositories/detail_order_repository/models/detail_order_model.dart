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
    otherPrice = json['other_price'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    type = json['type'];
    status = json['status'];
    finishAt = json['finish_at'];
    storeId = json['store_id'];
    paymentId = json['payment_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    needReview = json['need_review'];
    isStore = json['isStore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['price'] = this.price;
    data['total_price'] = this.totalPrice;
    data['other_price'] = this.otherPrice;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['type'] = this.type;
    data['status'] = this.status;
    data['finish_at'] = this.finishAt;
    data['store_id'] = this.storeId;
    data['payment_id'] = this.paymentId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['need_review'] = this.needReview;
    data['isStore'] = this.isStore;
    return data;
  }
}

class Data {
  int? weight;
  Biteship? biteship;
  Map? shipping;
  String? noTracking;
  StoreAddress? storeAddress;
  ShippingAddress? shippingAddress;
  String? biteshipOrderId;

  Data(
      {this.weight,
      this.biteship,
      this.shipping,
      this.noTracking,
      this.storeAddress,
      this.shippingAddress,
      this.biteshipOrderId});

  Data.fromJson(Map<String, dynamic> json) {
    weight = json['weight'];
    biteship = json['biteship'] != null
        ? new Biteship.fromJson(json['biteship'])
        : null;
    shipping = json['shipping'];
    noTracking = json['no_tracking'];
    storeAddress = json['store_address'] != null
        ? new StoreAddress.fromJson(json['store_address'])
        : null;
    shippingAddress = json['shipping_address'] != null
        ? new ShippingAddress.fromJson(json['shipping_address'])
        : null;
    biteshipOrderId = json['biteship_order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight'] = this.weight;
    if (this.biteship != null) {
      data['biteship'] = this.biteship!.toJson();
    }
    if (this.shipping != null) {
      data['shipping'] = this.shipping;
    }
    data['no_tracking'] = this.noTracking;
    if (this.storeAddress != null) {
      data['store_address'] = this.storeAddress!.toJson();
    }
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }
    data['biteship_order_id'] = this.biteshipOrderId;
    return data;
  }
}

class Biteship {
  int? price;
  Courier? courier;
  String? orderId;
  String? waybillId;

  Biteship({this.price, this.courier, this.orderId, this.waybillId});

  Biteship.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    courier =
        json['courier'] != null ? new Courier.fromJson(json['courier']) : null;
    orderId = json['order_id'];
    waybillId = json['waybill_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    if (this.courier != null) {
      data['courier'] = this.courier!.toJson();
    }
    data['order_id'] = this.orderId;
    data['waybill_id'] = this.waybillId;
    return data;
  }
}

class Courier {
  String? link;
  Null? name;
  String? type;
  Null? phone;
  String? company;
  Insurance? insurance;
  String? waybillId;
  String? trackingId;
  Null? routingCode;

  Courier(
      {this.link,
      this.name,
      this.type,
      this.phone,
      this.company,
      this.insurance,
      this.waybillId,
      this.trackingId,
      this.routingCode});

  Courier.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    name = json['name'];
    type = json['type'];
    phone = json['phone'];
    company = json['company'];
    insurance = json['insurance'] != null
        ? new Insurance.fromJson(json['insurance'])
        : null;
    waybillId = json['waybill_id'];
    trackingId = json['tracking_id'];
    routingCode = json['routing_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    data['name'] = this.name;
    data['type'] = this.type;
    data['phone'] = this.phone;
    data['company'] = this.company;
    if (this.insurance != null) {
      data['insurance'] = this.insurance!.toJson();
    }
    data['waybill_id'] = this.waybillId;
    data['tracking_id'] = this.trackingId;
    data['routing_code'] = this.routingCode;
    return data;
  }
}

class Insurance {
  int? fee;
  String? note;
  int? amount;
  String? feeCurrency;
  String? amountCurrency;

  Insurance(
      {this.fee,
      this.note,
      this.amount,
      this.feeCurrency,
      this.amountCurrency});

  Insurance.fromJson(Map<String, dynamic> json) {
    fee = json['fee'];
    note = json['note'];
    amount = json['amount'];
    feeCurrency = json['fee_currency'];
    amountCurrency = json['amount_currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fee'] = this.fee;
    data['note'] = this.note;
    data['amount'] = this.amount;
    data['fee_currency'] = this.feeCurrency;
    data['amount_currency'] = this.amountCurrency;
    return data;
  }
}

class Shipping {
  String? note;
  String? type;
  int? price;
  String? company;
  String? version;
  String? currency;
  String? duration;
  Null? taxLines;
  String? description;
  String? courierCode;
  String? courierName;
  String? serviceType;
  String? shippingType;
  String? courierServiceCode;
  String? courierServiceName;
  String? shipmentDurationUnit;
  bool? availableForInsurance;
  String? shipmentDurationRange;
  List<String>? availableCollectionMethod;
  bool? availableForCashOnDelivery;
  bool? availableForProofOfDelivery;
  bool? availableForInstantWaybillId;

  Shipping(
      {this.note,
      this.type,
      this.price,
      this.company,
      this.version,
      this.currency,
      this.duration,
      this.taxLines,
      this.description,
      this.courierCode,
      this.courierName,
      this.serviceType,
      this.shippingType,
      this.courierServiceCode,
      this.courierServiceName,
      this.shipmentDurationUnit,
      this.availableForInsurance,
      this.shipmentDurationRange,
      this.availableCollectionMethod,
      this.availableForCashOnDelivery,
      this.availableForProofOfDelivery,
      this.availableForInstantWaybillId});

  Shipping.fromJson(Map<String, dynamic> json) {
    note = json['note'];
    type = json['type'];
    price = json['price'];
    company = json['company'];
    version = json['version'];
    currency = json['currency'];
    duration = json['duration'];
    taxLines = json['tax_lines'];
    description = json['description'];
    courierCode = json['courier_code'];
    courierName = json['courier_name'];
    serviceType = json['service_type'];
    shippingType = json['shipping_type'];
    courierServiceCode = json['courier_service_code'];
    courierServiceName = json['courier_service_name'];
    shipmentDurationUnit = json['shipment_duration_unit'];
    availableForInsurance = json['available_for_insurance'];
    shipmentDurationRange = json['shipment_duration_range'];
    availableCollectionMethod =
        json['available_collection_method'].cast<String>();
    availableForCashOnDelivery = json['available_for_cash_on_delivery'];
    availableForProofOfDelivery = json['available_for_proof_of_delivery'];
    availableForInstantWaybillId = json['available_for_instant_waybill_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['note'] = this.note;
    data['type'] = this.type;
    data['price'] = this.price;
    data['company'] = this.company;
    data['version'] = this.version;
    data['currency'] = this.currency;
    data['duration'] = this.duration;
    data['tax_lines'] = this.taxLines;
    data['description'] = this.description;
    data['courier_code'] = this.courierCode;
    data['courier_name'] = this.courierName;
    data['service_type'] = this.serviceType;
    data['shipping_type'] = this.shippingType;
    data['courier_service_code'] = this.courierServiceCode;
    data['courier_service_name'] = this.courierServiceName;
    data['shipment_duration_unit'] = this.shipmentDurationUnit;
    data['available_for_insurance'] = this.availableForInsurance;
    data['shipment_duration_range'] = this.shipmentDurationRange;
    data['available_collection_method'] = this.availableCollectionMethod;
    data['available_for_cash_on_delivery'] = this.availableForCashOnDelivery;
    data['available_for_proof_of_delivery'] = this.availableForProofOfDelivery;
    data['available_for_instant_waybill_id'] =
        this.availableForInstantWaybillId;
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
    latitude = json['latitude'];
    province = json['province'];
    longitude = json['longitude'];
    postalCode = json['postal_code'];
    nameAddress = json['name_address'];
    subDistrict = json['sub_district'];
    detailAddress = json['detail_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city'] = this.city;
    data['district'] = this.district;
    data['latitude'] = this.latitude;
    data['province'] = this.province;
    data['longitude'] = this.longitude;
    data['postal_code'] = this.postalCode;
    data['name_address'] = this.nameAddress;
    data['sub_district'] = this.subDistrict;
    data['detail_address'] = this.detailAddress;
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
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    userId = json['user_id'];
    addressId = json['address_id'];
    isSelected = json['is_selected'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['label'] = this.label;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['user_id'] = this.userId;
    data['address_id'] = this.addressId;
    data['is_selected'] = this.isSelected;
    data['phone_number'] = this.phoneNumber;
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
  Null? nameAddress;
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
    latitude = json['latitude'];
    province = json['province'];
    longitude = json['longitude'];
    postalCode = json['postal_code'];
    nameAddress = json['name_address'];
    subDistrict = json['sub_district'];
    detailAddress = json['detail_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city'] = this.city;
    data['district'] = this.district;
    data['latitude'] = this.latitude;
    data['province'] = this.province;
    data['longitude'] = this.longitude;
    data['postal_code'] = this.postalCode;
    data['name_address'] = this.nameAddress;
    data['sub_district'] = this.subDistrict;
    data['detail_address'] = this.detailAddress;
    return data;
  }
}

class Store {
  String? name;
  String? linkPhoto;
  int? id;
  Null? description;
  String? phoneNumber;
  bool? statusOpen;
  User? user;

  Store(
      {this.name,
      this.linkPhoto,
      this.id,
      this.description,
      this.phoneNumber,
      this.statusOpen,
      this.user});

  Store.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    linkPhoto = json['link_photo'];
    id = json['id'];
    description = json['description'];
    phoneNumber = json['phone_number'];
    statusOpen = json['status_open'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['link_photo'] = this.linkPhoto;
    data['id'] = this.id;
    data['description'] = this.description;
    data['phone_number'] = this.phoneNumber;
    data['status_open'] = this.statusOpen;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['phone'] = this.phone;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    data['code'] = this.code;
    data['fee'] = this.fee;
    data['user_id'] = this.userId;
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
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['total_price'] = this.totalPrice;
    data['note'] = this.note;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
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
