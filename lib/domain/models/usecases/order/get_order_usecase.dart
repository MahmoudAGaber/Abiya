import '../../OrderModel.dart';
import '../../repositroies/order_repository.dart';

class GetOrderUseCase {
  final OrderRepository _orderRepository;

  GetOrderUseCase(this._orderRepository);

  Future<List<OrderModel>> execute() async {
    return await _orderRepository.getOrders();
  }
}