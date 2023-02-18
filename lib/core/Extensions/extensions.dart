/// Extension on [String] that capitalizes the first letter of the first word in a sentence
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
