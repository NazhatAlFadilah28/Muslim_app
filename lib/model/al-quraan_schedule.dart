import '../data/static_surah_names.dart';

class QuranSurah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;

  QuranSurah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
  });

  // Get Indonesian name
  String get namaIndonesia => SurahNames.getIndonesianName(nomor);

  // Get Indonesian translation meaning
  String get artiIndonesia => SurahNames.getIndonesianTranslation(nomor);

  // From static data
  factory QuranSurah.fromJson(Map<String, dynamic> json) {
    return QuranSurah(
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['nama_latin'] ?? '',
      jumlahAyat: json['jumlah_ayat'] ?? 0,
      tempatTurun: json['tempat_turun'] ?? '',
      arti: json['arti'] ?? '',
    );
  }

  // From alquran.cloud API
  factory QuranSurah.fromJsonAlQuran(Map<String, dynamic> json) {
    return QuranSurah(
      nomor: json['number'] ?? 0,
      nama: json['name'] ?? '',
      namaLatin: json['englishName'] ?? '',
      jumlahAyat: json['numberOfAyahs'] ?? 0,
      tempatTurun: json['revelationType'] ?? '',
      arti: json['englishNameTranslation'] ?? '',
    );
  }
}
