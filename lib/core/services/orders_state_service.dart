import 'package:flutter/foundation.dart';

// ============================================================
// SHARED VENDOR ORDER MODEL & STATE SERVICE
// ============================================================

enum OrderStatus { active, completed, cancelled }

class OrderModel {
  final String id;
  final String orchardName;
  final String growerName;
  final double amount;
  final String quantity;
  OrderStatus status;
  final DateTime date;
  final String? location;
  final String? notes;
  final String? bidId;

  OrderModel({
    required this.id,
    required this.orchardName,
    required this.growerName,
    required this.amount,
    required this.quantity,
    required this.status,
    required this.date,
    this.location,
    this.notes,
    this.bidId,
  });

  OrderModel copyWith({
    String? orchardName,
    String? growerName,
    double? amount,
    String? quantity,
    OrderStatus? status,
    DateTime? date,
    String? location,
    String? notes,
  }) {
    return OrderModel(
      id: id,
      orchardName: orchardName ?? this.orchardName,
      growerName: growerName ?? this.growerName,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      date: date ?? this.date,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      bidId: bidId,
    );
  }
}

class OrdersStateService extends ChangeNotifier {
  static final OrdersStateService _instance = OrdersStateService._internal();
  factory OrdersStateService() => _instance;
  OrdersStateService._internal();

  final List<OrderModel> _orders = [
    OrderModel(
      id: 'ord_001',
      orchardName: 'Kinnow Block A',
      growerName: 'Grower account',
      amount: 182000,
      quantity: '4 tons',
      status: OrderStatus.active,
      date: DateTime.now(),
      location: 'Sargodha',
      notes: 'Active order. High-quality Kinnow harvest batch, pickup arranged at orchard block A.',
      bidId: 'vbid_001',
    ),
    OrderModel(
      id: 'ord_002',
      orchardName: 'Block C Mixed',
      growerName: 'Grower account',
      amount: 140000,
      quantity: '3 tons',
      status: OrderStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 3)),
      location: 'Sargodha',
      notes: 'Completed order. Mixed citrus batch processed and delivered successfully.',
      bidId: 'vbid_002',
    ),
    OrderModel(
      id: 'ord_003',
      orchardName: 'Mandarin North',
      growerName: 'Grower account',
      amount: 280000,
      quantity: '5 tons',
      status: OrderStatus.cancelled,
      date: DateTime.now().subtract(const Duration(days: 7)),
      location: 'Bhalwal',
      notes: 'Cancelled order. Mandarin batch order cancelled prior to dispatch.',
      bidId: 'vbid_003',
    ),
  ];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  List<OrderModel> get activeOrders =>
      _orders.where((o) => o.status == OrderStatus.active).toList();

  List<OrderModel> get completedOrders =>
      _orders.where((o) => o.status == OrderStatus.completed).toList();

  List<OrderModel> get cancelledOrders =>
      _orders.where((o) => o.status == OrderStatus.cancelled).toList();

  void addOrder(OrderModel order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = status;
      notifyListeners();
    }
  }

  void reflectAcceptedBid({
    required String bidId,
    required String orchardName,
    required double amount,
    required String quantity,
    required String growerName,
    String? location,
  }) {
    final index = _orders.indexWhere(
      (o) => o.bidId == bidId || o.orchardName == orchardName,
    );

    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        amount: amount,
        quantity: quantity,
        status: OrderStatus.active,
        date: DateTime.now(),
      );
    } else {
      _orders.insert(
        0,
        OrderModel(
          id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
          orchardName: orchardName,
          growerName: growerName,
          amount: amount,
          quantity: quantity,
          status: OrderStatus.active,
          date: DateTime.now(),
          location: location ?? 'Sargodha',
          bidId: bidId,
        ),
      );
    }
    notifyListeners();
  }
}
