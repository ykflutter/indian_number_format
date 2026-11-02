/// Groups a string of plain digits the Indian way.
///
/// The last three digits form one group, every group before that has two:
/// `125000` -> `1,25,000`, `1234567890` -> `1,23,45,67,890`.
String groupIndianDigits(String digits, {String separator = ','}) {
  if (digits.length <= 3) return digits;

  final lastThree = digits.substring(digits.length - 3);
  var rest = digits.substring(0, digits.length - 3);

  final groups = <String>[];
  while (rest.length > 2) {
    groups.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) groups.insert(0, rest);

  return '${groups.join(separator)}$separator$lastThree';
}

/// Splits [value] into its integer digits and fraction digits after rounding
/// to [decimals] places, without going through scientific notation.
///
/// Returns `(isNegative, integerDigits, fractionDigits)`. The sign is dropped
/// when the rounded value is zero, so `-0.001` with 0 decimals is not `-0`.
(bool, String, String) splitNumber(num value, int decimals) {
  if (decimals < 0) {
    throw ArgumentError.value(decimals, 'decimals', 'must not be negative');
  }
  if (value is double && (value.isNaN || value.isInfinite)) {
    throw ArgumentError.value(value, 'value', 'must be a finite number');
  }

  String integerPart;
  String fractionPart;

  if (value is int) {
    // Keep full precision for big ints instead of converting to double.
    integerPart = value.abs().toString();
    fractionPart = '0' * decimals;
  } else {
    final abs = value.abs();
    if (abs >= 1e21) {
      throw ArgumentError.value(
        value,
        'value',
        'is too large to format as a double; pass an int or BigInt instead',
      );
    }
    final fixed = abs.toStringAsFixed(decimals);
    final dot = fixed.indexOf('.');
    integerPart = dot == -1 ? fixed : fixed.substring(0, dot);
    fractionPart = dot == -1 ? '' : fixed.substring(dot + 1);
  }

  final isZero = !'$integerPart$fractionPart'.contains(RegExp('[1-9]'));
  final isNegative = value < 0 && !isZero;

  return (isNegative, integerPart, fractionPart);
}

/// Removes trailing zeros from a fraction string: `"500"` -> `"5"`, `"00"` -> `""`.
String trimTrailingZeros(String fraction) =>
    fraction.replaceFirst(RegExp(r'0+$'), '');
