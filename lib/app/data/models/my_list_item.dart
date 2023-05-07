import 'package:flutter/material.dart';

class MyListItem {
  final Icon icon;
  final String title;
  final VoidCallback onTap;

  MyListItem(this.icon, this.title, this.onTap);
}
