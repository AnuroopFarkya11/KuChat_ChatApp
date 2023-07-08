import 'package:flutter/material.dart';

class ReceiverBubble extends StatelessWidget {

  final String text;

  const ReceiverBubble({Key? key,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              text.trim(),
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
