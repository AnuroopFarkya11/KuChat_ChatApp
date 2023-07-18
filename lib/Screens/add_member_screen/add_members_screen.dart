import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuchat/Screens/add_member_screen/add_memeber_logic.dart';
import 'package:kuchat/Widgets/form_fields.dart';
import 'package:provider/provider.dart';

import '../../Modals/user_modal.dart';
import '../../Widgets/appbar.dart';


class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({Key? key}) : super(key: key);

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> with AddMemberLogic {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUID = context.read<UserModel>().userId;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: CustomScrollView(
        slivers: [
          const KuAppBar(kuTitle: "",kuPath:"skates.png" ,),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [

                  TextField(
                    focusNode: searchFocusNode,
                    cursorColor: Colors.white,
                    autocorrect: false,

                    onChanged:(value) {
                      searchValue = value;
                      setState(() {});
                    } ,
                    onTapOutside: (event) {
                      // _searchFocusNode.nextFocus();
                    },
                    decoration: InputDecoration(

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            gapPadding: 20.0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            gapPadding: 20.0,
                            borderSide:
                            const BorderSide(color: Colors.white, width: 1.5)),
                        labelText: "  Search",
                        // labelStyle: GoogleFonts.poppins(color: Colors.white70),
                        suffixIcon: const Icon(Icons.search)),
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 1.25,
                    indent: size.width * 0.15,
                    endIndent: size.width * 0.15,
                  )
                ],
              ),
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("KuChatsUsers").where("UserID",isNotEqualTo:currentUID)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  log("Home screen:${snapshot.data!.docs.isEmpty}");
                  return getUserList(snapshot,context);
                } else {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/kuuuu/confusingKuu.png",
                            height: 150,
                          ),
                          Text(
                            "No recent chat\nDon't you wanna chat??!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
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
