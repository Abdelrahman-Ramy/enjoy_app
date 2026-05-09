import 'package:enjoy_app/features/home/widgets/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static SharedPreferences? pref;

  static Future init() async {
    pref = await SharedPreferences.getInstance();
  }

  // ================= SESSION =================

  static Future<void> saveSession({
    required String key,
    required int start,
    required String type,
    required int duration,
    required int index,
    required double price,
    required String name,
  }) async {
    final pref = SharedPrefService.pref;

    await pref?.setInt("${key}_start", start);
    await pref?.setString("${key}_type", type);
    await pref?.setInt("${key}_duration", duration);
    await pref?.setInt("${key}_index", index);
    await pref?.setDouble("${key}_price", price);
    await pref?.setString("${key}_name", name);
  }

  static SessionModel? getSession(String key) {
    final start = pref?.getInt("${key}_start");
    final type = pref?.getString("${key}_type");
    final duration = pref?.getInt("${key}_duration");
    final index = pref?.getInt("${key}_index");

    if (start == null) return null;

    return SessionModel(
      start: start,
      type: type ?? "open",
      duration: duration ?? 0,
      index: index ?? -1,
      price: pref?.getDouble("${key}_price") ?? 0,
      name: pref?.getString("${key}_name") ?? "Unknown",
    );
  }

  static Future clearSession(String key) async {
    await pref?.remove("${key}_start");
    await pref?.remove("${key}_type");
    await pref?.remove("${key}_duration");
    await pref?.remove("${key}_index");
    await pref?.remove("${key}_price");
    await pref?.remove("${key}_name");
  }

  // ================= HISTORY =================

  static Future saveToHistory(SessionModel session) async {
    final pref = SharedPrefService.pref;

    final historyString = pref?.getString("history");

    List<String> historyList = [];

    if (historyString != null) {
      historyList = historyString.split("|");
    }

   
    final sessionString =
        "${session.start},${session.type},${session.duration},${session.index},${session.price},${session.name}";

    historyList.add(sessionString);

    await pref?.setString("history", historyList.join("|"));
  }

static List<SessionModel> getHistory() {
  final historyString = pref?.getString("history");

  if (historyString == null) return [];

  final list = historyString.split("|");

  return list.map((e) {
    final parts = e.split(",");

    
    if (parts.length < 6) {
      return SessionModel(
        start: int.tryParse(parts[0]) ?? 0,
        type: parts.length > 1 ? parts[1] : "open",
        duration: parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0,
        index: parts.length > 3 ? int.tryParse(parts[3]) ?? -1 : -1,
        price: 0,
        name: "Unknown",
      );
    }

    return SessionModel(
      start: int.parse(parts[0]),
      type: parts[1],
      duration: int.parse(parts[2]),
      index: int.parse(parts[3]),
      price: double.parse(parts[4]),
      name: parts[5],
    );
    
  }).toList();
}
static Future<void> clearHistory() async {
  await pref?.remove("history");
}
}
