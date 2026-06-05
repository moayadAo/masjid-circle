import 'package:hive/hive.dart';

class HiveHelper {

  Future<Box> openBox(final String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }


  Future<void> saveData<T>(final String boxName, final String key, final T value) async {
    final box = await openBox(boxName);
    await box.put(key, value);
  }


  Future<T?> getData<T>(final String boxName, final String key) async {
    final box = await openBox(boxName);
    return box.get(key);
  }


  Future<void> deleteData(final String boxName, final String key) async {
    final box = await openBox(boxName);
    await box.delete(key);
  }

  Future<void> clearBox(final String boxName) async {
    final box = await openBox(boxName);
    await box.clear();
  }

  Future<bool> containsKey(final String boxName, final String key) async {
    final box = await openBox(boxName);
    return box.containsKey(key);
  }

  Future<List<String>> getAllKeys(final String boxName) async {
    final box = await openBox(boxName);
    return box.keys.cast<String>().toList();
  }

  Future<List<T>> getAllValues<T>(final String boxName) async {
    final box = await openBox(boxName);
    return box.values.cast<T>().toList();
  }
}
