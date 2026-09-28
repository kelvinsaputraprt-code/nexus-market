import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartManager extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  void addToCart(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get itemCount => _items.length;

  double get totalPrice {
    double total = 0;

    for (final product in _items) {
      total += product.price;
    }

    return total;
  }
}

final CartManager cartManager = CartManager();