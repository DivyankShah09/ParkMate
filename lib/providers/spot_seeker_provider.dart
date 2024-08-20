import 'package:flutter/material.dart';
import 'package:parkmate/models/spot.dart';

class SpotSeekerProvider extends ChangeNotifier {
  List<Spot> _spots = [];
  List<Spot> get spots => _spots;
  set spots(List<Spot> value) {
    _spots = value;
    notifyListeners();
  }

  List<Spot> _filteredSpots = [];
  List<Spot> get filteredSpots => _filteredSpots;
  set filteredSpots(List<Spot> value) {
    _filteredSpots = value;
    notifyListeners();
  }

  bool _isFetchingSpots = false;
  bool get isFetchingSpots => _isFetchingSpots;
  set isFetchingSpots(bool value) {
    _isFetchingSpots = value;
    notifyListeners();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }
}
