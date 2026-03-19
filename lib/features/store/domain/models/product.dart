import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String price;
  final String emoji;
  final String category;
  final bool isNew;
  final bool hasGoldBorder;
  final List<String> gradientHexColors;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
    required this.category,
    this.isNew = false,
    this.hasGoldBorder = false,
    this.gradientHexColors = const ['0xFF1A1A1A', '0xFF0F0F0F'],
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    return Product(
      id: doc.id,
      name: data['name']?.toString() ?? '',
      price: data['price']?.toString() ?? '£0',
      emoji: data['emoji']?.toString() ?? '📦',
      category: data['category']?.toString() ?? 'ACCESSORIES',
      isNew: data['isNew'] as bool? ?? false,
      hasGoldBorder: data['hasGoldBorder'] as bool? ?? false,
      gradientHexColors: List<String>.from(data['gradientHexColors'] ?? ['0xFF1A1A1A', '0xFF0F0F0F']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'emoji': emoji,
      'category': category,
      'isNew': isNew,
      'hasGoldBorder': hasGoldBorder,
      'gradientHexColors': gradientHexColors,
    };
  }
}
