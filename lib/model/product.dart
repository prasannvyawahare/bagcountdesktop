class Product {
  int? id;
  String name;
  String description;
  String brand;
  double brand_code;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.brand,
    required this.brand_code,
  });

  // Convert Product to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'brand': brand,
      'value': brand_code,
    };
  }

  // Convert Map to Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      brand: map['brand'],
      brand_code: map['value'],
    );
  }
}
