import 'package:flutter/foundation.dart';

import '../model/doa_model.dart';
import '../repository/doa_repository.dart';

class DoaViewModel extends ChangeNotifier {
  final DoaRepository _repository = DoaRepository();

  bool _isLoading = false;
  String? _error;
  List<DoaModel> _doas = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<DoaModel> get doas => _doas;

  Future<void> fetchDoas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.getAllDoa();
      _doas = response.map((e) => DoaModel.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<DoaModel> getFilteredDoas(String query) {
    if (query.isEmpty) return _doas;
    return _doas.where((doa) {
      return doa.nama.toLowerCase().contains(query.toLowerCase()) ||
          doa.doa.toLowerCase().contains(query.toLowerCase()) ||
          doa.artinya.toLowerCase().contains(query.toLowerCase()) ||
          (doa.latin.isNotEmpty &&
              doa.latin.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }
}
