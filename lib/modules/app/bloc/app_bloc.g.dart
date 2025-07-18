// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) => AppState(
      token: json['token'] as String? ?? '',
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      loadingNotif: json['loadingNotif'] as bool? ?? false,
      badgeCart: json['badgeCart'] == null
          ? null
          : CartCountModel.fromJson(json['badgeCart'] as Map<String, dynamic>),
      profile: json['profile'] == null
          ? null
          : ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
      badges: json['badges'] == null
          ? null
          : NotificationCountModel.fromJson(
              json['badges'] as Map<String, dynamic>),
      isRelease: json['isRelease'] as bool? ?? false,
      alreadyOnboarding: json['alreadyOnboarding'] as bool? ?? false,
    );

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'token': instance.token,
      'user': instance.user,
      'badgeCart': instance.badgeCart,
      'profile': instance.profile,
      'loadingNotif': instance.loadingNotif,
      'isRelease': instance.isRelease,
      'badges': instance.badges,
      'alreadyOnboarding': instance.alreadyOnboarding,
    };
