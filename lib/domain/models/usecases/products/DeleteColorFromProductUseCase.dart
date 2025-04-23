import '../../repositroies/products_repository.dart';


class DeleteColorFromProductUseCase {
  final ProductRepository _productRepository;

  DeleteColorFromProductUseCase(this._productRepository);

  Future<void> execute(String productCode, String colorToRemove) async {
    await _productRepository.deleteColorFromProduct(productCode, colorToRemove);
  }
}