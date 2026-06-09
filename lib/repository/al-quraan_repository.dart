import 'dart:convert';
import 'package:http/http.dart' as http;

class AlQuranRepository {
  final http.Client _client;

  AlQuranRepository({http.Client? client}) : _client = client ?? http.Client();

  // Get all surahs from alquran.cloud API
  Future<List<Map<String, dynamic>>> getAllSurah() async {
    final url = Uri.parse('https://api.alquran.cloud/v1/surah');

    final res = await _client.get(url);

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: gagal ambil data');
    }

    final Map<String, dynamic> jsonMap = json.decode(res.body);

    if (jsonMap['status'] != 'OK') {
      throw Exception('API status = false');
    }

    final data = jsonMap['data'] as List;
    return data.map((e) => e as Map<String, dynamic>).toList();
  }

  // Get surah detail with Arabic text from alquran.cloud API
  Future<Map<String, dynamic>> getSurahDetail(int surahNumber) async {
    final url = Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber');

    final res = await _client.get(url);

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: gagal ambil data');
    }

    final Map<String, dynamic> jsonMap = json.decode(res.body);

    if (jsonMap['status'] != 'OK') {
      throw Exception('API status = false');
    }

    return jsonMap['data'] as Map<String, dynamic>;
  }

  // Get surah with Indonesian translation
  Future<Map<String, dynamic>> getSurahWithTranslation(int surahNumber) async {
    final url = Uri.parse(
      'https://api.alquran.cloud/v1/surah/$surahNumber/id.indonesian',
    );

    final res = await _client.get(url);

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: gagal ambil data');
    }

    final Map<String, dynamic> jsonMap = json.decode(res.body);

    if (jsonMap['status'] != 'OK') {
      throw Exception('API status = false');
    }

    return jsonMap['data'] as Map<String, dynamic>;
  }

  // Get surah with Indonesian transliteration
  Future<Map<String, dynamic>> getSurahWithTransliteration(
    int surahNumber,
  ) async {
    final url = Uri.parse(
      'https://api.alquran.cloud/v1/surah/$surahNumber/id.transliteration',
    );

    final res = await _client.get(url);

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: gagal ambil data');
    }

    final Map<String, dynamic> jsonMap = json.decode(res.body);

    if (jsonMap['status'] != 'OK') {
      throw Exception('API status = false');
    }

    return jsonMap['data'] as Map<String, dynamic>;
  }
}
