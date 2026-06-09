import 'package:flutter/foundation.dart';

class RamadanTrackerViewModel extends ChangeNotifier {
  // Prayer names in Indonesian
  static const List<String> prayers = [
    'Subuh',
    'Dzuhur',
    'Ashar',
    'Maghrib',
    'Isya',
  ];

  // Track completion for each prayer - Map<day, Map<prayer, completed>>
  final Map<int, Map<int, bool>> _prayersCompleted = {};

  // Track fasting status for each day - Map<day, isFasting>
  final Map<int, bool> _fastingStatus = {};

  bool isPrayerCompleted(int day, int prayerIndex) {
    return _prayersCompleted[day]?[prayerIndex] ?? false;
  }

  void togglePrayer(int day, int prayerIndex) {
    _prayersCompleted[day] ??= {};
    _prayersCompleted[day]![prayerIndex] =
        !(_prayersCompleted[day]?[prayerIndex] ?? false);
    notifyListeners();
  }

  int getCompletedCount(int day) {
    int count = 0;
    for (int i = 0; i < prayers.length; i++) {
      if (_prayersCompleted[day]?[i] == true) {
        count++;
      }
    }
    return count;
  }

  void resetDay(int day) {
    _prayersCompleted[day] = {};
    notifyListeners();
  }

  // Fasting methods
  bool isFasting(int day) {
    return _fastingStatus[day] ?? false;
  }

  void toggleFasting(int day) {
    _fastingStatus[day] = !(_fastingStatus[day] ?? false);
    notifyListeners();
  }
}
