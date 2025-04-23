import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/StateModel.dart';
import '../../../data/repositries/products_repo_impl.dart';
import '../../../domain/models/ProductModel.dart';
import '../../../domain/models/SizeModel.dart';
import '../../../domain/models/repositroies/products_repository.dart';
import '../../../domain/models/usecases/products/AddColorToProductUseCase.dart';
import '../../../domain/models/usecases/products/AddProductUseCase.dart';

import '../../../domain/models/usecases/products/DeleteColorFromProductUseCase.dart';
import '../../../domain/models/usecases/products/DeleteProductUseCase.dart';
import '../../../domain/models/usecases/products/EditProductSizeModelUseCase.dart';
import '../../../domain/models/usecases/products/GetAllProductsUseCase.dart';
import '../../../domain/models/usecases/products/UpdateProductUseCase.dart';


final productProvider = StateNotifierProvider<ProductNotifier, StateModel<List<ProductModel>>>(
      (ref) => ProductNotifier(
        ref.read(getProductUseCaseProvider),
        ref.read(addProductUseCaseProvider),
    ref.read(deleteProductUseCaseProvider),
    ref.read(addColorToProductUseCaseProvider),
    ref.read(editProductSizeModelUseCaseProvider),
    ref.read(updateProductUseCaseProvider),
        ref.read(deleteColorFromProductUseCaseProvider)
  ),
);

final getProductUseCaseProvider = Provider<GetAllProductsUseCase>((ref) {
  final productRepository = ref.read(productRepositoryProvider


  );
  return GetAllProductsUseCase(productRepository);
});

final addProductUseCaseProvider = Provider<AddProductUseCase>((ref) {
  final productRepository = ref.read(productRepositoryProvider


  );
  return AddProductUseCase(productRepository);
});

final deleteProductUseCaseProvider = Provider<DeleteProductUseCase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return DeleteProductUseCase(productRepository);
});

final addColorToProductUseCaseProvider = Provider<AddColorToProductUseCase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return AddColorToProductUseCase(productRepository);
});

final editProductSizeModelUseCaseProvider = Provider<EditProductSizeModelUseCase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return EditProductSizeModelUseCase(productRepository);
});

final updateProductUseCaseProvider = Provider<UpdateProductUseCase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return UpdateProductUseCase(productRepository);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final firestore = FirebaseFirestore.instance; // Replace with your actual FirebaseFirestore instance
  return ProductRepositoryImpl(firestore);
});

final deleteColorFromProductUseCaseProvider = Provider<DeleteColorFromProductUseCase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return DeleteColorFromProductUseCase(productRepository);
});

class ProductNotifier extends StateNotifier<StateModel<List<ProductModel>>> {
  final GetAllProductsUseCase _getAllProductsUseCase;
  final AddProductUseCase _addProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final AddColorToProductUseCase _addColorToProductUseCase;
  final EditProductSizeModelUseCase _editProductSizeModelUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteColorFromProductUseCase _deleteColorFromProductUseCase;

  ProductNotifier(
      this._getAllProductsUseCase,
      this._addProductUseCase,
      this._deleteProductUseCase,
      this._addColorToProductUseCase,
      this._editProductSizeModelUseCase,
      this._updateProductUseCase,
      this._deleteColorFromProductUseCase
      ) : super(StateModel.loading()){
    fetchProducts();
  }

  List<ProductModel> products = [];


  Future<void> fetchProducts() async {
    try {
      state = StateModel.loading();
      products = await _getAllProductsUseCase.execute();
      state = StateModel.success(products);
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }


  Future<void> addProduct(ProductModel product) async {
    try {
      state = StateModel.loading();
      await _addProductUseCase.execute(product);
      await fetchProducts(); // Fetch updated list
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }

  Future<void> deleteProduct(int index) async {
    try {
      state = StateModel.loading();
      await _deleteProductUseCase.execute(index);
      await fetchProducts(); // Fetch updated list
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }

  Future<void> addColorToProduct(String productCode, SizeModel newColor) async {
    try {
      state = StateModel.loading();
      await _addColorToProductUseCase.execute(productCode, newColor);
      await fetchProducts(); // Fetch updated list
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }

  Future<void> editProductSizeModel(String productCode, SizeModel updatedSizeModel) async {
    try {
      state = StateModel.loading();
      await _editProductSizeModelUseCase.execute(productCode, updatedSizeModel);
      await fetchProducts(); // Fetch updated list
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }

  Future<void> updateProduct(String productCode, SizeModel updatedSizeModel) async {
    try {
      state = StateModel.loading();
      await _updateProductUseCase.execute(productCode, updatedSizeModel);
      await fetchProducts(); // Fetch updated list
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }

  Future<void> deleteColorFromProduct(String productCode, String colorToRemove) async {
    try {
      state = StateModel.loading();
      await _deleteColorFromProductUseCase.execute(productCode, colorToRemove);
      await fetchProducts(); // Fetch updated list
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }

  void searchProduct(String query) {
    final filteredProducts = products.where((product) {
      final lowerQuery = query.toLowerCase();
      return product.code.toLowerCase().contains(lowerQuery) ||
          product.productName.toLowerCase().contains(lowerQuery);
    }).toList();
    state = StateModel.success(filteredProducts);
  }
}
