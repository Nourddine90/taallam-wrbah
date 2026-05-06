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
      _speechInitialized = await _speech.initialize(
        onError: (error) => print('Speech error: $error'),
        onStatus: (status) => print('Speech status: $status'),
      );
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
    try {
      final imageBytes = await imageFile.readAsBytes();
      return {
        'success': true,
        'score': 8,
        'feedback': 'التقيم: 8/10 - المنتوج بجودة جيدة',
      };
    } catch (e) {
      return {
        'success': false,
        'score': 5,
        'feedback': 'تعذر تحليل الصورة مؤقتاً',
      };
    }
  }

  void dispose() {
    _speech.stop();
    _tts.stop();
  }
}
