import 'package:flutter/foundation.dart';

enum VoucherType {
  fixed,
  percentage,
  freeShipping,
}

class Voucher {
  final String code;
  final String name;
  final VoucherType type;
  final double value;

  const Voucher({
    required this.code,
    required this.name,
    required this.type,
    required this.value,
  });

  double calculateDiscount({
    required double subtotal,
    required double shippingCost,
  }) {
    switch (type) {
      case VoucherType.fixed:
        return value > subtotal ? subtotal : value;

      case VoucherType.percentage:
        return subtotal * (value / 100);

      case VoucherType.freeShipping:
        return shippingCost;
    }
  }

  String get description {
    switch (type) {
      case VoucherType.fixed:
        return 'Potongan Rp ${value.toStringAsFixed(0)}';

      case VoucherType.percentage:
        return 'Diskon ${value.toStringAsFixed(0)}%';

      case VoucherType.freeShipping:
        return 'Gratis ongkir';
    }
  }
}

class VoucherManager extends ChangeNotifier {
  final List<Voucher> _vouchers = const [
    Voucher(
      code: 'NEXUS50',
      name: 'NEXUS Discount 50K',
      type: VoucherType.fixed,
      value: 50000,
    ),
    Voucher(
      code: 'NEXUS20',
      name: 'NEXUS Discount 20K',
      type: VoucherType.fixed,
      value: 20000,
    ),
    Voucher(
      code: 'WELCOME10',
      name: 'Welcome Discount',
      type: VoucherType.percentage,
      value: 10,
    ),
    Voucher(
      code: 'NEXUSFREE',
      name: 'Free Shipping',
      type: VoucherType.freeShipping,
      value: 0,
    ),
  ];

  Voucher? _selectedVoucher;

  List<Voucher> get vouchers => List.unmodifiable(_vouchers);

  Voucher? get selectedVoucher => _selectedVoucher;

  Voucher? findVoucher(String code) {
    final normalizedCode = code.trim().toUpperCase();

    for (final voucher in _vouchers) {
      if (voucher.code == normalizedCode) {
        return voucher;
      }
    }

    return null;
  }

  bool applyVoucher(String code) {
    final voucher = findVoucher(code);

    if (voucher == null) {
      return false;
    }

    _selectedVoucher = voucher;
    notifyListeners();
    return true;
  }

  void removeVoucher() {
    _selectedVoucher = null;
    notifyListeners();
  }

  double calculateDiscount({
    required double subtotal,
    required double shippingCost,
  }) {
    final voucher = _selectedVoucher;

    if (voucher == null) {
      return 0;
    }

    return voucher.calculateDiscount(
      subtotal: subtotal,
      shippingCost: shippingCost,
    );
  }
}

final VoucherManager voucherManager = VoucherManager();