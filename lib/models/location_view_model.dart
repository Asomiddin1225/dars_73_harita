import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationViewModel with ChangeNotifier {
  MapType _currentMapType = MapType.normal;

  MapType get currentMapType => _currentMapType;

  void changeMapType(MapType mapType) {
    _currentMapType = mapType;
    notifyListeners();
  }
}
