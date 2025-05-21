class WaitingPaymentModel {
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
  Data? data;
  String? status;
  String? expireAt;
  String? userId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  WaitingPaymentModel(
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
      this.data,
      this.status,
      this.expireAt,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  WaitingPaymentModel.fromJson(Map<String, dynamic> json) {
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
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
    expireAt = json['expire_at'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = status;
    data['expire_at'] = expireAt;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class Data {
  String? bank;
  String? billKey;
  String? vaNumber;
  String? billerCode;
  String? paymentType;

  Data(
      {this.bank,
      this.billKey,
      this.vaNumber,
      this.billerCode,
      this.paymentType});

  Data.fromJson(Map<String, dynamic> json) {
    bank = json['bank'];
    billKey = json['billKey'];
    vaNumber = json['vaNumber'];
    billerCode = json['billerCode'];
    paymentType = json['paymentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bank'] = bank;
    data['billKey'] = billKey;
    data['vaNumber'] = vaNumber;
    data['billerCode'] = billerCode;
    data['paymentType'] = paymentType;
    return data;
  }
}
