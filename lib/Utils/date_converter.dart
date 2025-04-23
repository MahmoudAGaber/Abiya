import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DateConverter {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String formatDateHour(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static String slotDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }
  static String localDateToIsoStringAMPM(DateTime dateTime, BuildContext context) {
    return DateFormat('${_timeFormatter(context)} | d-MMM-yyyy ').format(dateTime.toLocal());
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS','en').parse(dateTime, true).toLocal();
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('HH:mm').format(isoStringToLocalDate(dateTime));
  }
  static String isoStringToLocalTimeWithAMPMOnly(String dateTime) {
    return DateFormat('hh:mm a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalTimeWithAmPmAndDay(String dateTime) {
    return DateFormat('hh:mm a, EEE').format(isoStringToLocalDate(dateTime));
  }
  static String stringToStringTime(String dateTime, BuildContext context) {
    DateTime inputDate = DateFormat('HH:mm:ss').parse(dateTime);
    return DateFormat(_timeFormatter(context)).format(inputDate);
  }
  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly2(String dateTime) {
    return DateFormat('dd/MM/yyyy').format(isoStringToLocalDate(dateTime));
  }

    static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  }
  static String isoDayWithDateString(String dateTime) {
    return DateFormat('EEE, MMM d, yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String convertTimeRange(String start, String end, BuildContext context) {
    DateTime startTime = DateFormat('HH:mm:ss').parse(start);
    DateTime endTime = DateFormat('HH:mm:ss').parse(end);
    return '${DateFormat(_timeFormatter(context)).format(startTime)} - ${DateFormat(_timeFormatter(context)).format(endTime)}';
  }

  static DateTime stringTimeToDateTime(String time) {
    return DateFormat('HH:mm:ss').parse(time);
  }

  static String _timeFormatter(BuildContext context) {
   // return Provider.of<SplashProvider>(context, listen: false).configModel!.timeFormat == '24' ? 'HH:mm' : 'hh:mm a';
    return  'HH:mm' ;
  }

  static String timeAgoSinceDate(DateTime dateTime, {bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(dateTime);

    if (difference.inDays > 8) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 اسبوع' : 'الاسبوع الماضي';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} يوم';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 يوم ' : 'امس';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} ساعه ';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 ساعه ' : 'من ساعه';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} ق';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 ق' : 'من دقيقه';
    } else if (difference.inSeconds >= 3) { 
      return '${difference.inSeconds} ثانيه';
    } else {
      return 'Just now';
    }
  }

  static dynamic numberFormat(dynamic number){
   return NumberFormat('#,##0', 'en_US').format(number);
  }

  static dynamic parseFormattedNumber(String formattedString) {
    String unformatted = formattedString.replaceAll(RegExp(r'[^\d.-]'), '');
    return num.tryParse(unformatted);
  }

  static String formatDay(DateTime date) {
    return DateFormat('EEEE').format(date); // Returns day name like "Monday"
  }

}
