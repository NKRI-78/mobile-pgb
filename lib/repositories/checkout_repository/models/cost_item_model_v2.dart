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
      this.times});

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
    return data;
  }
}
