import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiAIRepository {
  // Google AI Studio API Key
  static const String _apiKey = 'AIzaSyBP1ZpbesKRr1RrQIFFH4BeJVo372PAzIg';
  static const String _apiUrl =
      'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent';

  bool _isInitialized = false;

  GeminiAIRepository() {
    _isInitialized = _apiKey.isNotEmpty && _apiKey != 'YOUR_GEMINI_API_KEY';
  }

  bool get isConfigured => _isInitialized;

  // Get Tafsir using Google AI Studio REST API
  Future<String> getTafsir({
    required String surahName,
    required int verseNumber,
    required String arabicText,
    required String translation,
  }) async {
    if (!_isInitialized) {
      return _getBasicTafsir(surahName, verseNumber);
    }

    try {
      final prompt =
          '''
Saya ingin mendapatkan tafsir Al-Quran dalam bahasa Indonesia yang lengkap dan mudah dipahami.

Surah: $surahName
Nomor Ayat: $verseNumber
Teks Arab: $arabicText
Terjemahan: $translation

Tolong berikan tafsir yang mencakup:
1. Penjelasan makna ayat
2. Asbabun Nuzul (sebab turun) jika ada
3. Pelajaran yang bisa dipetik dari ayat ini

Tulis dalam 2-3 paragraf yang mengalir dan mudah dipahami.
''';

      final response = await http.post(
        Uri.parse('$_apiUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 1000},
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        }
      } else {
        // Print error for debugging
        print('API Error: ${response.statusCode} - ${response.body}');
      }

      return _getBasicTafsir(surahName, verseNumber);
    } catch (e) {
      print('Exception: $e');
      return _getBasicTafsir(surahName, verseNumber);
    }
  }

  // Basic offline tafsir
  String _getBasicTafsir(String surahName, int verseNumber) {
    final tafsirMap = {
      'Al-Fatihah': {
        1: 'Bismillahirrahmanirrahim. Dengan menyebut nama Allah Yang Mahapemurah lagi Maha Penyayang. Ini adalah kunci pembuka setiap aktivitas seorang muslim.',
        2: 'Alhamdulillahirabbil alamin. Segala puji bagi Allah, Tuhan semesta alam. Pujian ini mencakup semua bentuk syukur kepada Allah SWT.',
        3: 'Arrahmani irrahim. Yang Mahapemurah lagi Maha Penyayang. Kedua sifat Allah menunjukkan kasih sayang Allah kepada seluruh makhluk.',
        4: 'Maliki yawmiddin. YangMahonemuliakan hari kiamat. Iman kepada hari akhir menjadi dasar amal shaleh.',
        5: 'Iyyaka nabudu wa iyyaka nasta\'in. Hanya kepada Engkaulah kami menyembah dan memohon pertolongan.',
        6: 'Ihdinash shirathal mustaqim. Tunjukkanlah kami jalan yang lurus.',
        7: 'Shirathalladzina an\'amta alayhim. Jalan yang mereka anugerahi, bukan jalan yang dimurkai.',
      },
    };

    if (tafsirMap.containsKey(surahName) &&
        tafsirMap[surahName]!.containsKey(verseNumber)) {
      return tafsirMap[surahName]![verseNumber]!;
    }

    return '''
📖 Tafsir Surah $surahName Ayat $verseNumber

Ayat ini merupakan bagian dari Surah $surahName yang mengandung pelajaran penting tentang keimanan dan ketakwaan.

- Keimanan kepada Allah SWT
- Ketakwaan dalam kehidupan  
- Hubungan manusia dengan Allah

💡 Klik tombol Tafsir untuk mendapatkan penjelasan lengkap dari Google AI.
''';
  }

  // Get verse explanation
  Future<String> getVerseExplanation({
    required String surahName,
    required int verseNumber,
    required String arabicText,
  }) async {
    if (!_isInitialized) {
      return 'Penjelasan tidak tersedia. Sambungkan API.';
    }

    try {
      final prompt =
          '''
Jelaskan makna dan hikmah dari ayat Al-Quran berikut:

Surah: $surahName
Ayat ke-$verseNumber
Arab: $arabicText

Berikan penjelasan dalam bahasa Indonesia.
''';

      final response = await http.post(
        Uri.parse('$_apiUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ??
            'Penjelasan tidak tersedia';
      }

      return 'Gagal mendapatkan penjelasan';
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Get additional context
  Future<String> getAdditionalContext({
    required String surahName,
    required int verseNumber,
  }) async {
    if (!_isInitialized) {
      return 'Informasi tidak tersedia.';
    }

    return 'Konteks unavailable';
  }
}
