import 'package:enjoy_app/features/home/widgets/order_model.dart';

class SessionModel {
  final int start;
  final String type;
  final int duration;
  final int index;
  final double price;
  final String name;
  final List<OrderModel> orders;
  final String? notes; // NEW: Optional session notes
  final String? psGameType; // NEW: PlayStation game type (single/multi)

  SessionModel({
    required this.start,
    required this.type,
    required this.duration,
    required this.index,
    required this.price,
    required this.name,
    this.orders = const [],
    this.notes, // NEW: Optional notes field
    this.psGameType, // NEW: PlayStation game type field
  });

  /// Get total price (already includes orders in the stored price)
  /// Note: 'price' field stores the complete total (session base + orders)
  double getTotalPrice() {
    return price;
  }

  /// Get total price of all orders/extras
  double getExtrasTotal() {
    double total = 0.0;
    for (final order in orders) {
      total += order.price;
    }
    return total;
  }

  /// Convert SessionModel to JSON Map
  /// Example output: {
  ///   "start": 1234567890,
  ///   "type": "playstation",
  ///   "duration": 3600,
  ///   "index": 1,
  ///   "price": 5.0,
  ///   "name": "PS-01",
  ///   "orders": [{"name": "Pepsi", "price": 2.5, "note": null}],
  ///   "notes": "Fun session!"
  /// }
  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'type': type,
      'duration': duration,
      'index': index,
      'price': price,
      'name': name,
      'orders': orders.map((order) => order.toJson()).toList(),
      'notes': notes,
      'psGameType': psGameType,
    };
  }

  /// Create SessionModel from JSON Map
  /// Example input: {
  ///   "start": 1234567890,
  ///   "type": "playstation",
  ///   "duration": 3600,
  ///   "index": 1,
  ///   "price": 5.0,
  ///   "name": "PS-01",
  ///   "orders": [{"name": "Pepsi", "price": 2.5, "note": null}],
  ///   "notes": "Fun session!"
  /// }
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse orders list safely
      final ordersList = <OrderModel>[];
      if (json['orders'] is List) {
        for (final order in json['orders'] as List) {
          if (order is Map<String, dynamic>) {
            ordersList.add(OrderModel.fromJson(order));
          }
        }
      }

      return SessionModel(
        start: json['start'] as int? ?? 0,
        type: json['type'] as String? ?? 'open',
        duration: json['duration'] as int? ?? 0,
        index: json['index'] as int? ?? -1,
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        name: json['name'] as String? ?? 'Unknown',
        orders: ordersList,
        notes: json['notes'] as String?,
        psGameType: json['psGameType'] as String?,
      );
    } catch (e) {
      // Fallback for corrupted data
      print('Error parsing SessionModel from JSON: $e');
      return SessionModel(
        start: 0,
        type: 'open',
        duration: 0,
        index: -1,
        price: 0.0,
        name: 'Unknown',
        orders: [],
        notes: null,
        psGameType: null,
      );
    }
  }

  /// Create a copy with optional field changes
  SessionModel copyWith({
    int? start,
    String? type,
    int? duration,
    int? index,
    double? price,
    String? name,
    List<OrderModel>? orders,
    String? notes,
  }) {
    return SessionModel(
      start: start ?? this.start,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      index: index ?? this.index,
      price: price ?? this.price,
      name: name ?? this.name,
      orders: orders ?? this.orders,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() =>
      'SessionModel(start: $start, type: $type, duration: $duration, index: $index, price: $price, name: $name, orders: ${orders.length}, notes: $notes)';
}
