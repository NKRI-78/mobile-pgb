class NeedRiviewModel {
  int? id;
  int? quantity;
  int? price;
  int? totalPrice;
  int? weight;
  int? totalWeight;
  String? note;
  int? productId;
  int? orderId;
  String? createdAt;
  String? updatedAt;
  String? review;
  Product? product;

  NeedRiviewModel(
      {this.id,
      this.quantity,
      this.price,
      this.totalPrice,
      this.weight,
      this.totalWeight,
      this.note,
      this.productId,
      this.orderId,
      this.createdAt,
      this.updatedAt,
      this.review,
      this.product});

  NeedRiviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    totalPrice = json['total_price'];
    weight = json['weight'];
    totalWeight = json['total_weight'];
    note = json['note'];
    productId = json['product_id'];
    orderId = json['order_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    review = json['review'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['weight'] = weight;
    data['total_weight'] = totalWeight;
    data['note'] = note;
    data['product_id'] = productId;
    data['order_id'] = orderId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['review'] = review;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  String? name;
  int? id;
  String? description;
  List<Pictures>? pictures;

  Product({this.name, this.id, this.description, this.pictures});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    description = json['description'];
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['description'] = description;
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pictures {
  String? link;

  Pictures({this.link});

  Pictures.fromJson(Map<String, dynamic> json) {
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link'] = link;
    return data;
  }
}
