import 'package:flutter/material.dart';

import '../../../../Utils/date_converter.dart';
import '../../../../domain/models/OrderModel.dart';


class OrderDetailsWebScreen extends StatelessWidget {
  final List<OrderModel> orders;

  const OrderDetailsWebScreen({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: orders
                  .fold<Map<String, List<OrderModel>>>({}, (groupedOrders, order) {
                    final day = DateConverter.formatDay(order.orderDate);
                    groupedOrders.putIfAbsent(day, () => []).add(order);
                    return groupedOrders;
                  })
                  .entries
                  .map((entry) {
                    final day = entry.key;
                    final dayOrders = entry.value;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Orders for $day',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            ...dayOrders.map((order) => ListTile(
                              leading: const Icon(Icons.shopping_cart, color: Colors.teal),
                              title: Text(
                                'Product Code: ${order.productCode}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Color: ${order.color}'),
                                  ...?order.sizes?.map((size) => Text(
                                    'Size: ${size.name}, Quantity: ${size.quantity}',
                                    style: const TextStyle(fontSize: 14),
                                  )),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}