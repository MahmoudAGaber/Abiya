import 'package:hive/hive.dart';
import '../../../domain/models/SizeModel.dart';

part 'ProductModel.g.dart';

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  String productName;

  @HiveField(1)
  String code;

  @HiveField(2)
  String imagePath;

  @HiveField(3)
  List<SizeModel> sizes;

  ProductModel({
    required this.productName,
    required this.code,
    required this.imagePath,
    required this.sizes,
  });

  ProductModel copyWith({
    String? productName,
    String? code,
    String? imagePath,
    List<SizeModel>? sizes,
  }) {
    return ProductModel(
      productName: productName ?? this.productName,
      code: code ?? this.code,
      imagePath: imagePath ?? this.imagePath,
      sizes: sizes ?? this.sizes,
    );
  }
}