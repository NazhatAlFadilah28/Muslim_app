import '../data/static_doa_data.dart';

class DoaRepository {
  // Get all daily doas from static data
  Future<List<Map<String, dynamic>>> getAllDoa() async {
    // Simulate network delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));
    return StaticDoaData.doas.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
