import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janel_abiya/domain/models/OrderModel.dart';

import '../../../data/StateModel.dart';
import '../../../data/repositries/order_repo_impl.dart';
import '../../../data/source/FirebaseService.dart';
import '../../../data/source/localServices.dart';
import '../../../domain/models/SizeModel.dart';
import '../../../domain/models/repositroies/order_repository.dart';
import '../../../domain/models/usecases/order/add_order_usercase.dart';
import '../../../domain/models/usecases/order/get_order_usecase.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final firebaseService = FirebaseService(); // Replace with your actual FirebaseService instance
  return OrderRepositoryImpl(firebaseService);
});

final addOrderUseCaseProvider = Provider<AddOrderUseCase>((ref) {
  final orderRepository = ref.read(orderRepositoryProvider);
  return AddOrderUseCase(orderRepository);
});

final getOrderUseCaseProvider = Provider<GetOrderUseCase>((ref) {
  final orderRepository = ref.read(orderRepositoryProvider);
  return GetOrderUseCase(orderRepository);
});


final orderProvider = StateNotifierProvider<OrderNotifier, StateModel<Map<String, List<OrderModel>>>>(
      (ref) => OrderNotifier(
    ref.read(addOrderUseCaseProvider),
    ref.read(getOrderUseCaseProvider),
  ),
);



class OrderNotifier extends StateNotifier<StateModel<Map<String, List<OrderModel>>>> {
  final AddOrderUseCase _addOrderUseCase;
  final GetOrderUseCase _getOrderUseCase;

  OrderNotifier(this._addOrderUseCase, this._getOrderUseCase) : super(StateModel.loading());

  Future<void> getOrders() async {
    try {
      final orders = await _getOrderUseCase.execute(); // Use GetOrderUseCase to fetch orders
      state = StateModel.success(_groupOrdersByEmployee(orders)); // Group orders by employee
    } catch (e) {
      state = StateModel.fail(e.toString()); // Handle errors
    }
  }


  void addOrder(OrderModel order,employeeId) async {
    try {
      await _addOrderUseCase.execute(order,employeeId); // Use AddOrderUseCase to add the order
      final updatedOrders = await _getOrderUseCase.execute(); // Use GetOrderUseCase to fetch updated orders
      state = StateModel.success(_groupOrdersByEmployee(updatedOrders)); // Group orders by employee
    } catch (e) {
      state = StateModel.fail(e.toString()); // Handle errors
    }
  }


  Map<String, List<OrderModel>> _groupOrdersByEmployee(List<OrderModel> orders) {
    return orders.fold<Map<String, List<OrderModel>>>({}, (groupedOrders, order) {
      final customerName = order.customerName;

      // Debugging: Print the customerName and order details
      print('Processing order for customer: $customerName');
      print('Order details: ${order.toJson()}');

      if (!groupedOrders.containsKey(customerName)) {
        groupedOrders[customerName] = [];
      }
      groupedOrders[customerName]!.add(order);
      return groupedOrders;
    });
  }
}