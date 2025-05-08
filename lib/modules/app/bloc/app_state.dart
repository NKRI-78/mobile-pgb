part of 'app_bloc.dart';

@JsonSerializable()
final class AppState extends Equatable {
  final String token;
  final String user;

  const AppState({
    this.token = '',
    this.user = '',
  });

  bool get userEmpty => token.isEmpty;
  bool get isLoggedIn => token != '' && user != '';

  @override
  List<Object> get props => [
        token,
        user,
      ];

  AppState logout() {
    return AppState(
      token: '',
      user: '',
    );
  }

  AppState copyWith({
    String? token,
    String? user,
  }) {
    return AppState(
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);
}

final class AppInitial extends AppState {}
