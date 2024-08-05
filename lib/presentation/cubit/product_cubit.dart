import 'package:bloc/bloc.dart';
import '../../data/models/product_model.dart';
import '../../data/repository/product_repository.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository productRepository;

  ProductCubit({required this.productRepository}) : super(ProductInitial());

  Future<void> saveProduct(Product product) async {
    try {
      emit(ProductLoading());
      await productRepository.saveProduct(product);
      final products = await productRepository.getProducts();
      emit(ProductSuccess(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> getProducts() async {
    try {
      emit(ProductLoading());
      final products = await productRepository.getProducts();
      emit(ProductSuccess(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      emit(ProductLoading());
      await productRepository.updateProduct(product);
      final products = await productRepository.getProducts();
      emit(ProductSuccess(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> changeProductStatus(int id) async {
    try {
      emit(ProductLoading());
      await productRepository.changeProductStatus(id);
      final products = await productRepository.getProducts();
      emit(ProductSuccess(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
