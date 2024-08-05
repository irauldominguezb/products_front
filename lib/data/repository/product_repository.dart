import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductRepository {
  final String apiUrl;
  ProductRepository({required this.apiUrl});

  Future<void> saveProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$apiUrl/products/save'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(product.toJson()..remove('id')),
    );
    final message = jsonDecode(response.body)['message'] ?? 'Failed to save product.';
    
    switch (response.statusCode) {
      case 200:
        break;
      case 400:
        throw Exception('$message');
      case 500:
        throw Exception('$message');
      default:
    }
  }

  Future<void> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$apiUrl/products/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(product.toJson()),
    );

    final message = jsonDecode(response.body)['message'] ?? 'Failed to update the product.';

    switch (response.statusCode) {
      case 200:
        break;
      case 400:
        throw Exception('$message');
      case 500:
        throw Exception('$message');
      default:
    }
  }

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$apiUrl/products'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> products = body['products'];
      return products.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> changeProductStatus(int id) async {
    final response = await http.put(
      Uri.parse('$apiUrl/products/change_status'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'id': id}),
    );

    final message = jsonDecode(response.body)['message'] ?? 'Failed to change product status.';

    switch (response.statusCode) {
      case 200:
        break;
      case 400:
        throw Exception('$message');
      case 500:
        throw Exception('$message');
      default:
    }
  }

}

