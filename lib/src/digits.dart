const _latin = '0123456789';
const _devanagari = '०१२३४५६७८९';

/// Converts between Latin digits (0-9) and Devanagari digits (०-९).
///
/// Other characters, such as commas and the ₹ sign, are left unchanged.
class IndianDigits {
  IndianDigits._();

  /// `"₹1,25,000"` -> `"₹१,२५,०००"`
  static String toDevanagari(String text) => _map(text, _latin, _devanagari);

  /// `"₹१,२५,०००"` -> `"₹1,25,000"`
  static String fromDevanagari(String text) =>
      _map(text, _devanagari, _latin);

  static String _map(String text, String from, String to) {
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      final index = from.indexOf(char);
      buffer.write(index == -1 ? char : to[index]);
    }
    return buffer.toString();
  }
}
