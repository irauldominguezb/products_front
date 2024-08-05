class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final int status;

  Product({required this.id,required this.name,required this.price,required this.stock, required this.status});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'],
      status: json['status'],

    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'stock': stock,
    'status': status,
  };
}