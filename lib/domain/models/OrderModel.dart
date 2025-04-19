import 'package:hive/hive.dart';
import 'package:janel_abiya/domain/models/SizeModel.dart';
import 'ProductModel.dart';
part 'OrderModel.g.dart';

@HiveType(typeId: 3) // Ensure the typeId is unique across all models
class OrderModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productCode;

  @HiveField(2)
  final DateTime orderDate;

  @HiveField(3)
  final String customerName;

  @HiveField(4) // Add a new field for ProductModel
  final SizeModel sizeModel;

  @HiveField(5) // Add a new field for ProductModel
  final List<SizeQuantityModel>? sizes;


  OrderModel({
    required this.id,
    required this.productCode,
    required this.orderDate,
    required this.customerName,
    required this.sizeModel,
    required this.sizes
  });
}