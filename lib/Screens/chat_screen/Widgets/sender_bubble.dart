import 'package:flutter/material.dart';
import 'package:kuchat/Services/fire_store/firebase_store_services.dart';


class SenderBubble extends StatefulWidget {
  final String text;
  final String senderUID;
  final String receiverUID;


  const SenderBubble({Key? key, required this.text,required this.senderUID,required this.receiverUID}) : super(key: key);

  @override
  State<SenderBubble> createState() => _SenderBubbleState();
}

class _SenderBubbleState extends State<SenderBubble> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FireStoreServices().updateLastMessageStatus(widget.senderUID, widget.receiverUID, false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Align(
      alignment: Alignment.topRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 13),
            margin: EdgeInsets.all(10),
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
    );
  }
}
