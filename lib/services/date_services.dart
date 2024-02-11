import 'package:cloud_firestore/cloud_firestore.dart';

DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

dateTimetoTimeStamp(DateTime dateTime) {
  Timestamp myTimeStamp =
      Timestamp.fromDate(DateTime(dateTime.year, dateTime.month, dateTime.day));

  return myTimeStamp;
}

timeStampToDate(Timestamp myTimeStamp) => myTimeStamp.toDate();
