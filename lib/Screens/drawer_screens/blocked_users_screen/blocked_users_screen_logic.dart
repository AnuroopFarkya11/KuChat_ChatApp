import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Services/auth/firebase_auth_services.dart';
import '../../../Services/fire_store/firebase_store_services.dart';
import '../../../Utils/theme_color/app_colors.dart';

class BlockedUsersScreenLogic{

  late String currentUID;
  final FirebaseAuthService authService = FirebaseAuthService();
  final FireStoreServices _storeServices = FireStoreServices();



  getUserList(context,snapshot) {
    return SliverFixedExtentList(
        delegate: SliverChildListDelegate(getUserTile(snapshot, context)),
        itemExtent: 85);
  }
  getUserTile(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, BuildContext context) {
    return snapshot.data!.docs
        .map((doc) => ListTile(
      // minVerticalPadding: 25.0,

      leading: CircleAvatar(
        radius: 25,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(55),
          child: CachedNetworkImage(
            imageUrl: doc["receiverPhoto"],
            height: 60,
            fit: BoxFit.fill,
            width: 60,
            placeholder: (context, val) {
              return CircleAvatar(
                  backgroundColor: Colors.white70,
                  backgroundImage: Image.asset(
                    "assets/kuuuu/hello.png",
                    fit: BoxFit.fitWidth,
                  ).image);
            },
          ),
        ),
      ),
      /*CircleAvatar(

                    backgroundImage: Image.network(doc["receiverPhoto"]).image,
                    radius: 25,
                  )*/
      title: Text(
        doc["receivedBy"],
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        doc["lastMessage"],
        style: const TextStyle(color: Colors.white30),
        softWrap: true,
        maxLines: 1,
      ),
      onTap: () {
        leadToUser(context, doc["receiverUID"]);
      },
      onLongPress: () {
        showDialog(
            useSafeArea: true,
            context: context,
            builder: (context) {
              return SimpleDialog(
                children: [
      /*            ListTile(
                    leading: const Icon(Icons.unarchive_outlined),
                    title: Text("Unarchive ${doc["receivedBy"]}"),
                    iconColor: AppColor.kuWhite70,
                    textColor: AppColor.kuWhite70,
                    onTap: () {
                      _storeServices.updateArchiveStatus(
                          doc["receiverUID"], false);
                      Navigator.of(context).pop();
                    },
                  ),*/
                 /* const Divider(
                    color: AppColor.kuWhite,
                    indent: 65,
                    endIndent: 65,
                  ),*/
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: Text("Unblock ${doc["receivedBy"]}"),
                    iconColor: AppColor.kuRed,
                    textColor: AppColor.kuWhite70,
                    onTap: () {
                      _storeServices.updateBlockedStatus(doc["receiverUID"], false);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      },
    ))
        .toList();
  }
  void leadToUser(context, String uid) async {
    var roomId = "";
    Map<String, dynamic>? UserMap = await _storeServices.getUserData(uid);
    if (UserMap!.isNotEmpty) {
      roomId = chatRoomID(currentUID, UserMap["UserID"]);
      log("ROOM ID GENERATED : $currentUID and ${UserMap["UserID"]}");
      Navigator.pushNamed(context, '/ChatScreen',
          arguments: {'roomId': roomId, 'userMap': UserMap});
    }
    // todo pass chatroomid user map hi paas kr do
  }

  String chatRoomID(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }


}