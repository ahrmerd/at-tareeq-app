extension StringCasingExtension on String {
  String get toCapitalize =>
      length > 0 ? this[0].toUpperCase() + substring(1).toLowerCase() : '';
  String toTitleCase() => split(" ").map((e) => e.toCapitalize).join(" ");

  String removeTrailing(String pattern) {
    if (pattern.isEmpty) return this;
    var source = this;
    while (source.endsWith(pattern)) {
      source.substring(0, source.length - pattern.length);
    }
    return source;
  }
}
