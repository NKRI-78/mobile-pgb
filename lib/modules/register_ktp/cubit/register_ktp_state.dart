part of 'register_ktp_cubit.dart';

class RegisterKtpState extends Equatable {
  final bool loading;
  final List<String> imagePaths;
  //
  final String nik;
  final String nama;
  final String ttl;
  final String alamat;
  final String rtRw;
  final String kelDesa;
  final String kecamatan;
  final String agama;
  final String statusPerkawinan;
  final String pekerjaan;
  final String kewarganegaraan;
  final String berlakuHingga;

  const RegisterKtpState({
    this.loading = false,
    this.imagePaths = const [],
    //
    this.nik = '',
    this.nama = '',
    this.ttl = '',
    this.alamat = '',
    this.rtRw = '',
    this.kelDesa = '',
    this.kecamatan = '',
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
        //
        nik,
        nama,
        ttl,
        alamat,
        rtRw,
        kelDesa,
        kecamatan,
        agama,
        statusPerkawinan,
        pekerjaan,
        kewarganegaraan,
        berlakuHingga
      ];

  RegisterKtpState copyWith({
    bool? loading,
    List<String>? imagePaths,
    //
    String? nik,
    String? nama,
    String? ttl,
    String? alamat,
    String? rtRw,
    String? kelDesa,
    String? kecamatan,
    String? agama,
    String? statusPerkawinan,
    String? pekerjaan,
    String? kewarganegaraan,
    String? berlakuHingga,
  }) {
    return RegisterKtpState(
      loading: loading ?? this.loading,
      imagePaths: imagePaths ?? this.imagePaths,
      //
      nik: nik ?? this.nik,
      nama: nama ?? this.nama,
      ttl: ttl ?? this.ttl,
      alamat: alamat ?? this.alamat,
      rtRw: rtRw ?? this.rtRw,
      kelDesa: kelDesa ?? this.kelDesa,
      kecamatan: kecamatan ?? this.kecamatan,
      agama: agama ?? this.agama,
      statusPerkawinan: statusPerkawinan ?? this.statusPerkawinan,
      pekerjaan: pekerjaan ?? this.pekerjaan,
      kewarganegaraan: kewarganegaraan ?? this.kewarganegaraan,
      berlakuHingga: berlakuHingga ?? this.berlakuHingga,
    );
  }
}
