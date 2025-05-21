class CheckoutDetailModel {
  int? id;
  String? name;
  String? linkPhoto;
  List<Carts>? carts;

  CheckoutDetailModel({this.id, this.name, this.linkPhoto, this.carts});

  CheckoutDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    linkPhoto = json['link_photo'];
    if (json['carts'] != null) {
      carts = <Carts>[];
      json['carts'].forEach((v) {
        carts!.add(Carts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['link_photo'] = linkPhoto;
    if (carts != null) {
      data['carts'] = carts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Carts {
  int? id;
  int? quantity;
  int? price;
  int? totalPrice;
  bool? isSelected;
  String? note;
  Product? product;

  Carts(
      {this.id,
      this.quantity,
      this.price,
      this.totalPrice,
      this.isSelected,
      this.note,
      this.product});

  Carts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    totalPrice = json['total_price'];
    isSelected = json['is_selected'];
    note = json['note'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['is_selected'] = isSelected;
    data['note'] = note;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? description;
  int? price;
  int? stock;
  String? itemCondition;
  bool? status;
  int? weight;
  Store? store;
  List<Pictures>? pictures;

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.stock,
      this.itemCondition,
      this.status,
      this.weight,
      this.store,
      this.pictures});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stock = json['stock'];
    itemCondition = json['item_condition'];
    status = json['status'];
    weight = json['weight'];
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
    data['item_condition'] = itemCondition;
    data['status'] = status;
    data['weight'] = weight;
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Store {
  int? id;
  String? name;
  String? linkPhoto;
  bool? statusOpen;

  Store({this.id, this.name, this.linkPhoto, this.statusOpen});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    linkPhoto = json['link_photo'];
    statusOpen = json['status_open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['link_photo'] = linkPhoto;
    data['status_open'] = statusOpen;
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
