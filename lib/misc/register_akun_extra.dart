import 'package:mobile_pgb/modules/app/models/user_google_model.dart';
import 'package:mobile_pgb/modules/register_akun/model/extrack_ktp_model.dart';

class RegisterAkunExtra {
  final ExtrackKtpModel? extrackKtp;
  final UserGoogleModel? userGoogle;

  RegisterAkunExtra({
    this.extrackKtp,
    this.userGoogle,
  });
}
