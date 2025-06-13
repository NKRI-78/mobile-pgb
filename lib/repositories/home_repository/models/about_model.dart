class AboutModel {
  int? id;
  String? aboutUs;
  String? createdAt;
  String? updatedAt;

  AboutModel({this.id, this.aboutUs, this.createdAt, this.updatedAt});

  AboutModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    aboutUs = json['about_us'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['about_us'] = aboutUs;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
