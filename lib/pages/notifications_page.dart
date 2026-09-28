import 'package:flutter/material.dart';

import '../data/notification_manager.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    super.key,
  });

  @override
  State<NotificationsPage> createState() =>
      _NotificationsPageState();
}

class _NotificationsPageState
    extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();

    notificationManager.addSampleNotifications();
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day-$month-${date.year}';
  }

  IconData getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return Icons.local_shipping_outlined;

      case 'promo':
        return Icons.local_offer_outlined;

      case 'wishlist':
        return Icons.favorite_border;

      case 'review':
        return Icons.star_outline;

      case 'payment':
        return Icons.payment_outlined;

      default:
        return Icons.notifications_none;
    }
  }

  Color getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return Colors.blue;

      case 'promo':
        return Colors.deepPurple;

      case 'wishlist':
        return Colors.red;

      case 'review':
        return Colors.amber.shade700;

      case 'payment':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5FC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          AnimatedBuilder(
            animation: notificationManager,
            builder: (context, _) {
              if (notificationManager.notifications.isEmpty) {
                return const SizedBox.shrink();
              }

              return TextButton(
                onPressed: () {
                  notificationManager.markAllAsRead();
                },
                child: const Text(
                  'Mark all read',
                ),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: notificationManager,
        builder: (context, _) {
          final notifications =
              notificationManager.notifications;

          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              30,
            ),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification =
                  notifications[index];

              return _buildNotificationCard(
                context,
                notification,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    AppNotification notification,
  ) {
    final iconColor =
        getNotificationColor(notification.type);

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        notificationManager.remove(
          notification.id,
        );

        return false;
      },
      background: Container(
        margin: const EdgeInsets.only(
          bottom: 12,
        ),
        padding: const EdgeInsets.only(
          right: 20,
        ),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(
          bottom: 12,
        ),
        elevation: notification.isRead ? 0 : 2,
        color: notification.isRead
            ? Colors.white
            : const Color(0xFFF3ECFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: notification.isRead
                ? Colors.grey.shade200
                : Colors.deepPurple.withValues(
                    alpha: 0.15,
                  ),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            notificationManager.markAsRead(
              notification.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Icon(
                    getNotificationIcon(
                      notification.type,
                    ),
                    color: iconColor,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    notification.isRead
                                        ? FontWeight.w600
                                        : FontWeight.bold,
                              ),
                            ),
                          ),

                          if (!notification.isRead)
                            Container(
                              width: 9,
                              height: 9,
                              margin:
                                  const EdgeInsets.only(
                                left: 8,
                                top: 5,
                              ),
                              decoration:
                                  const BoxDecoration(
                                color:
                                    Colors.deepPurple,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color:
                              Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        formatDate(
                          notification.date,
                        ),
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(
                  alpha: 0.08,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                size: 52,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Notifikasi pesanan, promo, dan aktivitas '
              'lainnya akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}