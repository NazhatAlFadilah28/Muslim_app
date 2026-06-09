import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationViewModel extends ChangeNotifier {
  double? _latitude;
  double? _longitude;
  String _locationName = 'Mendapatkan lokasi...';
  String _timezone = 'WIB';
  bool _isLoading = true;
  String _errorMessage = '';
  DateTime _currentTime = DateTime.now();

  Timer? _timer;

  // Getters
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String get locationName => _locationName;
  String get timezone => _timezone;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  DateTime get currentTime => _currentTime;

  String get formattedTime {
    return '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}';
  }

  String get formattedDate {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${_currentTime.day} ${months[_currentTime.month - 1]} ${_currentTime.year}';
  }

  LocationViewModel() {
    _initializeLocation();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    // Get current UTC time and convert to local timezone (Indonesia is UTC+7)
    final utcNow = DateTime.now().toUtc();
    final localTime = utcNow.add(const Duration(hours: 7));

    setState(() {
      _currentTime = localTime;
    });
  }

  Future<void> _initializeLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Layanan lokasi dimatikan';
          _locationName = 'Lokasi tidak tersedia';
          _isLoading = false;
        });
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Izin lokasi ditolak';
            _locationName = 'Izin lokasi ditolak';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Izin lokasi dinonaktifkan';
          _locationName = 'Pengaturan lokasi permanen';
          _isLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _latitude = position.latitude;
      _longitude = position.longitude;

      // Determine timezone based on longitude (Indonesia covers 3 timezones)
      // UTC+7 (WIB): 105°E - 112°E
      // UTC+8 (WITA): 115°E - 125°E
      // UTC+9 (WIT): 125°E - 141°E
      if (_longitude! >= 125) {
        _timezone = 'WIT';
      } else if (_longitude! >= 115) {
        _timezone = 'WITA';
      } else {
        _timezone = 'WIB';
      }

      // Try to get location name using geocoding
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _latitude!,
          _longitude!,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String city = place.subLocality ?? place.locality ?? '';
          String province = place.administrativeArea ?? '';

          if (city.isNotEmpty && province.isNotEmpty) {
            _locationName = '$city, $province';
          } else if (city.isNotEmpty) {
            _locationName = city;
          } else if (province.isNotEmpty) {
            _locationName = province;
          } else {
            _locationName = 'Lokasi ditemukan';
          }
        } else {
          _locationName =
              'Lokasi: ${_latitude!.toStringAsFixed(2)}, ${_longitude!.toStringAsFixed(2)}';
        }
      } catch (e) {
        // If geocoding fails, use coordinates
        _locationName =
            'Lokasi: ${_latitude!.toStringAsFixed(2)}, ${_longitude!.toStringAsFixed(2)}';
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mendapatkan lokasi';
        _locationName = 'Error lokasi';
        _isLoading = false;
      });
    }
  }

  Future<void> refreshLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    await _initializeLocation();
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
