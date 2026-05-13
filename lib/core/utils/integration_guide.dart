/// =============================================================================
/// PRACTICAL INTEGRATION GUIDE - WHERE TO ADD CODE
/// =============================================================================
///
/// This file shows EXACTLY where to add the new history system code
/// to your existing widgets. Copy and paste these snippets.
///
/// =============================================================================

// =============================================================================
// 🔧 INTEGRATION POINT 1: playstation_card.dart or status_widget.dart
// When user ends a session
// =============================================================================
//
// Location: In the button/action that ends the session
//
// BEFORE (Pseudocode):
// Button -> onTap -> showConfirmDialog -> endSession()
//
// AFTER (Updated):
//
// import 'package:enjoy_app/features/home/widgets/session_model.dart';
// import 'package:enjoy_app/features/home/widgets/order_model.dart';
// import 'package:enjoy_app/core/utils/session_prefs.dart';
//
// void endSessionAndSaveToHistory({
//   required String deviceName,
//   required String deviceType,
//   required int deviceIndex,
//   required Duration sessionDuration,
//   required double basePrice,
//   required List<OrderModel> orders,
// }) async {
//   // Create session with all data
//   final session = SessionModel(
//     start: DateTime.now().millisecondsSinceEpoch - sessionDuration.inMilliseconds,
//     type: deviceType, // 'playstation', 'ping', or 'billiards'
//     duration: sessionDuration.inMilliseconds,
//     index: deviceIndex,
//     price: basePrice,
//     name: deviceName,
//     orders: orders,
//     notes: null, // optional: add user notes if available
//   );
//
//   // Save to history
//   await SharedPrefService.saveToHistory(session);
//
//   // Show summary dialog
//   showSummaryDialog(context, sessionDuration);
// }

// =============================================================================
// 🔧 INTEGRATION POINT 2: add_order_bottom_sheet.dart
// When user adds an order/product
// =============================================================================
//
// Location: _AddOrderBottomSheetState._addOrder() method
//
// CURRENT CODE (around line 50):
// void _addOrder() {
//   if (productNameController.text.trim().isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Product name is required')),
//     );
//     return;
//   }
//
//   final price = double.tryParse(priceController.text) ?? 0.0;
//   final note = noteController.text.trim();
//
//   // CREATE ORDER (New code to add)
//   final order = OrderModel(
//     name: productNameController.text.trim(),
//     price: price,
//     note: note.isNotEmpty ? note : null,
//   );
//
//   // Pass to parent widget
//   widget.onAddOrder(order);
//
//   // Clear fields
//   productNameController.clear();
//   priceController.clear();
//   noteController.clear();
//
//   // Close bottom sheet
//   Navigator.pop(context);
// }

// =============================================================================
// 🔧 INTEGRATION POINT 3: history_view.dart
// Loading and displaying history
// =============================================================================
//
// Location: _HistoryViewState class
//
// CURRENT CODE (around line 20):
// class _HistoryViewState extends State<HistoryView> {
//   List<SessionModel> history = [];
//   String? selectedDate;
//
//   @override
//   void initState() {
//     super.initState();
//     initializeDateFormatting('ar');
//     loadHistory(); // NEW: This method below
//   }
//
//   // NEW METHOD TO ADD:
//   void loadHistory() {
//     // Load history using new JSON system (safe, handles errors)
//     history = SharedPrefService.getHistory();
//     setState(() {});
//   }
//
//   // Replace old loading logic with this
// }

// =============================================================================
// 🔧 INTEGRATION POINT 4: settings_view.dart
// Clear history button
// =============================================================================
//
// Location: Settings screen button (already mostly there)
//
// CURRENT CODE (around line 50):
// ElevatedButton(
//   style: ElevatedButton.styleFrom(
//     backgroundColor: AppColors.redColor,
//   ),
//   onPressed: () async {
//     // NEW: Use updated method
//     await SharedPrefService.clearHistory();
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("History Cleared Successfully")),
//     );
//   },
//   child: Text('Clear History'),
// )

