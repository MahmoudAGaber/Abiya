import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:janel_abiya/domain/models/ProductModel.dart';
import 'package:janel_abiya/presentation/home/provider/orderViewModel.dart';

import '../../../domain/models/OrderModel.dart';
import '../../../domain/models/SizeModel.dart';
import '../provider/categoryViewModel.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product!.code),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                  child: Image.file(File(widget.product!.imagePath), fit: BoxFit.cover, height: 250, width: double.infinity)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Center(
                    child: DataTable(
                     // border: TableBorder.all(color: Colors.teal),
                      columns: [
                        const DataColumn(
                          label: Text(
                            'Color',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...sizes.map((size) {
                          return DataColumn(
                            label: Text(
                              size,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                        const DataColumn(
                          label: Icon(
                            Icons.edit
                          ),
                        ),
                      ],
                      rows: widget.product!.sizes.map((sizeModel) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                sizeModel.color,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            ...sizes.map((size) {
                              final matchingSize = sizeModel.sizes.firstWhere(
                                    (s) => s.name == size,
                                orElse: () => SizeQuantityModel(name: size, quantity: '0'),
                              );
                              return DataCell(Text(matchingSize.quantity));
                            }).toList(),
                            DataCell(
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'Edit') {
                                    _showEditSizesBottomSheet(context, sizeModel);
                                  }
                                  else if (value == 'Drop') {
                                    setState(() {
                                      widget.product!.sizes.remove(sizeModel);
                                    });
                                  } else if (value == 'Order') {
                                    _showOrderSizesBottomSheet(context, sizeModel);

                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'Edit',
                                    child: Text('Edit Sizes'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'Drop',
                                    child: Text('Drop Color'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'Order',
                                    child: Text('Order'),
                                  )
                                ],
                                child: const Icon(Icons.more_vert),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            ),

            const SizedBox(height: 20),

            // Add new color button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      final TextEditingController colorController = TextEditingController();
                      final List<TextEditingController> sizeControllers =
                          List.generate(sizes.length, (_) => TextEditingController());

                      return SafeArea(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                                left: 16,
                                right: 16,
                                top: 16,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Add New Color',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: colorController,
                                    decoration: const InputDecoration(
                                      labelText: 'Color Name',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.color_lens),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...sizes.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final size = entry.value;
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: TextField(
                                        controller: sizeControllers[index],
                                        decoration: InputDecoration(
                                          labelText: 'Quantity for size $size',
                                          border: const OutlineInputBorder(),
                                          prefixIcon: const Icon(Icons.format_list_numbered),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    );
                                  }).toList(),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {

                                      if (colorController.text.isEmpty ){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Please fill a Color Name'),
                                          ),
                                        );
                                        return;
                                      }
                                      var sizeModel = SizeModel(
                                        color: colorController.text,
                                        sizes: sizeControllers
                                            .map((controller) => SizeQuantityModel(
                                                  name: sizes[sizeControllers.indexOf(controller)],
                                                  quantity: controller.text.isEmpty ? '0' : controller.text,
                                                ))
                                            .toList(),
                                      );
                                      ref.read(productProvider.notifier).addColorToProduct(widget.product!.code, sizeModel);

                                      setState(() {
                                        widget.product!.sizes.add(sizeModel);
                                      });

                                      Navigator.pop(context);

                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add Color'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Color'),
              ),
            ),

            const SizedBox(height: 20),

            // // Save button
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Save product changes
            //       // colorVariants contains all the updated quantities
            //     },
            //     child: const Text('SAVE CHANGES'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
  void _showOrderSizesBottomSheet(BuildContext context, SizeModel sizeModel) {
    final List<TextEditingController> orderControllers = sizes.map((size) {
      return TextEditingController(text: '0'); // Default order quantity is 0
    }).toList();
    final TextEditingController employeeNameController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Sizes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: sizeModel.color,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.color_lens),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: employeeNameController,
                      decoration: const InputDecoration(
                        labelText: 'Employee Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...sizes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final size = entry.value;
                      final availableQuantity = sizeModel.sizes.firstWhere(
                            (s) => s.name == size,
                        orElse: () => SizeQuantityModel(name: size, quantity: '0'),
                      ).quantity;
              
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextField(
                          controller: orderControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Order quantity for size $size (Available: $availableQuantity)',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.shopping_cart),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        _handleOrderPlacement(context, sizeModel, orderControllers,employeeNameController);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Place Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
 void _handleOrderPlacement(BuildContext context, SizeModel sizeModel, List<TextEditingController> orderControllers, TextEditingController employeeNameController) {
   final List<SizeQuantityModel> orderedSizes = [];

   setState(() {
     for (int i = 0; i < orderControllers.length; i++) {
       final orderQuantity = int.tryParse(orderControllers[i].text) ?? 0;
       final sizeName = sizes[i];
       final sizeIndex = sizeModel.sizes.indexWhere((s) => s.name == sizeName);

       if (sizeIndex != -1) {
         final availableQuantity = int.tryParse(sizeModel.sizes[sizeIndex].quantity) ?? 0;

         if (orderQuantity > availableQuantity) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('Cannot order more than available quantity for size $sizeName'),
             ),
           );
           return;
         }

         // Subtract the ordered quantity
         sizeModel.sizes[sizeIndex] = sizeModel.sizes[sizeIndex].copyWith(
           quantity: (availableQuantity - orderQuantity).toString(),
         );

         // Add the ordered size to the list
         if (orderQuantity > 0) {
           orderedSizes.add(SizeQuantityModel(name: sizeName, quantity: orderQuantity.toString()));
         }
       }
     }
   });

   // Update the state in the ViewModel
   ref.read(productProvider.notifier).editProductSizeModel(widget.product!.code, sizeModel);
   ref.read(orderProvider.notifier).addOrder(
     OrderModel(
       customerName: employeeNameController.text,
       orderDate: DateTime.now(),
       id: '',
       productCode: widget.product!.code,
       sizeModel: sizeModel,
       sizes: orderedSizes, // Pass the ordered sizes here
     ),
   );

   Navigator.pop(context);
 }

  void _showEditSizesBottomSheet(BuildContext context, SizeModel sizeModel) {
    final List<TextEditingController> sizeControllers = sizes.map((size) {
      final matchingSize = sizeModel.sizes.firstWhere(
            (s) => s.name == size,
        orElse: () => SizeQuantityModel(name: size, quantity: '0'),
      );
      return TextEditingController(text: matchingSize.quantity);
    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit Sizes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: sizeModel.color,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.color_lens),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ...sizes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final size = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextField(
                          controller: sizeControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Quantity for size $size',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.format_list_numbered),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        _saveEditedSizes(sizeModel, sizeControllers);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save Changes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveEditedSizes(SizeModel sizeModel, List<TextEditingController> sizeControllers) {
    setState(() {
      for (int i = 0; i < sizeControllers.length; i++) {
        final sizeName = sizes[i];
        final existingSizeIndex = sizeModel.sizes.indexWhere((s) => s.name == sizeName);

        if (existingSizeIndex != -1) {
          // Update the existing size
          sizeModel.sizes[existingSizeIndex] = sizeModel.sizes[existingSizeIndex].copyWith(
            quantity: sizeControllers[i].text.isEmpty || int.tryParse(sizeControllers[i].text) == null
                ? '0'
                : sizeControllers[i].text,
          );
        } else {
          // Add a new size if it doesn't exist
          sizeModel.sizes.add(SizeQuantityModel(
            name: sizeName,
            quantity: sizeControllers[i].text.isEmpty || int.tryParse(sizeControllers[i].text) == null
                ? '0'
                : sizeControllers[i].text,
          ));
        }
      }
    });
    // Update the state in the ViewModel
    ref.read(productProvider.notifier).editProductSizeModel(widget.product!.code, sizeModel);
  }

}

