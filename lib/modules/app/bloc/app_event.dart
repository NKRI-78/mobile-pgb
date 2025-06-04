part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

final class FinishOnboarding extends AppEvent {}

final class InitialAppData extends AppEvent {}

final class SetUserLogout extends AppEvent {}

final class GetBadgeNotif extends AppEvent {}

final class GetBadgeCart extends AppEvent {}

final class GetProfileData extends AppEvent {}

final class SetUserData extends AppEvent {
  final UserModel user;
  final String token;

  const SetUserData({required this.user, required this.token});
}

final class SetUserGoogle extends AppEvent {
  final UserGoogleModel userGoogle;

  const SetUserGoogle({required this.userGoogle});
}
