import 'dart:convert';

import 'package:enjoy_app/features/home/widgets/order_model.dart';
import 'package:enjoy_app/features/home/widgets/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static SharedPreferences? pref;

  // Key for storing history (now stores JSON array)
  static const String _historyKey = 'history_json';

  static Future init() async {
    pref = await SharedPreferences.getInstance();
  }

  // ================= SESSION =================

  /// Save individual session data using separate keys
  /// This is useful for storing a current session in progress
  ///
  /// Usage:
  /// ```dart
  /// await SharedPrefService.saveSession(
  ///   key: 'current_session',
  ///   start: DateTime.now().millisecondsSinceEpoch,
  ///   type: 'playstation',
  ///   duration: 3600,
  ///   index: 1,
  ///   price: 5.0,
  ///   name: 'PS-01',
  ///   orders: [],
  /// );
  /// ```
  static Future<void> saveSession({
    required String key,
    required int start,
    required String type,
    required int duration,
    required int index,
    required double price,
    required String name,
    List<OrderModel> orders = const [],
    String? notes,
  }) async {
    final pref = SharedPrefService.pref;

    // Create SessionModel and convert to JSON
    final session = SessionModel(
      start: start,
      type: type,
      duration: duration,
      index: index,
      price: price,
      name: name,
      orders: orders,
      notes: notes,
    );

    // Store as JSON string
    await pref?.setString("${key}_json", jsonEncode(session.toJson()));
  }

  /// Retrieve individual session data using key
  /// Returns null if session doesn't exist or is corrupted
  ///
  /// Usage:
  /// ```dart
  /// SessionModel? session = SharedPrefService.getSession('current_session');
  /// ```
  static SessionModel? getSession(String key) {
    try {
      final jsonString = pref?.getString("${key}_json");

      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return SessionModel.fromJson(json);
    } catch (e) {
      print('Error loading session with key "$key": $e');
      return null;
    }
  }

  /// Clear individual session data
  static Future clearSession(String key) async {
    await pref?.remove("${key}_json");
  }

  // ================= HISTORY =================

  /// Save a session to history using JSON format
  /// All history is stored as a JSON array
  ///
  /// Usage:
  /// ```dart
  /// SessionModel session = SessionModel(
  ///   start: DateTime.now().millisecondsSinceEpoch,
  ///   type: 'playstation',
  ///   duration: 3600,
  ///   index: 1,
  ///   price: 5.0,
  ///   name: 'PS-01',
  ///   orders: [OrderModel(name: 'Pepsi', price: 2.5)],
  ///   notes: 'Great session!',
  /// );
  /// await SharedPrefService.saveToHistory(session);
  /// ```
  static Future<void> saveToHistory(SessionModel session) async {
    try {
      final pref = SharedPrefService.pref;

      // Get existing history or create empty list
      final existingJson = pref?.getString(_historyKey) ?? '[]';
      final List<dynamic> historyList = jsonDecode(existingJson) as List;

      // Convert existing history to SessionModels and add new session
      final sessions = historyList
          .whereType<Map<String, dynamic>>()
          .map((json) => SessionModel.fromJson(json))
          .toList();

      sessions.add(session);

      // Save updated history as JSON array
      final jsonArray = sessions.map((s) => s.toJson()).toList();
      await pref?.setString(_historyKey, jsonEncode(jsonArray));
    } catch (e) {
      print('Error saving session to history: $e');
    }
  }

  /// Load all history sessions as JSON
  /// Safely handles corrupted data - skips invalid entries
  /// Returns empty list if no history exists
  ///
  /// Usage:
  /// ```dart
  /// List<SessionModel> history = SharedPrefService.getHistory();
  /// for (final session in history) {
  ///   print('${session.name}: ${session.getTotalPrice()}');
  /// }
  /// ```
  static List<SessionModel> getHistory() {
    try {
      final pref = SharedPrefService.pref;
      final jsonString = pref?.getString(_historyKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString) as List;

      final sessions = <SessionModel>[];

      // Process each item safely - skip corrupted entries
      for (final item in jsonList) {
        try {
          if (item is Map<String, dynamic>) {
            final session = SessionModel.fromJson(item);
            sessions.add(session);
          }
        } catch (e) {
          print('Warning: Skipping corrupted history entry: $e');
          // Continue processing other entries
        }
      }

      return sessions;
    } catch (e) {
      print('Error loading history: $e');
      // Return empty list instead of crashing
      return [];
    }
  }

  /// Clear all history
  static Future<void> clearHistory() async {
    try {
      await pref?.remove(_historyKey);
    } catch (e) {
      print('Error clearing history: $e');
    }
  }

  /// Get a specific number of recent sessions
  /// Useful for showing recent activity
  ///
  /// Usage:
  /// ```dart
  /// List<SessionModel> recent = SharedPrefService.getRecentSessions(10);
  /// ```
  static List<SessionModel> getRecentSessions(int count) {
    final history = getHistory();
    if (history.length <= count) {
      return history.reversed.toList();
    }
    return history.sublist(history.length - count).reversed.toList();
  }

  /// Get total earnings from history
  /// Sums up all session prices including extras
  ///
  /// Usage:
  /// ```dart
  /// double total = SharedPrefService.getTotalEarnings();
  /// ```
  static double getTotalEarnings() {
    final history = getHistory();
    double total = 0.0;
    for (final session in history) {
      total += session.getTotalPrice();
    }
    return total;
  }

  /// Legacy method: Migrate old history format to new JSON format
  /// Only call this ONCE after updating your app
  /// This handles old corrupted history without crashing
  ///
  /// Usage in main():
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await SharedPrefService.init();
  ///   await SharedPrefService.migrateOldHistory();
  ///   runApp(const MyApp());
  /// }
  /// ```
  static Future<void> migrateOldHistory() async {
    try {
      final pref = SharedPrefService.pref;

      // Check if old format exists
      final oldHistory = pref?.getString('history');
      if (oldHistory == null || oldHistory.isEmpty) {
        return;
      }

      // Check if already migrated (new format exists)
      final newHistory = pref?.getString(_historyKey);
      if (newHistory != null && newHistory.isNotEmpty) {
        return; // Already migrated
      }

      print('Migrating old history format to JSON...');

      final sessions = <SessionModel>[];
      final sessionStrings = oldHistory.split("|");

      for (final sessionStr in sessionStrings) {
        try {
          final parts = sessionStr.split(",");

          if (parts.length < 6) continue; // Skip invalid entries

          // Try to parse orders if they exist (old format)
          List<OrderModel> orders = [];
          if (parts.length > 6 && parts[6].isNotEmpty) {
            try {
              final orderStrings = parts[6].split("||");
              orders = orderStrings.map((str) {
                final orderParts = str.split("|");
                if (orderParts.length >= 2) {
                  return OrderModel(
                    name: orderParts[0],
                    price: double.tryParse(orderParts[1]) ?? 0.0,
                    note: orderParts.length > 2 && orderParts[2].isNotEmpty
                        ? orderParts[2]
                        : null,
                  );
                }
                return OrderModel(name: 'Unknown', price: 0.0);
              }).toList();
            } catch (e) {
              print('Warning: Could not parse orders from old format: $e');
            }
          }

          final session = SessionModel(
            start: int.tryParse(parts[0]) ?? 0,
            type: parts.length > 1 ? parts[1] : 'open',
            duration: parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0,
            index: parts.length > 3 ? int.tryParse(parts[3]) ?? -1 : -1,
            price: parts.length > 4 ? double.tryParse(parts[4]) ?? 0.0 : 0.0,
            name: parts.length > 5 ? parts[5] : 'Unknown',
            orders: orders,
            notes: null,
          );

          sessions.add(session);
        } catch (e) {
          print('Warning: Skipping corrupted old history entry: $e');
          continue;
        }
      }

      // Save migrated history
      if (sessions.isNotEmpty) {
        final jsonArray = sessions.map((s) => s.toJson()).toList();
        await pref?.setString(_historyKey, jsonEncode(jsonArray));
        print('Migration complete: ${sessions.length} sessions migrated');
      }
    } catch (e) {
      print('Error during history migration: $e');
    }
  }
}
