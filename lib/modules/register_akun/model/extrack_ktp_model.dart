class ExtrackKtpModel {
  int? id;
  String? fullname;
  int? userId;
  String? nik;
  String? avatarLink;
  String? gender;
  String? birthPlaceAndDate;
  String? villageUnit;
  String? administrativeVillage;
  String? subDistrict;
  String? religion;
  String? maritalStatus;
  String? occupation;
  String? citizenship;
  String? bloodType;
  String? address;
  String? validUntil;
  String? updatedAt;
  String? createdAt;

  String get translateGender {
    final value = gender?.trim().toUpperCase() ?? '';
    if (value.isEmpty || value == '-') return '';
    if (value.contains('LAKI')) return 'L';
    if (value.contains('PEREMPUAN')) return 'P';
    return '';
  }

  ExtrackKtpModel(
      {this.id,
      this.fullname,
      this.userId,
      this.nik,
      this.avatarLink,
      this.gender,
      this.birthPlaceAndDate,
      this.villageUnit,
      this.administrativeVillage,
      this.subDistrict,
      this.religion,
      this.maritalStatus,
      this.occupation,
      this.citizenship,
      this.bloodType,
      this.address,
      this.validUntil,
      this.updatedAt,
      this.createdAt});
}
