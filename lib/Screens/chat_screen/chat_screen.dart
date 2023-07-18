import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuchat/Screens/chat_screen/Widgets/receiver_bubble.dart';
import 'package:kuchat/Screens/chat_screen/Widgets/sender_bubble.dart';
import 'package:kuchat/Screens/chat_screen/chat_screen_logic.dart';
import 'package:kuchat/Services/notification_manager/notifcation_manager.dart';
import 'package:kuchat/Widgets/snack_bar.dart';
import 'package:provider/provider.dart';
import '../../Modals/user_modal.dart';
import '../../Services/fire_store/firebase_store_services.dart';
import '../../Utils/theme_color/app_colors.dart';
import 'Widgets/chat_input_box_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin, ChatScreenLogic {
  final FireStoreServices _storeServices = FireStoreServices();

  late final CurvedAnimation fadeAnimation;
  late String currentUID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    fadeAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    setUpdateState(() {
      setState(() {});
    });
    size = MediaQuery
        .of(context)
        .size;
    if (!receiverDataReceived || receiverMap.isEmpty) {
      arguments =
      ModalRoute
          .of(context)!
          .settings
          .arguments as Map<String, dynamic>;

      log("ARGUMENTS RECEIVED: ${arguments["roomId"]}");

      receiverMap = arguments["userMap"];
      receiverUserName = arguments["userMap"]["Name"];
      receiverUserId = arguments["userMap"]["UserID"];
      receiverProfilePicture = arguments["userMap"]["ProfilePictureURL"];
      roomID = arguments["roomId"];
      currentUserName = context
          .read<UserModel>()
          .name;
      currentUID = context
          .read<UserModel>()
          .userId;

      receiverDataReceived = true;
    }
    /*  if (!imageDownloaded) {
      getImageFileFromUrl();
    }*/
    if (!senderDataReceived || senderMap.isEmpty) {
      senderMap = {
        "senderUserName": context
            .read<UserModel>()
            .name,
        "senderUid": context
            .read<UserModel>()
            .userId,
        "senderProfilePicture": context
            .read<UserModel>()
            .downloadUrl,
      };
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: true,
              elevation: 40,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.white12,
              expandedHeight: size.height * 0.3,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                // todo add option button
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierColor: Colors.black87,
                          builder: (context) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: receiverProfilePicture,
                                  placeholder: (context,string)=>Center(child: CircularProgressIndicator(color: AppColor.kuWhite,),),
                                  )
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.info_outline))
              ],
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    receiverUserName,
                    style:
                    GoogleFonts.poppins(color: Colors.white, fontSize: 19),
                  ),
                  // titlePadding: EdgeInsets.symmetric(horizontal: 50,vertical: 17),
                  // centerTitle: true,
                  background: CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    imageUrl: receiverProfilePicture,
                    placeholder: (context, str) =>
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                  )),
            ),
            SliverFillRemaining(
              // hasScrollBody: false,
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('KuChatRooms')
                          .doc(roomID)
                          .collection('chats')
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.size != 0) {
                            return ListView.builder(
                                reverse: true,
                                // itemExtent: 50.0,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, count) {
                                  Map<String, dynamic> messageMap =
                                  snapshot.data!.docs[count].data()
                                  as Map<String, dynamic>;
                                  return bubbleMessage(
                                      messageMap, currentUserName);
                                });
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/kuuuu/mail.png",
                                  height: 150,
                                ),
                                Text(
                                  //todo add user name
                                  "Say Hey to ${receiverUserName
                                      .split(" ")
                                      .first}!👋",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white24,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            );
                          }
                        }
                        /*if(!snapshot.hasData){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/kuuuu/mail.png",
                                height: 150,
                              ),
                              Text(
                                //todo add user name
                                "Say Hey to ${receiverUserName.split(" ").first}!👋",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    color: Colors.white24,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          );
                        }*/
                        return Container();
                      },
                    ),
                  ),
                  /*Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/kuuuu/mail.png",
                          height: 150,
                        ),
                        Text(
                          //todo add user name
                          "Say Hey to ${receiverUserName.split(" ").first}!👋",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.white24,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),*/
                  /*  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('KuChatsUsers')
                          .doc(currentUID)
                          .collection('RecentChats')
                          .doc(receiverUserId).snapshots(),

                      builder: (context, snapshot) {

                        log("Seen status : ${snapshot.data!["lastMessageStatus"]}");
                        return Container(height: 1,);


                      }),*/
                  /*  if(true)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Seen",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),*/
                  ChatInputBoxField(onSend: onSendMessage)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSendMessage(BuildContext context, String message) async {
    String currentUID = context
        .read<UserModel>()
        .userId;
    log(message);
    if (message.isNotEmpty) {
      //
      Map<String, dynamic> messageMap = {
        "sendby": currentUserName,
        "message": message,
        "time": FieldValue.serverTimestamp(),
        "receiverUID": receiverUserId,
        "senderUID": currentUID
        // "sendFrom":context.read<>,
        // "sendTo":receiverUserId
      };

      try {
        try {
          await _storeServices.sendToStore(roomID, messageMap);
          await _storeServices.updateSenderRecentChat(
              receiverMap, senderMap, message);
          await _storeServices
              .getReceiverNotificationToken(receiverUserId)
              .then((value) async {
            await NotificationManager.sendNotification(
                currentUserName, value, message);
          });
        } on Exception catch (e) {
          showSnackBar(context, "Message Sent Failed.");
        }
      } on Exception catch (e) {
        // TODO
      }
    } else {
      showSnackBar(context, "Message Failed.");
    }
  }

  Widget bubbleMessage(Map<String, dynamic> messageMap,
      String currentUserName) {
    return messageMap['sendby'] == currentUserName
        ? SenderBubble(
      text: messageMap["message"],
      senderUID: messageMap["senderUID"],
      receiverUID: messageMap["receiverUID"],
      // time: messageMap["time"],
    )
        : ReceiverBubble(
      text: messageMap["message"],
      currentUID: messageMap["senderUID"],
      receiverUID: messageMap["receiverUID"],
    );
  }
}
/*
*
* // Widget
* Center(
                  child: imageDownloaded
                      ? ShaderMask(
                          blendMode: BlendMode.hardLight,
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.grey.shade900
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds);
                          },
                          child: FadeTransition(
                              opacity: fadeAnimation,
                              child: Image.file(
                                height: double.infinity,
                                width: double.infinity,
                                userProfileFile,
                                fit: BoxFit.fitWidth,
                              )),
                        )
                      : const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                              // backgroundColor: Colors.grey.shade900,
                              color: Colors.white,
                              semanticsLabel: "Processing profile picture",
                              semanticsValue: "Processing",
                              strokeWidth: 2)),
                )
*
* */
