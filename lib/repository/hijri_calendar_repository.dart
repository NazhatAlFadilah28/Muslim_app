import 'dart:convert';
import 'package:http/http.dart' as http;

class HijriCalendarRepository {
  final http.Client _client;

  HijriCalendarRepository({http.Client? client})
    : _client = client ?? http.Client();

  // Get Hijri calendar for a specific month
  // API: https://api.aladhan.com/v1/hijriCalendar
  Future<Map<String, dynamic>> getHijriCalendar({
    required int month,
    required int year,
    double? latitude,
    double? longitude,
  }) async {
    // Default to Jakarta coordinates if not provided
    latitude ??= -6.2088;
    longitude ??= 106.8456;

    final url = Uri.parse(
      'https://api.aladhan.com/v1/hijriCalendar/$year/$month?latitude=$latitude&longitude=$longitude&method=3',
    );

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
          'Failed to load Hijri calendar: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching Hijri calendar: $e');
    }
  }

  // Get current Hijri date using gToH endpoint
  // API: https://api.aladhan.com/v1/gToH?date=DD-MM-YYYY
  Future<Map<String, dynamic>> getCurrentHijriDate({
    double? latitude,
    double? longitude,
  }) async {
    // Get current date
    final now = DateTime.now();
    final dateStr =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

    final url = Uri.parse('https://api.aladhan.com/v1/gToH?date=$dateStr');

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? {};
      } else {
        throw Exception(
          'Failed to load current Hijri date: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching current Hijri date: $e');
    }
  }
}

// Model for Hijri date
class HijriDate {
  final String day;
  final String month;
  final String year;
  final String monthAr;
  final Map<String, String>? designation;

  HijriDate({
    required this.day,
    required this.month,
    required this.year,
    required this.monthAr,
    this.designation,
  });

  factory HijriDate.fromJson(Map<String, dynamic> json) {
    return HijriDate(
      day: json['day'] ?? '',
      month: json['month']?['en'] ?? '',
      year: json['year'] ?? '',
      monthAr: json['month']?['ar'] ?? '',
      designation: json['designation'] != null
          ? {
              'abbreviated': json['designation']['abbreviated'] ?? '',
              'expanded': json['designation']['expanded'] ?? '',
            }
          : null,
    );
  }
}

// Model for Hijri calendar month
class HijriCalendarMonth {
  final int month;
  final int year;
  final List<HijriDate> days;

  HijriCalendarMonth({
    required this.month,
    required this.year,
    required this.days,
  });

  factory HijriCalendarMonth.fromJson(
    Map<String, dynamic> json,
    int month,
    int year,
  ) {
    final List<dynamic> dataList = json['data'] ?? [];

    return HijriCalendarMonth(
      month: month,
      year: year,
      days: dataList.map((e) => HijriDate.fromJson(e['hijri'] ?? {})).toList(),
    );
  }
}
