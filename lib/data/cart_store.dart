import 'package:flutter/foundation.dart';

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


class CartStore extends ChangeNotifier {
  final List<OrderItem> _currentCart = [];
  final List<List<OrderItem>> _history = [];

  List<OrderItem> get currentCart => List.unmodifiable(_currentCart);
  List<List<OrderItem>> get history => List.unmodifiable(_history);

  void addToCart(OrderItem item) {
    _currentCart.add(item);
    notifyListeners();
  }

  void checkout() {
    if (_currentCart.isEmpty) return;
    _history.add(List<OrderItem>.from(_currentCart));
    _currentCart.clear();
    notifyListeners();
  }

  double get totalPrice =>
      _currentCart.fold(0.0, (sum, item) => sum + item.price * item.quantity);
}