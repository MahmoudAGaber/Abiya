
import '../../SizeModel.dart';
import '../../repositroies/products_repository.dart';

class EditProductSizeModelUseCase {
  final ProductRepository _repository;

  EditProductSizeModelUseCase(this._repository);

  Future<void> execute(String productCode, SizeModel updatedSizeModel) async {
    await _repository.editProductSizeModel(productCode, updatedSizeModel);
  }
}