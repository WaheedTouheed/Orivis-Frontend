import 'package:flutter/foundation.dart';

// ============================================================
// SHARED LISTING MODEL
// Used by both Grower (Create Listing) and Vendor (Dashboard)
// ============================================================

enum ListingStatus { open, paused, closed }

class ListingModel {
  final String id;
  final String orchardId;
  final String orchardName;
  final String location;
  final String fruitVariety;
  final int estimatedFruitCount;
  final double ripenessPercentage;
  final double healthyPercentage;
  final double askingPrice;
  final double minimumBid;
  final DateTime createdAt;
  ListingStatus listingStatus;
  final bool isAiScanned;
  final String? notes;

  ListingModel({
    required this.id,
    required this.orchardId,
    required this.orchardName,
    required this.location,
    required this.fruitVariety,
    required this.estimatedFruitCount,
    required this.ripenessPercentage,
    required this.healthyPercentage,
    required this.askingPrice,
    required this.minimumBid,
    required this.createdAt,
    this.listingStatus = ListingStatus.open,
    this.isAiScanned = true,
    this.notes,
  });

  ListingModel copyWith({
    String? orchardName,
    String? location,
    String? fruitVariety,
    int? estimatedFruitCount,
    double? ripenessPercentage,
    double? healthyPercentage,
    double? askingPrice,
    double? minimumBid,
    ListingStatus? listingStatus,
    String? notes,
  }) {
    return ListingModel(
      id: id,
      orchardId: orchardId,
      orchardName: orchardName ?? this.orchardName,
      location: location ?? this.location,
      fruitVariety: fruitVariety ?? this.fruitVariety,
      estimatedFruitCount: estimatedFruitCount ?? this.estimatedFruitCount,
      ripenessPercentage: ripenessPercentage ?? this.ripenessPercentage,
      healthyPercentage: healthyPercentage ?? this.healthyPercentage,
      askingPrice: askingPrice ?? this.askingPrice,
      minimumBid: minimumBid ?? this.minimumBid,
      createdAt: createdAt,
      listingStatus: listingStatus ?? this.listingStatus,
      isAiScanned: isAiScanned,
      notes: notes ?? this.notes,
    );
  }
}

// ============================================================
// SHARED VENDOR BID MODEL
// ============================================================

enum VendorBidStatus { pending, accepted, rejected }

class VendorBidRecord {
  final String id;
  final String listingId;
  final String orchardName;
  final double bidAmount;
  VendorBidStatus status;
  final DateTime placedAt;

  VendorBidRecord({
    required this.id,
    required this.listingId,
    required this.orchardName,
    required this.bidAmount,
    this.status = VendorBidStatus.pending,
    required this.placedAt,
  });
}

// ============================================================
// SINGLETON SHARED STATE SERVICE
// ============================================================

class ListingStateService extends ChangeNotifier {
  static final ListingStateService _instance = ListingStateService._internal();
  factory ListingStateService() => _instance;
  ListingStateService._internal();

  // ---- Listings ----
  final List<ListingModel> _listings = [
    ListingModel(
      id: 'lst_001',
      orchardId: '1',
      orchardName: 'Kinnow Block A',
      location: 'Sargodha',
      fruitVariety: 'Kinnow',
      estimatedFruitCount: 1248,
      ripenessPercentage: 72,
      healthyPercentage: 86,
      askingPrice: 200000,
      minimumBid: 150000,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      listingStatus: ListingStatus.open,
      isAiScanned: true,
    ),
    ListingModel(
      id: 'lst_002',
      orchardId: '2',
      orchardName: 'Block C Mixed',
      location: 'Sargodha',
      fruitVariety: 'Mixed citrus',
      estimatedFruitCount: 860,
      ripenessPercentage: 38,
      healthyPercentage: 91,
      askingPrice: 150000,
      minimumBid: 110000,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      listingStatus: ListingStatus.open,
      isAiScanned: true,
    ),
    ListingModel(
      id: 'lst_003',
      orchardId: '3',
      orchardName: 'Mandarin North',
      location: 'Bhalwal',
      fruitVariety: 'Mandarin',
      estimatedFruitCount: 2010,
      ripenessPercentage: 61,
      healthyPercentage: 79,
      askingPrice: 320000,
      minimumBid: 250000,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      listingStatus: ListingStatus.open,
      isAiScanned: true,
    ),
  ];

  List<ListingModel> get listings => List.unmodifiable(_listings);

  List<ListingModel> get openListings =>
      _listings.where((l) => l.listingStatus == ListingStatus.open).toList();

  int get openListingCount => openListings.length;

  void addListing(ListingModel listing) {
    _listings.insert(0, listing);
    notifyListeners();
  }

  void updateListing(ListingModel updated) {
    final index = _listings.indexWhere((l) => l.id == updated.id);
    if (index != -1) {
      _listings[index] = updated;
      notifyListeners();
    }
  }

  void removeListing(String id) {
    _listings.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  void pauseListing(String id) {
    final index = _listings.indexWhere((l) => l.id == id);
    if (index != -1) {
      _listings[index].listingStatus = ListingStatus.paused;
      notifyListeners();
    }
  }

  ListingModel? getById(String id) {
    try {
      return _listings.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  // ---- Vendor Bids ----
  final List<VendorBidRecord> _vendorBids = [
    VendorBidRecord(
      id: 'vbid_001',
      listingId: 'lst_001',
      orchardName: 'Kinnow Block A',
      bidAmount: 182000,
      status: VendorBidStatus.pending,
      placedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    VendorBidRecord(
      id: 'vbid_002',
      listingId: 'lst_002',
      orchardName: 'Block C Mixed',
      bidAmount: 140000,
      status: VendorBidStatus.rejected,
      placedAt: DateTime.now().subtract(const Duration(hours: 10)),
    ),
  ];

  List<VendorBidRecord> get vendorBids => List.unmodifiable(_vendorBids);

  int get pendingBidCount =>
      _vendorBids.where((b) => b.status == VendorBidStatus.pending).length;

  int get acceptedBidCount =>
      _vendorBids.where((b) => b.status == VendorBidStatus.accepted).length;

  void addVendorBid(VendorBidRecord bid) {
    _vendorBids.insert(0, bid);
    notifyListeners();
  }

  void updateVendorBidStatus(String bidId, VendorBidStatus status) {
    final index = _vendorBids.indexWhere((b) => b.id == bidId);
    if (index != -1) {
      _vendorBids[index].status = status;
      notifyListeners();
    }
  }
}
