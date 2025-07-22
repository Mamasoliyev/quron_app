class SurahModel {
  final int code;
  final String status;
  final List<SurahData> data;

  SurahModel({
    required this.code,
    required this.status,
    required this.data,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      code: json['code'],
      status: json['status'],
      data: List<SurahData>.from(
        json['data'].map((x) => SurahData.fromJson(x)),
      ),
    );
  }
}

class SurahData {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  SurahData({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory SurahData.fromJson(Map<String, dynamic> json) {
    return SurahData(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      numberOfAyahs: json['numberOfAyahs'],
      revelationType: json['revelationType'],
    );
  }
}
