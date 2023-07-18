import 'package:intl/intl.dart';

class BubbleLogic {
  static String formatSecondsToTime(int seconds) {
    Duration duration = Duration(seconds: seconds);
    DateTime dateTime = DateTime(0).add(duration);

    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }

}
