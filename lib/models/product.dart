class Product {
  String? id, title, price;
  DateTime? cretedAt, updatedAt;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.cretedAt,
    this.updatedAt,
  });
}
