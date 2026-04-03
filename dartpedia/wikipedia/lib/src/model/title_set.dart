/// Модель для заголовков статьи из Wikipedia API
class TitlesSet {
  TitlesSet({
    required this.canonical,
    required this.normalized,
    required this.display,
  });

  /// Ключ базы данных (с _ вместо пробелов)
  final String canonical;

  /// Нормализованный заголовок (с пробелами вместо _)
  final String normalized;

  /// Заголовок для отображения пользователю
  final String display;

  /// Создаёт [TitlesSet] из JSON
  static TitlesSet fromJson(Map<String, Object?> json) {
    if (json case {
      'canonical': final String canonical,
      'normalized': final String normalized,
      'display': final String display,
    }) {
      return TitlesSet(
        canonical: canonical,
        normalized: normalized,
        display: display,
      );
    }
    throw FormatException('Could not deserialize TitleSet, json=$json');
  }

  @override
  String toString() =>
      'TitlesSet[canonical=$canonical, normalized=$normalized, display=$display]';
}