part of 'update_shipping_address_cubit.dart';

class UpdateShippingAddressState extends Equatable {
  final DetailAddressModel? detailAddress;
  final String idAddress;
  final String nameAddress;
  final String phoneNumber;
  final String label;
  final String shopAddress;
  final String province;
  final String city;
  final String subDistrict;
  final String postalCode;
  final String district;
  final LatLng? shopLocation; // Store shop's LatLng coordinates
  final SelectedAdministration? selectedAdministration;
  final bool loading; // State to track loading status
  final bool showLabel; // State to track loading status
  final double latitude;
  final double longitude;
  final String currentAddress;
  final String location;

  const UpdateShippingAddressState({
    this.detailAddress,
    this.idAddress = "",
    this.nameAddress = "",
    this.phoneNumber = "",
    this.label = "",
    this.shopLocation,
    this.district = "",
    this.shopAddress = "",
    this.province = "",
    this.city = "",
    this.subDistrict = "",
    this.postalCode = "",
    this.selectedAdministration,
    this.loading = false, // Default loading is false
    this.showLabel = false, // Default loading is false
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.currentAddress = "",
    this.location = "",
  });

  @override
  List<dynamic> get props => [
        detailAddress,
        idAddress,
        nameAddress,
        phoneNumber,
        label,
        shopLocation,
        district,
        shopAddress,
        province,
        city,
        subDistrict,
        postalCode,
        selectedAdministration,
        loading,
        showLabel,
        latitude,
        longitude,
        currentAddress,
        location
      ];

  UpdateShippingAddressState copyWith({
    DetailAddressModel? detailAddress,
    String? idAddress,
    String? phoneNumber,
    String? nameAddress,
    String? label,
    LatLng? shopLocation,
    String? shopAddress,
    String? province,
    String? city,
    String? subDistrict,
    String? postalCode,
    String? district,
    SelectedAdministration? selectedAdministration,
    bool? loading,
    bool? showLabel,
    double? latitude,
    double? longitude,
    String? currentAddress,
    String? location,
  }) {
    return UpdateShippingAddressState(
      detailAddress: detailAddress ?? this.detailAddress,
      idAddress: idAddress ?? this.idAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nameAddress: nameAddress ?? this.nameAddress,
      label: label ?? this.label,
      shopLocation: shopLocation ?? this.shopLocation,
      district: district ?? this.district,
      shopAddress: shopAddress ?? this.shopAddress,
      province: province ?? this.province,
      city: city ?? this.city,
      subDistrict: subDistrict ?? this.subDistrict,
      postalCode: postalCode ?? this.postalCode,
      selectedAdministration:
          selectedAdministration ?? this.selectedAdministration,
      loading: loading ?? this.loading,
      showLabel: showLabel ?? this.showLabel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      currentAddress: currentAddress ?? this.currentAddress,
      location: location ?? this.location,
    );
  }
}
