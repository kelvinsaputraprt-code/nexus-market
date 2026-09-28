import 'package:flutter/foundation.dart';
import '../models/product.dart';

class WishlistManager extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  bool contains(Product product) {
    return _items.any(
      (item) => item.name == product.name,
    );
  }

  void toggle(Product product) {
    final index = _items.indexWhere(
      (item) => item.name == product.name,
    );

    if (index >= 0) {
      _items.removeAt(index);
    } else {
      _items.add(product);
    }

    notifyListeners();
  }

  void remove(Product product) {
    _items.removeWhere(
      (item) => item.name == product.name,
    );

    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

final WishlistManager wishlistManager = WishlistManager();