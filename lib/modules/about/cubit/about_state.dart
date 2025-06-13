part of 'about_cubit.dart';

final class AboutState extends Equatable {
  final AboutModel? about;
  final String errorMessage;
  final bool isLoading;

  const AboutState({
    this.about,
    this.errorMessage = "",
    this.isLoading = false,
  });

  AboutState copyWith({
    AboutModel? about,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AboutState(
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
