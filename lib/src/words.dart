const _ones = [
  '',
  'One',
  'Two',
  'Three',
  'Four',
  'Five',
  'Six',
  'Seven',
  'Eight',
  'Nine',
  'Ten',
  'Eleven',
  'Twelve',
  'Thirteen',
  'Fourteen',
  'Fifteen',
  'Sixteen',
  'Seventeen',
  'Eighteen',
  'Nineteen',
];

const _tens = [
  '',
  '',
  'Twenty',
  'Thirty',
  'Forty',
  'Fifty',
  'Sixty',
  'Seventy',
  'Eighty',
  'Ninety',
];

String _belowHundred(int n) {
  if (n < 20) return _ones[n];
  final ten = _tens[n ~/ 10];
  final one = _ones[n % 10];
  return one.isEmpty ? ten : '$ten $one';
}

/// Words for a positive integer in the Indian system. Returns '' for 0.
///
/// Amounts above 99 crore keep counting in crores, the way Indian
/// cheques and invoices write them: 1,00,00,00,000 -> "One Hundred Crore".
String positiveIntToWords(int n) {
  if (n <= 0) return '';

  final parts = <String>[];

  final crore = n ~/ 10000000;
  if (crore > 0) {
    parts.add('${positiveIntToWords(crore)} Crore');
    n %= 10000000;
  }

  final lakh = n ~/ 100000;
  if (lakh > 0) {
    parts.add('${_belowHundred(lakh)} Lakh');
    n %= 100000;
  }

  final thousand = n ~/ 1000;
  if (thousand > 0) {
    parts.add('${_belowHundred(thousand)} Thousand');
    n %= 1000;
  }

  final hundred = n ~/ 100;
  if (hundred > 0) {
    parts.add('${_ones[hundred]} Hundred');
    n %= 100;
  }

  if (n > 0) parts.add(_belowHundred(n));

  return parts.join(' ');
}
