class CategoryModel {
  int? id;
  String? name;
  String? description;
  String? imageUrl;
  String? iconUrl;
  bool? pinToHomepage;
  String? createdAt;
  String? updatedAt;

  CategoryModel(
      {this.id,
      this.name,
      this.description,
      this.imageUrl,
      this.iconUrl,
      this.pinToHomepage,
      this.createdAt,
      this.updatedAt});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    iconUrl = json['icon_url'];
    pinToHomepage = json['pin_to_homepage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image_url'] = imageUrl;
    data['icon_url'] = iconUrl;
    data['pin_to_homepage'] = pinToHomepage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
