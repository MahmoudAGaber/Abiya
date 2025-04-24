import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:janel_abiya/data/StateModel.dart';
import 'package:janel_abiya/presentation/home/provider/productsViewModel.dart';
import 'package:janel_abiya/presentation/home/screen/mobile/MobileCategoryScreen.dart';

import '../../../../domain/models/ProductModel.dart';
import '../../widgets/AddProductForm.dart';

class WebCategoryScreen extends ConsumerStatefulWidget {
  WebCategoryScreen({super.key});

  @override
  ConsumerState<WebCategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<WebCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var category = ref.watch(productProvider);
    return  Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1200), // Adjust the maxWidth as needed
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.black),
                                  onPressed: () {
                                    ref
                                        .read(productProvider.notifier)
                                        .fetchProducts();
                                    _searchController.clear();
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          ref.read(productProvider.notifier).searchProduct(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        showAddProductBottomSheet(context);
                      },
                      child: const Text('Add Product'),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(100, 55),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.black,
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                      ),
                    ),)
                  ],
                ),
              ),
              const SizedBox(height: 16),
              category.handelState(
                onLoading: (state) =>
                    const Center(child: CircularProgressIndicator()),
                onSuccess: (state) {
                  return state.data!.isEmpty
                      ? const Center(child: Text('No Products'))
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final isWideScreen = constraints.maxWidth > 600;
                            return isWideScreen
                                ? Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        childAspectRatio: .65,
                                      ),
                                      itemCount: category.data!.length,
                                      itemBuilder: (context, index) {
                                        final product =
                                            category.data![index];
                                        return Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                context.push(
                                                  '/product/${product.code}',
                                                );
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                        12,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/logo.jpeg',
                                                        width:
                                                        double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    child: Text(
                                                      product.code,
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child:
                                              PopupMenuButton<String>(
                                                onSelected: (value) {
                                                  if (value == 'delete') {
                                                    showDeleteConfirmationDialog(
                                                      context,
                                                      product,
                                                      index,
                                                    );
                                                  }
                                                },
                                                itemBuilder: (BuildContext
                                                context) =>
                                                [
                                                  const PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                                icon: const Icon(
                                                  Icons.more_vert,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: category.data!.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        childAspectRatio: 0.65,
                                      ),
                                      itemBuilder: (context, index) {
                                        final product =
                                            category.data![index];
                                        return Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                context.push(
                                                  '/product/${product.code}',
                                                );
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                        12,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/logo.jpeg',
                                                        width:
                                                            double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    product.code,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child:
                                                  PopupMenuButton<String>(
                                                onSelected: (value) {
                                                  if (value == 'delete') {
                                                    showDeleteConfirmationDialog(
                                                      context,
                                                      product,
                                                      index,
                                                    );
                                                  }
                                                },
                                                itemBuilder: (BuildContext
                                                        context) =>
                                                    [
                                                  const PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                                icon: const Icon(
                                                  Icons.more_vert,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                          },
                        );
                },
                onFailure: (state) =>
                    Center(child: Text(state.message!)),
              ),
            ],
          ),
        ),
      ),
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

  void showDeleteConfirmationDialog(
    BuildContext context,
    ProductModel product,
    index,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                ref.read(productProvider.notifier).deleteProduct(index);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
