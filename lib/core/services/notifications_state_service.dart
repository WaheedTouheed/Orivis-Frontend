import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final String category;
  final IconData iconData;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    required this.iconData,
    this.isRead = false,
  });
}

class NotificationsStateService extends ChangeNotifier {
  static final NotificationsStateService _instance =
      NotificationsStateService._internal();
  factory NotificationsStateService() => _instance;
  NotificationsStateService._internal();

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'New bid received!',
      description:
          'Al-Noor Traders placed a bid of PKR 182,000 for Kinnow Block A.',
      time: '5 minutes ago',
      category: 'Bids',
      iconData: Icons.handshake_outlined,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Bid accepted successfully',
      description:
          "You accepted Madni Fruit Co.'s bid of PKR 176,500 for Kinnow Block A.",
      time: '1 hour ago',
      category: 'Bids',
      iconData: Icons.check_circle_outline,
      isRead: false,
    ),
  ];

  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void addNotification(NotificationItem item) {
    _notifications.insert(0, item);
    notifyListeners();
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
