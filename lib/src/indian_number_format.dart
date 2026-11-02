import 'compact_labels.dart';
import 'digits.dart';
import 'grouping.dart';
import 'words.dart';

/// Formats and parses numbers using the Indian numbering system
/// (lakh and crore grouping).
///
/// ```dart
/// IndianNumberFormat.format(125000);          // 1,25,000
/// IndianNumberFormat.currency(125000.5);      // ₹1,25,000.50
/// IndianNumberFormat.compact(35000000);       // 3.5Cr
/// IndianNumberFormat.toWords(125000);         // One Lakh Twenty Five Thousand
/// IndianNumberFormat.tryParse('₹1.5 Cr');     // 15000000
/// ```
class IndianNumberFormat {
  IndianNumberFormat._();

  static const int _thousand = 1000;
  static const int _lakh = 100000;
  static const int _crore = 10000000;

  // ---------------------------------------------------------------------------
  // FORMAT
  // ---------------------------------------------------------------------------

  /// Formats [value] with Indian digit grouping.
  ///
  /// ```dart
  /// IndianNumberFormat.format(1234567);                     // 12,34,567
  /// IndianNumberFormat.format(1234.5, decimals: 2);         // 1,234.50
  /// IndianNumberFormat.format(1234.5, decimals: 2,
  ///     trimZeros: true);                                   // 1,234.5
  /// IndianNumberFormat.format(-98765);                      // -98,765
  /// ```
  ///
  /// [decimals] rounds to that many places. With [trimZeros], trailing zeros
  /// after the decimal point are removed. [separator] replaces the comma, and
  /// [devanagari] writes the digits as ०-९.
  static String format(
    num value, {
    int decimals = 0,
    bool trimZeros = false,
    String separator = ',',
    bool devanagari = false,
  }) {
    final (isNegative, integerPart, rawFraction) =
        splitNumber(value, decimals);
    final fraction = trimZeros ? trimTrailingZeros(rawFraction) : rawFraction;

    final grouped = groupIndianDigits(integerPart, separator: separator);
    final result =
        '${isNegative ? '-' : ''}$grouped${fraction.isEmpty ? '' : '.$fraction'}';

    return devanagari ? IndianDigits.toDevanagari(result) : result;
  }

  /// Formats a [BigInt] with Indian digit grouping, for amounts too large
  /// for an `int` on the web.
  ///
  /// ```dart
  /// IndianNumberFormat.formatBigInt(BigInt.parse('123456789012345678901'));
  /// // 12,34,56,78,90,12,34,56,78,901
  /// ```
  static String formatBigInt(
    BigInt value, {
    String separator = ',',
    bool devanagari = false,
  }) {
    final grouped = groupIndianDigits(
      value.abs().toString(),
      separator: separator,
    );
    final result = '${value.isNegative ? '-' : ''}$grouped';
    return devanagari ? IndianDigits.toDevanagari(result) : result;
  }

  // ---------------------------------------------------------------------------
  // CURRENCY
  // ---------------------------------------------------------------------------

  /// Formats [value] as a currency amount with Indian grouping.
  ///
  /// ```dart
  /// IndianNumberFormat.currency(125000);                    // ₹1,25,000.00
  /// IndianNumberFormat.currency(125000, decimals: 0);       // ₹1,25,000
  /// IndianNumberFormat.currency(-499.5);                    // -₹499.50
  /// IndianNumberFormat.currency(2500, symbol: 'Rs. ');      // Rs. 2,500.00
  /// ```
  static String currency(
    num value, {
    String symbol = '₹',
    int decimals = 2,
    bool trimZeros = false,
    String separator = ',',
    bool devanagari = false,
  }) {
    final formatted = format(
      value,
      decimals: decimals,
      trimZeros: trimZeros,
      separator: separator,
      devanagari: devanagari,
    );
    return formatted.startsWith('-')
        ? '-$symbol${formatted.substring(1)}'
        : '$symbol$formatted';
  }

