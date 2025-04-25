import 'package:flutter/material.dart';
import 'package:janel_abiya/data/StateModel.dart';

import '../orderDetails.dart';


class OrdersWebScreen extends StatelessWidget {
  final StateModel order;

  const OrdersWebScreen({required this.order, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Scaffold(
       body: Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Chip(
                label: const Text('Orders'),
                backgroundColor: Colors.blue.withOpacity(0.1),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: order.handelState(
                    onLoading: (state) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    onFailure: (state) => Center(
                      child: Text(
                        'Error: $state',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onSuccess: (state) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.data?.length ?? 0,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        itemBuilder: (context, index) {
                          var customerName = order.data?.keys.elementAt(index);
                          var customerOrders = order.data?[customerName];
                          if (customerName == null) {
                            return const SizedBox.shrink();
                          }
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            title: Text(
                              customerName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                              size: 16,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderDetailsScreen(orders: customerOrders!),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )
  );
  }
}