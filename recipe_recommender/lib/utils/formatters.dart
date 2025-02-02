class Formatters {
  // Format duration from minutes to 'hours:minutes'
  static String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return hours > 0 ? '$hours hrs $mins mins' : '$mins mins';
  }
 
  // Capitalize the first letter of each word in a string
  static String capitalizeWords(String text) {
    return text
        .split(' ')
        .map((word) => word.isNotEmpty
        ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
        : '')
        .join(' ');
  }
 
  // Format a list of items into a comma-separated string
  static String formatList(List<String> items) {
    return items.join(', ');
  }
}