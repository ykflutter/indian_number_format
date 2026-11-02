import 'package:indian_number_format/indian_number_format.dart';

void main() {
  // Grouping
  print(IndianNumberFormat.format(1234567)); // 12,34,567
  print(1234.5.toIndianFormat(decimals: 2)); // 1,234.50

  // Currency
  print(125000.toIndianCurrency()); // ₹1,25,000.00
  print(125000.toIndianCurrency(decimals: 0)); // ₹1,25,000

  // Compact
  print(12500.toIndianCompact()); // 12.5K
  print(150000.toIndianCompact()); // 1.5L
  print(35000000.toIndianCompact(labels: IndianCompactLabels.long)); // 3.5 Crore
  print(35000000.toIndianCompact(labels: IndianCompactLabels.hindi)); // 3.5 करोड़

  // Words (invoices, cheques)
  print(125000.toIndianWords()); // One Lakh Twenty Five Thousand
  print(1499.50.toRupeeWords());
  // Rupees One Thousand Four Hundred Ninety Nine and Fifty Paise Only

  // Parsing
  print('₹1,25,000.50'.tryParseIndian()); // 125000.5
  print('Rs. 2.5 L'.tryParseIndian()); // 250000

  // Devanagari digits
  print(IndianNumberFormat.currency(125000, decimals: 0, devanagari: true));
  // ₹१,२५,०००
}
