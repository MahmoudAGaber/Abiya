import 'package:flutter/material.dart';
import 'package:janel_abiya/presentation/home/screen/home/web/OrderDetailsWebScreen.dart';

import '../../../../domain/models/OrderModel.dart';
import 'mobile/OrderDetailsMobileScreen.dart';


class OrderDetailsScreen extends StatelessWidget {
  final List<OrderModel> orders;

  const OrderDetailsScreen({super.key, required this.orders});


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return OrderDetailsWebScreen(orders: orders);
        } else {
          return OrderDetailsMobileScreen(orders: orders);
        }
      },
    );
  }
}