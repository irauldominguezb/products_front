import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/data/models/product_model.dart';
import 'package:products_app/presentation/cubit/product_cubit.dart';
import 'package:products_app/presentation/cubit/product_state.dart';

class AddProductDialog extends StatefulWidget {
  final Function(Product) onSave;

  AddProductDialog({required this.onSave});

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  String? _nameError;
  String? _priceError;
  String? _stockError;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateName);
    _priceController.addListener(_validatePrice);
    _stockController.addListener(_validateStock);
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateName);
    _priceController.removeListener(_validatePrice);
    _stockController.removeListener(_validateStock);
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      _nameError = _getNameError(_nameController.text);
    });
  }

  void _validatePrice() {
    setState(() {
      _priceError = _getPriceError(_priceController.text);
    });
  }

  void _validateStock() {
    setState(() {
      _stockError = _getStockError(_stockController.text);
    });
  }

  String? _getNameError(String value) {
    if (value.isEmpty) {
      return 'Por favor ingresa un nombre';
    } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
      return 'El nombre solo puede contener letras y números';
    }
    return null;
  }

  String? _getPriceError(String value) {
    if (value.isEmpty) {
      return 'Por favor ingresa un precio';
    } else if (!RegExp(r'^[0-9]+(\.[0-9]+)?$').hasMatch(value)) {
      return 'El precio solo puede contener números';
    }
    return null;
  }

  String? _getStockError(String value) {
    if (value.isEmpty) {
      return 'Por favor ingresa una cantidad';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'La cantidad solo puede contener números';
    }
    return null;
  }

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
           _priceController.text.isNotEmpty &&
           _stockController.text.isNotEmpty &&
           _nameError == null &&
           _priceError == null &&
           _stockError == null;
  }

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
          context.read<ProductCubit>().getProducts();
        }
      },
      child: AlertDialog(
        title: const Text('Agregar producto'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  errorText: _nameError,
                ),
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  errorText: _priceError,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  errorText: _stockError,
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: _isFormValid
                ? () {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final newProduct = Product(
                          id: 0, 
                          name: _nameController.text,
                          price: double.parse(_priceController.text),
                          stock: int.parse(_stockController.text),
                          status: 1,
                        );
                        context.read<ProductCubit>().saveProduct(newProduct);
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error al convertir valores de entrada')),
                        );
                      }
                    }
                  }
                : null,
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
