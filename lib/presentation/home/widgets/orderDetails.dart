import 'package:flutter/material.dart';

import '../../../Utils/date_converter.dart';
import '../../../domain/models/OrderModel.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Date: ${DateConverter.formatDate(order.orderDate)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Product Code: ${order.productCode}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Color: ${order.sizeModel.color}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sizes:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: order.sizes!.length,
                itemBuilder: (context, index) {
                  final size = order.sizes![index];
                  return ListTile(
                    leading: const Icon(Icons.format_list_numbered),
                    title: Text('Size: ${size.name}'),
                    trailing: Text('Quantity: ${size.quantity}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}