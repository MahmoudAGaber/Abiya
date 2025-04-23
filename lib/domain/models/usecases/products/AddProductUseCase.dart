
import '../../ProductModel.dart';
import '../../repositroies/products_repository.dart';

class AddProductUseCase {
  final ProductRepository _repository;

  AddProductUseCase(this._repository);

  Future<void> execute(ProductModel product) async {
    await _repository.addProduct(product);
  }
}