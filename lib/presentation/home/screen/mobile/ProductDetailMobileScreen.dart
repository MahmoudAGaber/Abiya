import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janel_abiya/presentation/home/screen/home/ProductDetailScreen.dart';

import '../../../../domain/models/OrderModel.dart';
import '../../../../domain/models/ProductModel.dart';
import '../../../../domain/models/SizeModel.dart';
import '../../provider/orderViewModel.dart';
import '../../provider/productsViewModel.dart';

class ProductDetailMobileScreen extends ConsumerStatefulWidget {
  final ProductModel? product;
  List<String> sizes;

   ProductDetailMobileScreen({super.key, this.product,required this.sizes});

  @override
  ConsumerState<ProductDetailMobileScreen> createState() => _ProductDetailMobileScreenState();
}

class _ProductDetailMobileScreenState extends ConsumerState<ProductDetailMobileScreen> {
  final List<String> sizes = ['38', '40', '42', '44', '46', '48', '50','52','54','56','58','60'];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController colorController = TextEditingController();
  final List<TextEditingController> sizeControllers =
  List.generate(12, (_) => TextEditingController());
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
                child: Image.asset('assets/images/logo.jpeg', fit: BoxFit.cover, height: 250, width: double.infinity),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Center(
                child: DataTable(
                  columns: [
                    const DataColumn(
                      label: Text(
                        'Color',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...widget.sizes.map((size) {
                      return DataColumn(
                        label: Text(
                          size,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    const DataColumn(
                      label: Icon(Icons.edit),
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
                        ...widget.sizes.map((size) {
                          final matchingSize = sizeModel.sizes.firstWhere(
                            (s) => s.name == size,
                            orElse: () => SizeQuantityModel(name: size, quantity: 0),
                          );
                          return DataCell(Text(matchingSize.quantity.toString()));
                        }).toList(),
                        DataCell(
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'Edit') {
                                showEditSizesBottomSheet(context, sizeModel);
                              } else if (value == 'Drop') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: const Text('Are you sure you want to drop this color?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            ref.read(productProvider.notifier).deleteColorFromProduct(widget.product!.code, sizeModel.color);
                                            setState(() {
                                              widget.product!.sizes.remove(sizeModel);
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Confirm'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (value == 'Order') {
                                showOrderSizesBottomSheet(context, sizeModel);
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
                              ),
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
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                addColor(context);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Color'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  void addColor(BuildContext context){
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
                child: Form(
                  key: _formKey,
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
                              quantity: controller.text.isEmpty ? int.parse('0') : int.parse(controller.text),
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
          ),
        );
      },
    );

  }

  void showOrderSizesBottomSheet(BuildContext context, SizeModel sizeModel) {
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
                    TextFormField(
                      controller: employeeNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
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
                        orElse: () => SizeQuantityModel(name: size, quantity: 0),
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
                        handleOrderPlacement(context, sizeModel, orderControllers,employeeNameController);
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

  void handleOrderPlacement(BuildContext context, SizeModel sizeModel, List<TextEditingController> orderControllers, TextEditingController employeeNameController) {
    if (employeeNameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Employee name cannot be empty.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Exit if employee name is not provided
      return; // Exit if employee name is not provided
    }

    bool hasInvalidQuantity = false;
    for (int i = 0; i < orderControllers.length; i++) {
      final orderQuantity = int.tryParse(orderControllers[i].text) ?? 0;
      final sizeName = sizes[i];
      final sizeIndex = sizeModel.sizes.indexWhere((s) => s.name == sizeName);

      if (sizeIndex != -1) {
        final availableQuantity = sizeModel.sizes[sizeIndex].quantity ?? 0;

        if (orderQuantity > availableQuantity) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Invalid quantity for size $sizeName. Available: $availableQuantity'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          hasInvalidQuantity = true;
          break;

        }
      }
    }

    if (hasInvalidQuantity) {
      return; // Exit if any invalid quantity is found
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Order'),
          content: const Text('Are you sure you want to place this order?'),
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
                processOrder(context, sizeModel, orderControllers, employeeNameController);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void processOrder(BuildContext context, SizeModel sizeModel, List<TextEditingController> orderControllers, TextEditingController employeeNameController) {
    final List<SizeQuantityModel> orderedSizes = [];

    for (int i = 0; i < orderControllers.length; i++) {
      final orderQuantity = int.tryParse(orderControllers[i].text) ?? 0;
      final sizeName = sizes[i];
      final sizeIndex = sizeModel.sizes.indexWhere((s) => s.name == sizeName);

      if (sizeIndex != -1) {
        final availableQuantity = sizeModel.sizes[sizeIndex].quantity ?? 0;

        if (orderQuantity > availableQuantity) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot order more than available quantity for size $sizeName'),
            ),
          );
          return; // Exit the method if any invalid order is found
        }

        // Add the ordered size to the list
        if (orderQuantity > 0) {
          orderedSizes.add(SizeQuantityModel(name: sizeName, quantity: orderQuantity));
        }
      }
    }

    // Subtract the ordered quantities and update the sizes
    setState(() {
      for (final orderedSize in orderedSizes) {
        final sizeIndex = sizeModel.sizes.indexWhere((s) => s.name == orderedSize.name);
        if (sizeIndex != -1) {
          sizeModel.sizes[sizeIndex] = sizeModel.sizes[sizeIndex].copyWith(
            quantity: sizeModel.sizes[sizeIndex].quantity - orderedSize.quantity,
          );
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
        color: sizeModel.color,
        sizes: orderedSizes,
      ),
      employeeNameController.text,
    );

    Navigator.pop(context);
  }

  void showEditSizesBottomSheet(BuildContext context, SizeModel sizeModel) {
    final List<TextEditingController> sizeControllers = sizes.map((size) {
      final matchingSize = sizeModel.sizes.firstWhere(
            (s) => s.name == size,
        orElse: () => SizeQuantityModel(name: size, quantity: 0),
      );
      return TextEditingController(text: matchingSize.quantity.toString());
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
                        saveEditedSizes(sizeModel, sizeControllers);
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

  void saveEditedSizes(SizeModel sizeModel, List<TextEditingController> sizeControllers) {
    setState(() {
      for (int i = 0; i < sizeControllers.length; i++) {
        final sizeName = sizes[i];
        final existingSizeIndex = sizeModel.sizes.indexWhere((s) => s.name == sizeName);

        if (existingSizeIndex != -1) {
          // Update the existing size
          sizeModel.sizes[existingSizeIndex] = sizeModel.sizes[existingSizeIndex].copyWith(
            quantity: sizeControllers[i].text.isEmpty || int.tryParse(sizeControllers[i].text) == null
                ? int.parse('0')
                : int.parse(sizeControllers[i].text),
          );
        } else {
          // Add a new size if it doesn't exist
          sizeModel.sizes.add(SizeQuantityModel(
            name: sizeName,
            quantity: sizeControllers[i].text.isEmpty || int.tryParse(sizeControllers[i].text) == null
                ? int.parse('0')
                : int.parse(sizeControllers[i].text),
          ));
        }
      }
    });
    // Update the state in the ViewModel
    ref.read(productProvider.notifier).editProductSizeModel(widget.product!.code, sizeModel);
  }

}