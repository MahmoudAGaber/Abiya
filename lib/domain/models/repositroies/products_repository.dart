import '../OrderModel.dart';
import '../ProductModel.dart';
import '../SizeModel.dart';

  abstract class ProductRepository {
  Future<List<ProductModel>> getAllProducts();
  Future<void> addProduct(ProductModel product);
  Future<void> deleteProduct(int index);
  Future<void> addColorToProduct(String productCode, SizeModel newColor);
  Future<void> editProductSizeModel(String productCode, SizeModel updatedSizeModel);
  Future<void> updateProduct(String productCode, SizeModel updatedSizeModel);
  Future<void> deleteColorFromProduct(String productCode, String colorToRemove);
  }
