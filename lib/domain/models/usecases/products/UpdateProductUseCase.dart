

import '../../SizeModel.dart';
import '../../repositroies/products_repository.dart';

class UpdateProductUseCase {
  final ProductRepository _repository;

  UpdateProductUseCase(this._repository);

  Future<void> execute(String productCode, SizeModel updatedSizeModel) async {
    await _repository.updateProduct(productCode, updatedSizeModel);
  }
}