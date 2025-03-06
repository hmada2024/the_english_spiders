//lib/core/widgets/text/string_formatter.dart
class StringFormatter {
  static String formatFieldName(String fieldName) {
    return fieldName
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return '';
    }).join(' ');
  }
}
