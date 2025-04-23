import 'SizeModel.dart';

class OrderModel {
  final String id;
  final String productCode;
  final DateTime orderDate;
  final String customerName;
  final String color;
  final List<SizeQuantityModel>? sizes;

  OrderModel({
    required this.id,
    required this.productCode,
    required this.orderDate,
    required this.customerName,
    required this.color,
    required this.sizes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      productCode: json['productCode'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      customerName: json['customerName'] as String,
      color: json['color'] as String,
      sizes: (json['sizes'] as List<dynamic>?)
          ?.map((size) => SizeQuantityModel.fromJson(size as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productCode': productCode,
      'orderDate': orderDate.toIso8601String(),
      'customerName': customerName,
      'color': color,
      'sizes': sizes?.map((size) => size.toJson()).toList(),
    };
  }
}