// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) => AppState(
      token: json['token'] as String? ?? '',
      user: json['user'] as String? ?? '',
    );

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'token': instance.token,
      'user': instance.user,
    };
