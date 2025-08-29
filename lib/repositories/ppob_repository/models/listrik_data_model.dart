class ListrikDataModel {
  final String id;
  final String code;
  final int price;
  final String name;

  ListrikDataModel({
    required this.id,
    required this.code,
    required this.price,
    required this.name,
  });

  factory ListrikDataModel.fromJson(Map<String, dynamic> json) {
    return ListrikDataModel(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      price: json['price'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
