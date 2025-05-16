part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final ProfileModel? profile;
  final String? errorMessage;
  final bool isLoading;

  const ProfileState({
    this.errorMessage,
    this.profile,
    this.isLoading = false,
  });

  ProfileState copyWith({
    ProfileModel? profile,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, profile, errorMessage];
}
