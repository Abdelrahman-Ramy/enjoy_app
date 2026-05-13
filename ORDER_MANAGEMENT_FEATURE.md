## 🎮 Order Management Feature - Complete Implementation Guide

### Overview
This feature allows users to add extra orders/products (like Pepsi, Chips, Coffee) to a running PlayStation session and dynamically calculates the total price including both session price and extras.

---

## 📁 Files Created/Modified

### New Files Created:

#### 1. **OrderModel** - [lib/features/home/widgets/order_model.dart](lib/features/home/widgets/order_model.dart)
   - Represents a single product order
   - Contains: `name`, `price`, `note` (optional)
   - Methods:
     - `toStorageString()` - Convert to string for SharedPreferences
     - `fromStorageString()` - Parse from storage string
     - `copyWith()` - Create a copy with optional field changes

#### 2. **AddOrderBottomSheet** - [lib/features/home/widgets/add_order_bottom_sheet.dart](lib/features/home/widgets/add_order_bottom_sheet.dart)
   - Bottom sheet UI for adding new orders
   - Form inputs:
     - Product name (required)
     - Price (required, validates for valid number)
     - Note (optional)
   - Validation and error handling
   - Callbacks to parent widget when order is added

#### 3. **OrdersList Widget** - [lib/features/home/widgets/orders_list_widget.dart](lib/features/home/widgets/orders_list_widget.dart)
   - Displays list of added orders
   - Shows product name, price, and optional note
   - Delete button to remove individual orders
   - Handles `onRemoveOrder` callback

#### 4. **PriceBreakdownWidget** - [lib/features/home/widgets/price_breakdown_widget.dart](lib/features/home/widgets/price_breakdown_widget.dart)
   - Displays price calculation breakdown:
     - Session price (calculated from timer)
     - Extras total (sum of all orders)
     - Final total (session + extras)
   - Only shows extras/divider if there are orders

### Modified Files:

#### 1. **SessionModel** - [lib/features/home/widgets/session_model.dart](lib/features/home/widgets/session_model.dart)
   - Added:
     - `List<OrderModel> orders` field
     - `getTotalPrice()` method - returns session price + extras total
     - `getExtrasTotal()` method - returns sum of order prices
     - `copyWith()` method for creating copies with field changes

#### 2. **SharedPrefService** - [lib/core/utils/session_prefs.dart](lib/core/utils/session_prefs.dart)
   - Updated `saveSession()` to include `orders` parameter
   - Added `_saveOrders()` helper - saves orders as concatenated string
   - Added `_getOrders()` helper - retrieves and parses orders
   - Updated `getSession()` to load orders from storage
   - Updated `clearSession()` to clear orders
   - Updated `saveToHistory()` to include orders in history
   - Updated `getHistory()` to parse orders from history

#### 3. **PlaystationCard** - [lib/features/home/views/playstation_card.dart](lib/features/home/views/playstation_card.dart)
   - **State Changes:**
     - Added `List<OrderModel> orders = []` to state
   
   - **New Methods:**
     - `_addOrder(OrderModel)` - Adds order and saves session
     - `_removeOrder(int index)` - Removes order by index and saves
     - `_showAddOrderSheet()` - Shows bottom sheet for adding order
   
   - **Updated Methods:**
     - `saveSession()` - Now passes `orders` to SharedPrefService
     - `loadSession()` - Now loads `orders` from saved session
     - Timer auto-end logic - Now includes orders when saving to history
     - "END SECTION" logic - Now includes orders in final session
   
   - **UI Changes:**
     - Dynamic card height based on number of orders
     - Replaced `PriceCalculator` with `PriceBreakdownWidget`
     - Added "+ Add Order" button to show bottom sheet
     - Added "Added Orders" section with `OrdersList` widget
     - All orders cleared when session ends

---

## 🔄 Data Flow

### Adding an Order:
```
User taps "+ Add Order"
  ↓
AddOrderBottomSheet opens
  ↓
User fills: name, price, note
  ↓
Taps "ADD ORDER" button
  ↓
_addOrder() called with OrderModel
  ↓
Order added to list: orders.add(order)
  ↓
saveSession() called
  ↓
SharedPrefService saves orders as string
```

### Saving to History:
```
Session ends (manually or auto)
  ↓
Final session created with current orders
  ↓
saveToHistory() called
  ↓
Orders serialized and stored with history
  ↓
Session cleared, orders list reset
```

### Loading Existing Session:
```
App launches
  ↓
loadSession() called
  ↓
Session fetched from SharedPreferences
  ↓
Orders loaded via _getOrders()
  ↓
Order list populated, UI updates
```

---

## 💾 Storage Format

