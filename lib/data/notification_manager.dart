import 'package:flutter/foundation.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime date;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    this.isRead = false,
  });
}

class NotificationManager extends ChangeNotifier {
  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadCount {
    return _notifications
        .where((notification) => !notification.isRead)
        .length;
  }

  void addNotification({
    required String title,
    required String message,
    required String type,
  }) {
    final notification = AppNotification(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      date: DateTime.now(),
    );

    _notifications.insert(0, notification);

    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere(
      (notification) => notification.id == id,
    );

    if (index == -1) {
      return;
    }

    _notifications[index].isRead = true;

    notifyListeners();
  }

  void markAllAsRead() {
    for (final notification in _notifications) {
      notification.isRead = true;
    }

    notifyListeners();
  }

  void remove(String id) {
    _notifications.removeWhere(
      (notification) => notification.id == id,
    );

    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();

    notifyListeners();
  }

  void addSampleNotifications() {
    if (_notifications.isNotEmpty) {
      return;
    }

    _notifications.addAll([
      AppNotification(
        id: 'sample-1',
        title: 'Pesanan Sedang Diproses',
        message:
            'Pesanan NM-001 sedang diproses oleh NEXUS MARKET.',
        type: 'order',
        date: DateTime.now().subtract(
          const Duration(minutes: 5),
        ),
      ),
      AppNotification(
        id: 'sample-2',
        title: 'Promo NEXUS MARKET',
        message:
            'Gaming Gear Sale! Nikmati berbagai promo menarik.',
        type: 'promo',
        date: DateTime.now().subtract(
          const Duration(hours: 2),
        ),
      ),
      AppNotification(
        id: 'sample-3',
        title: 'Wishlist',
        message:
            'Produk favoritmu masih tersedia. Yuk cek kembali!',
        type: 'wishlist',
        date: DateTime.now().subtract(
          const Duration(hours: 5),
        ),
      ),
    ]);

    notifyListeners();
  }
}

final NotificationManager notificationManager =
    NotificationManager();