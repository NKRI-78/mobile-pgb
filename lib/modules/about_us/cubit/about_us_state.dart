part of 'about_us_cubit.dart';

final class AboutUsState extends Equatable {
  final AboutModel? about;
  final String errorMessage;
  final bool isLoading;

  const AboutUsState({
    this.about,
    this.errorMessage = "",
    this.isLoading = false,
  });

  AboutUsState copyWith({
    AboutModel? about,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AboutUsState(
      about: about ?? this.about,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        about,
        errorMessage,
        isLoading,
      ];
}
