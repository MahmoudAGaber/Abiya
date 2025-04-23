
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/models/OrderModel.dart';
import '../../domain/models/SizeModel.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login Function
  Future<User?> login(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Signup Function
  Future<void> signup(String email, String password, String name) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'token': userCredential.user!.uid,
        });
      }
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

//fireStore

  Future<void> addOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').add(order.toJson());
    } catch (e) {
      throw Exception('Failed to add order: $e');
    }
  }

  Future<void> addOrMergeOrder(OrderModel order, String employeeId) async {
    try {
      // Query Firestore for existing orders with the same productCode, color, and employeeId
      final querySnapshot = await _firestore
          .collection('orders')
          .where('productCode', isEqualTo: order.productCode)
          .where('color', isEqualTo: order.color)
          .where('customerName', isEqualTo: employeeId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If an existing order is found, merge the sizes
        final existingOrderDoc = querySnapshot.docs.first;
        final existingOrderData = existingOrderDoc.data();
        final existingSizes = (existingOrderData['sizes'] as List)
            .map((size) => SizeQuantityModel.fromJson(size))
            .toList();

        final newSizes = order.sizes;

        // Merge sizes
        final mergedSizes = <SizeQuantityModel>[];
        final allSizeNames = {
          ...existingSizes.map((s) => s.name),
          ...newSizes!.map((s) => s.name),
        };

        for (final sizeName in allSizeNames) {
          final existingSize = existingSizes.firstWhere(
                (s) => s.name == sizeName,
            orElse: () => SizeQuantityModel(name: sizeName, quantity: 0),
          );
          final newSize = newSizes.firstWhere(
                (s) => s.name == sizeName,
            orElse: () => SizeQuantityModel(name: sizeName, quantity: 0),
          );
          mergedSizes.add(SizeQuantityModel(
            name: sizeName,
            quantity: existingSize.quantity + newSize.quantity,
          ));
        }

        // Update the existing order with the merged sizes
        await _firestore.collection('orders').doc(existingOrderDoc.id).update({
          'sizes': mergedSizes.map((size) => size.toJson()).toList(),
        });
      } else {
        // If no existing order is found, add the new order with employeeId
        await _firestore.collection('orders').add({
          ...order.toJson(),
          'employeeId': employeeId,
        });
      }
    } catch (e) {
      throw Exception('Failed to add or merge order: $e');
    }
  }

  // Get all orders from Firestore
  Future<List<OrderModel>> getOrders() async {
    try {
      final querySnapshot = await _firestore.collection('orders').get();
      return querySnapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }
}