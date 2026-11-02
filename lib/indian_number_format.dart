/// Format numbers the Indian way: lakh/crore grouping, ₹ currency,
/// compact units (1.2L, 3.5Cr), amounts in words and parsing.
library;

export 'src/compact_labels.dart' show IndianCompactLabels;
export 'src/digits.dart' show IndianDigits;
export 'src/extensions.dart';
export 'src/indian_number_format.dart' show IndianNumberFormat;
