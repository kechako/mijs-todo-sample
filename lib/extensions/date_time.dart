import 'package:flutter/material.dart';

extension DateExtension on DateTime {
  DateTime toDate() => DateUtils.dateOnly(this);
}
