import 'package:indian_number_format/indian_number_format.dart';
import 'package:test/test.dart';

void main() {
  group('format', () {
    test('groups digits the Indian way', () {
      expect(IndianNumberFormat.format(0), '0');
      expect(IndianNumberFormat.format(999), '999');
      expect(IndianNumberFormat.format(1000), '1,000');
      expect(IndianNumberFormat.format(125000), '1,25,000');
      expect(IndianNumberFormat.format(1234567), '12,34,567');
      expect(IndianNumberFormat.format(1234567890), '1,23,45,67,890');
    });

    test('handles negatives', () {
      expect(IndianNumberFormat.format(-98765), '-98,765');
    });

    test('rounds and pads decimals', () {
      expect(IndianNumberFormat.format(1234.5, decimals: 2), '1,234.50');
      expect(IndianNumberFormat.format(1234.5678, decimals: 2), '1,234.57');
    });

    test('trims trailing zeros', () {
      expect(
        IndianNumberFormat.format(1234.5, decimals: 2, trimZeros: true),
        '1,234.5',
      );
      expect(
        IndianNumberFormat.format(1234.0, decimals: 2, trimZeros: true),
        '1,234',
      );
    });

    test('does not show negative zero', () {
      expect(IndianNumberFormat.format(-0.001), '0');
      expect(IndianNumberFormat.format(-0.004, decimals: 2), '0.00');
    });

    test('custom separator and Devanagari digits', () {
      expect(IndianNumberFormat.format(125000, separator: ' '), '1 25 000');
      expect(IndianNumberFormat.format(125000, devanagari: true), '१,२५,०००');
    });

    test('BigInt', () {
      expect(
        IndianNumberFormat.formatBigInt(BigInt.parse('123456789012345678901')),
        '12,34,56,78,90,12,34,56,78,901',
      );
      expect(IndianNumberFormat.formatBigInt(BigInt.from(-125000)), '-1,25,000');
    });

    test('rejects invalid input', () {
      expect(() => IndianNumberFormat.format(double.nan), throwsArgumentError);
      expect(
        () => IndianNumberFormat.format(double.infinity),
        throwsArgumentError,
      );
      expect(
        () => IndianNumberFormat.format(1, decimals: -1),
        throwsArgumentError,
      );
    });
  });

  group('currency', () {
    test('default rupee format', () {
      expect(IndianNumberFormat.currency(125000), '₹1,25,000.00');
      expect(IndianNumberFormat.currency(125000, decimals: 0), '₹1,25,000');
    });

    test('negative sign goes before the symbol', () {
      expect(IndianNumberFormat.currency(-499.5), '-₹499.50');
    });

    test('custom symbol and trimming', () {
      expect(
        IndianNumberFormat.currency(2500, symbol: 'Rs. '),
        'Rs. 2,500.00',
      );
      expect(
        IndianNumberFormat.currency(1999.0, trimZeros: true),
        '₹1,999',
      );
    });
  });

  group('compact', () {
    test('small numbers stay as they are', () {
      expect(IndianNumberFormat.compact(0), '0');
      expect(IndianNumberFormat.compact(950), '950');
      expect(IndianNumberFormat.compact(999.4), '999.4');
    });

    test('thousand, lakh and crore', () {
      expect(IndianNumberFormat.compact(1000), '1K');
      expect(IndianNumberFormat.compact(12500), '12.5K');
      expect(IndianNumberFormat.compact(150000), '1.5L');
      expect(IndianNumberFormat.compact(1550000), '15.5L');
      expect(IndianNumberFormat.compact(200000), '2L');
      expect(IndianNumberFormat.compact(35000000), '3.5Cr');
      expect(IndianNumberFormat.compact(125000, decimals: 2), '1.25L');
    });

    test('moves up a unit when rounding reaches it', () {
      expect(IndianNumberFormat.compact(999.96), '1K');
      expect(IndianNumberFormat.compact(99999), '1L');
      expect(IndianNumberFormat.compact(9999999), '1Cr');
    });

    test('stays in crores above 100 crore', () {
      expect(IndianNumberFormat.compact(12500000000), '1,250Cr');
    });

    test('negatives and zero', () {
      expect(IndianNumberFormat.compact(-150000), '-1.5L');
      expect(IndianNumberFormat.compact(-0.01), '0');
    });

    test('label presets', () {
      expect(
        IndianNumberFormat.compact(35000000, labels: IndianCompactLabels.long),
        '3.5 Crore',
      );
      expect(
        IndianNumberFormat.compact(150000, labels: IndianCompactLabels.long),
        '1.5 Lakh',
      );
      expect(
        IndianNumberFormat.compact(35000000, labels: IndianCompactLabels.hindi),
        '3.5 करोड़',
      );
    });

    test('custom labels', () {
      const marathi = IndianCompactLabels(
        thousand: 'हजार',
        lakh: 'लाख',
        crore: 'कोटी',
        separator: ' ',
      );
      expect(IndianNumberFormat.compact(20000000, labels: marathi), '2 कोटी');
    });

    test('keeps zeros when trimZeros is false', () {
      expect(IndianNumberFormat.compact(200000, trimZeros: false), '2.0L');
    });
  });

  group('toWords', () {
    test('basic numbers', () {
      expect(IndianNumberFormat.toWords(0), 'Zero');
      expect(IndianNumberFormat.toWords(5), 'Five');
      expect(IndianNumberFormat.toWords(15), 'Fifteen');
      expect(IndianNumberFormat.toWords(40), 'Forty');
      expect(IndianNumberFormat.toWords(99), 'Ninety Nine');
      expect(IndianNumberFormat.toWords(100), 'One Hundred');
      expect(IndianNumberFormat.toWords(101), 'One Hundred One');
      expect(IndianNumberFormat.toWords(1000), 'One Thousand');
    });

    test('lakh and crore', () {
      expect(
        IndianNumberFormat.toWords(125000),
        'One Lakh Twenty Five Thousand',
      );
      expect(IndianNumberFormat.toWords(10000000), 'One Crore');
      expect(
        IndianNumberFormat.toWords(123456789),
        'Twelve Crore Thirty Four Lakh Fifty Six Thousand '
        'Seven Hundred Eighty Nine',
      );
    });

    test('above 99 crore keeps counting in crores', () {
      expect(IndianNumberFormat.toWords(1000000000), 'One Hundred Crore');
    });

    test('negative', () {
      expect(IndianNumberFormat.toWords(-42), 'Minus Forty Two');
    });
  });

  group('toRupeeWords', () {
    test('whole rupees', () {
      expect(
        IndianNumberFormat.toRupeeWords(125000),
        'Rupees One Lakh Twenty Five Thousand Only',
      );
      expect(IndianNumberFormat.toRupeeWords(0), 'Rupees Zero Only');
    });

    test('rupees and paise', () {
      expect(
        IndianNumberFormat.toRupeeWords(1499.50),
        'Rupees One Thousand Four Hundred Ninety Nine and Fifty Paise Only',
      );
      expect(
        IndianNumberFormat.toRupeeWords(10.05),
        'Rupees Ten and Five Paise Only',
      );
    });

    test('only paise', () {
      expect(
        IndianNumberFormat.toRupeeWords(0.75),
        'Seventy Five Paise Only',
      );
    });

    test('options and negatives', () {
      expect(
        IndianNumberFormat.toRupeeWords(250, currency: 'INR', only: false),
        'INR Two Hundred Fifty',
      );
      expect(
        IndianNumberFormat.toRupeeWords(-100),
        'Minus Rupees One Hundred Only',
      );
    });
  });

  group('parse', () {
    test('plain and grouped numbers', () {
      expect(IndianNumberFormat.tryParse('1,25,000'), 125000);
      expect(IndianNumberFormat.tryParse('.5'), 0.5);
    });

    test('currency symbols', () {
      expect(IndianNumberFormat.tryParse('₹1,25,000.50'), 125000.5);
      expect(IndianNumberFormat.tryParse('-₹500'), -500);
      expect(IndianNumberFormat.tryParse('₹-500'), -500);
    });

    test('units', () {
      expect(IndianNumberFormat.tryParse('12K'), 12000);
      expect(IndianNumberFormat.tryParse('Rs. 2.5 L'), 250000);
      expect(IndianNumberFormat.tryParse('INR 3 lakhs'), 300000);
      expect(IndianNumberFormat.tryParse('1.5 Crore'), 15000000);
      expect(IndianNumberFormat.tryParse('2.35Cr'), 23500000);
    });

    test('returns int when the result is whole', () {
      expect(IndianNumberFormat.tryParse('2.5 L'), isA<int>());
    });

    test('Devanagari digits', () {
      expect(IndianNumberFormat.tryParse('१,२५,०००'), 125000);
    });

    test('invalid input', () {
      expect(IndianNumberFormat.tryParse('abc'), isNull);
      expect(IndianNumberFormat.tryParse(''), isNull);
      expect(IndianNumberFormat.tryParse('L'), isNull);
      expect(IndianNumberFormat.tryParse('1.2.3'), isNull);
      expect(IndianNumberFormat.tryParse('-₹-5'), isNull);
      expect(() => IndianNumberFormat.parse('abc'), throwsFormatException);
    });
  });

  group('IndianDigits', () {
    test('converts both ways', () {
      expect(IndianDigits.toDevanagari('₹1,25,000'), '₹१,२५,०००');
      expect(IndianDigits.fromDevanagari('₹१,२५,०००'), '₹1,25,000');
    });
  });

  group('extensions', () {
    test('num', () {
      expect(125000.toIndianFormat(), '1,25,000');
      expect(125000.toIndianCurrency(), '₹1,25,000.00');
      expect(35000000.toIndianCompact(), '3.5Cr');
      expect(10.05.toRupeeWords(), 'Rupees Ten and Five Paise Only');
    });

    test('int and String', () {
      expect(125000.toIndianWords(), 'One Lakh Twenty Five Thousand');
      expect('₹1,25,000'.tryParseIndian(), 125000);
    });
  });
}
