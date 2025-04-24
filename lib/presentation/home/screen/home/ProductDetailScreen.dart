import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:janel_abiya/domain/models/ProductModel.dart';
import 'package:janel_abiya/presentation/home/provider/orderViewModel.dart';

import '../../../../domain/models/OrderModel.dart';
import '../../../../domain/models/SizeModel.dart';
import '../../provider/productsViewModel.dart';
import '../mobile/ProductDetailMobileScreen.dart';
import '../web/ProductDetailWebScreen.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final ProductModel? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final List<String> sizes = ['38', '40', '42', '44', '46', '48', '50','52','54','56','58','60'];


  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return ProductDetailWebScreen(product: widget.product, sizes: sizes,);
        } else {
          return ProductDetailMobileScreen(product: widget.product, sizes: sizes,);
        }
      },
    );
  }


}

