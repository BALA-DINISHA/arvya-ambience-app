import 'package:hive_flutter/hive_flutter.dart';

class DatabaseHelper {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    // Register adapters if needed
  }

  static Future<Box> openBox(String boxName) async {
    return await Hive.openBox(boxName);
  }
}