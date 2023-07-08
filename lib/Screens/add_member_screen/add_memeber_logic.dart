import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddMemberLogic{
  late String currentUID = "";
  final FocusNode searchFocusNode = FocusNode();
  String searchValue = "";

  getUserList(snapshot,context) {
    return SliverFixedExtentList(
        delegate: SliverChildListDelegate(getUserTile(snapshot, context)),
        itemExtent: 85);
  }
  getUserTile(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, BuildContext context) {
    return snapshot.data!.docs
        .map((doc) => ListTile(
      minVerticalPadding: 20.0,
      leading:CircleAvatar(
        radius: 25,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(55),
          child: CachedNetworkImage(
            imageUrl: doc["ProfilePictureURL"],
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
      title: Text(doc["Name"],style: const TextStyle(color: Colors.white),),
      subtitle: Text(doc["userBio"],style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.message_outlined,color: Colors.white,),
      onTap: () {
        // NEXT USER KI UID PASS KR RHA
        leadToUser(context, doc.data());
      },
    ))
        .toList();
  }

  void leadToUser(context, doc) async {
    var roomId = "";


    // GETTING DATA OF NEXT USER
    Map<String, dynamic>? UserMap = {
      "Name":doc["Name"],
      "ProfilePictureURL":doc["ProfilePictureURL"],
      "userBio":doc["userBio"],
      "UserID":doc["UserID"],
      "EmailAddress":doc["EmailAddress"]
    };

    log("USER DATA : $UserMap");
    if (UserMap.isNotEmpty) {
      // ROOM ID IS BEING CREATED USING UID OF BOTH CANDIDATES
      roomId = chatRoomID(currentUID, UserMap["UserID"]);

      log("ROOM ID GENERATED : $currentUID and ${UserMap["UserID"]}");

      // NAVIGATING TO NEXT SCREEN WITH ROOM ID AND USER MAP THAT CONSIST DATA OF THE NEXT CANDIDATE
      Navigator.pushNamed(context, '/ChatScreen',
          arguments: {'roomId': roomId, 'userMap': UserMap});
    }

  }
  String chatRoomID(String user1, String user2) {
    log("Chat room id $user1");
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

}