import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quron_app/feautures/models/audio_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurahBookmarkProvider extends ChangeNotifier {
  Future<void> saveSurahAyahs(int surahNumber, String surahName, String surahEnglishName, List<AudioModel> ayahs) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = ayahs.map((a) => jsonEncode(a.toMap())).toList();
    await prefs.setStringList('surah_$surahNumber', jsonList);
    await prefs.setString('surah_${surahNumber}_name', surahName);
    await prefs.setString('surah_${surahNumber}_english_name', surahEnglishName);
    notifyListeners();
  }

  Future<void> removeSurahAyahs(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('surah_$surahNumber');
    await prefs.remove('surah_${surahNumber}_name');
    await prefs.remove('surah_${surahNumber}_english_name');
    notifyListeners();
  }

  Future<bool> isSurahBookmarked(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('surah_$surahNumber');
  }

  Future<List<AudioModel>> getBookmarkedSurah(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('surah_$surahNumber') ?? [];
    return jsonList.map((e) => AudioModel.fromMap(jsonDecode(e))).toList();
  }

  Future<Map<String, dynamic>> getBookmarkedSurahDetails(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('surah_$surahNumber') ?? [];
    final surahName = prefs.getString('surah_${surahNumber}_name') ?? '';
    final surahEnglishName = prefs.getString('surah_${surahNumber}_english_name') ?? '';
    final ayahs = jsonList.map((e) => AudioModel.fromMap(jsonDecode(e))).toList();
    return {
      'surahNumber': surahNumber,
      'surahName': surahName,
      'surahEnglishName': surahEnglishName,
      'ayahs': ayahs,
    };
  }

  Future<Map<int, Map<String, dynamic>>> getBookmarkedSurahs() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final bookmarkedSurahs = <int, Map<String, dynamic>>{};

    for (var key in keys) {
      if (key.startsWith('surah_') && !key.contains('_name') && !key.contains('_english_name')) {
        final surahNumber = int.tryParse(key.split('_')[1]);
        final jsonList = prefs.getStringList(key);
        final surahName = prefs.getString('surah_${surahNumber}_name') ?? '';
        final surahEnglishName = prefs.getString('surah_${surahNumber}_english_name') ?? '';
        if (surahNumber != null && jsonList != null) {
          final ayahs = jsonList
              .map((e) => AudioModel.fromMap(jsonDecode(e)))
              .toList();
          bookmarkedSurahs[surahNumber] = {
            'surahName': surahName,
            'surahEnglishName': surahEnglishName,
            'ayahs': ayahs,
          };
        }
      }
    }

    return bookmarkedSurahs;
  }
}
