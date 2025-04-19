import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janel_abiya/data/services.dart';
import 'package:janel_abiya/domain/models/OrderModel.dart';

import '../../../data/StateModel.dart';
import '../../../domain/models/SizeModel.dart';

final orderProvider = StateNotifierProvider<OrderNotifier, StateModel<List<OrderModel>>>(
  (ref) => OrderNotifier(),
);

class OrderNotifier extends StateNotifier<StateModel<List<OrderModel>>> {
  OrderNotifier() : super(StateModel.loading());
  HiveService hiveService = HiveService('ordersBox');

  void addOrder(OrderModel order) async {
    try {
      await hiveService.addItem(order); // Save the order
      final updatedOrders = (await hiveService.getAllItems()).cast<OrderModel>(); // Fetch updated orders
      state = StateModel.success(updatedOrders); // Update state with new orders
    } catch (e) {
      state = StateModel.fail(e.toString()); // Handle errors
    }
  }

  Future<void> getOrders() async {
    try {
      final orders =  (await hiveService.getAllItems()).cast<OrderModel>();
      print(orders);
      state = StateModel.success(orders); // Update state with fetched orders
    } catch (e) {
      state = StateModel.fail(e.toString()); // Handle errors
    }
  }
}