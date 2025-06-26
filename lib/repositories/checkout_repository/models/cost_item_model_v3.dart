class CostListModelV3 {
  String? message;
  double? distance;
  double? distanceKm;
  List<CostItemModelV3>? data;

  CostListModelV3({
    this.message,
    this.distance,
    this.distanceKm,
    this.data,
  });

  factory CostListModelV3.fromJson(Map<String, dynamic> json) {
    return CostListModelV3(
      message: json['message'],
      distance: (json['distance'] is int)
          ? (json['distance'] as int).toDouble()
          : json['distance']?.toDouble(),
      distanceKm: (json['distance_km'] is int)
          ? (json['distance_km'] as int).toDouble()
          : json['distance_km']?.toDouble(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CostItemModelV3.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'distance': distance,
      'distance_km': distanceKm,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

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

  CostItemModelV3({
    this.availableCollectionMethod,
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
    this.version,
  });

  factory CostItemModelV3.fromJson(Map<String, dynamic> json) {
    return CostItemModelV3(
      availableCollectionMethod:
          (json['available_collection_method'] as List<dynamic>?)
              ?.cast<String>(),
      availableForCashOnDelivery: json['available_for_cash_on_delivery'],
      availableForProofOfDelivery: json['available_for_proof_of_delivery'],
      availableForInstantWaybillId: json['available_for_instant_waybill_id'],
      availableForInsurance: json['available_for_insurance'],
      company: json['company'],
      courierName: json['courier_name'],
      courierCode: json['courier_code'],
      courierServiceName: json['courier_service_name'],
      courierServiceCode: json['courier_service_code'],
      currency: json['currency'],
      description: json['description'],
      duration: json['duration'],
      shipmentDurationRange: json['shipment_duration_range'],
      shipmentDurationUnit: json['shipment_duration_unit'],
      serviceType: json['service_type'],
      shippingType: json['shipping_type'],
      price: json['price'],
      taxLines: (json['tax_lines'] as List<dynamic>?)?.cast<String>(),
      type: json['type'],
      logoUrl: json['logo_url'],
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available_collection_method': availableCollectionMethod,
      'available_for_cash_on_delivery': availableForCashOnDelivery,
      'available_for_proof_of_delivery': availableForProofOfDelivery,
      'available_for_instant_waybill_id': availableForInstantWaybillId,
      'available_for_insurance': availableForInsurance,
      'company': company,
      'courier_name': courierName,
      'courier_code': courierCode,
      'courier_service_name': courierServiceName,
      'courier_service_code': courierServiceCode,
      'currency': currency,
      'description': description,
      'duration': duration,
      'shipment_duration_range': shipmentDurationRange,
      'shipment_duration_unit': shipmentDurationUnit,
      'service_type': serviceType,
      'shipping_type': shippingType,
      'price': price,
      'tax_lines': taxLines,
      'type': type,
      'logo_url': logoUrl,
      'version': version,
    };
  }
}
