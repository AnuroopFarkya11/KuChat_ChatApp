import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuchat/Screens/chat_screen/Widgets/bubble_logic.dart';
import 'package:kuchat/Services/fire_store/firebase_store_services.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';


class SenderBubble extends StatefulWidget {
  final String text;
  final String senderUID;
  final String receiverUID;
  //TODO MESSAGE TIME
  // late Timestamp? time;


  SenderBubble({Key? key, required this.text,required this.senderUID,required this.receiverUID                                     }) : super(key: key);

  @override
  State<SenderBubble> createState() => _SenderBubbleState();
}

class _SenderBubbleState extends State<SenderBubble> {
  // late String _bubbleTime="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   /* log(widget.time.toString());
    _bubbleTime = BubbleLogic.formatSecondsToTime(widget.time!.seconds);
    log(_bubbleTime);*/
    FireStoreServices().updateLastMessageStatus(widget.senderUID, widget.receiverUID, false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Align(
      alignment: Alignment.topRight,

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 13),
              // margin: EdgeInsets.all(5),
              constraints: BoxConstraints(
                  minWidth: size.width * 0.15,
                  maxWidth: size.width * 0.7,
                  maxHeight: size.height * 0.5),
              decoration: const BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.text.trim(),
                    style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w100
                    )
                    ,textAlign: TextAlign.start,
                  ),


                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
