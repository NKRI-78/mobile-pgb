part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final bool isLoading;
  final String? token;
  final String? errorMessage;
  final UserModel? user;
  final String? oauthId;

  const RegisterState({
    this.isLoading = false,
    this.token,
    this.errorMessage,
    this.user,
    this.oauthId,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? token,
    String? errorMessage,
    UserModel? user,
    String? oauthId,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      oauthId: oauthId ?? this.oauthId,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        token,
        errorMessage,
        user,
        oauthId,
      ];
}
