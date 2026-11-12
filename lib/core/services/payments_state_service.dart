import 'package:flutter/foundation.dart';
import 'listing_state_service.dart';

// ============================================================
// SHARED VENDOR PAYMENTS STATE SERVICE
// ============================================================

enum PaymentMethodType { card, account }

class PaymentTransaction {
  final String id;
  final String orchardName;
  final String stageName;
  final double percentage;
  final double amount;
  final PaymentMethodType methodType;
  final String accountOrCardMask;
  final DateTime timestamp;

  PaymentTransaction({
    required this.id,
    required this.orchardName,
    required this.stageName,
    required this.percentage,
    required this.amount,
    required this.methodType,
    required this.accountOrCardMask,
    required this.timestamp,
  });
}

class ConfirmedBidPaymentModel {
  final String id;
  final String orchardName;
  final String growerName;
  final double totalAmount;
  final VendorBidStatus bidStatus; // pending, accepted, rejected
  double paidAmount;
  final DateTime acceptedDate;

  ConfirmedBidPaymentModel({
    required this.id,
    required this.orchardName,
    required this.growerName,
    required this.totalAmount,
    required this.bidStatus,
    this.paidAmount = 0.0,
    required this.acceptedDate,
  });

  double get paidPercentage =>
      totalAmount > 0 ? ((paidAmount / totalAmount) * 100).clamp(0.0, 100.0) : 0.0;
  double get remainingAmount => (totalAmount - paidAmount).clamp(0.0, totalAmount);

  double get advanceAmount => totalAmount * 0.30;
  double get harvestAmount => totalAmount * 0.40;
  double get finalAmount => totalAmount * 0.30;

  bool get isAdvancePaid => paidAmount >= (advanceAmount - 1.0);
  bool get isHarvestPaid => paidAmount >= (advanceAmount + harvestAmount - 1.0);
  bool get isFinalPaid => paidAmount >= (totalAmount - 1.0);
}

class PaymentsStateService extends ChangeNotifier {
  static final PaymentsStateService _instance = PaymentsStateService._internal();
  factory PaymentsStateService() => _instance;
  PaymentsStateService._internal();

  final List<ConfirmedBidPaymentModel> _schedules = [
    ConfirmedBidPaymentModel(
      id: 'pay_001',
      orchardName: 'Kinnow Block A',
      growerName: 'Grower account',
      totalAmount: 182000,
      bidStatus: VendorBidStatus.accepted,
      paidAmount: 54600, // 30% advance already paid
      acceptedDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ConfirmedBidPaymentModel(
      id: 'pay_002',
      orchardName: 'Block C Mixed',
      growerName: 'Grower account',
      totalAmount: 140000,
      bidStatus: VendorBidStatus.accepted,
      paidAmount: 140000, // 100% completed
      acceptedDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ConfirmedBidPaymentModel(
      id: 'pay_003',
      orchardName: 'Mandarin North',
      growerName: 'Grower account',
      totalAmount: 280000,
      bidStatus: VendorBidStatus.pending,
      paidAmount: 0, // Pending bid: payment locked
      acceptedDate: DateTime.now().subtract(const Duration(hours: 4)),
    ),
  ];

  final List<PaymentTransaction> _transactions = [
    PaymentTransaction(
      id: 'TXN-948201',
      orchardName: 'Kinnow Block A',
      stageName: 'Advance (30%)',
      percentage: 30.0,
      amount: 54600,
      methodType: PaymentMethodType.card,
      accountOrCardMask: 'Visa **** 4821',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    PaymentTransaction(
      id: 'TXN-882319',
      orchardName: 'Block C Mixed',
      stageName: 'Full Payment (100%)',
      percentage: 100.0,
      amount: 140000,
      methodType: PaymentMethodType.account,
      accountOrCardMask: 'Meezan Bank **** 9012',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  List<ConfirmedBidPaymentModel> get schedules => List.unmodifiable(_schedules);
  List<PaymentTransaction> get transactions => List.unmodifiable(_transactions);

  List<ConfirmedBidPaymentModel> get confirmedBids =>
      _schedules.where((s) => s.bidStatus == VendorBidStatus.accepted).toList();

  void recordPayment({
    required String scheduleId,
    required String stageName,
    required double percentage,
    required double amount,
    required PaymentMethodType methodType,
    required String accountOrCardMask,
  }) {
    final index = _schedules.indexWhere((s) => s.id == scheduleId);
    if (index != -1) {
      _schedules[index].paidAmount += amount;
      if (_schedules[index].paidAmount > _schedules[index].totalAmount) {
        _schedules[index].paidAmount = _schedules[index].totalAmount;
      }

      final txn = PaymentTransaction(
        id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
        orchardName: _schedules[index].orchardName,
        stageName: stageName,
        percentage: percentage,
        amount: amount,
        methodType: methodType,
        accountOrCardMask: accountOrCardMask,
        timestamp: DateTime.now(),
      );

      _transactions.insert(0, txn);
      notifyListeners();
    }
  }

  void syncAcceptedBid({
    required String orchardName,
    required double totalAmount,
    required String growerName,
  }) {
    final index = _schedules.indexWhere((s) => s.orchardName == orchardName);
    if (index != -1) {
      _schedules[index] = ConfirmedBidPaymentModel(
        id: _schedules[index].id,
        orchardName: orchardName,
        growerName: growerName,
        totalAmount: totalAmount,
        bidStatus: VendorBidStatus.accepted,
        paidAmount: _schedules[index].paidAmount,
        acceptedDate: DateTime.now(),
      );
    } else {
      _schedules.insert(
        0,
        ConfirmedBidPaymentModel(
          id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
          orchardName: orchardName,
          growerName: growerName,
          totalAmount: totalAmount,
          bidStatus: VendorBidStatus.accepted,
          paidAmount: 0.0,
          acceptedDate: DateTime.now(),
        ),
      );
    }
    notifyListeners();
  }
}
