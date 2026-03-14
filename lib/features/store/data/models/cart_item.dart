import 'package:flutter/foundation.dart';

@immutable
class CartItem {
  final String id;
  final String name;
  final String price;
  final String emoji;
  final int quantity;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? price,
    String? emoji,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      emoji: emoji ?? this.emoji,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          quantity == other.quantity;

  @override
  int get hashCode => id.hashCode ^ quantity.hashCode;
}
