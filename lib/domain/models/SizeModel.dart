import 'package:hive/hive.dart';


   class SizeModel {
     String color; // e.g., "Red", "Blue"
     List<SizeQuantityModel> sizes; // List of sizes, e.g., ["S", "M", "L"]

     SizeModel({
       required this.color,
       required this.sizes,
     });

     factory SizeModel.fromJson(Map<String, dynamic> json) {
       return SizeModel(
         color: json['color'],
         sizes: (json['sizes'] as List).map((size) => SizeQuantityModel.fromJson(size)).toList(),
       );
     }

     Map<String, dynamic> toJson() {
       return {
         'color': color,
         'sizes': sizes.map((size) => size.toJson()).toList(),
       };
     }

     SizeModel copyWith({
       String? color,
       List<SizeQuantityModel>? sizes,
     }) {
       return SizeModel(
         color: color ?? this.color,
         sizes: sizes ?? this.sizes,
       );
     }
   }

   class SizeQuantityModel {
     String name; // e.g., "S", "M", "L"
     int quantity; // e.g., "10", "5"

     SizeQuantityModel({
       required this.name,
       required this.quantity,
     });

     factory SizeQuantityModel.fromJson(Map<String, dynamic> json) {
       return SizeQuantityModel(
         name: json['name'],
         quantity: json['quantity'],
       );
     }

     Map<String, dynamic> toJson() {
       return {
         'name': name,
         'quantity': quantity,
       };
     }

     SizeQuantityModel copyWith({
       String? name,
       int? quantity,
     }) {
       return SizeQuantityModel(
         name: name ?? this.name,
         quantity: quantity ?? this.quantity,
       );
     }
   }