import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quron_app/feautures/models/audio_model.dart';

class AudioService {
  Future<List<AudioModel>> fetchSurah(int surahNumber) async {
    final arabicUrl = Uri.parse(
      'https://api.alquran.cloud/v1/surah/$surahNumber/ar.alafasy',
    );
    final englishUrl = Uri.parse(
      'https://api.alquran.cloud/v1/surah/$surahNumber/en.sahih',
    );
    final uzbekUrl = Uri.parse(
      'https://api.alquran.cloud/v1/surah/$surahNumber/uz.sodik',
    );

    final arabicResponse = await http.get(arabicUrl);
    final englishResponse = await http.get(englishUrl);
    final uzbekResponse = await http.get(uzbekUrl);

    if (arabicResponse.statusCode == 200 &&
        englishResponse.statusCode == 200 &&
        uzbekResponse.statusCode == 200) {
      final arabicData = jsonDecode(arabicResponse.body)['data']['ayahs'];
      final englishData = jsonDecode(englishResponse.body)['data']['ayahs'];
      final uzbekData = jsonDecode(uzbekResponse.body)['data']['ayahs'];

      return List.generate(arabicData.length, (index) {
        return AudioModel.fromJson(
          arabicJson: arabicData[index],
          englishJson: englishData[index],
          uzbekJson: uzbekData[index],
        );
      });
    } else {
      throw Exception("Surah yuklab bo‘lmadi");
    }
  }
}
