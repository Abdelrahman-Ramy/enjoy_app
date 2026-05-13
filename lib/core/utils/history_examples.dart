/// =============================================================================
/// HISTORY SYSTEM - EXAMPLES & USAGE GUIDE
/// =============================================================================
///
/// This file demonstrates how to use the new JSON-based history system.
/// DO NOT import this file - it's for documentation purposes only.
/// Copy code examples directly into your widgets/screens.
///
/// =============================================================================

// ============= EXAMPLE 1: SAVE A NEW SESSION TO HISTORY =============
//
// Location: In any widget/screen where you end a session
// (e.g., in show_dialog.dart or a session completion handler)
//
// void saveSessionToHistory() {
//   final session = SessionModel(
//     start: DateTime.now().millisecondsSinceEpoch,
//     type: 'playstation', // 'playstation', 'ping', 'billiards'
//     duration: 3600, // in milliseconds
//     index: 1,
//     price: 5.0, // base price
//     name: 'PS-01', // device name
//     orders: [
//       OrderModel(name: 'Pepsi', price: 2.5, note: 'Large'),
//       OrderModel(name: 'Snacks', price: 1.5),
//     ],
//     notes: 'Great session!', // optional
//   );
//
//   await SharedPrefService.saveToHistory(session);
// }

// ============= EXAMPLE 2: LOAD AND DISPLAY HISTORY =============
//
// Location: In history_view.dart or similar
//
// void loadHistory() {
//   final history = SharedPrefService.getHistory();
//   
//   for (final session in history) {
//     print('Session: ${session.name}');
//     print('Base Price: ${session.price}');
//     print('Extras Total: ${session.getExtrasTotal()}');
//     print('Total Price: ${session.getTotalPrice()}');
//     print('Orders: ${session.orders.length}');
//     if (session.notes != null) {
//       print('Notes: ${session.notes}');
//     }
//   }
// }

// ============= EXAMPLE 3: SAVE CURRENT SESSION (IN PROGRESS) =============
//
// Location: When starting a session or adding orders
//
// void saveCurrentSession(List<OrderModel> orders) {
//   await SharedPrefService.saveSession(
//     key: 'current_session',
//     start: DateTime.now().millisecondsSinceEpoch,
//     type: 'playstation',
//     duration: 1800, // 30 minutes elapsed
//     index: 1,
//     price: 2.5,
//     name: 'PS-01',
//     orders: orders,
//     notes: 'In progress...', // optional
//   );
// }

// ============= EXAMPLE 4: RETRIEVE CURRENT SESSION =============
//
// Location: When you need to load a session in progress
//
// void loadCurrentSession() {
//   final session = SharedPrefService.getSession('current_session');
//   
//   if (session != null) {
//     print('Current Session: ${session.name}');
//     print('Elapsed: ${session.duration} ms');
//     print('Current Total: ${session.getTotalPrice()}');
//   }
// }

// ============= EXAMPLE 5: GET RECENT SESSIONS =============
//
// Location: In dashboard or home view
//
// void showRecentActivity() {
//   final recent = SharedPrefService.getRecentSessions(10);
//   
//   for (final session in recent) {
//     print('${session.name}: \$${session.getTotalPrice()}');
//   }
// }

// ============= EXAMPLE 6: GET TOTAL EARNINGS =============
//
// Location: In earnings/statistics view
//
// void showTotalEarnings() {
//   final total = SharedPrefService.getTotalEarnings();
//   print('Total Earnings: \$$total');
// }

// ============= EXAMPLE 7: CLEAR ALL HISTORY =============
//
// Location: In settings_view.dart (already implemented)
//
// onPressed: () async {
//   await SharedPrefService.clearHistory();
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(content: Text("History Cleared Successfully")),
//   );
// }

// ============= EXAMPLE 8: MIGRATE OLD DATA (ONE-TIME) =============
//
// Location: Already called in main.dart - but shown for reference
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SharedPrefService.init();
//   
//   // This safely converts old format to new JSON format
//   await SharedPrefService.migrateOldHistory();
//   
//   runApp(const MyApp());
// }

// ============= EXAMPLE 9: HANDLE CORRUPTED DATA SAFELY =============
//
// Location: Anywhere you load history
//
// List<SessionModel> loadHistoryWithFallback() {
//   try {
//     final history = SharedPrefService.getHistory();
//     if (history.isEmpty) {
//       print('No history found');
//       return [];
//     }
//     return history;
//   } catch (e) {
//     print('Error loading history: $e');
//     // Returns empty list instead of crashing
//     return [];
//   }
// }

// ============= EXAMPLE 10: CREATE ORDER FROM USER INPUT =============
//
// Location: In add_order_bottom_sheet.dart or order_form
//
// void createOrderFromInput() {
//   final productName = productNameController.text.trim();
//   final priceText = priceController.text.trim();
//   final note = noteController.text.trim();
//
//   if (productName.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Product name is required')),
//     );
//     return;
//   }
//
//   final price = double.tryParse(priceText) ?? 0.0;
//
//   final order = OrderModel(
//     name: productName,
//     price: price,
//     note: note.isNotEmpty ? note : null,
//   );
//
//   // Pass to parent widget
//   widget.onAddOrder(order);
// }

// =============================================================================
// JSON STRUCTURE REFERENCE
// =============================================================================
//
// Single OrderModel as JSON:
// {
//   "name": "Pepsi",
//   "price": 2.5,
//   "note": "Large size"
// }
//
// Single SessionModel as JSON:
// {
//   "start": 1715423456789,
//   "type": "playstation",
//   "duration": 3600000,
//   "index": 1,
//   "price": 5.0,
//   "name": "PS-01",
//   "orders": [
//     {
//       "name": "Pepsi",
//       "price": 2.5,
//       "note": "Large"
//     },
//     {
//       "name": "Snacks",
//       "price": 1.5,
//       "note": null
//     }
//   ],
//   "notes": "Great session!"
// }
//
// Full History Array (stored in SharedPreferences):
// [
//   {
//     "start": 1715423456789,
//     "type": "playstation",
//     ...
//   },
//   {
//     "start": 1715423556789,
//     "type": "ping",
//     ...
//   }
// ]
//
// =============================================================================

// =============================================================================
// INTEGRATION CHECKLIST
// =============================================================================
//
// ✓ main.dart - Added migration call (already done)
// ✓ OrderModel - Updated with toJson/fromJson
// ✓ SessionModel - Updated with toJson/fromJson + notes field
// ✓ SharedPrefService - Completely refactored to use JSON
//
// Next Steps:
// 1. ✓ Review all file changes above
// 2. Test app startup (migration runs once)
// 3. Create new session and verify it saves correctly
// 4. Check SharedPreferences to see JSON format
// 5. Load history and verify data integrity
// 6. Clear and reset if needed
//
// =============================================================================

// =============================================================================
// BENEFITS OF NEW SYSTEM
// =============================================================================
//
// ✓ Cleaner Data: JSON format is human-readable and structured
// ✓ Scalable: Easy to add new fields to SessionModel
// ✓ Safer: Better error handling and fallbacks for corrupted data
// ✓ Flexible: Orders are properly nested instead of string-concatenated
// ✓ Debuggable: Can inspect SharedPreferences and see exact JSON
// ✓ Maintainable: No more split(",") and join("|") chaos
// ✓ Future-proof: Adding new session types requires no refactoring
//
// =============================================================================
