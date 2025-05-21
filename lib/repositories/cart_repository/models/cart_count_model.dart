class CartCountModel {
  int? totalQuantity;
  int? totalItem;

  CartCountModel({this.totalQuantity, this.totalItem});

  CartCountModel.fromJson(Map<String, dynamic> json) {
    totalQuantity = json['totalQuantity'];
    totalItem = json['totalItem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalQuantity'] = totalQuantity;
    data['totalItem'] = totalItem;
    return data;
  }
}
