import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:janel_abiya/presentation/home/provider/categoryViewModel.dart';
import 'package:path_provider/path_provider.dart';

import '../../../domain/models/ProductModel.dart';
import '../../../domain/models/SizeModel.dart';

class AddProductForm extends ConsumerStatefulWidget {
  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends ConsumerState<AddProductForm> {
  final _formKey = GlobalKey<FormState>();

  String? productName, color, price, size38, size40, size42, size44, size46, size48, size50,size52,size54,size56,size58,size60;
  String? pickedImage;

  Future<void> pickAndSaveImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final tempImage = File(picked.path);
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/images');

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
    final savedImage = await tempImage.copy('${imagesDir.path}/$fileName');

    print('✅ Image saved at: ${savedImage.path}');
    print('📁 File exists: ${File(savedImage.path).existsSync()}');

    setState(() {
      pickedImage = savedImage.path;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Add Item',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                buildTextField(
                  'Product Name',
                  onSaved: (val) => productName = val,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Product Name is required';
                    }
                    return null;
                  },
                ),
                buildTextField('Price', onSaved: (val) => price = val),
                // Image Picker
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: pickAndSaveImage,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(Icons.image, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          pickedImage != null
                              ? 'Image selected'
                              : 'Choose an image...',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                buildTextField('Color', onSaved: (val) => color = val),


                const SizedBox(height: 12),
                buildTextField('38', onSaved: (val) => size38 = val),
                buildTextField('40', onSaved: (val) => size40 = val),
                buildTextField('42', onSaved: (val) => size42 = val),
                buildTextField('44', onSaved: (val) => size44 = val),
                buildTextField('46', onSaved: (val) => size46 = val),
                buildTextField('48', onSaved: (val) => size48 = val),
                buildTextField('50', onSaved: (val) => size50 = val),
                buildTextField('52', onSaved: (val) => size52 = val),
                buildTextField('54', onSaved: (val) => size54 = val),
                buildTextField('56', onSaved: (val) => size56 = val),
                buildTextField('58', onSaved: (val) => size58 = val),
                buildTextField('60', onSaved: (val) => size60 = val),



                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            print("PickedImageNow${pickedImage}");
                            var product = ProductModel(productName:productName!,
                                code: productName!,
                                imagePath: pickedImage!,
                                sizes: [
                                  SizeModel(
                                    color: color!,
                                    sizes: [
                                      SizeQuantityModel(name: '38', quantity: size38!),
                                      SizeQuantityModel(name: '40', quantity: size40!),
                                      SizeQuantityModel(name: '42', quantity: size42!),
                                      SizeQuantityModel(name: '44', quantity: size44!),
                                      SizeQuantityModel(name: '46', quantity: size46!),
                                      SizeQuantityModel(name: '48', quantity: size48!),
                                      SizeQuantityModel(name: '50', quantity: size50!),
                                      SizeQuantityModel(name: '52', quantity: size52!),
                                      SizeQuantityModel(name: '54', quantity: size54!),
                                      SizeQuantityModel(name: '56', quantity: size56!),
                                      SizeQuantityModel(name: '58', quantity: size58!),
                                      SizeQuantityModel(name: '60', quantity: size60!),
                                    ],
                                  ),
                                ]);
                            ref.read(productProvider.notifier).addProduct(product);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade200,
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, {required Function(String?) onSaved, String? Function(dynamic val)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
