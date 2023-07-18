import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager{

  static late final SharedPreferences preferences;

  static Future initializePreferences()
  async{
    preferences = await SharedPreferences.getInstance();
  }

  static Future notificationPreference({bool status = true})async{
    await preferences.setBool("NotificationStatus", status);
  }

  static bool? getNotificationPreferenceStatus(){

    return preferences.getBool("NotificationStatus");

  }
}