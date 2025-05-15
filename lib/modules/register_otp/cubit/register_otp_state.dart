part of 'register_otp_cubit.dart';

class RegisterOtpState extends Equatable {
  final bool loading;
  final String otp;
  final String email;
  final String newEmail;
  final int timeRemaining;
  final bool timerFinished;

  const RegisterOtpState({
    this.timeRemaining = 120,
    this.timerFinished = false,
    this.loading = false,
    this.otp = '',
    this.email = '',
    this.newEmail = '',
  });

  RegisterOtpState copyWith({
    int? timeRemaining,
    bool? timerFinished,
    bool? loading,
    String? otp,
    String? email,
    String? newEmail,
  }) {
    return RegisterOtpState(
      timeRemaining: timeRemaining ?? this.timeRemaining,
      timerFinished: timerFinished ?? this.timerFinished,
      loading: loading ?? this.loading,
      otp: otp ?? this.otp,
      email: email ?? this.email,
      newEmail: newEmail ?? this.newEmail,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        email,
        timeRemaining,
        timerFinished,
        otp,
        newEmail,
      ];
}
