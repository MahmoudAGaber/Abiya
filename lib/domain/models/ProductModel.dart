import 'SizeModel.dart';

class ProductModel {
  final String productName;
  final String code;
  final String imagePath;
  final List<SizeModel> sizes;

  ProductModel({
    required this.productName,
    required this.code,
    required this.imagePath,
    required this.sizes,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productName: json['productName'] as String,
      code: json['code'] as String,
      imagePath: json['imagePath'] as String,
      sizes: (json['sizes'] as List<dynamic>)
          .map((size) => SizeModel.fromJson(size as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'code': code,
      'imagePath': imagePath,
      'sizes': sizes.map((size) => size.toJson()).toList(),
    };
  }

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