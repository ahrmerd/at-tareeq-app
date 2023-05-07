import 'package:at_tareeq/core/extentions/string_extensions.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

InputDecoration myInputDecoration(
    {Icon? icon, required String label, double borderRadius = 8}) {
  return InputDecoration(
    prefixIcon: icon,
    prefixIconColor: primaryColor,
    hintText: label.toTitleCase(),
    label: Text(
      label.toTitleCase(),
      style: TextStyle(color: primaryDarkColor),
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
