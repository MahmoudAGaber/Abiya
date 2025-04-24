
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janel_abiya/presentation/home/screen/mobile/MobileCategoryScreen.dart';
import 'package:janel_abiya/presentation/home/screen/web/WebCategoryScreen.dart';

import '../../widgets/AddProductForm.dart';

class CategoryScreen extends ConsumerStatefulWidget {
   CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: kIsWeb
            ? WebCategoryScreen()
            : MobileCategoryScreen(),
        floatingActionButton: kIsWeb
            ? null // Hide the FloatingActionButton on the web
            : FloatingActionButton(
          onPressed: () {
            showAddProductBottomSheet(context);
          },
          child: const Icon(Icons.add),
        ),)
    );
  }
  void showAddProductBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: AddProductForm(),
        );
      },
    );
  }
}