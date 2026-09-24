import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const _key = 'kopf_leeren_tasks_v1';

  Future<List<Task>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
