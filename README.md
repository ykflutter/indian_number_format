# indian_number_format

Format numbers the Indian way: lakh/crore grouping, ₹ currency, compact
units, amounts in words and parsing. Pure Dart with no dependencies, so it
works in Flutter (Android, iOS, web, desktop) and in server or CLI apps.

```dart
125000.toIndianFormat();      // 1,25,000
125000.toIndianCurrency();    // ₹1,25,000.00
35000000.toIndianCompact();   // 3.5Cr
125000.toIndianWords();       // One Lakh Twenty Five Thousand
'₹1.5 Cr'.tryParseIndian();   // 15000000
```

## Features

- **Indian grouping**: `12,34,567` instead of `1,234,567`
- **Currency**: `₹1,25,000.00`, `-₹499.50`, or any symbol such as `Rs.`
- **Compact**: `12.5K`, `1.5L`, `3.5Cr`, `3.5 Crore` or `3.5 करोड़`.
  Rounding moves up a unit correctly, so 99,999 shows as `1L` and not `100K`.
- **Amount in words**: `Rupees One Thousand Four Hundred Ninety Nine and Fifty Paise Only`,
  for invoices, receipts and cheques
- **Parsing**: reads `₹1,25,000.50`, `Rs. 2.5 L`, `1.5 Crore` and `१,२५,०००` back into numbers
- **Devanagari digits**: `१,२५,०००`
- **Large numbers**: `int` and `BigInt` keep their full precision
- **Extensions** on `num`, `int` and `String`

## Installation

```yaml
dependencies:
  indian_number_format: ^0.1.0
```

```dart
import 'package:indian_number_format/indian_number_format.dart';
```

## Usage

### Grouping

```dart
IndianNumberFormat.format(1234567);                              // 12,34,567
IndianNumberFormat.format(1234.5, decimals: 2);                  // 1,234.50
IndianNumberFormat.format(1234.5, decimals: 2, trimZeros: true); // 1,234.5
IndianNumberFormat.format(-98765);                               // -98,765
IndianNumberFormat.format(125000, separator: ' ');               // 1 25 000

IndianNumberFormat.formatBigInt(BigInt.parse('123456789012345678901'));
// 12,34,56,78,90,12,34,56,78,901
```

### Currency

```dart
IndianNumberFormat.currency(125000);                 // ₹1,25,000.00
IndianNumberFormat.currency(125000, decimals: 0);    // ₹1,25,000
IndianNumberFormat.currency(-499.5);                 // -₹499.50
IndianNumberFormat.currency(2500, symbol: 'Rs. ');   // Rs. 2,500.00
```

### Compact

```dart
IndianNumberFormat.compact(950);               // 950
IndianNumberFormat.compact(12500);             // 12.5K
IndianNumberFormat.compact(150000);            // 1.5L
IndianNumberFormat.compact(35000000);          // 3.5Cr
IndianNumberFormat.compact(12500000000);       // 1,250Cr
IndianNumberFormat.compact(99999);             // 1L

IndianNumberFormat.compact(35000000, labels: IndianCompactLabels.long);  // 3.5 Crore
IndianNumberFormat.compact(35000000, labels: IndianCompactLabels.hindi); // 3.5 करोड़
```

To use another language, create your own labels:

```dart
const marathi = IndianCompactLabels(
  thousand: 'हजार',
  lakh: 'लाख',
  crore: 'कोटी',
  separator: ' ',
);

IndianNumberFormat.compact(20000000, labels: marathi); // 2 कोटी
```

### Words

```dart
IndianNumberFormat.toWords(125000);
// One Lakh Twenty Five Thousand

IndianNumberFormat.toRupeeWords(1499.50);
// Rupees One Thousand Four Hundred Ninety Nine and Fifty Paise Only

IndianNumberFormat.toRupeeWords(0.75);
// Seventy Five Paise Only

IndianNumberFormat.toRupeeWords(250, currency: 'INR', only: false);
// INR Two Hundred Fifty
```

### Parsing

```dart
IndianNumberFormat.tryParse('1,25,000');       // 125000
IndianNumberFormat.tryParse('₹1,25,000.50');   // 125000.5
IndianNumberFormat.tryParse('Rs. 2.5 L');      // 250000
IndianNumberFormat.tryParse('1.5 Crore');      // 15000000
IndianNumberFormat.tryParse('१,२५,०००');       // 125000
IndianNumberFormat.tryParse('abc');            // null

IndianNumberFormat.parse('abc');               // throws FormatException
```

### Devanagari digits

```dart
IndianNumberFormat.format(125000, devanagari: true); // १,२५,०००
IndianDigits.toDevanagari('₹1,25,000');              // ₹१,२५,०००
IndianDigits.fromDevanagari('१२३');                  // 123
```

### Extensions

```dart
125000.toIndianFormat();       // 1,25,000
125000.toIndianCurrency();     // ₹1,25,000.00
150000.toIndianCompact();      // 1.5L
125000.toIndianWords();        // One Lakh Twenty Five Thousand
1499.5.toRupeeWords();         // Rupees ... and Fifty Paise Only
'₹1,25,000'.tryParseIndian();  // 125000
```

## Notes

- Rounding uses the exact value of the `double`, like Dart's `toStringAsFixed`.
  For money, store paise as an `int` and divide by 100 when formatting.
- A `double` of 10²¹ or more can't be formatted exactly. Pass an `int` or `BigInt` instead.

## Contributing

Issues and pull requests are welcome on
[GitHub](https://github.com/ykflutter/indian_number_format).

## License

MIT
