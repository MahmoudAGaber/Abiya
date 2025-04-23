import '../OrderModel.dart';

abstract class OrderRepository {
  Future<void> addOrder(OrderModel order, String employeeId);
  Future<List<OrderModel>> getOrders();
}