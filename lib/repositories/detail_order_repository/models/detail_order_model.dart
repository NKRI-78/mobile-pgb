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
    otherPrice = json['other_price'] != null
        ? int.tryParse(json['other_price'].toString())
        : null;

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
    biteship =
        json['biteship'] != null ? Biteship.fromJson(json['biteship']) : null;
    shipping = json['shipping'];
    noTracking = json['no_tracking'];
    storeAddress = json['store_address'] != null
        ? StoreAddress.fromJson(json['store_address'])
        : null;
    shippingAddress = json['shipping_address'] != null
        ? ShippingAddress.fromJson(json['shipping_address'])
        : null;
    biteshipOrderId = json['biteship_order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weight'] = weight;
    if (biteship != null) {
      data['biteship'] = biteship!.toJson();
    }
    if (shipping != null) {
      data['shipping'] = shipping;
    }
    data['no_tracking'] = noTracking;
    if (storeAddress != null) {
      data['store_address'] = storeAddress!.toJson();
    }
    if (shippingAddress != null) {
      data['shipping_address'] = shippingAddress!.toJson();
    }
    data['biteship_order_id'] = biteshipOrderId;
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
        json['courier'] != null ? Courier.fromJson(json['courier']) : null;
    orderId = json['order_id'];
    waybillId = json['waybill_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    if (courier != null) {
      data['courier'] = courier!.toJson();
    }
    data['order_id'] = orderId;
    data['waybill_id'] = waybillId;
    return data;
  }
}

class Courier {
  String? link;
  Null name;
  String? type;
  Null phone;
  String? company;
  Insurance? insurance;
  String? waybillId;
  String? trackingId;
  Null routingCode;

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
        ? Insurance.fromJson(json['insurance'])
        : null;
    waybillId = json['waybill_id'];
    trackingId = json['tracking_id'];
    routingCode = json['routing_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link'] = link;
    data['name'] = name;
    data['type'] = type;
    data['phone'] = phone;
    data['company'] = company;
    if (insurance != null) {
      data['insurance'] = insurance!.toJson();
    }
    data['waybill_id'] = waybillId;
    data['tracking_id'] = trackingId;
    data['routing_code'] = routingCode;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fee'] = fee;
    data['note'] = note;
    data['amount'] = amount;
    data['fee_currency'] = feeCurrency;
    data['amount_currency'] = amountCurrency;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['note'] = note;
    data['type'] = type;
    data['price'] = price;
    data['company'] = company;
    data['version'] = version;
    data['currency'] = currency;
    data['duration'] = duration;
    data['tax_lines'] = taxLines;
    data['description'] = description;
    data['courier_code'] = courierCode;
    data['courier_name'] = courierName;
    data['service_type'] = serviceType;
    data['shipping_type'] = shippingType;
    data['courier_service_code'] = courierServiceCode;
    data['courier_service_name'] = courierServiceName;
    data['shipment_duration_unit'] = shipmentDurationUnit;
    data['available_for_insurance'] = availableForInsurance;
    data['shipment_duration_range'] = shipmentDurationRange;
    data['available_collection_method'] = availableCollectionMethod;
    data['available_for_cash_on_delivery'] = availableForCashOnDelivery;
    data['available_for_proof_of_delivery'] = availableForProofOfDelivery;
    data['available_for_instant_waybill_id'] = availableForInstantWaybillId;
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
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['link_photo'] = linkPhoto;
    data['id'] = id;
    data['description'] = description;
    data['phone_number'] = phoneNumber;
    data['status_open'] = statusOpen;
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
