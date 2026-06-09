import 'package:flutter/foundation.dart';
import '../model/asmaul_husna_model.dart';
import '../repository/asmaul_husna_repository.dart';

class AsmaulHusnaViewModel extends ChangeNotifier {
  final AsmaulHusnaRepository _repository = AsmaulHusnaRepository();

  List<AsmaulHusnaModel> _asmaulHusna = [];
  bool _isLoading = false;

  List<AsmaulHusnaModel> getAsmaulHusnaList() => _asmaulHusna;
  bool get isLoading => _isLoading;

  void fetchAsmaulHusna() {
    _isLoading = true;
    notifyListeners();

    _asmaulHusna = _repository.getAllAsmaulHusna();
    _isLoading = false;
    notifyListeners();
  }

  List<AsmaulHusnaModel> getFilteredAsmaulHusna(String query) {
    if (query.isEmpty) return _asmaulHusna;
    return _asmaulHusna.where((asmaul) {
      bool matchesLatin = asmaul.latin.toLowerCase().contains(
        query.toLowerCase(),
      );
      bool matchesArti = asmaul.artinya.toLowerCase().contains(
        query.toLowerCase(),
      );
      return matchesLatin || matchesArti;
    }).toList();
  }
}
