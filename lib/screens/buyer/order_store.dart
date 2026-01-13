import 'package:flutter/foundation.dart';

class UnitSelection {
  final Set<String> toppings;
  final String? mix;

  UnitSelection({Set<String>? toppings, this.mix}) : toppings = toppings ?? {};
}

class OrderLine {
  final String name;
  final double basePrice;
  final List<UnitSelection> units;

  OrderLine({
    required this.name,
    required this.basePrice,
    required this.units,
  });

  int get qty => units.length;

  double get total {
    double sum = 0.0;
    for (final u in units) {
      sum += basePrice + (u.toppings.length * 0.50);
    }
    return sum;
  }
}

class Order {
  final String orderId;
  String status; // pending, preparing, ready, completed
  final List<OrderLine> items;
  final DateTime createdAt;

  Order({
    required this.orderId,
    required this.status,
    required this.items,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  double get total => items.fold(0.0, (sum, i) => sum + i.total);
}

class OrderStore extends ChangeNotifier {
  final List<OrderLine> cart = [];

  /// history simpan "Order" (bukan OrderLine)
  final List<Order> history = [];

  void addToCart(OrderLine line) {
    cart.add(line);
    notifyListeners();
  }

  void addToHistory(Order order) {
  history.insert(0, order);
  notifyListeners();
}


  void removeFromCart(int index) {
    if (index < 0 || index >= cart.length) return;
    cart.removeAt(index);
    notifyListeners();
  }

  double get cartTotal => cart.fold(0.0, (sum, o) => sum + o.total);

  /// ✅ clear cart (untuk checkout screen / supabase flow)
  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  /// checkout return orderId supaya receipt boleh terus track (LOCAL mode)
  String? checkout() {
    if (cart.isEmpty) return null;

    final id = _newOrderId();
    final order = Order(
      orderId: id,
      status: "pending",
      items: List<OrderLine>.from(cart),
    );

    history.insert(0, order);
    cart.clear();
    notifyListeners();
    return id;
  }

  Order? findInHistory(String orderId) {
    try {
      return history.firstWhere((o) => o.orderId == orderId);
    } catch (_) {
      return null;
    }
  }

  /// untuk staff update status (demo / nanti supabase)
  void updateStatus(String orderId, String newStatus) {
    final order = findInHistory(orderId);
    if (order == null) return;
    order.status = newStatus;
    notifyListeners();
  }

  void setOrderStatus(String orderId, String newStatus) {
  final order = findInHistory(orderId);
  if (order == null) return;
  order.status = newStatus;
  notifyListeners();
  }


  String _newOrderId() {
    final n = DateTime.now().millisecondsSinceEpoch % 10000;
    return "W${n.toString().padLeft(4, '0')}";
  }
}

// Global instance
final orderStore = OrderStore();
