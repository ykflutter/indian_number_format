import 'compact_labels.dart';
import 'indian_number_format.dart';

/// Shortcuts on numbers.
///
/// ```dart
/// 125000.toIndianFormat();     // 1,25,000
/// 125000.toIndianCurrency();   // ₹1,25,000.00
/// 35000000.toIndianCompact();  // 3.5Cr
/// 1499.5.toRupeeWords();       // Rupees One Thousand ... and Fifty Paise Only
/// ```
extension IndianNumberFormatNum on num {
  /// See [IndianNumberFormat.format].
  String toIndianFormat({
    int decimals = 0,
    bool trimZeros = false,
    String separator = ',',
    bool devanagari = false,
  }) =>
      IndianNumberFormat.format(
        this,
        decimals: decimals,
        trimZeros: trimZeros,
        separator: separator,
        devanagari: devanagari,
      );

  /// See [IndianNumberFormat.currency].
  String toIndianCurrency({
    String symbol = '₹',
    int decimals = 2,
    bool trimZeros = false,
    String separator = ',',
    bool devanagari = false,
  }) =>
      IndianNumberFormat.currency(
        this,
        symbol: symbol,
        decimals: decimals,
        trimZeros: trimZeros,
        separator: separator,
        devanagari: devanagari,
      );

  /// See [IndianNumberFormat.compact].
  String toIndianCompact({
    int decimals = 1,
    IndianCompactLabels labels = IndianCompactLabels.short,
    bool trimZeros = true,
    String separator = ',',
    bool devanagari = false,
  }) =>
      IndianNumberFormat.compact(
        this,
        decimals: decimals,
        labels: labels,
        trimZeros: trimZeros,
        separator: separator,
        devanagari: devanagari,
      );

  /// See [IndianNumberFormat.toRupeeWords].
  String toRupeeWords({
    String currency = 'Rupees',
    String subunit = 'Paise',
    bool only = true,
  }) =>
      IndianNumberFormat.toRupeeWords(
        this,
        currency: currency,
        subunit: subunit,
        only: only,
      );
}

/// Shortcuts on whole numbers.
extension IndianNumberFormatInt on int {
  /// See [IndianNumberFormat.toWords].
  ///
  /// ```dart
  /// 125000.toIndianWords(); // One Lakh Twenty Five Thousand
  /// ```
  String toIndianWords() => IndianNumberFormat.toWords(this);
}

/// Shortcuts on strings.
extension IndianNumberFormatString on String {
  /// See [IndianNumberFormat.tryParse].
  ///
  /// ```dart
  /// '₹1,25,000'.tryParseIndian(); // 125000
  /// ```
  num? tryParseIndian() => IndianNumberFormat.tryParse(this);
}
