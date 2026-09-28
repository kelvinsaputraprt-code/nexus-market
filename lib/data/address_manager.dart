import 'package:flutter/foundation.dart';

class ShippingAddress {
  final String id;
  final String label;
  final String recipientName;
  final String address;
  final String phone;
  bool isDefault;

  ShippingAddress({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.address,
    required this.phone,
    this.isDefault = false,
  });
}

class AddressManager extends ChangeNotifier {
  final List<ShippingAddress> _addresses = [
    ShippingAddress(
      id: 'address-1',
      label: 'Kos Ketintang',
      recipientName: 'Kelvin',
      address: 'Ketintang, Surabaya',
      phone: '08xxxxxxxxxx',
      isDefault: true,
    ),
    ShippingAddress(
      id: 'address-2',
      label: 'Rumah',
      recipientName: 'Kelvin',
      address: 'Madiun, Jawa Timur',
      phone: '08xxxxxxxxxx',
      isDefault: false,
    ),
  ];

  List<ShippingAddress> get addresses =>
      List.unmodifiable(_addresses);

  ShippingAddress get defaultAddress {
    return _addresses.firstWhere(
      (address) => address.isDefault,
      orElse: () => _addresses.first,
    );
  }

  void addAddress({
    required String label,
    required String recipientName,
    required String address,
    required String phone,
    bool setAsDefault = false,
  }) {
    final newAddress = ShippingAddress(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      label: label,
      recipientName: recipientName,
      address: address,
      phone: phone,
      isDefault: setAsDefault || _addresses.isEmpty,
    );

    if (newAddress.isDefault) {
      for (final item in _addresses) {
        item.isDefault = false;
      }
    }

    _addresses.add(newAddress);

    notifyListeners();
  }

  void setDefault(String id) {
    for (final address in _addresses) {
      address.isDefault = address.id == id;
    }

    notifyListeners();
  }

  void removeAddress(String id) {
    if (_addresses.length <= 1) {
      return;
    }

    final removedWasDefault =
        _addresses.any(
      (address) =>
          address.id == id && address.isDefault,
    );

    _addresses.removeWhere(
      (address) => address.id == id,
    );

    if (removedWasDefault && _addresses.isNotEmpty) {
      _addresses.first.isDefault = true;
    }

    notifyListeners();
  }
}

final AddressManager addressManager =
    AddressManager();