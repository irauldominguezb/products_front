import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/data/repository/product_repository.dart';
import 'package:products_app/presentation/cubit/product_cubit.dart';
import 'package:products_app/presentation/screens/products_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductRepository productRepository = ProductRepository(apiUrl: 'https://7fr21jtz7g.execute-api.us-east-1.amazonaws.com/Prod');

    return BlocProvider(
      create: (context) => ProductCubit(productRepository: productRepository),
      child: MaterialApp(
        title: 'Products App',
        home: ProductsList(),
      ),
    );
  }
}
