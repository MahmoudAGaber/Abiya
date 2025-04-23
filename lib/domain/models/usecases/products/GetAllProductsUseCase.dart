

import '../../ProductModel.dart';
import '../../repositroies/products_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository _repository;

  GetAllProductsUseCase(this._repository);

  Future<List<ProductModel>> execute() async {
    return await _repository.getAllProducts();
  }
}