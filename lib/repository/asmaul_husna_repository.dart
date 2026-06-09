import '../data/static_asmaul_husna_data.dart';
import '../model/asmaul_husna_model.dart';

class AsmaulHusnaRepository {
  List<AsmaulHusnaModel> getAllAsmaulHusna() {
    final data = StaticAsmaulHusnaData.getAsmaulHusna();
    return data.map((e) => AsmaulHusnaModel.fromJson(e)).toList();
  }
}
