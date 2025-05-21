part of 'app_bloc.dart';

@JsonSerializable()
final class AppState extends Equatable {
  final String token;
  final User? user;
  final bool loadingNotif;
  final CartCountModel? badgeCart;
  final NotificationCountModel? badges;

  const AppState({
    this.token = '',
    this.user,
    this.loadingNotif = false,
    this.badgeCart,
    this.badges,
  });

  bool get userEmpty => token.isEmpty;
  bool get isLoggedIn => user != null && token.isNotEmpty;

  @override
  List<Object?> get props => [
        token,
        user,
        loadingNotif,
        badgeCart,
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
    bool? loadingNotif,
    CartCountModel? badgeCart,
    NotificationCountModel? badges,
  }) {
    return AppState(
      token: token ?? this.token,
      user: user ?? this.user,
      loadingNotif: loadingNotif ?? this.loadingNotif,
      badgeCart: badgeCart ?? this.badgeCart,
      badges: badges ?? this.badges,
    );
  }

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);
}

final class AppInitial extends AppState {}
