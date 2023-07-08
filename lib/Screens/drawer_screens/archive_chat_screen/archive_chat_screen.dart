import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kuchat/Screens/drawer_screens/archive_chat_screen/archive_chat_screen_logic.dart';
import 'package:kuchat/Widgets/kudrawer.dart';

import '../../../Widgets/appbar.dart';


class ArchiveChatScreen extends StatefulWidget {
  const ArchiveChatScreen({Key? key}) : super(key: key);

  @override
  State<ArchiveChatScreen> createState() => _ArchiveChatScreenState();
}

class _ArchiveChatScreenState extends State<ArchiveChatScreen> with ArchiveChatScreenLogic {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    currentUID = authService.getCurrentUserUID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const KuDrawer(),
      body: CustomScrollView(

        slivers: [

          const KuAppBar(
              kuTitle: "Archive Chat",
              kuPath: "lovebird.png",
              titleFontSize: 25,
          autoLead: false,),

          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("KuChatsUsers")
                  .doc(currentUID)
                  .collection("RecentChats")
                  .where("archived", isEqualTo: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {

                if(snapshot.hasData&& snapshot.data!.docs.isNotEmpty)
                  {
                    return getUserList(context,snapshot);
                  }
                else{
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.archive,size: 200,color: Colors.white70,),
                          Text(
                            "No archive chat.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                  );
                }



              })
        ],
      ),
    );
  }
}
