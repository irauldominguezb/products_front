import 'package:equatable/equatable.dart';
import 'package:products_app/data/models/product_model.dart';


abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}
class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<Product> products;

  const ProductSuccess({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}