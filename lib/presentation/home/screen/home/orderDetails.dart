import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../Utils/date_converter.dart';
import '../../../../domain/models/OrderModel.dart';
import '../mobile/OrderDetailsMobileScreen.dart';
import '../web/OrderDetailsWebScreen.dart';

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