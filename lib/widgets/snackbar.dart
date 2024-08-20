import 'package:flutter/material.dart';
import 'package:parkmate/constants/colors.dart';

void showInSnackBar(BuildContext context, String value,
    {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    content:
        Text(value, style: TextStyle(color: isError ? Colors.white : kPrimary)),
    backgroundColor: isError ? Colors.red : Colors.white,
  ));
}
