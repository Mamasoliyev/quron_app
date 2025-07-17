import 'package:flutter/material.dart';
import '../models/surah_model.dart';
import '../services/surah_service.dart';

class SurahProvider with ChangeNotifier {
  final SurahService _surahService = SurahService();

  List<SurahData> _surahList = [];
  List<SurahData> get surahList => _surahList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadSurahs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _surahList = await _surahService.fetchAllSurahs();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
