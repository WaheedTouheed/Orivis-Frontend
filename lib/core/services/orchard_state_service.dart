import 'package:flutter/foundation.dart';

class OrchardModel {
  final String id;
  String name;
  String location;
  String variety;
  double area;
  String areaUnit;
  double askingPrice;
  int bidCount;

  OrchardModel({
    required this.id,
    required this.name,
    required this.location,
    required this.variety,
    required this.area,
    required this.areaUnit,
    required this.askingPrice,
    required this.bidCount,
  });
}

class OrchardStateService extends ChangeNotifier {
  static final OrchardStateService _instance = OrchardStateService._internal();
  factory OrchardStateService() => _instance;
  OrchardStateService._internal();

  final List<OrchardModel> orchards = [
    OrchardModel(
      id: '1',
      name: 'Kinnow Block A',
      location: 'Sargodha',
      variety: 'Kinnow',
      area: 12,
      areaUnit: 'acres',
      askingPrice: 200000,
      bidCount: 3,
    ),
    OrchardModel(
      id: '2',
      name: 'Block C',
      location: 'Sargodha',
      variety: 'Mixed citrus',
      area: 6,
      areaUnit: 'acres',
      askingPrice: 150000,
      bidCount: 1,
    ),
  ];

  OrchardModel? _selectedOrchard;

  OrchardModel get selectedOrchard => _selectedOrchard ?? orchards.first;

  void selectOrchard(OrchardModel orchard) {
    _selectedOrchard = orchard;
    notifyListeners();
  }

  void selectOrchardByName(String name) {
    final found = orchards.firstWhere(
      (o) => o.name == name,
      orElse: () => orchards.first,
    );
    _selectedOrchard = found;
    notifyListeners();
  }

  void addOrchard({
    required String name,
    required String location,
    required String variety,
    required double area,
    required String areaUnit,
    double askingPrice = 180000,
    int bidCount = 0,
  }) {
    final newOrchard = OrchardModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      location: location,
      variety: variety,
      area: area,
      areaUnit: areaUnit,
      askingPrice: askingPrice,
      bidCount: bidCount,
    );
    orchards.add(newOrchard);
    _selectedOrchard ??= newOrchard;
    notifyListeners();
  }

  void updateOrchard({
    required String id,
    required String name,
    required String location,
    required String variety,
    required double area,
    required String areaUnit,
  }) {
    final index = orchards.indexWhere((o) => o.id == id);
    if (index != -1) {
      final o = orchards[index];
      o.name = name;
      o.location = location;
      o.variety = variety;
      o.area = area;
      o.areaUnit = areaUnit;
      if (_selectedOrchard?.id == id) {
        _selectedOrchard = o;
      }
      notifyListeners();
    }
  }
}
