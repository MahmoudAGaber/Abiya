import '../../OrderModel.dart';
import '../../repositroies/order_repository.dart';

class AddOrderUseCase {
  final OrderRepository _orderRepository;

  AddOrderUseCase(this._orderRepository);

  Future<void> execute(OrderModel order,employeeId) async {
    await _orderRepository.addOrder(order,employeeId);
  }
}