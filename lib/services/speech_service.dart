import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Dünner Wrapper um speech_to_text, damit die UI nichts vom Plugin weiß.
class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _available = false;
  void Function()? _onDone;

  bool get isListening => _speech.isListening;

  /// Fragt beim ersten Aufruf die Mikrofon-/Spracherkennungs-Berechtigung an.
  Future<bool> init() async {
    _available = await _speech.initialize(
      onError: (_) => _finish(),
      onStatus: (status) {
        if (status == stt.SpeechToText.doneStatus ||
            status == stt.SpeechToText.notListeningStatus) {
          _finish();
        }
      },
    );
    return _available;
  }

  void _finish() {
    final cb = _onDone;
    _onDone = null;
    cb?.call();
  }

  /// onResult liefert den erkannten Text und ob es ein finales Ergebnis ist.
  /// onDone wird aufgerufen, sobald die Erkennung von selbst endet.
  /// Liefert false, wenn Spracherkennung nicht verfügbar/erlaubt ist.
  Future<bool> start({
    required void Function(String text, bool isFinal) onResult,
    required String localeId,
    void Function()? onDone,
  }) async {
    if (!_available) {
      final ok = await init();
      if (!ok) return false;
    }
    _onDone = onDone;
    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      listenOptions: stt.SpeechListenOptions(
        localeId: localeId,
        listenFor: const Duration(minutes: 5),
        pauseFor: const Duration(seconds: 4),
        partialResults: true,
        cancelOnError: true,
      ),
    );
    return true;
  }

  Future<void> stop() async {
    _onDone = null;
    await _speech.stop();
  }
}
