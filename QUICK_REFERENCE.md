# 🎯 QUICK REFERENCE CARD

## Copy-Paste Code Snippets

### 1. Import statements
```dart
import 'package:enjoy_app/features/home/widgets/session_model.dart';
import 'package:enjoy_app/features/home/widgets/order_model.dart';
import 'package:enjoy_app/core/utils/session_prefs.dart';
```

### 2. Create Order
```dart
OrderModel order = OrderModel(
  name: 'Pepsi',
  price: 2.5,
  note: 'Large', // optional
);
```

### 3. Create Session
```dart
SessionModel session = SessionModel(
  start: DateTime.now().millisecondsSinceEpoch,
  type: 'playstation', // 'playstation', 'ping', 'billiards'
  duration: 3600000, // milliseconds
  index: 1,
  price: 5.0,
  name: 'PS-01',
  orders: [
    OrderModel(name: 'Pepsi', price: 2.5),
  ],
  notes: 'Optional note', // optional
);
```

### 4. Save to History
```dart
await SharedPrefService.saveToHistory(session);
```

### 5. Load History
```dart
List<SessionModel> history = SharedPrefService.getHistory();
```

### 6. Display Session Info
```dart
for (final session in history) {
  print('${session.name}: \$${session.getTotalPrice()}');
}
```

### 7. Get Total Earnings
```dart
double total = SharedPrefService.getTotalEarnings();
print('Total: \$$total');
```

### 8. Get Recent Sessions
```dart
List<SessionModel> recent = SharedPrefService.getRecentSessions(10);
```

### 9. Clear History
```dart
await SharedPrefService.clearHistory();
```

### 10. Session Calculations
```dart
double basePrice = session.price;           // $5.00
double extrasTotal = session.getExtrasTotal();  // $4.00
double totalPrice = session.getTotalPrice();    // $9.00
```

---

## Method Cheat Sheet

| Method | Returns | Purpose |
|--------|---------|---------|
| `saveToHistory(session)` | Future<void> | Save completed session |
| `getHistory()` | List<SessionModel> | Load all history |
| `saveSession(...)` | Future<void> | Save in-progress session |
| `getSession(key)` | SessionModel? | Load in-progress session |
| `clearHistory()` | Future<void> | Delete all history |
| `getTotalEarnings()` | double | Sum all prices |
| `getRecentSessions(n)` | List<SessionModel> | Get last N sessions |
| `clearSession(key)` | Future<void> | Delete one session |
| `migrateOldHistory()` | Future<void> | Convert old format (auto) |

---

## Property Reference

### SessionModel Properties
- `int start` - Milliseconds since epoch
- `String type` - 'playstation', 'ping', 'billiards'
- `int duration` - Milliseconds
- `int index` - Device index
- `double price` - Base price
- `String name` - Device name
- `List<OrderModel> orders` - Orders/extras
- `String? notes` - Optional notes

### OrderModel Properties
- `String name` - Product name
- `double price` - Product price
- `String? note` - Optional note

---

## Common Patterns

### Pattern 1: Save Session When Ending
```dart
// When session ends
SessionModel session = SessionModel(
  start: startTime,
  type: deviceType,
  duration: elapsed,
  index: deviceIndex,
  price: basePrice,
  name: deviceName,
  orders: ordersAdded,
);
await SharedPrefService.saveToHistory(session);
```

### Pattern 2: Load and Display History
```dart
// In history screen
List<SessionModel> history = SharedPrefService.getHistory();

for (final session in history) {
  print('${session.name}: \$${session.getTotalPrice()}');
}
```

### Pattern 3: Handle Empty History
```dart
List<SessionModel> history = SharedPrefService.getHistory();

if (history.isEmpty) {
  print('No history');
} else {
  // Display history
}
```

### Pattern 4: Calculate Statistics
```dart
List<SessionModel> history = SharedPrefService.getHistory();

double totalEarnings = 0;
int sessionCount = history.length;
double avgEarnings = totalEarnings / sessionCount;

for (final session in history) {
  totalEarnings += session.getTotalPrice();
}
```

