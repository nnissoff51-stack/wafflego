import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CartStore extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void add(Map<String, dynamic> item) {
    _items.add(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
