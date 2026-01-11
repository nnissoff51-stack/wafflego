import 'package:flutter/material.dart';

// Model untuk satu order item
class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final List<String> toppings;
  final String? mix;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.toppings = const [],
    this.mix,
  });

  double get total => price * quantity;

  String get summary {
    final t = toppings.isEmpty ? "-" : toppings.join(", ");
    final m = mix ?? "-";
    return "Topping: $t | Mix: $m";
  }
}
// Store untuk cart + history
class OrderStore extends ChangeNotifier {
  // Current cart
  final List<OrderItem> _currentCart = [];
  List<OrderItem> get currentCart => List.unmodifiable(_currentCart);

  // Completed orders
  final List<List<OrderItem>> _history = [];
  List<List<OrderItem>> get history => List.unmodifiable(_history);

  // Tambah item ke cart
  void addToCart(OrderItem item) {
    _currentCart.add(item);
    notifyListeners();
  }

  // Checkout: pindah semua item ke history
  void checkout() {
    if (_currentCart.isEmpty) return;
    _history.add(List<OrderItem>.from(_currentCart));
    _currentCart.clear();
    notifyListeners();
  }

  // Total harga
  double get totalPrice =>
      _currentCart.fold(0, (sum, item) => sum + item.price * item.quantity);
}