### Pattern 5: Save with Orders
```dart
List<OrderModel> orders = [];
orders.add(OrderModel(name: 'Item1', price: 1.0));
orders.add(OrderModel(name: 'Item2', price: 2.0));

SessionModel session = SessionModel(
  start: now,
  type: 'playstation',
  duration: 3600000,
  index: 1,
  price: 5.0,
  name: 'PS-01',
  orders: orders, // Include orders
);

await SharedPrefService.saveToHistory(session);
```

---

## Troubleshooting Quick Fixes

| Problem | Solution |
|---------|----------|
| Can't import SessionModel | Add: `import 'package:enjoy_app/features/home/widgets/session_model.dart';` |
| getHistory() returns empty | Create a session first, or migration didn't complete |
| Prices not calculating | Check `getTotalPrice()` includes all orders |
| App crashes on startup | Run `flutter clean && flutter pub get` |
| No migration message | Old history didn't exist (normal) |
| Data disappeared | Did you call `clearHistory()`? Check SharedPreferences |

---

## File Locations

```
Core Models:
lib/features/home/widgets/order_model.dart
lib/features/home/widgets/session_model.dart

Storage Service:
lib/core/utils/session_prefs.dart

Main Entry:
lib/main.dart

Documentation:
HISTORY_SYSTEM_REFACTORING.md
IMPLEMENTATION_SUMMARY.md
DATA_FLOW_DIAGRAM.md
VALIDATION_CHECKLIST.md
history_examples.dart
integration_guide.dart
```

---

## Testing Quick Commands

### Test Save
```dart
final session = SessionModel(
  start: DateTime.now().millisecondsSinceEpoch,
  type: 'playstation',
  duration: 3600000,
  index: 1,
  price: 5.0,
  name: 'PS-01',
  orders: [],
);
await SharedPrefService.saveToHistory(session);
```

### Test Load
```dart
final history = SharedPrefService.getHistory();
print('Sessions: ${history.length}');
```

### Test Clear
```dart
await SharedPrefService.clearHistory();
```

---

## Time Conversions

```dart
// Duration to milliseconds
Duration(hours: 1).inMilliseconds        // 3600000
Duration(minutes: 30).inMilliseconds      // 1800000
Duration(seconds: 60).inMilliseconds      // 60000

// Milliseconds to Duration
Duration(milliseconds: 3600000).inHours   // 1

// Current timestamp
DateTime.now().millisecondsSinceEpoch     // 1715423456789
```

---

## JSON Format Reference

```json
{
  "start": 1715423456789,
  "type": "playstation",
  "duration": 3600000,
  "index": 1,
  "price": 5.0,
  "name": "PS-01",
  "orders": [
    {
      "name": "Pepsi",
      "price": 2.5,
      "note": "Large"
    }
  ],
  "notes": "Great session!"
}
```

---

## One-Liners

```dart
// Get total money made today
double today = SharedPrefService.getTotalEarnings();

// Get all sessions
List<SessionModel> all = SharedPrefService.getHistory();

// Get last 5 sessions
List<SessionModel> recent = SharedPrefService.getRecentSessions(5);

// Total price with extras
double total = session.getTotalPrice();

// Just the extras
double extras = session.getExtrasTotal();

// Number of orders
int orderCount = session.orders.length;
```

---

## Important Notes

⚠️ **Always await** async methods:
```dart
// ❌ Wrong
SharedPrefService.saveToHistory(session);

// ✅ Correct
await SharedPrefService.saveToHistory(session);
```

⚠️ **Check for null** optional fields:
```dart
if (session.notes != null) {
  print(session.notes);
}
```

⚠️ **Wrap in try-catch** for reliability:
```dart
try {
  final history = SharedPrefService.getHistory();
  // Process history
} catch (e) {
  print('Error: $e');
}
```

---

## Status Check

✅ Code Updated  
✅ Models Ready  
✅ SharedPreferences Refactored  
✅ Migration Implemented  
✅ Documentation Complete  

**Ready to Use!** 🚀

