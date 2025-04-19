import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../data/StateModel.dart';
import '../../../data/services.dart';
import '../../../domain/models/ProductModel.dart';
import '../../../domain/models/SizeModel.dart';


final productProvider = StateNotifierProvider<ProductNotifier, StateModel<List<ProductModel>>>(
      (ref) => ProductNotifier(),
);


class ProductNotifier extends StateNotifier<StateModel<List<ProductModel>>> {
  ProductNotifier() : super(StateModel.loading()){
    init();
  }
  List<ProductModel> products = [];
  HiveService hiveService = HiveService('productsBox');

  void init() async {
    try {
      state = StateModel.loading();
    final products = (await hiveService.getAllItems()).cast<ProductModel>();
    this.products = products;
      state = StateModel.success(products);
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      state = StateModel.loading();
      await hiveService.addItem(product);
      final products = (await hiveService.getAllItems()).cast<ProductModel>();
      state = StateModel.success(products);
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }

  Future<void> deleteProduct(int index) async {
    try {
      state = StateModel.loading();
      await hiveService.deleteItem(index);
      final products = (await hiveService.getAllItems()).cast<ProductModel>();
      state = StateModel.success(products);
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }




  Future<void> addColorToProduct(String productCode, SizeModel newColor) async {
    try {
      final productIndex = products.indexWhere((product) => product.code == productCode);
      if (productIndex != -1) {
        final product = products[productIndex];
        final updatedProduct = product.copyWith(
          sizes: [...product.sizes, newColor],
        );

        await hiveService.updateItem(productIndex, updatedProduct);

        final updatedProducts = (await hiveService.getAllItems()).cast<ProductModel>();
        this.products = updatedProducts;
        state = StateModel.success(updatedProducts);
      }
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }

  Future<void> editProductSizeModel(String productCode, SizeModel updatedSizeModel) async {
    try {
      final productIndex = products.indexWhere((product) => product.code == productCode);
      if (productIndex != -1) {
        final product = products[productIndex];
        final updatedSizes = product.sizes.map((size) {
          if (size.color == updatedSizeModel.color) {
            return updatedSizeModel;
          }
          return size;
        }).toList();

        final updatedProduct = product.copyWith(sizes: updatedSizes);
        await hiveService.updateItem(productIndex, updatedProduct);

        final updatedProducts = (await hiveService.getAllItems()).cast<ProductModel>();
        this.products = updatedProducts;
        state = StateModel.success(updatedProducts);
      }
    } catch (e) {
      state = StateModel.fail(e.toString());
    }
  }

  Future<void> updateProduct(String productCode, SizeModel updatedSizeModel) async {
    try {
      final productIndex = products.indexWhere((product) => product.code == productCode);
      if (productIndex != -1) {
        final product = products[productIndex];
        final updatedSizes = product.sizes.map((size) {
          if (size.color == updatedSizeModel.color) {
            return updatedSizeModel; // Replace the existing size model with the updated one
          }
          return size;
        }).toList();

        final updatedProduct = product.copyWith(sizes: updatedSizes);
        await hiveService.updateItem(productIndex, updatedProduct);

        final updatedProducts = (await hiveService.getAllItems()).cast<ProductModel>();
        this.products = updatedProducts;
        state = StateModel.success(updatedProducts);
      }
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

