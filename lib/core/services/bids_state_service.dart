import 'package:flutter/foundation.dart';

class BidItem {
  final String id;
  final String companyName;
  final String initials;
  final String quantity;
  final double amount;
  String status; // 'Pending', 'Accepted', 'Rejected'
  bool isHighest;

  BidItem({
    required this.id,
    required this.companyName,
    required this.initials,
    required this.quantity,
    required this.amount,
    required this.status,
    this.isHighest = false,
  });
}

class BidsStateService extends ChangeNotifier {
  static final BidsStateService _instance = BidsStateService._internal();
  factory BidsStateService() => _instance;
  BidsStateService._internal();

  final List<BidItem> _bids = [
    BidItem(
      id: '1',
      companyName: 'Al-Noor Traders',
      initials: 'AT',
      quantity: '4 tons',
      amount: 182000,
      status: 'Pending',
      isHighest: true,
    ),
    BidItem(
      id: '2',
      companyName: 'Madni Fruit Co.',
      initials: 'MF',
      quantity: '3.5 tons',
      amount: 176500,
      status: 'Pending',
      isHighest: false,
    ),
    BidItem(
      id: '3',
      companyName: 'Shah Agency',
      initials: 'SA',
      quantity: '4 tons',
      amount: 168000,
      status: 'Pending',
      isHighest: false,
    ),
  ];

  List<BidItem> get bids => List.unmodifiable(_bids);

  int get bidCount => _bids.length;

  void removeBid(String id) {
    _bids.removeWhere((b) => b.id == id);
    if (_bids.isNotEmpty) {
      final maxAmount =
          _bids.map((b) => b.amount).reduce((a, b) => a > b ? a : b);
      for (var b in _bids) {
        b.isHighest = (b.amount == maxAmount);
      }
    }
    notifyListeners();
  }
}
