import 'product.dart';

class Order {
  String _orderId;
  DateTime _date;
  String _status;
  List<Product> _products;
  double _shippingCost;

  // =========================================================
  // SHIPPING ADDRESS
  // =========================================================

  String _recipientName;
  String _address;
  String _phone;

  // =========================================================
  // VOUCHER
  // =========================================================

  String? _voucherCode;
  String? _voucherName;
  double _discount;

  // =========================================================
  // PAYMENT METHOD
  // =========================================================

  String _paymentMethod;

  Order({
    required String orderId,
    required DateTime date,
    required String status,
    required List<Product> products,
    required double shippingCost,

    // Alamat
    String recipientName = '',
    String address = '',
    String phone = '',

    // Voucher
    String? voucherCode,
    String? voucherName,
    double discount = 0,

    // Payment
    String paymentMethod = 'NEXUS Pay',
  })  : _orderId = orderId,
        _date = date,
        _status = status,
        _products = products,
        _shippingCost = shippingCost,
        _recipientName = recipientName,
        _address = address,
        _phone = phone,
        _voucherCode = voucherCode,
        _voucherName = voucherName,
        _discount = discount,
        _paymentMethod = paymentMethod;

  // =========================================================
  // ORDER
  // =========================================================

  String get orderId => _orderId;
  set orderId(String value) => _orderId = value;

  DateTime get date => _date;
  set date(DateTime value) => _date = value;

  String get status => _status;
  set status(String value) => _status = value;

  List<Product> get products => List.unmodifiable(_products);
  set products(List<Product> value) => _products = value;

  double get shippingCost => _shippingCost;
  set shippingCost(double value) => _shippingCost = value;

  // =========================================================
  // SHIPPING ADDRESS
  // =========================================================

  String get recipientName => _recipientName;
  set recipientName(String value) => _recipientName = value;

  String get address => _address;
  set address(String value) => _address = value;

  String get phone => _phone;
  set phone(String value) => _phone = value;

  // =========================================================
  // VOUCHER
  // =========================================================

  String? get voucherCode => _voucherCode;
  set voucherCode(String? value) => _voucherCode = value;

  String? get voucherName => _voucherName;
  set voucherName(String? value) => _voucherName = value;

  double get discount => _discount;
  set discount(double value) => _discount = value;

  // =========================================================
  // PAYMENT METHOD
  // =========================================================

  String get paymentMethod => _paymentMethod;
  set paymentMethod(String value) => _paymentMethod = value;

  // =========================================================
  // PRICE CALCULATION
  // =========================================================

  double getSubtotal() {
    double subtotal = 0;

    for (final product in _products) {
      subtotal += product.price;
    }

    return subtotal;
  }

  double getTotal() {
    final subtotal = getSubtotal();
    final total = subtotal + _shippingCost - _discount;

    return total < 0 ? 0 : total;
  }

  // =========================================================
  // UPDATE STATUS
  // =========================================================

  void updateStatus(String newStatus) {
    _status = newStatus;
  }
}