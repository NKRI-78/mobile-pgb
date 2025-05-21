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
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['total_price'] = this.totalPrice;
    data['weight'] = this.weight;
    data['total_weight'] = this.totalWeight;
    data['note'] = this.note;
    data['product_id'] = this.productId;
    data['order_id'] = this.orderId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['review'] = this.review;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
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
        pictures!.add(new Pictures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['description'] = this.description;
    if (this.pictures != null) {
      data['pictures'] = this.pictures!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    return data;
  }
}
