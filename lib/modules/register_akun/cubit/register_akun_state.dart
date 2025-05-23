part of 'register_akun_cubit.dart';

class RegisterAkunState extends Equatable {
  final bool isLoading;
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirm;
  final File? fileImage;
  final ExtrackKtpModel? ktpModel;

  const RegisterAkunState({
    this.isLoading = false,
    this.isPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
    this.email = '',
    this.phone = '',
    this.password = '',
    this.passwordConfirm = '',
    this.fileImage,
    this.ktpModel,
  });

  @override
  List<Object?> get props => [
        isLoading,
        isPasswordObscured,
        isConfirmPasswordObscured,
        email,
        phone,
        password,
        passwordConfirm,
        fileImage,
        ktpModel,
      ];

  RegisterAkunState copyWith({
    bool? isLoading,
    bool? isPasswordObscured,
    bool? isConfirmPasswordObscured,
    String? email,
    String? phone,
    String? password,
    String? passwordConfirm,
    ValueGetter<File?>? fileImage,
    ExtrackKtpModel? ktpModel,
  }) {
    return RegisterAkunState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isConfirmPasswordObscured:
          isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      fileImage: fileImage != null ? fileImage() : this.fileImage,
      ktpModel: ktpModel ?? this.ktpModel,
    );
  }
}
