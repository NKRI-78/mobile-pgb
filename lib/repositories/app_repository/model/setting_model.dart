// To parse this JSON data, do
//
//     final settingModel = settingModelFromJson(jsonString);

import 'dart:convert';

SettingModel settingModelFromJson(String str) => SettingModel.fromJson(json.decode(str));

String settingModelToJson(SettingModel data) => json.encode(data.toJson());

class SettingModel {
    String message;
    Data data;

    SettingModel({
        required this.message,
        required this.data,
    });

    factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    bool isReview;
    String iosVersion;

    Data({
        required this.isReview,
        required this.iosVersion,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        isReview: json["isReview"],
        iosVersion: json["iosVersion"],
    );

    Map<String, dynamic> toJson() => {
        "isReview": isReview,
        "iosVersion": iosVersion,
    };
}
