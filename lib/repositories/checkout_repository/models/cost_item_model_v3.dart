class CostItemModelV3 {
  List<String>? availableCollectionMethod;
  bool? availableForCashOnDelivery;
  bool? availableForProofOfDelivery;
  bool? availableForInstantWaybillId;
  bool? availableForInsurance;
  String? company;
  String? courierName;
  String? courierCode;
  String? courierServiceName;
  String? courierServiceCode;
  String? currency;
  String? description;
  String? duration;
  String? shipmentDurationRange;
  String? shipmentDurationUnit;
  String? serviceType;
  String? shippingType;
  int? price;
  List<String>? taxLines;
  String? type;
  String? logoUrl;
  String? version;

  CostItemModelV3(
      {this.availableCollectionMethod,
      this.availableForCashOnDelivery,
      this.availableForProofOfDelivery,
      this.availableForInstantWaybillId,
      this.availableForInsurance,
      this.company,
      this.courierName,
      this.courierCode,
      this.courierServiceName,
      this.courierServiceCode,
      this.currency,
      this.description,
      this.duration,
      this.shipmentDurationRange,
      this.shipmentDurationUnit,
      this.serviceType,
      this.shippingType,
      this.price,
      this.taxLines,
      this.type,
      this.logoUrl,
      this.version});

  CostItemModelV3.fromJson(Map<String, dynamic> json) {
    availableCollectionMethod =
        json['available_collection_method'].cast<String>();
    availableForCashOnDelivery = json['available_for_cash_on_delivery'];
    availableForProofOfDelivery = json['available_for_proof_of_delivery'];
    availableForInstantWaybillId = json['available_for_instant_waybill_id'];
    availableForInsurance = json['available_for_insurance'];
    company = json['company'];
    courierName = json['courier_name'];
    courierCode = json['courier_code'];
    courierServiceName = json['courier_service_name'];
    courierServiceCode = json['courier_service_code'];
    currency = json['currency'];
    description = json['description'];
    duration = json['duration'];
    shipmentDurationRange = json['shipment_duration_range'];
    shipmentDurationUnit = json['shipment_duration_unit'];
    serviceType = json['service_type'];
    shippingType = json['shipping_type'];
    price = json['price'];
    json['tax_lines'] != null ? json['tax_lines'].cast<String>() : [];
    type = json['type'];
    logoUrl = json['logo_url'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['available_collection_method'] = availableCollectionMethod;
    data['available_for_cash_on_delivery'] = availableForCashOnDelivery;
    data['available_for_proof_of_delivery'] = availableForProofOfDelivery;
    data['available_for_instant_waybill_id'] = availableForInstantWaybillId;
    data['available_for_insurance'] = availableForInsurance;
    data['company'] = company;
    data['courier_name'] = courierName;
    data['courier_code'] = courierCode;
    data['courier_service_name'] = courierServiceName;
    data['courier_service_code'] = courierServiceCode;
    data['currency'] = currency;
    data['description'] = description;
    data['duration'] = duration;
    data['shipment_duration_range'] = shipmentDurationRange;
    data['shipment_duration_unit'] = shipmentDurationUnit;
    data['service_type'] = serviceType;
    data['shipping_type'] = shippingType;
    data['price'] = price;
    data['tax_lines'] = taxLines;
    data['type'] = type;
    data['logo_url'] = logoUrl;
    data['version'] = version;
    return data;
  }
}
