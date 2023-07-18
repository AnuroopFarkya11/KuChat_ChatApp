import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:kuchat/Services/auth/firebase_auth_services.dart';
import 'package:kuchat/Services/fire_storage/firebase_storage_services.dart';
import 'package:kuchat/Services/notification_manager/notifcation_manager.dart';
import 'package:kuchat/Widgets/snack_bar.dart';
import 'package:provider/provider.dart';

import '../../Modals/user_modal.dart';

class FireStoreServices {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseStorageServices _storageServices = FirebaseStorageServices();
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

  Future<void> updateUserToken() async {
    //todo baad me add this to user model class
    String currentUID = _authService.getCurrentUserUID();
    try {
      await _fireStore
          .collection("KuChatsUsers")
          .doc(currentUID)
          .update({"userToken": NotificationManager.currentUserToken});
      log("UPDATING USER TOKEN STATUS: DONE");
    } on FirebaseException catch (e) {
      // TODO
      log("UPDATING USER TOKEN STATUS:${e.message.toString()}");
    }
  }

  Future<String> getReceiverNotificationToken(String receiverUID) async {
    String receiverToken = "";
    try {
      await _fireStore
          .collection("KuChatsUsers")
          .doc(receiverUID)
          .get()
          .then((value) {
        if (value.exists) {
          receiverToken = value.get("userToken");
          log("RECEIVER NOTIFICATION TOKEN STATUS: $receiverToken ");
        } else {
          log("RECEIVER NOTIFICATION TOKEN STATUS: NO TOKEN");
        }
      });
    } on FirebaseException catch (e) {
      log("RECEIVER NOTIFICATION TOKEN STATUS: ${e.message.toString()}");
    }
    return receiverToken;
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

  Future<bool> createUserInStore(
      {required Map<String, dynamic> userModel}) async {
    //todo
    // Map<String, dynamic> userData = context.read<UserModel>().toJSON();

    // Map<String,dynamic> userModelMap = userModel.toJSON();
    String uid = _authService.getCurrentUserUID();

    try {
      await _fireStore.collection("KuChatsUsers").doc(uid).set(userModel);
      log(name:"User Details with default data status","SUCCESSFULLY COMPLETED");
      return true;
    } on FirebaseException catch (e) {
      log("User Details with default data status: FAILED ${e.message}");
      throw e.message.toString();
    }
  }

  Future<void> pushUserDetailsToStore({required BuildContext context}) async {
    //TODO THIS FUNCTION WILL ACCEPT UID, USER PROFILE URL AND BIO
    // THEN WILL PUSH TO FIRESTORE

    String uid = _authService.getCurrentUserUID();
    String userBio = context.read<UserModel>().userBio;
    String userProfilePic = context.read<UserModel>().downloadUrl;

    log("FIRESTORE STATUS: Loading user details to firestorm");

    _fireStore.collection("KuChatsUsers").doc(uid).update({"userBio":userBio});
/*
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

 */

  }

  Future<void> sendToStore(String roomID, Map<String, dynamic> message) async {
    try {
      await _fireStore
          .collection('KuChatRooms')
          .doc(roomID)
          .collection('chats')
          .add(message);
    } on FirebaseException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> updateSenderRecentChat(Map<String, dynamic> receiverMap,
      Map<String, dynamic> senderMap, String message) async {
    var time = FieldValue.serverTimestamp();

    // providers may be get deleted when app gets resumed.

    String receiverUid = receiverMap["UserID"];
    String senderUid = senderMap["senderUid"];

    // Sender Recent chat record
    try {
      await _fireStore
          .collection('KuChatsUsers')
          .doc(senderUid)
          .collection('RecentChats')
          .doc(receiverMap["UserID"])
          .set({
        "lastMessage": message,
        "lastMessageStatus": false,
        "receivedBy": receiverMap["Name"],
        "receiverPhoto": receiverMap["ProfilePictureURL"],
        "receiverUID": receiverMap["UserID"],
        "time": time,
        "archived": false,
        "blocked": false
      });

      // Receiver Recent chat record
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
      log("message error : ${e.toString()}");
      throw e.message.toString();
    }

    // Receiver Recent chat record
    /* try {
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
    }*/
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
      throw e.message.toString();
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

  Future<bool>updateProfileURL({required String url}) async {
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
          .collection("Support")
          .doc(time.toString())
          .set({"request": request});

      return true;
    } on FirebaseException catch (e) {
      log("Send help request status: ${e.message.toString()}");
    }
    return false;
  }

  Future setActiveStatus(bool status) async {
    await _fireStore
        .collection("KuChatsUsers")
        .doc(_authService.getCurrentUserUID())
        .update({"activityStatus": status});
  }

  Future updateLastMessageStatus(senderUID, receiverUID, bool status) async {
    await _fireStore
        .collection('KuChatsUsers')
        .doc(senderUID)
        .collection('RecentChats')
        .doc(receiverUID)
        .update({"lastMessageStatus": status});
  }

  Future<String> startUploadImage(imagePath) async {

    String userUID = _authService.getCurrentUserUID();
    String profilePictureUrl = "";

    if (imagePath.isNotEmpty) {
      // setState();
      try {

        //          UPLOADING IMAGE TO STORAGE
        await _storageServices
            .uploadProfilePictureToStorage(
            imagePath: imagePath, imageName: userUID)
            .then((value) async {
          // context.read<UserModel>().downloadUrl = value;

          await updateProfileURL(url: value).whenComplete((){
            profilePictureUrl = value;
          });
        });
      } on Exception catch (e) {
        throw "An error occurred.Please try again";
        // showSnackBar(context, "An error occurred.Please try again");
      }

    }
    return profilePictureUrl;
  }
}
