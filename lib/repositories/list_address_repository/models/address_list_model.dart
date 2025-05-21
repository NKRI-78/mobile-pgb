class AddressListModel {
  int? id;
  String? name;
  String? phoneNumber;
  String? label;
  int? addressId;
  int? userId;
  bool? isSelected;
  String? createdAt;
  String? updatedAt;
  Address? address;

  AddressListModel(
      {this.id,
      this.name,
      this.phoneNumber,
      this.label,
      this.addressId,
      this.userId,
      this.isSelected,
      this.createdAt,
      this.updatedAt,
      this.address});

  AddressListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    label = json['label'];
    addressId = json['address_id'];
    userId = json['user_id'];
    isSelected = json['is_selected'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['label'] = label;
    data['address_id'] = addressId;
    data['user_id'] = userId;
    data['is_selected'] = isSelected;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class Address {
  int? id;
  String? nameAddress;
  String? detailAddress;
  String? province;
  String? city;
  String? district;
  String? subDistrict;
  int? postalCode;
  double? latitude;
  double? longitude;
  String? createdAt;
  String? updatedAt;

  Address(
      {this.id,
      this.nameAddress,
      this.detailAddress,
      this.province,
      this.city,
      this.district,
      this.subDistrict,
      this.postalCode,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAddress = json['name_address'];
    detailAddress = json['detail_address'];
    province = json['province'];
    city = json['city'];
    district = json['district'];
    subDistrict = json['sub_district'];
    postalCode = json['postal_code'];
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_address'] = nameAddress;
    data['detail_address'] = detailAddress;
    data['province'] = province;
    data['city'] = city;
    data['district'] = district;
    data['sub_district'] = subDistrict;
    data['postal_code'] = postalCode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
