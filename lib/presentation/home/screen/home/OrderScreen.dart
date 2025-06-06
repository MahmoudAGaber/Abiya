import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janel_abiya/presentation/home/provider/orderViewModel.dart';
import 'package:janel_abiya/presentation/home/screen/home/web/OrdersWebScreen.dart';

import 'mobile/OrdersMobileScreen.dart';


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

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return OrdersWebScreen(order: order);
        } else {
          return OrdersMobileScreen(order: order);
        }
      },
    );
  }
}

