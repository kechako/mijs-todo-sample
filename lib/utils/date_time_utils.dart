import 'package:flutter/material.dart';
import 'package:mellowpia/extensions/date_time.dart';

abstract final class DateTimeUtils {
  static int weekOffset(DateTime date, MaterialLocalizations localizations) {
    // 0-based day of week for the month and year, with 0 representing Monday.
    final int weekdayFromMonday = date.weekday - 1;

    // 0-based start of week depending on the locale, with 0 representing Sunday.
    int firstDayOfWeekIndex = localizations.firstDayOfWeekIndex;

    // firstDayOfWeekIndex recomputed to be Monday-based, in order to compare with
    // weekdayFromMonday.
    firstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;

    // Number of days between the first day of week appearing on the calendar,
    // and the day corresponding to the first of the month.
    return (weekdayFromMonday - firstDayOfWeekIndex) % 7;
  }

  static DateTime firstDateOfWeek(
      DateTime date, MaterialLocalizations localizations) {
    date = date.toDate();
    final offset = DateTimeUtils.weekOffset(date, localizations);
    return DateTime(date.year, date.month, date.day - offset);
  }

  static DateTime firstDayOfMonth(DateTime day) =>
      DateTime(day.year, day.month, 1);

  static DateTime lastDayOfMonth(DateTime day) => DateTime(
      day.year, day.month, DateUtils.getDaysInMonth(day.year, day.month));
}
