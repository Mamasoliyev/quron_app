import 'package:flutter/material.dart';
import 'package:quron_app/feautures/models/surah_model.dart';
import 'package:quron_app/feautures/services/surah_service.dart'
    show SurahService;

class QuranProvider extends ChangeNotifier {
  bool isLoading = false;
  final SurahService _surahService = SurahService();
  List<SurahData> surahList = [];
  List<SurahData> searchSurahList = [];
  bool isSearch = false;

  String error = "";

  Future<void> getSurahs() async {
    isLoading = true;
    error = "";
    notifyListeners();

    try {
      final result = await _surahService.getSurah();
      surahList = result.data;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void searchSurah(String query) {
    isLoading = true;
    error = "";
    try {
      searchSurahList = surahList.where((surah) {
        final lowerQuery = query.toLowerCase();
        return surah.englishName.toLowerCase().contains(lowerQuery) == true ||
            surah.name.toLowerCase().contains(lowerQuery) == true ||
            surah.englishNameTranslation.toLowerCase().contains(lowerQuery) ==
                true;
      }).toList();
    } catch (e) {
      error = e.toString();
    }
  }
}
