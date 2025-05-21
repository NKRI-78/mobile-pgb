part of 'app_bloc.dart';

@JsonSerializable()
final class AppState extends Equatable {
  final String token;
  final User? user;
  final ProfileModel? profile;
  final bool loadingNotif;
  final NotificationCountModel? badges;

  const AppState({
    this.token = '',
    this.user,
    this.profile,
    this.loadingNotif = false,
    this.badges,
  });

  bool get userEmpty => token.isEmpty;
  bool get isLoggedIn => user != null && token.isNotEmpty;

  @override
  List<Object?> get props => [
        token,
        user,
        profile,
        loadingNotif,
        badges,
      ];

  AppState logout() {
    return AppState(
      token: '',
      user: null,
    );
  }

  AppState copyWith({
    String? token,
    User? user,
    ProfileModel? profile,
    bool? loadingNotif,
    NotificationCountModel? badges,
  }) {
    return AppState(
      token: token ?? this.token,
      user: user ?? this.user,
      profile: profile ?? this.profile,
      loadingNotif: loadingNotif ?? this.loadingNotif,
      badges: badges ?? this.badges,
    );
  }

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);
}

final class AppInitial extends AppState {}
