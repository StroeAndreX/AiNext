import 'package:AiOrganization/Core/AppLocalizations.dart';
import 'package:flutter/material.dart';

class CalendarLabelsConfig {
  static final List<String> today = ["4:00", "8:00", "12:00", "16:00", "20:00"];
  static final List<String> twoDays = [
    "8:00",
    "16:00",
    "24:00",
    "8:00",
    "16:00",
    "24:00"
  ];
  static final List<String> yesterday = [
    "4:00",
    "8:00",
    "12:00",
    "16:00",
    "20:00"
  ];
  static List<String> week(BuildContext context) {
    if (context == null) {
      return [
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
        "Sun",
      ];
    }

    var language = AppLocalizations.of(context);
    return [
      language.translate("mon"),
      language.translate("tue"),
      language.translate("wed"),
      language.translate("thu"),
      language.translate("fri"),
      language.translate("sat"),
      language.translate("sun")
    ];
  }

  static List<String> fullWeekLabels(BuildContext context) {
    if (context == null) {
      return [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
      ];
    }

    var language = AppLocalizations.of(context);
    return [
      language.translate("monday"),
      language.translate("tuesday"),
      language.translate("wednesday"),
      language.translate("thursday"),
      language.translate("friday"),
      language.translate("saturday"),
      language.translate("sunday")
    ];
  }

  static List<String> month(int month) {
    DateTime lastDayOfMonth = DateTime(DateTime.now().year, month + 1, 0);
    List<String> labels =
        List.generate((lastDayOfMonth.day / 5).truncate(), (index) {
      return (5 * (index + 1)).toString();
    });
    return labels;
  }

  static List<String> monthLabels(BuildContext context) {
    if (context == null) {
      return [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ];
    }

    var language = AppLocalizations.of(context);
    return [
      language.translate("jan"),
      language.translate("feb"),
      language.translate("mar"),
      language.translate("apr"),
      language.translate("may"),
      language.translate("jun"),
      language.translate("jul"),
      language.translate("aug"),
      language.translate("sep"),
      language.translate("oct"),
      language.translate("nov"),
      language.translate("dec")
    ];
  }

  static List<String> fullMonthLabels(BuildContext context) {
    if (context == null) {
      return [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
      ];
    }

    var language = AppLocalizations.of(context);
    return [
      language.translate("january"),
      language.translate("february"),
      language.translate("march"),
      language.translate("april"),
      language.translate("may"),
      language.translate("june"),
      language.translate("july"),
      language.translate("august"),
      language.translate("september"),
      language.translate("october"),
      language.translate("november"),
      language.translate("december")
    ];
  }
}
