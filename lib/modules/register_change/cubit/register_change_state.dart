part of 'register_change_cubit.dart';

class RegisterChangeState extends Equatable {
  final String emailNew;
  final bool isLoading;
  final bool success;
  final String? errorMessage;

  const RegisterChangeState({
    this.emailNew = '',
    this.isLoading = false,
    this.success = false,
    this.errorMessage,
  });

  RegisterChangeState copyWith({
    String? emailNew,
    bool? isLoading,
    bool? success,
    String? errorMessage,
  }) {
    return RegisterChangeState(
      emailNew: emailNew ?? this.emailNew,
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [emailNew, isLoading, success, errorMessage];
}