### Orders Storage:
**Format:** `"Product Name|Price|Note||Product 2|Price2|"`

**Example:**
```
"Pepsi|2.5|Large||Coffee|3.0|No sugar||Chips|1.5|"
```

**In SharedPreferences:**
```
Key: "category_device_orders"
Value: "Pepsi|2.5|Large||Coffee|3.0|No sugar||Chips|1.5|"
```

### History Storage:
**Format:** `"timestamp,type,duration,index,sessionPrice,name,ordersString"`

**Example:**
```
"1620000000,open,30,2,25.50,PS #1,Pepsi|2.5|Large||Coffee|3.0|No sugar"
```

---

## 🎨 UI Components Hierarchy

```
PlaystationCard (running state)
├── Timer Display
├── PriceBreakdownWidget
│   ├── Session Price: $X.XX
│   ├── Extras Total: $Y.YY (if > 0)
│   └── Final Total: $Z.ZZ
├── Added Orders Section (if exists)
│   └── OrdersList
│       ├── Order Item 1
│       │   ├── Name
│       │   ├── Note (if exists)
│       │   ├── Price
│       │   └── Delete Button
│       ├── Order Item 2
│       └── ...
├── "+ Add Order" Button
│   └── Opens AddOrderBottomSheet
│       ├── Product Name Input
│       ├── Price Input
│       ├── Note Input
│       └── Action Buttons
└── "END SECTION" Button
```

---

## 📋 Quick Reference: Method Usage

### Add an Order
```dart
_addOrder(
  OrderModel(
    name: 'Pepsi',
    price: 2.50,
    note: 'Large',
  ),
);
```

### Remove an Order
```dart
_removeOrder(0); // Removes first order
```

### Show Add Order Sheet
```dart
_showAddOrderSheet();
```

### Get Total Price (in widget)
```dart
final sessionPrice = calculatePrice(elapsed, getPricePerHour());
final extrasTotal = orders.fold<double>(0, (sum, o) => sum + o.price);
final totalPrice = sessionPrice + extrasTotal;
```

### Access Orders in Session
```dart
final session = SharedPrefService.getSession(keyPrefix);
print(session.orders); // List<OrderModel>
print(session.getTotalPrice()); // Total with extras
print(session.getExtrasTotal()); // Only extras
```

---

## ✅ Feature Checklist

- [x] OrderModel class with serialization
- [x] AddOrderBottomSheet with form validation
- [x] OrdersList widget to display orders
- [x] PriceBreakdownWidget for price calculation display
- [x] Add order to running session
- [x] Remove order from session
- [x] Dynamic price calculation
- [x] Persist orders in SharedPreferences
- [x] Include orders in history
- [x] Load orders when session resumes
- [x] Clear orders when session ends
- [x] StatefulWidget implementation
- [x] Clean, beginner-friendly code
- [x] Proper error handling

---

## 🚀 Usage Example

```dart
// Orders automatically integrated into PlaystationCard
PlaystationCard(
  deviceNumber: '1',
  cardName: 'PS Corner',
  category: Categories.playstation,
);

// User flow:
// 1. Starts session
// 2. Timer runs, shows time elapsed
// 3. Taps "+ Add Order"
// 4. Adds: Pepsi ($2.50) + Coffee ($3.00)
// 5. UI updates showing:
//    - Session Price: $X.XX
//    - Extras Total: $5.50
//    - Final Total: $X.XX + $5.50
// 6. Ends session
// 7. History saved with all order details
```

---

## 🔧 Customization Tips

### Change Order Limit
Add validation in `_addOrder()`:
```dart
if (orders.length >= 10) {
  _showErrorSnackBar('Maximum 10 orders per session');
  return;
}
```

### Add Quantity to Orders
Extend OrderModel:
```dart
class OrderModel {
  final String name;
  final double price;
  final int quantity; // NEW
  final String? note;
}
```

### Pre-defined Menu Items
Create a list of common items in AddOrderBottomSheet:
```dart
final commonItems = ['Pepsi', 'Coffee', 'Chips', 'Water'];
// Add dropdown to select from list
```

### Order History Statistics
In HistoryView, calculate totals from orders:
```dart
double calculateOrdersRevenue(SessionModel session) {
  return session.getExtrasTotal();
}
```

---

## 📝 Notes

- Orders are stored per session using `SharedPreferences`
- Each order has independent serialization
- Price validation ensures valid decimal numbers
- UI automatically resizes based on order count
- All orders cleared when session ends
- Orders persist if app is backgrounded during session
- History includes all order details for records

---

Generated: May 11, 2026
Version: 1.0
Status: Ready for Production ✅
