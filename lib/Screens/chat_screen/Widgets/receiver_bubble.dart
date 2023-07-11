import 'package:flutter/material.dart';
import 'package:kuchat/Services/fire_store/firebase_store_services.dart';

class ReceiverBubble extends StatefulWidget {

  final String text;
  final String currentUID;
  final String receiverUID;


  ReceiverBubble({Key? key,required this.text,required this.currentUID,required this.receiverUID}) : super(key: key);

  @override
  State<ReceiverBubble> createState() => _ReceiverBubbleState();
}

class _ReceiverBubbleState extends State<ReceiverBubble> {
  final FireStoreServices _storeServices = FireStoreServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _storeServices.updateLastMessageStatus(widget.currentUID, widget.receiverUID,true);

  }
  @override
  Widget build(BuildContext context) {


    // update seen status


    Size size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 15),
            margin: const EdgeInsets.all(10),
            constraints: BoxConstraints(
                minWidth: size.width * 0.15,
                maxWidth: size.width * 0.7,
                maxHeight: size.height * 0.5),
            decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Text(
              widget.text.trim(),
              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w100
              )
              ,textAlign: TextAlign.start,
            ),
          ),

        ],
      ),
    );
  }
}
