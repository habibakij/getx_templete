import 'package:intl/intl.dart';

class AppHelper {
  // "2026-04-24T09:25:19.000Z" → "April 24, 2026"
  String formatedDate(String isoString) {
    final dateTime = DateTime.parse(isoString).toLocal();
    return DateFormat('MMMM dd, yyyy').format(dateTime);
  }

  // "2026-04-24T09:25:19.000Z" → "09:25 AM"
  String formatedTime(String isoString) {
    final dateTime = DateTime.parse(isoString).toLocal();
    return DateFormat('hh:mm a').format(dateTime);
  }
}
