import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'initials': initials,
      'quantity': quantity,
      'amount': amount,
      'status': status,
      'isHighest': isHighest,
    };
  }

  factory BidItem.fromJson(Map<String, dynamic> json) {
    return BidItem(
      id: json['id'] ?? '',
      companyName: json['companyName'] ?? '',
      initials: json['initials'] ?? 'AT',
      quantity: json['quantity'] ?? '0 tons',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Pending',
      isHighest: json['isHighest'] ?? false,
    );
  }
}

class BidsStateService extends ChangeNotifier {
  static final BidsStateService _instance = BidsStateService._internal();
  factory BidsStateService() => _instance;

  BidsStateService._internal() {
    loadSavedState();
  }

  List<BidItem> _bids = [
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

  bool _isLoaded = false;

  List<BidItem> get bids => List.unmodifiable(_bids);

  int get bidCount => _bids.length;

  Future<void> loadSavedState() async {
    if (_isLoaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? bidsJson = prefs.getString('orivis_bids_state');
      final bool? isCleared = prefs.getBool('orivis_bids_cleared');

      if (isCleared == true) {
        _bids = [];
      } else if (bidsJson != null) {
        final List<dynamic> decoded = jsonDecode(bidsJson);
        _bids = decoded.map((item) => BidItem.fromJson(item)).toList();
      }
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading bids state: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_bids.isEmpty) {
        await prefs.setBool('orivis_bids_cleared', true);
        await prefs.setString('orivis_bids_state', jsonEncode([]));
      } else {
        await prefs.setBool('orivis_bids_cleared', false);
        final encoded = jsonEncode(_bids.map((b) => b.toJson()).toList());
        await prefs.setString('orivis_bids_state', encoded);
      }
    } catch (e) {
      debugPrint('Error saving bids state: $e');
    }
  }

  void addBid(BidItem bid) {
    _bids.insert(0, bid);
    if (_bids.isNotEmpty) {
      final maxAmount =
          _bids.map((b) => b.amount).reduce((a, b) => a > b ? a : b);
      for (var b in _bids) {
        b.isHighest = (b.amount == maxAmount);
      }
    }
    _saveToStorage();
    notifyListeners();
  }

  void removeBid(String id) {
    _bids.removeWhere((b) => b.id == id);
    if (_bids.isNotEmpty) {
      final maxAmount =
          _bids.map((b) => b.amount).reduce((a, b) => a > b ? a : b);
      for (var b in _bids) {
        b.isHighest = (b.amount == maxAmount);
      }
    }
    _saveToStorage();
    notifyListeners();
  }
}
