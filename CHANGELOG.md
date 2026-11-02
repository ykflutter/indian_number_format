## 0.1.0

- Initial release.
- `IndianNumberFormat.format`: lakh/crore digit grouping, decimals, custom separator.
- `IndianNumberFormat.formatBigInt` for very large amounts.
- `IndianNumberFormat.currency`: ₹ amounts with any symbol.
- `IndianNumberFormat.compact`: 12.5K, 1.5L, 3.5Cr with short, long, Hindi or custom labels.
- `IndianNumberFormat.toWords` and `toRupeeWords` for invoices and cheques.
- `IndianNumberFormat.tryParse` / `parse`: reads ₹, Rs., INR, commas, K/L/Cr units and Devanagari digits.
- `IndianDigits`: convert between 0-9 and ०-९.
- Extensions on `num`, `int` and `String`.
