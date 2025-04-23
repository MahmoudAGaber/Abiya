
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:janel_abiya/data/StateModel.dart';
import 'package:janel_abiya/presentation/home/provider/productsViewModel.dart';

import '../../../domain/models/ProductModel.dart';
import '../widgets/AddProductForm.dart';

class CategoryScreen extends ConsumerStatefulWidget {
   CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var category = ref.watch(productProvider);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty? IconButton(
                          icon: Icon(Icons.clear,color: Colors.black,),
                          onPressed: () {
                            ref.read(productProvider.notifier).fetchProducts(); // Reset the list state
                            _searchController.clear();
                          },
                        ):null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (value){
                        ref.read(productProvider.notifier).searchProduct(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // CircleAvatar(
                  //   backgroundColor: Colors.black,
                  //   child: InkWell(
                  //     onTap: () async {
                  //       String barcode = await FlutterBarcodeScanner.scanBarcode(
                  //         '#ff6666', // Scanner line color
                  //         'Cancel', // Cancel button text
                  //         true, // Show flash icon
                  //         ScanMode.BARCODE, // Scan mode
                  //       );
                  //       if (barcode != '-1') { // '-1' is returned when the user cancels
                  //         ref.read(productProvider.notifier).searchProduct(barcode);
                  //       }
                  //     },
                  //     child: Icon(Icons.qr_code_scanner, color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
            ),
        
            const SizedBox(height: 16),
        
            // Grid
            category.handelState(
              onLoading: (state) => const Center(child: CircularProgressIndicator()),
              onSuccess: (state) {
                return state.data!.isEmpty
                    ? const Center(child: Text('No Products'))
                    : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GridView.builder(
                      itemCount: category.data!.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final product = category.data![index];
                        return Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                context.push('/product/${product.code}');
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset('assets/images/logo.jpeg',
                                              width: double.infinity,
                                              fit: BoxFit.cover
                                            )
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(product.code, style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _showDeleteConfirmationDialog(context, product,index);
                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                                icon: const Icon(Icons.more_vert, color: Colors.white),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
              onFailure: (state) => Center(child: Text(state.message!)),
            ),
        
          ],
        ),
        floatingActionButton: FloatingActionButton(
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
  void _showDeleteConfirmationDialog(BuildContext context, ProductModel product, index) {
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