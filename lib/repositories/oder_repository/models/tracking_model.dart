class TrackingModel {
  Cnote? cnote;
  List<PhotoHistory>? photoHistory;
  List<Detail>? detail;
  List<History>? history;

  TrackingModel({this.cnote, this.photoHistory, this.detail, this.history});

  TrackingModel.fromJson(Map<String, dynamic> json) {
    cnote = json['cnote'] != null ? Cnote.fromJson(json['cnote']) : null;
    if (json['photo_history'] != null) {
      photoHistory = <PhotoHistory>[];
      json['photo_history'].forEach((v) {
        photoHistory!.add(PhotoHistory.fromJson(v));
      });
    }
    if (json['detail'] != null) {
      detail = <Detail>[];
      json['detail'].forEach((v) {
        detail!.add(Detail.fromJson(v));
      });
    }
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(History.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cnote != null) {
      data['cnote'] = cnote!.toJson();
    }
    if (photoHistory != null) {
      data['photo_history'] =
          photoHistory!.map((v) => v.toJson()).toList();
    }
    if (detail != null) {
      data['detail'] = detail!.map((v) => v.toJson()).toList();
    }
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cnote {
  String? cnoteNo;
  String? referenceNumber;
  String? cnoteOrigin;
  String? cnoteDestination;
  String? cnoteServicesCode;
  String? servicetype;
  String? cnoteCustNo;
  String? cnoteDate;
  String? cnotePodReceiver;
  String? cnoteReceiverName;
  String? cityName;
  String? cnotePodDate;
  String? podStatus;
  String? lastStatus;
  String? custType;
  String? cnoteAmount;
  String? cnoteWeight;
  String? podCode;
  String? keterangan;
  String? cnoteGoodsDescr;
  String? freightCharge;
  String? shippingcost;
  String? insuranceamount;
  String? priceperkg;
  String? signature;
  String? photo;
  String? long;
  String? lat;
  String? estimateDelivery;
  String? cnoteRt;
  String? cnoteFw;

  Cnote(
      {this.cnoteNo,
      this.referenceNumber,
      this.cnoteOrigin,
      this.cnoteDestination,
      this.cnoteServicesCode,
      this.servicetype,
      this.cnoteCustNo,
      this.cnoteDate,
      this.cnotePodReceiver,
      this.cnoteReceiverName,
      this.cityName,
      this.cnotePodDate,
      this.podStatus,
      this.lastStatus,
      this.custType,
      this.cnoteAmount,
      this.cnoteWeight,
      this.podCode,
      this.keterangan,
      this.cnoteGoodsDescr,
      this.freightCharge,
      this.shippingcost,
      this.insuranceamount,
      this.priceperkg,
      this.signature,
      this.photo,
      this.long,
      this.lat,
      this.estimateDelivery,
      this.cnoteRt,
      this.cnoteFw});

  Cnote.fromJson(Map<String, dynamic> json) {
    cnoteNo = json['cnote_no'];
    referenceNumber = json['reference_number'];
    cnoteOrigin = json['cnote_origin'];
    cnoteDestination = json['cnote_destination'];
    cnoteServicesCode = json['cnote_services_code'];
    servicetype = json['servicetype'];
    cnoteCustNo = json['cnote_cust_no'];
    cnoteDate = json['cnote_date'];
    cnotePodReceiver = json['cnote_pod_receiver'];
    cnoteReceiverName = json['cnote_receiver_name'];
    cityName = json['city_name'];
    cnotePodDate = json['cnote_pod_date'];
    podStatus = json['pod_status'];
    lastStatus = json['last_status'];
    custType = json['cust_type'];
    cnoteAmount = json['cnote_amount'];
    cnoteWeight = json['cnote_weight'];
    podCode = json['pod_code'];
    keterangan = json['keterangan'];
    cnoteGoodsDescr = json['cnote_goods_descr'];
    freightCharge = json['freight_charge'];
    shippingcost = json['shippingcost'];
    insuranceamount = json['insuranceamount'];
    priceperkg = json['priceperkg'];
    signature = json['signature'];
    photo = json['photo'];
    long = json['long'];
    lat = json['lat'];
    estimateDelivery = json['estimate_delivery'];
    cnoteRt = json['cnote_rt'];
    cnoteFw = json['cnote_fw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cnote_no'] = cnoteNo;
    data['reference_number'] = referenceNumber;
    data['cnote_origin'] = cnoteOrigin;
    data['cnote_destination'] = cnoteDestination;
    data['cnote_services_code'] = cnoteServicesCode;
    data['servicetype'] = servicetype;
    data['cnote_cust_no'] = cnoteCustNo;
    data['cnote_date'] = cnoteDate;
    data['cnote_pod_receiver'] = cnotePodReceiver;
    data['cnote_receiver_name'] = cnoteReceiverName;
    data['city_name'] = cityName;
    data['cnote_pod_date'] = cnotePodDate;
    data['pod_status'] = podStatus;
    data['last_status'] = lastStatus;
    data['cust_type'] = custType;
    data['cnote_amount'] = cnoteAmount;
    data['cnote_weight'] = cnoteWeight;
    data['pod_code'] = podCode;
    data['keterangan'] = keterangan;
    data['cnote_goods_descr'] = cnoteGoodsDescr;
    data['freight_charge'] = freightCharge;
    data['shippingcost'] = shippingcost;
    data['insuranceamount'] = insuranceamount;
    data['priceperkg'] = priceperkg;
    data['signature'] = signature;
    data['photo'] = photo;
    data['long'] = long;
    data['lat'] = lat;
    data['estimate_delivery'] = estimateDelivery;
    data['cnote_rt'] = cnoteRt;
    data['cnote_fw'] = cnoteFw;
    return data;
  }
}

class PhotoHistory {
  String? date;
  String? photo1;
  String? photo2;
  String? photo3;
  String? photo4;
  String? photo5;

  PhotoHistory(
      {this.date,
      this.photo1,
      this.photo2,
      this.photo3,
      this.photo4,
      this.photo5});

  PhotoHistory.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    photo1 = json['photo1'];
    photo2 = json['photo2'];
    photo3 = json['photo3'];
    photo4 = json['photo4'];
    photo5 = json['photo5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['photo1'] = photo1;
    data['photo2'] = photo2;
    data['photo3'] = photo3;
    data['photo4'] = photo4;
    data['photo5'] = photo5;
    return data;
  }
}

class Detail {
  String? cnoteNo;
  String? cnoteDate;
  String? cnoteWeight;
  String? cnoteOrigin;
  String? cnoteShipperName;
  String? cnoteShipperAddr1;
  String? cnoteShipperAddr2;
  String? cnoteShipperAddr3;
  String? cnoteShipperCity;
  String? cnoteReceiverName;
  String? cnoteReceiverAddr1;
  String? cnoteReceiverAddr2;
  String? cnoteReceiverAddr3;
  String? cnoteReceiverCity;

  Detail(
      {this.cnoteNo,
      this.cnoteDate,
      this.cnoteWeight,
      this.cnoteOrigin,
      this.cnoteShipperName,
      this.cnoteShipperAddr1,
      this.cnoteShipperAddr2,
      this.cnoteShipperAddr3,
      this.cnoteShipperCity,
      this.cnoteReceiverName,
      this.cnoteReceiverAddr1,
      this.cnoteReceiverAddr2,
      this.cnoteReceiverAddr3,
      this.cnoteReceiverCity});

  Detail.fromJson(Map<String, dynamic> json) {
    cnoteNo = json['cnote_no'];
    cnoteDate = json['cnote_date'];
    cnoteWeight = json['cnote_weight'];
    cnoteOrigin = json['cnote_origin'];
    cnoteShipperName = json['cnote_shipper_name'];
    cnoteShipperAddr1 = json['cnote_shipper_addr1'];
    cnoteShipperAddr2 = json['cnote_shipper_addr2'];
    cnoteShipperAddr3 = json['cnote_shipper_addr3'];
    cnoteShipperCity = json['cnote_shipper_city'];
    cnoteReceiverName = json['cnote_receiver_name'];
    cnoteReceiverAddr1 = json['cnote_receiver_addr1'];
    cnoteReceiverAddr2 = json['cnote_receiver_addr2'];
    cnoteReceiverAddr3 = json['cnote_receiver_addr3'];
    cnoteReceiverCity = json['cnote_receiver_city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cnote_no'] = cnoteNo;
    data['cnote_date'] = cnoteDate;
    data['cnote_weight'] = cnoteWeight;
    data['cnote_origin'] = cnoteOrigin;
    data['cnote_shipper_name'] = cnoteShipperName;
    data['cnote_shipper_addr1'] = cnoteShipperAddr1;
    data['cnote_shipper_addr2'] = cnoteShipperAddr2;
    data['cnote_shipper_addr3'] = cnoteShipperAddr3;
    data['cnote_shipper_city'] = cnoteShipperCity;
    data['cnote_receiver_name'] = cnoteReceiverName;
    data['cnote_receiver_addr1'] = cnoteReceiverAddr1;
    data['cnote_receiver_addr2'] = cnoteReceiverAddr2;
    data['cnote_receiver_addr3'] = cnoteReceiverAddr3;
    data['cnote_receiver_city'] = cnoteReceiverCity;
    return data;
  }
}

class History {
  String? date;
  String? desc;
  String? code;
  String? photo1;
  String? photo2;
  String? photo3;
  String? photo4;
  String? photo5;

  History(
      {this.date,
      this.desc,
      this.code,
      this.photo1,
      this.photo2,
      this.photo3,
      this.photo4,
      this.photo5});

  History.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    desc = json['desc'];
    code = json['code'];
    photo1 = json['photo1'];
    photo2 = json['photo2'];
    photo3 = json['photo3'];
    photo4 = json['photo4'];
    photo5 = json['photo5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['desc'] = desc;
    data['code'] = code;
    data['photo1'] = photo1;
    data['photo2'] = photo2;
    data['photo3'] = photo3;
    data['photo4'] = photo4;
    data['photo5'] = photo5;
    return data;
  }
}
