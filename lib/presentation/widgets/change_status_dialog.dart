import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/data/models/product_model.dart';
import 'package:products_app/presentation/cubit/product_cubit.dart';
import 'package:products_app/presentation/cubit/product_state.dart';

class ChangeStatusDialog extends StatelessWidget {
  final Product product;

  ChangeStatusDialog({required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductSuccess) {
          Navigator.of(context).pop();
        } else if (state is ProductError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: AlertDialog(
        title: const Text('Confirmar cambio de estado'),
        content: const Text('¿Está seguro de que desea cambiar el estado del producto?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Confirmar'),
            onPressed: () {
              context.read<ProductCubit>().changeProductStatus(product.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
