class Product {
  int? id;
  String name;
  String description;
  String brand;
  double value;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.brand,
    required this.value,
  });

  // Convert Product to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'brand': brand,
      'value': value,
    };
  }

  // Convert Map to Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      brand: map['brand'],
      value: map['value'],
    );
  }
}
