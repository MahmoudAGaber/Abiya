import 'package:hive/hive.dart';
import '../../domain/models/ProductModel.dart';
import '../../domain/models/SizeModel.dart';
import '../../domain/models/repositroies/products_repository.dart';
import '../source/localServices.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/ProductModel.dart';
import '../../domain/models/SizeModel.dart';
import '../../domain/models/repositroies/products_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepositoryImpl(this._firestore);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList();
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    await _firestore.collection('products').add(product.toJson());
  }

  @override
  Future<void> deleteProduct(int index) async {
    final snapshot = await _firestore.collection('products').get();
    if (index >= 0 && index < snapshot.docs.length) {
      await snapshot.docs[index].reference.delete();
    }
  }

  @override
  Future<void> addColorToProduct(String productCode, SizeModel newColor) async {
    final query = await _firestore.collection('products').where('code', isEqualTo: productCode).get();
    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      final product = ProductModel.fromJson(doc.data());
      final updatedProduct = product.copyWith(sizes: [...product.sizes, newColor]);
      await doc.reference.update(updatedProduct.toJson());
    }
  }

  @override
  Future<void> editProductSizeModel(String productCode, SizeModel updatedSizeModel) async {
    final query = await _firestore.collection('products').where('code', isEqualTo: productCode).get();
    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      final product = ProductModel.fromJson(doc.data());
      final updatedSizes = product.sizes.map((size) {
        if (size.color == updatedSizeModel.color) {
          return updatedSizeModel;
        }
        return size;
      }).toList();
      final updatedProduct = product.copyWith(sizes: updatedSizes);
      await doc.reference.update(updatedProduct.toJson());
    }
  }

  @override
  Future<void> updateProduct(String productCode, SizeModel updatedSizeModel) async {
    final query = await _firestore.collection('products').where('code', isEqualTo: productCode).get();
    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      final product = ProductModel.fromJson(doc.data());
      final updatedSizes = product.sizes.map((size) {
        if (size.color == updatedSizeModel.color) {
          return updatedSizeModel;
        }
        return size;
      }).toList();
      final updatedProduct = product.copyWith(sizes: updatedSizes);
      await doc.reference.update(updatedProduct.toJson());
    }
  }

  @override
  Future<void> deleteColorFromProduct(String productCode, String colorToRemove) async {
    final query = await _firestore.collection('products').where('code', isEqualTo: productCode).get();
    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      final product = ProductModel.fromJson(doc.data());
      final updatedSizes = product.sizes.where((size) => size.color != colorToRemove).toList();
      final updatedProduct = product.copyWith(sizes: updatedSizes);
      await doc.reference.update(updatedProduct.toJson());
    }
  }
}