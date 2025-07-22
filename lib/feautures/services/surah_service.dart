import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quron_app/feautures/models/surah_model.dart';

//surah
class SurahService {
  final String baseUrl = 'https://api.alquran.cloud/v1';
  Future<SurahModel> getSurah() async {
    final url = Uri.parse("$baseUrl/surah");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SurahModel.fromJson(data);
    } else {
      throw Exception("Suralarni yuklashda xatolik yuz berdi!");
    }
  }

  Future<List<SurahData>> searchSurah(String query) async {
    final surahModel = await getSurah();
    final allSurahs = surahModel.data ;

    return allSurahs.where((surah) {
      final lowerQuery = query.toLowerCase();
      return surah.englishName.toLowerCase().contains(lowerQuery) == true ||
          surah.name.toLowerCase().contains(lowerQuery) == true ||
          surah.englishNameTranslation.toLowerCase().contains(lowerQuery) ==
              true;
    }).toList();
  }
}
