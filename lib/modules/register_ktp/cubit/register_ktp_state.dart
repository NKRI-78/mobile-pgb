part of 'register_ktp_cubit.dart';

class RegisterKtpState extends Equatable {
  final bool loading;
  final List<String> imagePaths;
  final String? ktpImagePath;
  final Map<String, dynamic>? extractedData;
  final UserGoogleModel? userGoogleModel;
  final String? error;
  final String? validationMessage;
  //
  final String nik;
  final String nama;
  final String ttl;
  final String jenisKelamin;
  final String golDarah;
  final String alamat;
  final String rtRw;
  final String kelDesa;
  final String kecamatan;
  final String kabupaten;
  final String provinsi;
  final String agama;
  final String statusPerkawinan;
  final String pekerjaan;
  final String kewarganegaraan;
  final String berlakuHingga;

  const RegisterKtpState({
    this.loading = false,
    this.imagePaths = const [],
    this.ktpImagePath,
    this.extractedData,
    this.userGoogleModel,
    this.error,
    this.validationMessage,
    //
    this.nik = '',
    this.nama = '',
    this.ttl = '',
    this.jenisKelamin = '',
    this.golDarah = '',
    this.alamat = '',
    this.rtRw = '',
    this.kelDesa = '',
    this.kecamatan = '',
    this.kabupaten = '',
    this.provinsi = '',
    this.agama = '',
    this.statusPerkawinan = '',
    this.pekerjaan = '',
    this.kewarganegaraan = '',
    this.berlakuHingga = '',
  });

  @override
  List<Object?> get props => [
        loading,
        imagePaths,
        ktpImagePath,
        extractedData,
        userGoogleModel,
        error,
        validationMessage,
        //
        nik,
        nama,
        ttl,
        jenisKelamin,
        golDarah,
        alamat,
        rtRw,
        kelDesa,
        kecamatan,
        kabupaten,
        provinsi,
        agama,
        statusPerkawinan,
        pekerjaan,
        kewarganegaraan,
        berlakuHingga
      ];

  RegisterKtpState copyWith({
    bool? loading,
    List<String>? imagePaths,
    String? ktpImagePath,
    Map<String, dynamic>? extractedData,
    UserGoogleModel? userGoogleModel,
    Object? error = _sentinel,
    Object? validationMessage = _sentinel,
    //
    String? nik,
    String? nama,
    String? ttl,
    String? jenisKelamin,
    String? golDarah,
    String? alamat,
    String? rtRw,
    String? kelDesa,
    String? kecamatan,
    String? kabupaten,
    String? provinsi,
    String? agama,
    String? statusPerkawinan,
    String? pekerjaan,
    String? kewarganegaraan,
    String? berlakuHingga,
  }) {
    return RegisterKtpState(
      loading: loading ?? this.loading,
      imagePaths: imagePaths ?? this.imagePaths,
      ktpImagePath: ktpImagePath ?? this.ktpImagePath,
      extractedData: extractedData ?? this.extractedData,
      userGoogleModel: userGoogleModel ?? this.userGoogleModel,
      error: identical(error, _sentinel) ? this.error : error as String?,
      validationMessage: identical(validationMessage, _sentinel)
          ? this.validationMessage
          : validationMessage as String?,
      //
      nik: nik ?? this.nik,
      nama: nama ?? this.nama,
      ttl: ttl ?? this.ttl,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      golDarah: golDarah ?? this.golDarah,
      alamat: alamat ?? this.alamat,
      rtRw: rtRw ?? this.rtRw,
      kelDesa: kelDesa ?? this.kelDesa,
      kecamatan: kecamatan ?? this.kecamatan,
      kabupaten: kabupaten ?? this.kabupaten,
      provinsi: provinsi ?? this.provinsi,
      agama: agama ?? this.agama,
      statusPerkawinan: statusPerkawinan ?? this.statusPerkawinan,
      pekerjaan: pekerjaan ?? this.pekerjaan,
      kewarganegaraan: kewarganegaraan ?? this.kewarganegaraan,
      berlakuHingga: berlakuHingga ?? this.berlakuHingga,
    );
  }
}

const Object _sentinel = Object();
