import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janel_abiya/data/StateModel.dart';
import 'package:janel_abiya/domain/models/OrderModel.dart';
import 'package:janel_abiya/presentation/home/provider/orderViewModel.dart';

import '../widgets/orderDetails.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  void initState() {
   WidgetsBinding.instance.addPostFrameCallback((callback){
     ref.read(orderProvider.notifier).getOrders();
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var order = ref.watch(orderProvider);

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

          // Orders list
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

