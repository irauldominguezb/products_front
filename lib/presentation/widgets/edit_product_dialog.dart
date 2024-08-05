import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/data/models/product_model.dart';
import 'package:products_app/presentation/cubit/product_state.dart';
import 'package:toastification/toastification.dart';
import 'package:products_app/presentation/cubit/product_cubit.dart';

class EditProductDialog extends StatefulWidget {
  final Product product;
  final void Function(Product) onSave;

  const EditProductDialog({required this.product, required this.onSave, Key? key}) : super(key: key);

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _stockController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _stockController = TextEditingController(text: widget.product.stock.toString());
    _priceController = TextEditingController(text: widget.product.price.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return _formKey.currentState?.validate() ?? false;
  }
  void _showToast(String message, Color color, IconData icon) {
    toastification.show(
      context: context,
      title: Text(message),
      type: color == Colors.green ? ToastificationType.success : ToastificationType.error,
      style: ToastificationStyle.minimal,
      alignment: Alignment.bottomRight,
      icon: Icon(icon, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductCubit, ProductState>(
      listener: (context, state){
        if(state is ProductSuccess){
          Navigator.of(context).pop();
          _showToast('Producto actualizado', Colors.green, Icons.check);
        } else if(state is ProductError){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.read<ProductCubit>().getProducts();
        }
      },
      child: AlertDialog(
      title: const Text('Editar Producto'),
      content: Form(
        key: _formKey,
        onChanged: () => setState(() {}),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre no puede estar vacío';
                }
                if (RegExp(r'[^a-zA-Z0-9\s]').hasMatch(value)) {
                  return 'No se permiten caracteres especiales';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Precio',
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El precio no puede estar vacío';
                }
                if (double.tryParse(value)! <= 0) {
                  return 'El precio debe ser mayor a 0';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'Cantidad disponible',
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Debe ingresar una cantidad';
                }
                if (int.tryParse(value)! <= 0) {
                  return 'La cantidad debe ser mayor a 0';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isFormValid() ? () {
            if (_formKey.currentState!.validate()) {
              try {
                final updatedProduct = Product(
                  id: widget.product.id,
                  name: _nameController.text,
                  stock: int.parse(_stockController.text),
                  price: double.parse(_priceController.text),
                  status: widget.product.status,
                );

                context.read<ProductCubit>().updateProduct(updatedProduct);
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error al convertir valores de entrada')),
                );
              }
            }
          } : null,
          child: const Text('Guardar'),
        ),
      ],
    ),
    );
  }
}
