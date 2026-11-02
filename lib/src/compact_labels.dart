/// Unit labels used by [IndianNumberFormat.compact].
///
/// Use one of the presets, or create your own for another language:
///
/// ```dart
/// const marathi = IndianCompactLabels(
///   thousand: 'हजार',
///   lakh: 'लाख',
///   crore: 'कोटी',
///   separator: ' ',
/// );
/// ```
class IndianCompactLabels {
  /// Label for thousands, for example `K`.
  final String thousand;

  /// Label for lakhs (1,00,000), for example `L`.
  final String lakh;

  /// Label for crores (1,00,00,000), for example `Cr`.
  final String crore;

  /// Text placed between the number and the label, for example `' '`.
  final String separator;

  const IndianCompactLabels({
    required this.thousand,
    required this.lakh,
    required this.crore,
    this.separator = '',
  });

  /// `12K`, `1.2L`, `3.5Cr`
  static const short = IndianCompactLabels(
    thousand: 'K',
    lakh: 'L',
    crore: 'Cr',
  );

  /// `12 Thousand`, `1.2 Lakh`, `3.5 Crore`
  static const long = IndianCompactLabels(
    thousand: 'Thousand',
    lakh: 'Lakh',
    crore: 'Crore',
    separator: ' ',
  );

  /// `12 हज़ार`, `1.2 लाख`, `3.5 करोड़`
  static const hindi = IndianCompactLabels(
    thousand: 'हज़ार',
    lakh: 'लाख',
    crore: 'करोड़',
    separator: ' ',
  );
}
