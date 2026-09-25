/// Baut aus den Zwischenergebnissen der Spracherkennung eine Liste von
/// Gedanken – einer pro Zeile.
///
/// iOS beginnt nach einer Sprechpause intern einen neuen Abschnitt: das
/// Zwischenergebnis fängt dann wieder fast leer an. Das erkennen wir und
/// übernehmen den vorherigen Abschnitt als eigene Zeile (sonst ginge er
/// verloren). Zusätzlich wird an Satzenden (. ! ?) getrennt.
class TranscriptBuilder {
  TranscriptBuilder([String existing = '']) {
    final text = existing.trim();
    if (text.isNotEmpty) _lines.add(text);
  }

  final List<String> _lines = [];
  String _segment = '';

  /// Aktueller Text für das Eingabefeld.
  String get text => [..._lines, ..._split(_segment)].join('\n');

  void add(String recognized, {required bool isFinal}) {
    final next = recognized.trim();
    if (_isNewSegment(_segment, next)) _commit();
    _segment = next;
    if (isFinal) _commit();
  }

  static bool _isNewSegment(String previous, String next) {
    if (previous.isEmpty) return false;
    // Korrekturen der Erkennung ändern meist nur die letzten Wörter; ein
    // Einbruch auf weniger als die Hälfte heißt: neuer Abschnitt.
    return next.length < previous.length / 2;
  }

  void _commit() {
    _lines.addAll(_split(_segment));
    _segment = '';
  }

  static List<String> _split(String text) => text
      .split(RegExp(r'(?<=[.!?])\s+'))
      .map((s) => s.trim())
      .map((s) => s.endsWith('.') ? s.substring(0, s.length - 1) : s)
      .where((s) => s.isNotEmpty)
      .map((s) => s[0].toUpperCase() + s.substring(1))
      .toList();
}
