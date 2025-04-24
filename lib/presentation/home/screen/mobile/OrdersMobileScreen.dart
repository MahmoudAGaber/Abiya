import 'package:flutter/material.dart';
import 'package:janel_abiya/data/StateModel.dart';

import '../home/orderDetails.dart';

class OrdersMobileScreen extends StatelessWidget {
  final StateModel order;

  const OrdersMobileScreen({required this.order, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: const Text('Orders'),
                backgroundColor: Colors.grey.withOpacity(0.1),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: order.handelState(
              onLoading: (state) => const Center(child: CircularProgressIndicator()),
              onFailure: (state) => Center(child: Text('Error: $state')),
              onSuccess: (state) {
                return ListView.builder(
                  itemCount: order.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    var customerName = order.data?.keys.elementAt(index);
                    var customerOrders = order.data?[customerName];
                    if (customerName == null) {
                      return SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        ListTile(
                          title: Text(customerName),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetailsScreen(orders: customerOrders!),
                              ),
                            );
                          },
                        ),
                        Divider(height: 1),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}