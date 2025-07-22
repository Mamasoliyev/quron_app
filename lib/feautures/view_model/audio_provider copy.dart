import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quron_app/feautures/models/audio_model.dart';
import '../services/audio_service.dart';

class AudioProvider with ChangeNotifier {
  final AudioService _service = AudioService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<AudioModel> _ayahs = [];
  List<AudioModel> get ayahs => _ayahs;

  bool isLoading = false;
  bool isPlaying = false;
  AudioModel? currentAyah;

  Future<void> fetchAudio(int surahNumber) async {
    isLoading = true;
    notifyListeners();

    try {
      _ayahs = await _service.fetchSurah(surahNumber);
    } catch (e) {
      print("Xatolik: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> playAyah(AudioModel ayah) async {
    try {
      if (currentAyah?.number == ayah.number && isPlaying) {
        isPlaying = false;
        notifyListeners();
        await _audioPlayer.pause();
      } else {
        currentAyah = ayah;
        isPlaying = true;

        notifyListeners();
        await _audioPlayer.setUrl(ayah.audio);
        await _audioPlayer.play();
      }
    } catch (e) {
      log("Audio not found: $e");
    } finally {
      stopAudio();
    }
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    isPlaying = false;
    notifyListeners();
  }

  void disposeAudio() {
    _audioPlayer.dispose();
  }
}
