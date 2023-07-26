import 'package:at_tareeq/core/extentions/string_extensions.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

InputDecoration myInputDecoration(
    {Icon? icon, required String label, double borderRadius = 8}) {
  return InputDecoration(
    prefixIcon: icon,
    prefixIconColor: primaryColor,
    hintText: label.toTitleCase(),
    label: Text(
      label.toTitleCase(),
      style: const TextStyle(color: primaryDarkColor),
    ),
    // focusColor: primaryColor,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: primaryDarkColor, width: 1.2),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: primaryDarkColor),
    ),
  );
}

InputDecoration myInputDecoration2(
    {Icon? icon,
    required String label,
    String? hint,
    double borderRadius = 12}) {
  return InputDecoration(
    labelText: label,
    hintText: hint ?? label,
    prefixIcon: icon,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: CustomColor.appBlue),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: CustomColor.appBlue),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: Colors.red),
    ),
  );
}
