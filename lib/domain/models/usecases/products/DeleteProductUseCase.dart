
import '../../repositroies/products_repository.dart';

class DeleteProductUseCase {
  final ProductRepository _repository;

  DeleteProductUseCase(this._repository);

  Future<void> execute(int index) async {
    await _repository.deleteProduct(index);
  }
}