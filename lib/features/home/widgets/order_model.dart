/// OrderModel represents a single product order added to a session
///
/// Example:
/// OrderModel(
///   name: 'Pepsi',
///   price: 2.5,
///   note: 'Large size',
/// )
class OrderModel {
  final String name;
  final double price;
  final String? note;

  OrderModel({required this.name, required this.price, this.note});

  /// Convert OrderModel to JSON Map
  /// Example output: {"name": "Pepsi", "price": 2.5, "note": "Large size"}
  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price, 'note': note};
  }

  /// Create OrderModel from JSON Map
  /// Example input: {"name": "Pepsi", "price": 2.5, "note": "Large size"}
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderModel(
        name: json['name'] as String? ?? 'Unknown',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        note: json['note'] as String?,
      );
    } catch (e) {
      // Fallback for corrupted data
      return OrderModel(name: 'Unknown', price: 0.0);
    }
  }

  /// Create a copy of OrderModel with optional field changes
  OrderModel copyWith({String? name, double? price, String? note}) {
    return OrderModel(
      name: name ?? this.name,
      price: price ?? this.price,
      note: note ?? this.note,
    );
  }

  @override
  String toString() => 'OrderModel(name: $name, price: $price, note: $note)';
}
