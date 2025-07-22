class AudioModel {
  final int number;
  final String arabicText;
  final String englishText;
  final String uzbekText;
  final String audio;

  AudioModel({
    required this.number,
    required this.arabicText,
    required this.englishText,
    required this.uzbekText,
    required this.audio,
  });

  factory AudioModel.fromJson({
    required Map<String, dynamic> arabicJson,
    required Map<String, dynamic> englishJson,
    required Map<String, dynamic> uzbekJson,
  }) {
    return AudioModel(
      number: arabicJson['numberInSurah'],
      arabicText: arabicJson['text'],
      englishText: englishJson['text'],
      uzbekText: uzbekJson['text'],
      audio: arabicJson['audio'],
    );
  }

  factory AudioModel.fromMap(Map<String, dynamic> json) {
    return AudioModel(
      number: json['number'],
      arabicText: json['arabicText'],
      englishText: json['englishText'],
      uzbekText: json['uzbekText'],
      audio: json['audio'],
    );
  }

  Map<String, dynamic> toMap() => {
    'number': number,
    'arabicText': arabicText,
    'englishText': englishText,
    'uzbekText': uzbekText,
    'audio': audio,
  };
  @override
  String toString() {
    return 'AudioModel(number: $number, arabicText: $arabicText, englishText: $englishText, uzbekText: $uzbekText, audio: $audio)';
  }
}
