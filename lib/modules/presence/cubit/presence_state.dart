part of 'presence_cubit.dart';

class PresenceState extends Equatable {
  final bool isLoading;
  final String message;
  final bool isSuccess;
  final DateTime? presenceDate;

  const PresenceState({
    this.isLoading = false,
    this.message = '',
    this.isSuccess = false,
    this.presenceDate,
  });

  PresenceState copyWith({
    bool? isLoading,
    String? message,
    bool? isSuccess,
    DateTime? presenceDate,
  }) {
    return PresenceState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      isSuccess: isSuccess ?? this.isSuccess,
      presenceDate: presenceDate ?? this.presenceDate,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        message,
        isSuccess,
        presenceDate,
      ];
}
