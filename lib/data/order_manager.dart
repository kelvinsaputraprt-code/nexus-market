import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../models/product.dart';
import 'notification_manager.dart';

class OrderManager extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  // =========================================================
  // CREATE ORDER
  // =========================================================

  void createOrder({
    required List<Product> products,
    required double shippingCost,

    // ADDRESS
    String recipientName = '',
    String address = '',
    String phone = '',

    // VOUCHER
    String? voucherCode,
    String? voucherName,
    double discount = 0,

    // PAYMENT METHOD
    String paymentMethod = 'NEXUS Pay',
  }) {
    final orderNumber = _orders.length + 1;

    final order = Order(
      orderId: 'NM-${orderNumber.toString().padLeft(3, '0')}',
      date: DateTime.now(),
      status: 'Processing',
      products: List<Product>.from(products),
      shippingCost: shippingCost,

      // ADDRESS
      recipientName: recipientName,
      address: address,
      phone: phone,

      // VOUCHER
      voucherCode: voucherCode,
      voucherName: voucherName,
      discount: discount,

      // PAYMENT METHOD
      paymentMethod: paymentMethod,
    );

    _orders.insert(0, order);

    // =======================================================
    // NOTIFICATION
    // =======================================================

    notificationManager.addNotification(
      title: 'Pesanan Berhasil Dibuat',
      message:
          'Pesanan ${order.orderId} berhasil dibuat dan sedang diproses.',
      type: 'order',
    );

    notifyListeners();
  }

  // =========================================================
  // UPDATE ORDER STATUS
  // =========================================================

  void updateOrderStatus(
    String orderId,
    String newStatus,
  ) {
    final orderIndex = _orders.indexWhere(
      (order) => order.orderId == orderId,
    );

    if (orderIndex == -1) {
      return;
    }

    final order = _orders[orderIndex];

    order.updateStatus(newStatus);

    // =======================================================
    // NOTIFICATION BERDASARKAN STATUS
    // =======================================================

    String title;
    String message;

    switch (newStatus) {
      case 'Processing':
        title = 'Pesanan Diproses';
        message =
            'Pesanan ${order.orderId} sedang diproses oleh NEXUS MARKET.';
        break;

      case 'Shipped':
        title = 'Pesanan Dikirim';
        message =
            'Pesanan ${order.orderId} sedang dalam perjalanan menuju alamat kamu.';
        break;

      case 'Completed':
        title = 'Pesanan Selesai';
        message =
            'Pesanan ${order.orderId} telah selesai. Terima kasih sudah berbelanja di NEXUS MARKET.';
        break;

      case 'Cancelled':
        title = 'Pesanan Dibatalkan';
        message =
            'Pesanan ${order.orderId} telah dibatalkan.';
        break;

      default:
        title = 'Status Pesanan Diperbarui';
        message =
            'Status pesanan ${order.orderId} sekarang adalah $newStatus.';
    }

    notificationManager.addNotification(
      title: title,
      message: message,
      type: 'order',
    );

    notifyListeners();
  }

  // =========================================================
  // UPDATE ORDER ADDRESS
  // =========================================================

  void updateOrderAddress(
    String orderId, {
    required String recipientName,
    required String address,
    required String phone,
  }) {
    final orderIndex = _orders.indexWhere(
      (order) => order.orderId == orderId,
    );

    if (orderIndex == -1) {
      return;
    }

    final order = _orders[orderIndex];

    order.recipientName = recipientName;
    order.address = address;
    order.phone = phone;

    // =======================================================
    // NOTIFICATION
    // =======================================================

    notificationManager.addNotification(
      title: 'Alamat Pesanan Diperbarui',
      message:
          'Alamat pengiriman untuk pesanan ${order.orderId} berhasil diperbarui.',
      type: 'order',
    );

    notifyListeners();
  }

  // =========================================================
  // CLEAR ALL ORDERS
  // =========================================================

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}

final OrderManager orderManager = OrderManager();