  // ---------------------------------------------------------------------------
  // COMPACT
  // ---------------------------------------------------------------------------

  /// Shortens [value] using thousand, lakh and crore units.
  ///
  /// ```dart
  /// IndianNumberFormat.compact(950);                        // 950
  /// IndianNumberFormat.compact(12500);                      // 12.5K
  /// IndianNumberFormat.compact(125000);                     // 1.3L
  /// IndianNumberFormat.compact(125000, decimals: 2);        // 1.25L
  /// IndianNumberFormat.compact(35000000,
  ///     labels: IndianCompactLabels.long);                  // 3.5 Crore
  /// IndianNumberFormat.compact(35000000,
  ///     labels: IndianCompactLabels.hindi);                 // 3.5 करोड़
  /// IndianNumberFormat.compact(99999);                      // 1L (not 100K)
  /// ```
  ///
  /// Amounts of 100 crore and more stay in crores with Indian grouping:
  /// `1,250Cr`. [trimZeros] is on by default, so `2.0L` is shown as `2L`.
  static String compact(
    num value, {
    int decimals = 1,
    IndianCompactLabels labels = IndianCompactLabels.short,
    bool trimZeros = true,
    String separator = ',',
    bool devanagari = false,
  }) {
    if (value is double && (value.isNaN || value.isInfinite)) {
      throw ArgumentError.value(value, 'value', 'must be a finite number');
    }
    if (decimals < 0) {
      throw ArgumentError.value(decimals, 'decimals', 'must not be negative');
    }

    final units = <(int, String)>[
      (_crore, labels.crore),
      (_lakh, labels.lakh),
      (_thousand, labels.thousand),
      (1, ''),
    ];

    final abs = value.abs();
    var index = units.indexWhere((unit) => abs >= unit.$1);
    if (index == -1) index = units.length - 1;

    // Move up a unit when rounding reaches the next one:
    // 99,999 -> 100.0K -> 1L, and 999.96 -> 1,000.0 -> 1K.
    while (index > 0) {
      final rounded = _round(abs / units[index].$1, decimals);
      if (rounded * units[index].$1 >= units[index - 1].$1) {
        index--;
      } else {
        break;
      }
    }

    final (unitValue, label) = units[index];
    final scaled = unitValue == 1 ? abs : abs / unitValue;

    final number = format(
      scaled,
      decimals: decimals,
      trimZeros: trimZeros,
      separator: separator,
      devanagari: devanagari,
    );

    final isZero = !number.contains(RegExp('[1-9१-९]'));
    final sign = value < 0 && !isZero ? '-' : '';
    final suffix = label.isEmpty ? '' : '${labels.separator}$label';

    return '$sign$number$suffix';
  }

  static double _round(num value, int decimals) =>
      double.parse(value.toStringAsFixed(decimals));

  // ---------------------------------------------------------------------------
  // WORDS
  // ---------------------------------------------------------------------------

  /// Writes a whole number in words using the Indian system.
  ///
  /// ```dart
  /// IndianNumberFormat.toWords(0);         // Zero
  /// IndianNumberFormat.toWords(125000);    // One Lakh Twenty Five Thousand
  /// IndianNumberFormat.toWords(-42);       // Minus Forty Two
  /// IndianNumberFormat.toWords(1000000000);// One Hundred Crore
  /// ```
  static String toWords(int value) {
    if (value == 0) return 'Zero';
    final words = positiveIntToWords(value.abs());
    return value < 0 ? 'Minus $words' : words;
  }

