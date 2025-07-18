part of 'app_bloc.dart';

@JsonSerializable()
final class AppState extends Equatable {
  final String token;
  final UserModel? user;
  final CartCountModel? badgeCart;
  final ProfileModel? profile;
  final bool loadingNotif;
  final bool isRelease;
  final NotificationCountModel? badges;
  final bool alreadyOnboarding;

  const AppState({
    this.token = '',
    this.user,
    this.loadingNotif = false,
    this.badgeCart,
    this.profile,
    this.badges,
    this.isRelease = false,
    this.alreadyOnboarding = false,
  });

  bool get userEmpty => token.isEmpty;
  bool get isLoggedIn => user != null && token.isNotEmpty;
  bool get isVerified => user?.emailVerified != null && token.isNotEmpty;

  @override
  List<Object?> get props => [
        token,
        user,
        loadingNotif,
        badgeCart,
        profile,
        badges,
        alreadyOnboarding,
        isRelease,
      ];

  AppState logout() {
    return AppState(
      token: '',
      user: null,
      alreadyOnboarding: alreadyOnboarding,
    );
  }

  AppState copyWith({
    String? token,
    UserModel? user,
    bool? loadingNotif,
    CartCountModel? badgeCart,
    ProfileModel? profile,
    NotificationCountModel? badges,
    bool? alreadyOnboarding,
    bool? isRelease,
  }) {
    return AppState(
        alreadyOnboarding: alreadyOnboarding ?? this.alreadyOnboarding,
        token: token ?? this.token,
        user: user ?? this.user,
        loadingNotif: loadingNotif ?? this.loadingNotif,
        badgeCart: badgeCart ?? this.badgeCart,
        profile: profile ?? this.profile,
        badges: badges ?? this.badges,
        isRelease: isRelease ?? this.isRelease);
  }

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);
}

final class AppInitial extends AppState {}