// =============================================================================
// 🔧 INTEGRATION POINT 5: New file to create - session_manager.dart
// (OPTIONAL) Centralized session management
// =============================================================================
//
// Location: Create lib/core/utils/session_manager.dart
//
// import 'package:enjoy_app/features/home/widgets/session_model.dart';
// import 'package:enjoy_app/features/home/widgets/order_model.dart';
// import 'package:enjoy_app/core/utils/session_prefs.dart';
//
// /// Centralized session management helper
// /// Makes saving and loading sessions easier
// class SessionManager {
//   static final SessionManager _instance = SessionManager._internal();
//
//   factory SessionManager() {
//     return _instance;
//   }
//
//   SessionManager._internal();
//
//   /// Start a new session
//   Future<void> startSession({
//     required String deviceName,
//     required String deviceType,
//     required int deviceIndex,
//   }) async {
//     await SharedPrefService.saveSession(
//       key: 'current_session',
//       start: DateTime.now().millisecondsSinceEpoch,
//       type: deviceType,
//       duration: 0,
//       index: deviceIndex,
//       price: 0.0,
//       name: deviceName,
//       orders: [],
//     );
//   }
//
//   /// End session and save to history
//   Future<void> endSession({
//     required Duration duration,
//     required double price,
//     required List<OrderModel> orders,
//     String? notes,
//   }) async {
//     final current = SharedPrefService.getSession('current_session');
//     if (current == null) return;
//
//     final session = current.copyWith(
//       duration: duration.inMilliseconds,
//       price: price,
//       orders: orders,
//       notes: notes,
//     );
//
//     await SharedPrefService.saveToHistory(session);
//     await SharedPrefService.clearSession('current_session');
//   }
//
//   /// Add order to current session
//   Future<void> addOrderToSession(OrderModel order) async {
//     final current = SharedPrefService.getSession('current_session');
//     if (current == null) return;
//
//     final updated = current.copyWith(
//       orders: [...current.orders, order],
//     );
//
//     await SharedPrefService.saveSession(
//       key: 'current_session',
//       start: updated.start,
//       type: updated.type,
//       duration: updated.duration,
//       index: updated.index,
//       price: updated.price,
//       name: updated.name,
//       orders: updated.orders,
//       notes: updated.notes,
//     );
//   }
// }

// =============================================================================
// 📋 STEP-BY-STEP IMPLEMENTATION
// =============================================================================
//
// Step 1: Files Already Updated ✅
// ✓ OrderModel - toJson/fromJson added
// ✓ SessionModel - toJson/fromJson + notes added
// ✓ SharedPrefService - Complete JSON refactor
// ✓ main.dart - Migration call added
//
// Step 2: Test App (Do This First)
// 1. Run app (migration happens automatically)
// 2. Check no crashes on startup
// 3. Create a test session
// 4. Verify it saves to SharedPreferences
//
// Step 3: Integrate Save Code
// 1. Find where sessions END in your code
// 2. Create SessionModel with all data
// 3. Call SharedPrefService.saveToHistory(session)
//
// Step 4: Test Loading
// 1. Open history screen
// 2. Verify old history migrated (if any)
// 3. Verify new sessions appear
// 4. Check totals and prices are correct
//
// Step 5: Add Orders Support (if needed)
// 1. When user adds order: create OrderModel
// 2. Save it to session.orders list
// 3. When session ends, pass orders to SessionModel
//
// Step 6: Final Testing
// 1. Create multiple sessions
// 2. Add orders to some sessions
// 3. Add notes to some sessions
// 4. Check history displays everything
// 5. Test clear history
// 6. Done! 🎉

// =============================================================================
// ⚠️ COMMON MISTAKES TO AVOID
// =============================================================================
//
// ❌ DON'T: forget to import SessionModel and OrderModel
// ✅ DO: import 'package:enjoy_app/features/home/widgets/session_model.dart';
//
// ❌ DON'T: use old split(",") or join("|") methods
// ✅ DO: use jsonEncode/jsonDecode in SharedPrefService
//
// ❌ DON'T: save history without creating SessionModel first
// ✅ DO: always create SessionModel, then call saveToHistory(session)
//
// ❌ DON'T: assume getHistory() will never fail
// ✅ DO: wrap in try-catch or check if empty
//
// ❌ DON'T: forget to include orders when saving session
// ✅ DO: pass all orders list to SessionModel constructor
//
// ❌ DON'T: manually parse JSON
// ✅ DO: use SessionModel.fromJson() and OrderModel.fromJson()

// =============================================================================
// 🧪 TESTING CHECKLIST
// =============================================================================
//
// [ ] App starts without crashes
// [ ] Migration completes (check console)
// [ ] Can create new session
// [ ] Can add orders to session
// [ ] Can end session and save
// [ ] History screen loads and shows data
// [ ] Prices calculate correctly
// [ ] Session totals include extras
// [ ] Can clear history
// [ ] Old data migrated properly (if any existed)
// [ ] No corrupted data errors
// [ ] App continues on bad data (doesn't crash)

// =============================================================================
// 📞 QUICK REFERENCE
// =============================================================================
//
// To save session:
// await SharedPrefService.saveToHistory(sessionModel);
//
// To load history:
// List<SessionModel> history = SharedPrefService.getHistory();
//
// To get totals:
// double total = SharedPrefService.getTotalEarnings();
//
// To clear:
// await SharedPrefService.clearHistory();
//
// To add to session:
// final session = session.copyWith(orders: [..., newOrder]);

// =============================================================================