  /// Writes an amount in words, the way it appears on invoices and cheques.
  ///
  /// The amount is rounded to 2 decimal places for the paise.
  ///
  /// ```dart
  /// IndianNumberFormat.toRupeeWords(125000);
  /// // Rupees One Lakh Twenty Five Thousand Only
  ///
  /// IndianNumberFormat.toRupeeWords(1499.50);
  /// // Rupees One Thousand Four Hundred Ninety Nine and Fifty Paise Only
  ///
  /// IndianNumberFormat.toRupeeWords(0.75);
  /// // Seventy Five Paise Only
  ///
  /// IndianNumberFormat.toRupeeWords(250, currency: 'INR', only: false);
  /// // INR Two Hundred Fifty
  /// ```
  static String toRupeeWords(
    num amount, {
    String currency = 'Rupees',
    String subunit = 'Paise',
    bool only = true,
  }) {
    final (isNegative, integerPart, fraction) = splitNumber(amount, 2);
    final rupees = int.parse(integerPart);
    final paise = int.parse(fraction);

    final parts = <String>[];
    if (rupees > 0 || paise == 0) {
      parts.add(
        '${currency.isEmpty ? '' : '$currency '}${toWords(rupees)}'.trim(),
      );
    }
    if (paise > 0) {
      parts.add('${positiveIntToWords(paise)} $subunit'.trim());
    }

    var result = parts.join(' and ');
    if (only) result = '$result Only';
    return isNegative ? 'Minus $result' : result;
  }

  // ---------------------------------------------------------------------------
  // PARSE
  // ---------------------------------------------------------------------------

  static final RegExp _parsePattern = RegExp(
    r'^(-)?(?:₹|rs\.?|inr)?(-)?((?:\d[\d,]*)?(?:\.\d+)?)'
    r'(k|thousand|l|lac|lacs|lakh|lakhs|cr|crore|crores)?$',
    caseSensitive: false,
  );

  /// Parses an Indian-formatted amount. Returns `null` if [input] is not
  /// a valid number.
  ///
  /// Understands commas, ₹ / Rs. / INR, Devanagari digits and the
  /// K / L / Lakh / Cr / Crore units.
  ///
  /// ```dart
  /// IndianNumberFormat.tryParse('1,25,000');     // 125000
  /// IndianNumberFormat.tryParse('₹1,25,000.50'); // 125000.5
  /// IndianNumberFormat.tryParse('Rs. 2.5 L');    // 250000
  /// IndianNumberFormat.tryParse('1.5 Crore');    // 15000000
  /// IndianNumberFormat.tryParse('१,२५,०००');     // 125000
  /// IndianNumberFormat.tryParse('abc');          // null
  /// ```
  static num? tryParse(String input) {
    final cleaned = IndianDigits.fromDevanagari(input).replaceAll(
      RegExp(r'\s+'),
      '',
    );
    final match = _parsePattern.firstMatch(cleaned);
    if (match == null) return null;

    final numberText = match.group(3)!.replaceAll(',', '');
    if (numberText.isEmpty || numberText == '.') return null;

    final isNegative = match.group(1) != null || match.group(2) != null;
    if (match.group(1) != null && match.group(2) != null) return null;

    final multiplier = switch (match.group(4)?.toLowerCase()) {
      null => 1,
      'k' || 'thousand' => _thousand,
      'l' || 'lac' || 'lacs' || 'lakh' || 'lakhs' => _lakh,
      _ => _crore,
    };

    num result;
    if (!numberText.contains('.')) {
      final whole = int.tryParse(numberText);
      if (whole == null) return null;
      result = whole * multiplier;
    } else {
      final decimal = double.tryParse(numberText);
      if (decimal == null) return null;
      result = decimal * multiplier;
      // 2.5 L -> 250000 as an int rather than 250000.0
      final rounded = result.roundToDouble();
      if ((result - rounded).abs() < 1e-6 && rounded.abs() < 9007199254740992) {
        result = rounded.toInt();
      }
    }

    return isNegative ? -result : result;
  }

  /// Same as [tryParse], but throws a [FormatException] for invalid input.
  static num parse(String input) {
    final result = tryParse(input);
    if (result == null) {
      throw FormatException('Not a valid Indian number', input);
    }
    return result;
  }
}
