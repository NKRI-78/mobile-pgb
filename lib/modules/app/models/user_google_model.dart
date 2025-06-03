class UserGoogleModel {
  String? action;
  String? email;
  String? oauthId;
  String? name;
  String? avatar;

  UserGoogleModel({
    this.action,
    this.email,
    this.oauthId,
    this.name,
    this.avatar,
  });

  UserGoogleModel copyWith({
    String? action,
    String? email,
    String? oauthId,
    String? name,
    String? avatar,
  }) {
    return UserGoogleModel(
      action: action ?? this.action,
      email: email ?? this.email,
      oauthId: oauthId ?? this.oauthId,
      name: name ?? this.name,
      avatar: avatar, // Allow null override
    );
  }

  UserGoogleModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    email = json['email'];
    oauthId = json['oauth_id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    data['email'] = email;
    data['oauth_id'] = oauthId;
    data['name'] = name;
    data['avatar'] = avatar;
    return data;
  }
}
