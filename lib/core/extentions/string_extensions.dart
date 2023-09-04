extension StringCasingExtension on String {
  String get toCapitalize =>
      length > 0 ? this[0].toUpperCase() + substring(1).toLowerCase() : '';
  String toTitleCase() => split(" ").map((e) => e.toCapitalize).join(" ");
}
