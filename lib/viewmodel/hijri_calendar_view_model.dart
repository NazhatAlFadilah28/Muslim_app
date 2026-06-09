import 'package:flutter/foundation.dart';
import '../repository/hijri_calendar_repository.dart';

class HijriCalendarViewModel extends ChangeNotifier {
  final HijriCalendarRepository _repo;

  HijriCalendarViewModel(this._repo);

  bool _isLoading = false;
  String? _error;

  // Current selected month/year
  int _selectedMonth = 1;
  int _selectedYear = 1445;

  // Hijri date data
  List<dynamic> _calendarDays = [];
  Map<String, dynamic>? _currentHijriDate;

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;
  List<dynamic> get calendarDays => _calendarDays;
  Map<String, dynamic>? get currentHijriDate => _currentHijriDate;

  // Islamic months names
  static const List<String> hijriMonths = [
    'Muharram',
    'Safar',
    'Rabiul Awal',
    'Rabiul Akhir',
    'Jumadil Awal',
    'Jumadil Akhir',
    'Rajab',
    'Sha\'ban',
    'Ramadan',
    'Syawwal',
    'Dzulqa\'dah',
    'Dzulhijjah',
  ];

  // Get month name in Indonesian
  String getMonthName(int month) {
    if (month >= 1 && month <= 12) {
      return hijriMonths[month - 1];
    }
    return '';
  }

  // Initialize with current Hijri date
  Future<void> initialize() async {
    await fetchCurrentHijriDate();
    await fetchCalendarForMonth(_selectedMonth, _selectedYear);
  }

  // Fetch current Hijri date
  Future<void> fetchCurrentHijriDate() async {
    try {
      _currentHijriDate = await _repo.getCurrentHijriDate();

      // Extract current month and year from API
      if (_currentHijriDate != null) {
        final monthData = _currentHijriDate!['month'];
        if (monthData != null) {
          _selectedMonth = monthData['number'] ?? 1;
        }
        _selectedYear =
            int.tryParse(_currentHijriDate!['year'] ?? '1445') ?? 1445;
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Fetch calendar for specific month
  Future<void> fetchCalendarForMonth(int month, int year) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedMonth = month;
      _selectedYear = year;

      final data = await _repo.getHijriCalendar(month: month, year: year);

      _calendarDays = data['data'] as List<dynamic>? ?? [];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Change month
  void changeMonth(int delta) {
    int newMonth = _selectedMonth + delta;
    int newYear = _selectedYear;

    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }

    fetchCalendarForMonth(newMonth, newYear);
  }

  // Go to current month
  Future<void> goToCurrentMonth() async {
    await fetchCurrentHijriDate();
    await fetchCalendarForMonth(_selectedMonth, _selectedYear);
  }

  // Get specific day data
  Map<String, dynamic>? getDayData(int day) {
    if (_calendarDays.isEmpty || day < 1 || day > _calendarDays.length) {
      return null;
    }
    return _calendarDays[day - 1];
  }
}
