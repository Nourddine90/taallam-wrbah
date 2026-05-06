import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';

class AIService {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _speechInitialized = false;

  AIService() {
    _initTTS();
  }

  Future<void> _initTTS() async {
    await _tts.setLanguage('ar');
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
  }

  Future<bool> initializeSpeech() async {
    if (!_speechInitialized) {
      _speechInitialized = await _speech.initialize();
    }
    return _speechInitialized;
  }

  Future<String> listenToUser() async {
    if (!_speechInitialized) await initializeSpeech();
    String result = '';
    await _speech.listen(
      onResult: (val) => result = val.recognizedWords,
      localeId: 'ar_MA',
    );
    await Future.delayed(const Duration(seconds: 3));
    await _speech.stop();
    return result;
  }

  Future<Map<String, dynamic>> analyzeProductImage(File imageFile) async {
    return {
      'success': true,
      'score': 8,
      'feedback': 'التقييم: 8/10',
    };
  }

  void dispose() {
    _speech.stop();
    _tts.stop();
  }
}
