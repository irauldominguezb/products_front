import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/data/models/product_model.dart';
import 'package:products_app/presentation/cubit/product_cubit.dart';
import 'package:products_app/presentation/cubit/product_state.dart';
import 'package:products_app/presentation/widgets/add_product_dialog.dart';
import 'package:products_app/presentation/widgets/edit_product_dialog.dart';
import 'package:products_app/presentation/widgets/change_status_dialog.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  void initState() {
    super.initState();
    // Ejecuta getProducts cuando el widget se monta
    context.read<ProductCubit>().getProducts();
  }

  void showEditProductDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Reusar el cubit existente y proporcionarlo al nuevo contexto del diálogo
        return BlocProvider.value(
          value: BlocProvider.of<ProductCubit>(context),
          child: EditProductDialog(
            product: product,
            onSave: (updatedProduct) {
              // Manejo después de guardar, si es necesario
            },
          ),
        );
      },
    );
  }

  void showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: BlocProvider.of<ProductCubit>(context),
          child: AddProductDialog(
            onSave: (newProduct) {
              // Manejo después de guardar, si es necesario
            },
          ),
        );
      },
    );
  }

  void showChangeStatusDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ChangeStatusDialog(
          product: product,

        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos disponibles'),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductSuccess) {
            final productList = state.products;
            return ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                bool isToggled = product.status == 1;

                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color.fromARGB(255, 200, 200, 200), width: 0.5),
                    ),
                  ),
                  child: ListTile(
                    title: Text(product.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(isToggled ? Icons.toggle_on : Icons.toggle_off),
                          color: isToggled ? Colors.green : Color(0xFFAEABAB),
                          onPressed: () {
                            showChangeStatusDialog(context, product);
                          },
                          tooltip: 'Cambiar estado',
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Mostrar el modal de edición
                            showEditProductDialog(context, product);
                          },
                          tooltip: 'Editar',
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Sin productos'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mostrar el modal para agregar un nuevo producto
          showAddProductDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
