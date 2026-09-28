class Product {
  // =========================
  // ATTRIBUTE / PROPERTY
  // =========================

  String _name;
  String _imageUrl;
  double _price;
  double _rating;
  int _sold;
  String _category;
  int _stock;
  String _description;

  // =========================
  // CONSTRUCTOR
  // =========================

  Product({
    required String name,
    required String imageUrl,
    required double price,
    required double rating,
    required int sold,
    required String category,
    required int stock,
    required String description,
  })  : _name = name,
        _imageUrl = imageUrl,
        _price = price,
        _rating = rating,
        _sold = sold,
        _category = category,
        _stock = stock,
        _description = description;

  // =========================
  // GETTER
  // =========================

  String get name => _name;

  String get imageUrl => _imageUrl;

  double get price => _price;

  double get rating => _rating;

  int get sold => _sold;

  String get category => _category;

  int get stock => _stock;

  String get description => _description;

  // =========================
  // SETTER
  // =========================

  set name(String value) {
    if (value.trim().isNotEmpty) {
      _name = value;
    }
  }

  set imageUrl(String value) {
    _imageUrl = value;
  }

  set price(double value) {
    if (value >= 0) {
      _price = value;
    }
  }

  set rating(double value) {
    if (value >= 0 && value <= 5) {
      _rating = value;
    }
  }

  set sold(int value) {
    if (value >= 0) {
      _sold = value;
    }
  }

  set category(String value) {
    if (value.trim().isNotEmpty) {
      _category = value;
    }
  }

  set stock(int value) {
    if (value >= 0) {
      _stock = value;
    }
  }

  set description(String value) {
    _description = value;
  }

  // =========================
  // FUNCTION / METHOD
  // =========================

  bool isAvailable() {
    return _stock > 0;
  }

  void addStock(int amount) {
    if (amount > 0) {
      _stock += amount;
    }
  }

  bool reduceStock(int amount) {
    if (amount > 0 && amount <= _stock) {
      _stock -= amount;
      return true;
    }

    return false;
  }

  void addSold(int amount) {
    if (amount > 0) {
      _sold += amount;
    }
  }

  String getStockStatus() {
    if (_stock <= 0) {
      return 'Out of Stock';
    }

    if (_stock <= 5) {
      return 'Almost Sold Out';
    }

    return 'Available';
  }
}