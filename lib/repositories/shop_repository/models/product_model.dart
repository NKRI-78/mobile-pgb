class ProductModel {
  int? id;
  String? name;
  String? description;
  int? price;
  int? stock;
  bool? status;
  String? itemCondition;
  int? storeId;
  int? categoryId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Category? category;
  Store? store;
  List<Pictures>? pictures;

  ProductModel(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.stock,
      this.status,
      this.itemCondition,
      this.storeId,
      this.categoryId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.category,
      this.store,
      this.pictures});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stock = json['stock'];
    status = json['status'];
    itemCondition = json['item_condition'];
    storeId = json['store_id'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['stock'] = stock;
    data['status'] = status;
    data['item_condition'] = itemCondition;
    data['store_id'] = storeId;
    data['category_id'] = categoryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? description;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.id,
      this.name,
      this.description,
      this.imageUrl,
      this.createdAt,
      this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image_url'] = imageUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Store {
  int? id;
  String? name;
  String? linkBanner;
  String? linkPhoto;
  bool? statusOpen;
  String? type;
  String? verified;
  int? addressId;
  String? createdAt;
  String? updatedAt;

  Store(
      {this.id,
      this.name,
      this.linkBanner,
      this.linkPhoto,
      this.statusOpen,
      this.type,
      this.verified,
      this.addressId,
      this.createdAt,
      this.updatedAt});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    linkBanner = json['link_banner'];
    linkPhoto = json['link_photo'];
    statusOpen = json['status_open'];
    type = json['type'];
    verified = json['verified'];
    addressId = json['address_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['link_banner'] = linkBanner;
    data['link_photo'] = linkPhoto;
    data['status_open'] = statusOpen;
    data['type'] = type;
    data['verified'] = verified;
    data['address_id'] = addressId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Pictures {
  int? id;
  String? link;

  Pictures({this.id, this.link});

  Pictures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['link'] = link;
    return data;
  }
}
