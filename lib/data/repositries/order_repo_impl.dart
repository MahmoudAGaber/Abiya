import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/OrderModel.dart';
import '../../domain/models/repositroies/order_repository.dart';
import '../source/FirebaseService.dart';


class OrderRepositoryImpl implements OrderRepository {
  final FirebaseService _firebaseService;

  OrderRepositoryImpl(this._firebaseService);

  @override
  Future<void> addOrder(OrderModel order,employeeId) async {
    await _firebaseService.addOrMergeOrder(order,employeeId);
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    return await _firebaseService.getOrders();
  }
}