

import '../../SizeModel.dart';
import '../../repositroies/products_repository.dart';

class AddColorToProductUseCase {
  final ProductRepository _repository;

  AddColorToProductUseCase(this._repository);

  Future<void> execute(String productCode, SizeModel newColor) async {
    await _repository.addColorToProduct(productCode, newColor);
  }
}