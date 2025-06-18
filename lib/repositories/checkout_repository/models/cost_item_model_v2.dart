class CostItemModelV2 {
  String? originName;
  String? destinationName;
  String? serviceDisplay;
  String? serviceCode;
  String? goodsType;
  String? currency;
  String? price;
  String? etdFrom;
  String? etdThru;
  String? times;
  String? courierCode;
  String? service;
  String? code;
  String? courierServiceCode;
  int? cost;
  String? version;
  String? logoUrl;

  CostItemModelV2(
      {this.originName,
      this.destinationName,
      this.serviceDisplay,
      this.serviceCode,
      this.goodsType,
      this.currency,
      this.price,
      this.etdFrom,
      this.etdThru,
      this.times,
      this.courierCode,
      this.service,
      this.code,
      this.courierServiceCode,
      this.cost,
      this.version,
      this.logoUrl});

  CostItemModelV2.fromJson(Map<String, dynamic> json) {
    originName = json['origin_name'];
    destinationName = json['destination_name'];
    serviceDisplay = json['service_display'];
    serviceCode = json['service_code'];
    goodsType = json['goods_type'];
    currency = json['currency'];
    price = json['price'];
    etdFrom = json['etd_from'];
    etdThru = json['etd_thru'];
    times = json['times'];
    courierCode = json['courier_code'];
    service = json['service'];
    code = json['code'];
    courierServiceCode = json['courier_service_code'];
    cost = json['cost'];
    version = json['version'];
    logoUrl = json['logo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['origin_name'] = originName;
    data['destination_name'] = destinationName;
    data['service_display'] = serviceDisplay;
    data['service_code'] = serviceCode;
    data['goods_type'] = goodsType;
    data['currency'] = currency;
    data['price'] = price;
    data['etd_from'] = etdFrom;
    data['etd_thru'] = etdThru;
    data['times'] = times;
    data['courier_code'] = courierCode;
    data['service'] = service;
    data['code'] = code;
    data['courier_service_code'] = courierServiceCode;
    data['cost'] = cost;
    data['version'] = version;
    data['logo_url'] = logoUrl;
    return data;
  }
}
