import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markfc/core/providers/firebase_providers.dart';
import '../../domain/models/product.dart';

class ShopRepository {
  final FirebaseFirestore _firestore;

  ShopRepository(this._firestore);

  Stream<List<Product>> watchProductsByCategory(String category) {
    return _firestore
        .collection('shop')
        .where('category', isEqualTo: category.toUpperCase())
        .snapshots()
        .timeout(const Duration(seconds: 10), onTimeout: (sink) {
          debugPrint('Firestore Connection Timeout: Shop collection');
          sink.addError('Connection Timeout');
        })
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .toList());
  }
}

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ShopRepository(firestore);
});

final kitsStreamProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(shopRepositoryProvider).watchProductsByCategory('MATCH KITS');
});

final accessoriesStreamProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(shopRepositoryProvider).watchProductsByCategory('ACCESSORIES');
});

final trainingWearStreamProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(shopRepositoryProvider).watchProductsByCategory('TRAINING WEAR');
});
