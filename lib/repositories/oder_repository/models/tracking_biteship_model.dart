class TrackingBitshipModel {
  bool? success;
  String? message;
  String? object;
  String? id;
  String? waybillId;
  Courier? courier;
  Origin? origin;
  Origin? destination;
  List<History>? history;
  String? link;
  String? orderId;
  String? status;
  int? weight;

  TrackingBitshipModel(
      {this.success,
      this.message,
      this.object,
      this.id,
      this.waybillId,
      this.courier,
      this.origin,
      this.destination,
      this.history,
      this.link,
      this.orderId,
      this.status,
      this.weight});

  TrackingBitshipModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    object = json['object'];
    id = json['id'];
    waybillId = json['waybill_id'];
    courier =
        json['courier'] != null ? Courier.fromJson(json['courier']) : null;
    origin = json['origin'] != null ? Origin.fromJson(json['origin']) : null;
    destination = json['destination'] != null
        ? Origin.fromJson(json['destination'])
        : null;
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(History.fromJson(v));
      });
    }
    link = json['link'];
    orderId = json['order_id'];
    status = json['status'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['object'] = object;
    data['id'] = id;
    data['waybill_id'] = waybillId;
    if (courier != null) {
      data['courier'] = courier!.toJson();
    }
    if (origin != null) {
      data['origin'] = origin!.toJson();
    }
    if (destination != null) {
      data['destination'] = destination!.toJson();
    }
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    data['link'] = link;
    data['order_id'] = orderId;
    data['status'] = status;
    data['weight'] = weight;
    return data;
  }
}

class Courier {
  String? company;
  String? name;
  String? phone;
  String? driverName;
  String? driverPhone;
  String? driverPhotoUrl;
  String? driverPlateNumber;

  Courier(
      {this.company,
      this.name,
      this.phone,
      this.driverName,
      this.driverPhone,
      this.driverPhotoUrl,
      this.driverPlateNumber});

  Courier.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    name = json['name'];
    phone = json['phone'];
    driverName = json['driver_name'];
    driverPhone = json['driver_phone'];
    driverPhotoUrl = json['driver_photo_url'];
    driverPlateNumber = json['driver_plate_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company'] = company;
    data['name'] = name;
    data['phone'] = phone;
    data['driver_name'] = driverName;
    data['driver_phone'] = driverPhone;
    data['driver_photo_url'] = driverPhotoUrl;
    data['driver_plate_number'] = driverPlateNumber;
    return data;
  }
}

class Origin {
  String? contactName;
  String? address;

  Origin({this.contactName, this.address});

  Origin.fromJson(Map<String, dynamic> json) {
    contactName = json['contact_name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contact_name'] = contactName;
    data['address'] = address;
    return data;
  }
}

class History {
  String? status;
  String? eventDate;
  String? serviceType;
  String? note;

  History({this.status, this.eventDate, this.serviceType, this.note});

  History.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    eventDate = json['eventDate'];
    serviceType = json['serviceType'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['eventDate'] = eventDate;
    data['serviceType'] = serviceType;
    data['note'] = note;
    return data;
  }
}
