import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';

class NotificationManager{

  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String currentUserToken="";



  static Future<void> getFirebaseNotificationToken()async {

    try {
      await firebaseMessaging.requestPermission().then((NotificationSettings notificationSettings)async{
        if(notificationSettings.authorizationStatus==AuthorizationStatus.authorized)
          {
            log("NOTIFICATION PERMISSION STATUS: ${notificationSettings.authorizationStatus.toString()}");
            await firebaseMessaging.getToken().then((value){
              if(value!.isNotEmpty)
                {
                  currentUserToken = value;
                  log("NOTIFICATION TOKEN STATUS: ${value}");
                }
            });

          }
        else
          {
            log("NOTIFICATION PERMISSION STATUS: ${notificationSettings.authorizationStatus.toString()}");

          }
      });
    } on FirebaseException catch (e) {
      log("NOTIFICATION STATUS: ${e.message.toString()}");
    }

  }



  static Future<void> sendNotification(String currentUserName, String receiverTokenAddress,String message)async{
    log("Send Notification Status: $currentUserName,$receiverTokenAddress,$message");
    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    final body = {
      "to":receiverTokenAddress,
      "notification": {
        "title": currentUserName, //current user name
        "body": message,
        "android_channel_id": "KuChats117",
        "sound": "default"
      },
    };
    try {
      await post(url,
      headers: {
        HttpHeaders.contentTypeHeader:'application/json',
        HttpHeaders.authorizationHeader:"key=AAAANzhloPY:APA91bHO611X3JW4siOp__bHgOLAIwxhuj4QX3tFug8427sVuxehDG_RUuScTVFkKevwLjPSZOm4-n_4apKgp9kU_3TXN5-J2mvt-Tx9f_BjNulqoFE2UZYZnr2AvTNzSaoZTzaHZ70q"
      },
      body: jsonEncode(body)
      ); 
    } on FirebaseException catch (e) {
      log("SENDING NOTIFICATION ERROR: ${e.message.toString()}");
    }
  }



}