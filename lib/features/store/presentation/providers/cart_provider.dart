import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cart_item.dart';

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addItem(CartItem item) {
    final existingIndex = state.indexWhere((i) => i.id == item.id);
    
    if (existingIndex >= 0) {
      state = [
        for (final (index, i) in state.indexed)
          if (index == existingIndex)
            i.copyWith(quantity: i.quantity + item.quantity)
          else
            i,
      ];
    } else {
      state = [...state, item];
    }
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void decrementQuantity(String id) {
    final existingIndex = state.indexWhere((i) => i.id == id);
    if (existingIndex >= 0) {
      final item = state[existingIndex];
      if (item.quantity > 1) {
        state = [
          for (final (index, i) in state.indexed)
            if (index == existingIndex)
              i.copyWith(quantity: i.quantity - 1)
            else
              i,
        ];
      } else {
        removeItem(id);
      }
    }
  }

  void clear() {
    state = [];
  }
}

final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (total, item) => total + item.quantity);
});
