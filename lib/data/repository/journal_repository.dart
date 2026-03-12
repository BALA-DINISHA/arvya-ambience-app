import 'package:hive_flutter/hive_flutter.dart';
import '../models/journal_entry.dart';

class JournalRepository {
  static const String _boxName = 'journal_entries';
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    print('Journal box opened with ${_box.length} entries');

    // Debug: print all entries
    for (var key in _box.keys) {
      print('Entry $key: ${_box.get(key)}');
    }
  }

  Future<void> saveEntry(JournalEntry entry) async {
    print('Saving entry: ${entry.toJson()}'); // Debug
    await _box.put(entry.id, entry.toJson());
    print('Saved entry: ${entry.id} with title: ${entry.ambienceTitle}');
  }

  List<JournalEntry> getAllEntries() {
    final entries = <JournalEntry>[];
    for (var key in _box.keys) {
      final data = _box.get(key);
      if (data != null) {
        try {
          final entry = JournalEntry.fromJson(Map<String, dynamic>.from(data));
          entries.add(entry);
          print('Loaded entry: ${entry.id} with title: ${entry.ambienceTitle}');
        } catch (e) {
          print('Error loading entry: $e');
        }
      }
    }
    // Sort by timestamp descending (newest first)
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    print('Retrieved ${entries.length} entries');
    return entries;
  }

  JournalEntry? getEntry(String id) {
    final data = _box.get(id);
    if (data != null) {
      return JournalEntry.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<void> clearAll() async {
    await _box.clear();
    print('Cleared all entries');
  }
}