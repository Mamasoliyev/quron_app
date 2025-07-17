import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah_model.dart';

class SurahService {
  Future<List<SurahData>> fetchAllSurahs() async {
    final response = await http.get(
      Uri.parse('https://api.alquran.cloud/v1/surah'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final model = SurahListModel.fromJson(jsonData);
      return model.data;
    } else {
      throw Exception('Suralarni yuklashda xatolik yuz berdi');
    }
  }
}
