import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../data/static_data.dart';
import '../repository/shalat_repository.dart';

class ShalatViewModel extends ChangeNotifier {
  final ShalatRepository _repository = ShalatRepository();

  bool _isLoading = false;
  bool _isLoadingLocation = false;
  String? _error;
  String _currentLocation = 'Jakarta';
  List<Map<String, String>> _schedules = [];

  // City ID mapping for myquran API
  static const Map<String, int> cityIds = {
    'Jakarta': 1301,
    'Bandung': 1214,
    'Bekasi': 1771,
    'Cianjur': 1216,
    'Medan': 1063,
    'Makassar': 1020,
    'Palembang': 1284,
    'Malang': 1225,
    'Kediri': 1222,
    'Jember': 1209,
    'Bandar Lampung': 1272,
  };

  final List<String> availableCities = [
    'Jakarta',
    'Bandung',
    'Bekasi',
    'Cianjur',
    'Medan',
    'Makassar',
    'Palembang',
    'Malang',
    'Kediri',
    'Jember',
    'Bandar Lampung',
  ];

  bool get isLoading => _isLoading;
  bool get isLoadingLocation => _isLoadingLocation;
  String? get error => _error;
  String get currentLocation => _currentLocation;
  List<Map<String, String>> get schedules => _schedules;

  // Get current location using GPS
  Future<void> getCurrentLocation() async {
    try {
      _isLoadingLocation = true;
      notifyListeners();

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _currentLocation = 'Jakarta';
        _isLoadingLocation = false;
        notifyListeners();
        fetchSchedule();
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _currentLocation = 'Jakarta';
          _isLoadingLocation = false;
          notifyListeners();
          fetchSchedule();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _currentLocation = 'Jakarta';
        _isLoadingLocation = false;
        notifyListeners();
        fetchSchedule();
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      // Try to get city from coordinates
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          String? city = place.locality ?? place.subAdministrativeArea;

          // Check if city is in our list
          if (city != null) {
            for (var availableCity in availableCities) {
              if (city.toLowerCase().contains(availableCity.toLowerCase()) ||
                  availableCity.toLowerCase().contains(city.toLowerCase())) {
                _currentLocation = availableCity;
                break;
              }
            }
          }
                }
      } catch (e) {
        // Keep default
      }
    } catch (e) {
      _currentLocation = 'Jakarta';
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
      fetchSchedule();
    }
  }

  void setCity(String cityName) {
    _currentLocation = cityName;
    fetchSchedule();
  }

  Future<void> fetchSchedule() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final cityId = cityIds[_currentLocation] ?? 1301; // Default to Jakarta
      final now = DateTime.now();

      // Call the actual API
      final response = await _repository.getMonthlySchedule(
        cityId: cityId,
        year: now.year,
        month: now.month,
      );

      // Convert API response to the format used by the UI
      _schedules = response.schedules.map((schedule) {
        return {
          'tanggal': schedule.tanggal,
          'imsak': schedule.imsak,
          'subuh': schedule.subuh,
          'terbit': schedule.terbit,
          'dhuha': schedule.dhuha,
          'dzuhur': schedule.dzuhur,
          'ashar': schedule.ashar,
          'maghrib': schedule.maghrib,
          'isya': schedule.isya,
        };
      }).toList();
    } catch (e) {
      // Fallback to static data if API fails
      _error = e.toString();
      if (ShalatScheduleData.jadwalShalat.containsKey(_currentLocation)) {
        _schedules = ShalatScheduleData.jadwalShalat[_currentLocation]!;
      } else {
        _schedules = ShalatScheduleData.jadwalShalat['Jakarta']!;
        _currentLocation = 'Jakarta';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
