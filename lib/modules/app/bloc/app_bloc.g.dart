// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) => AppState(
      token: json['token'] as String? ?? '',
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      profile: json['profile'] == null
          ? null
          : ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
      loadingNotif: json['loadingNotif'] as bool? ?? false,
      badges: json['badges'] == null
          ? null
          : NotificationCountModel.fromJson(
              json['badges'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'token': instance.token,
      'user': instance.user,
      'profile': instance.profile,
      'loadingNotif': instance.loadingNotif,
      'badges': instance.badges,
    };
