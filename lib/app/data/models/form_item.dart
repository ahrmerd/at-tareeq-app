import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class FormItem {
  String field;
  late String label;
  Icon? icon;
  String? Function(String?)? validator;
  TextInputType type;
  TextEditingController? controller;

  FormItem(
    this.field, {
    this.icon,
    this.validator,
    this.type = TextInputType.text,
    String? label,
    this.controller,
  }) {
    this.label = label ?? field;
    // if (label == null) {
    //   this.label = field;
    // }
  }
}

// enum FormItemType {
//   phone,
//   text,
//   email,
//   password,
// }
