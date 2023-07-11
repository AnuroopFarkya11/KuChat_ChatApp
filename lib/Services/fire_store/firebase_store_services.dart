import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:kuchat/Services/auth/firebase_auth_services.dart';
import 'package:kuchat/Widgets/snack_bar.dart';
import 'package:provider/provider.dart';

import '../../Modals/user_modal.dart';

class FireStoreServices {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();
  late BuildContext _c;

  Future<void> loadCurrentUser(BuildContext context) async {
    _c = context;
    String uid = _authService.getCurrentUserUID();
    context.read<UserModel>().userId = uid;
    try {
      Map<String, dynamic>? currentUserData = await getUserData(uid);
      if (currentUserData != null) {
        loadDataInProviders(currentUserData);
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  void loadDataInProviders(currentUserData) {
    _c.read<UserModel>().name = currentUserData["Name"];
    _c.read<UserModel>().email = currentUserData["EmailAddress"];
    _c.read<UserModel>().downloadUrl = currentUserData["ProfilePictureURL"];
    _c.read<UserModel>().userBio = currentUserData["userBio"];
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    Map<String, dynamic>? userMap;
    log("RETRIEVING DATA FOR UID:  $userId");

    await _fireStore
        .collection('KuChatsUsers')
        .where("UserID", isEqualTo: userId)
        .get()
        .then((value) {
      var size = value.size;
      log("Got the match size:  $size");

      if (size == 1) {
        userMap = value.docs[0].data();
      } else {
        log("User with UID: $userId is not available to the datastore");
        userMap = null;
      }
    });
    return userMap;
  }

  Future<void> pushUserDetailsToStore({required BuildContext context}) async {
    log("Loading user details to firestorm");

    Map<String, dynamic> userData = context.read<UserModel>().toJSON();
    log("User Data : $userData");
    try {
      await _fireStore
          .collection('KuChatsUsers')
          .doc(userData["UserID"])
          .set(userData);

      log("USER DETAILS UPLOADED SUCCESSFULLY!");
    } catch (e) {
      log("FIRESTORM STORE: $e");
    }
  }

  Future<void> sendToStore(String roomID, Map<String, dynamic> message) async {
    try {
      await _fireStore
          .collection('KuChatRooms')
          .doc(roomID)
          .collection('chats')
          .add(message);
    } on FirebaseException catch (e) {
      // TODO
    }
  }

  Future<void> updateSenderRecentChat(
      BuildContext context,
      Map<String, dynamic> receiverMap,
      Map<String, dynamic> senderMap,
      String message) async {
    String time = FieldValue.serverTimestamp().toString();

    // providers may be get deleted when app gets resumed.

    String receiverUid = receiverMap["UserID"];
    String senderUid = senderMap["senderUid"];
    log(senderUid);

    // Sender Recent chat record
    try {
      await _fireStore
          .collection('KuChatsUsers')
          .doc(senderUid)
          .collection('RecentChats')
          .doc(receiverMap["UserID"])
          .set({
        "lastMessage": message,
        "lastMessageStatus":false,
        "receivedBy": receiverMap["Name"],
        "receiverPhoto": receiverMap["ProfilePictureURL"],
        "receiverUID": receiverMap["UserID"],
        "time": time,
        "archived": false,
        "blocked": false
      });
    } on FirebaseException catch (e) {
      log("Sender message error : ${e.toString()}");
    }


    // Receiver Recent chat record
    try {
      await _fireStore
          .collection('KuChatsUsers')
          .doc(receiverUid)
          .collection('RecentChats')
          .doc(senderUid)
          .set({
        "lastMessage": message,
        "receivedBy": senderMap["senderUserName"],
        "receiverPhoto": senderMap["senderProfilePicture"],
        "receiverUID": senderMap["senderUid"],
        "time": time,
        "archived": false,
        "blocked": false
      });
    } on FirebaseException catch (e) {
      log("Receiver message error : ${e.toString()}");
    }

    // todo get current uid
    //
  }

  Future<bool> updateUserBio({required String newUserBio}) async {
    String uid = _authService.getCurrentUserUID();
    try {
      await _fireStore
          .collection("KuChatsUsers")
          .doc(uid)
          .update({"userBio": newUserBio});
      return true;
    } on FirebaseException catch (e) {
      log("USER BIO STATUS : ${e.message}");
      // TODO
    }
    return false;
  }

  Future<bool> updateUserName({required String newUserName}) async {
    String uid = _authService.getCurrentUserUID();
    try {
      await _fireStore
          .collection('KuChatsUsers')
          .doc(uid)
          .update({"Name": newUserName});
      log("Update UserName Successful!");
      return true;
    } on FirebaseException catch (e) {
      log("Update user name error : ${e.message}");
    }
    return false;
  }

  Future<bool> updateProfileURL({required String url}) async {
    String uid = _authService.getCurrentUserUID();

    try {
      await _fireStore
          .collection("KuChatsUsers")
          .doc(uid)
          .update({"ProfilePictureURL": url});
      return true;
    } on FirebaseException catch (e) {
      // TODO
      log("USER PROFILE PICTURE UPLOAD STATUS: ${e.message}");
      return false;
    }
  }

  void updateArchiveStatus(receiverUID, status) async {
    String uid = _authService.getCurrentUserUID();

    try {
      await _fireStore
          .collection("KuChatsUsers")
          .doc(uid)
          .collection("RecentChats")
          .doc(receiverUID)
          .update({"archived": status});
    } on FirebaseException catch (e) {
      // TODO
    }
  }

  void updateBlockedStatus(receiverUID, status) async {
    String uid = _authService.getCurrentUserUID();
    log("Receiver UID $receiverUID");

    try {
      await _fireStore
          .collection("KuChatsUsers")
          .doc(uid)
          .collection("RecentChats")
          .doc(receiverUID)
          .update({"blocked": status});
    } on FirebaseException catch (e) {
      log(e.message.toString());
      // TODO
    }
  }

  Future<bool> sendRequestHelp(String currentUID, String request) async {
    var time = DateTime.now();
    log(time.toLocal().toString());
    try {
      await _fireStore
          .collection("KuChatsUsers")
          .doc(currentUID)
          .collection("Support").doc(time.toString()).set({
        "request":request
      });

      return true;
    } on FirebaseException catch (e) {

      log("Send help request status: ${e.message.toString()}");

    }
    return false;
  }

  Future setActiveStatus(bool status)async{
    await _fireStore.collection("KuChatsUsers").doc(_authService.getCurrentUserUID()).update({"activityStatus":status});
  }

 Future updateLastMessageStatus(senderUID,receiverUID,bool status)async{

   await _fireStore
       .collection('KuChatsUsers')
       .doc(senderUID)
       .collection('RecentChats')
       .doc(receiverUID).update({"lastMessageStatus":status});

 }





}
