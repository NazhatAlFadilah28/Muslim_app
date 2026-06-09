import 'package:flutter/foundation.dart';

import '../model/al-quraan_schedule.dart';
import '../repository/al-quraan_repository.dart';
import '../repository/gemini_ai_repository.dart';
import '../data/static_data.dart';
import '../data/static_surah_names.dart';

class AlQuranViewModel extends ChangeNotifier {
  final AlQuranRepository _repo;
  final GeminiAIRepository _geminiRepo;

  AlQuranViewModel(this._repo, this._geminiRepo);

  bool _isLoading = false;
  bool _isAILoading = false;
  String? _error;
  List<QuranSurah> _surahs = [];
  Map<String, dynamic>? _selectedSurah;
  List<dynamic>? _selectedAyats;

  // AI features
  final Map<int, String> _tafsirCache = {};
  String? _currentTafsir;
  int? _selectedVerseForTafsir;

  bool get isLoading => _isLoading;
  bool get isAILoading => _isAILoading;
  String? get error => _error;
  List<QuranSurah> get surahs => _surahs;
  Map<String, dynamic>? get selectedSurah => _selectedSurah;
  List<dynamic>? get selectedAyats => _selectedAyats;
  String? get currentTafsir => _currentTafsir;
  int? get selectedVerseForTafsir => _selectedVerseForTafsir;
  bool get isAIConfigured => _geminiRepo.isConfigured;

  // Load surahs from API or fallback to static data
  Future<void> fetchAllSurah() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to fetch from API first
      final apiData = await _repo.getAllSurah();
      _surahs = apiData.map((e) {
        final surah = QuranSurah.fromJsonAlQuran(e);
        // Override with Indonesian name if available
        return QuranSurah(
          nomor: surah.nomor,
          nama: surah.nama,
          namaLatin: SurahNames.getIndonesianName(surah.nomor),
          jumlahAyat: surah.jumlahAyat,
          tempatTurun: surah.tempatTurun,
          arti: SurahNames.getIndonesianTranslation(surah.nomor),
        );
      }).toList();
    } catch (e) {
      // Fallback to static data if API fails
      _surahs = QuranSurahData.surahs
          .map((e) => QuranSurah.fromJson(e))
          .toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get surah detail with Arabic and Indonesian translation
  Future<void> fetchSurahDetail(int surahNumber) async {
    _isLoading = true;
    _error = null;
    _tafsirCache.clear();
    _currentTafsir = null;
    _selectedVerseForTafsir = null;
    notifyListeners();

    try {
      // Get Arabic data
      final arabicData = await _repo.getSurahDetail(surahNumber);
      // Get Indonesian translation data
      final translationData = await _repo.getSurahWithTranslation(surahNumber);

      _selectedSurah = arabicData;

      // Get ayahs from both APIs
      final arabicAyats = arabicData['ayahs'] as List<dynamic>? ?? [];
      final translationAyats = translationData['ayahs'] as List<dynamic>? ?? [];

      // Combine Arabic text with Indonesian translation
      _selectedAyats = [];
      for (int i = 0; i < arabicAyats.length; i++) {
        final arabicAyah = arabicAyats[i];
        final translationAyah = i < translationAyats.length
            ? translationAyats[i]
            : {};

        _selectedAyats!.add({
          'numberInSurah': arabicAyah['numberInSurah'],
          'text': arabicAyah['text'], // Arabic text
          // Indonesian translation - API returns in 'text' field for id.indonesian
          'translation':
              translationAyah['text'] ?? translationAyah['translation'] ?? '',
        });
      }
    } catch (e) {
      // Fallback to Arabic only
      try {
        final data = await _repo.getSurahDetail(surahNumber);
        _selectedSurah = data;
        _selectedAyats = data['ayahs'] as List<dynamic>?;
      } catch (e2) {
        _error = e2.toString();
        _selectedSurah = null;
        _selectedAyats = null;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get Tafsir for a specific verse using Gemini AI
  Future<void> getTafsirForVerse(int verseNumber) async {
    if (_selectedSurah == null || _selectedAyats == null) return;

    // Check cache first
    if (_tafsirCache.containsKey(verseNumber)) {
      _currentTafsir = _tafsirCache[verseNumber];
      _selectedVerseForTafsir = verseNumber;
      notifyListeners();
      return;
    }

    _isAILoading = true;
    _selectedVerseForTafsir = verseNumber;
    _currentTafsir = null;
    notifyListeners();

    try {
      final surahName = _selectedSurah!['englishName'] ?? '';
      final arabicText =
          _selectedAyats!.firstWhere(
            (a) => a['numberInSurah'] == verseNumber,
          )['text'] ??
          '';
      final translation =
          _selectedAyats!.firstWhere(
            (a) => a['numberInSurah'] == verseNumber,
          )['translation'] ??
          '';

      final tafsir = await _geminiRepo.getTafsir(
        surahName: surahName,
        verseNumber: verseNumber,
        arabicText: arabicText,
        translation: translation,
      );

      _tafsirCache[verseNumber] = tafsir;
      _currentTafsir = tafsir;
    } catch (e) {
      _currentTafsir = 'Gagal mendapatkan tafsir: $e';
    } finally {
      _isAILoading = false;
      notifyListeners();
    }
  }

  // Clear current tafsir
  void clearTafsir() {
    _currentTafsir = null;
    _selectedVerseForTafsir = null;
    notifyListeners();
  }

  void clearSelectedSurah() {
    _selectedSurah = null;
    _selectedAyats = null;
    _tafsirCache.clear();
    _currentTafsir = null;
    _selectedVerseForTafsir = null;
    notifyListeners();
  }
}
