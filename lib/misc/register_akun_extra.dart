import '../modules/app/models/user_google_model.dart';
import '../modules/register_akun/model/extrack_ktp_model.dart';

class RegisterAkunExtra {
  final ExtrackKtpModel? extrackKtp;
  final UserGoogleModel? userGoogle;

  RegisterAkunExtra({
    this.extrackKtp,
    this.userGoogle,
  });
}
