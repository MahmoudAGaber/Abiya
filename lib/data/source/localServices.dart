import 'package:hive/hive.dart';
import '../../domain/models/ProductModel.dart';

class HiveService<T> {
  final String boxName;

  HiveService(this.boxName);

  Future<void> addItem(T item) async {
    final box = await Hive.openBox<T>(boxName);
    await box.add(item);
  }

  Future<void> updateItem(int index, T updatedItem) async {
    final box = await Hive.openBox<T>(boxName);
    await box.putAt(index, updatedItem);
  }

  Future<void> deleteItem(int index) async {
    final box = await Hive.openBox<T>(boxName);
    await box.deleteAt(index);
  }

  Future<List<T>> getAllItems() async {
    final box = await Hive.openBox<T>(boxName);
    return box.values.toList();
  }

  Future<void> clearAllItems() async {
    final box = await Hive.openBox<T>(boxName);
    await box.clear();
  }
}