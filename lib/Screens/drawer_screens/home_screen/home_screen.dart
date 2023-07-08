import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuchat/Services/auth/firebase_auth_services.dart';
import 'package:kuchat/Services/fire_store/firebase_store_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../Modals/user_modal.dart';
import '../../../Utils/theme_color/app_colors.dart';
import '../../../Widgets/kudrawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late String url = "";
  late String uid = "";
  late String currentUID = "";
  late File userProfileFile;
  final FocusNode _searchFocusNode = FocusNode();
  bool imageDownloaded = false;
  String searchValue = "";
  late AnimationController animationController;
  final FireStoreServices _storeServices = FireStoreServices();
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    url = context.read<UserModel>().downloadUrl;
    uid = context.read<UserModel>().userId;
    currentUID = context.read<UserModel>().userId;

    log("Home Screen init");
    // currentUID = context.read<UserModel>().userId;
    // getUrl(context);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    getImageFileFromUrl();
  }

  getImageFileFromUrl() async {
    final fileName = uid; // use uid
    final appDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDir.path}/$fileName';
    animationController.forward();

    //check if file already exists
    final file = File(filePath);
    if (file.existsSync()) {
      log("Exists : ${file.path.toString()}");
      userProfileFile = file;
      setState(() {
        imageDownloaded = true;
      });
      return file;
    } else {
      final response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes).whenComplete(() {
        log("File saved to ${file.path}");
        userProfileFile = file;
        setState(() {
          imageDownloaded = true;
        });
      });
      log(file.path.toString());
      return file;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
    // getUrl(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      drawer: const KuDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            elevation: 50,
            backgroundColor: AppColor.kuGrey,
            expandedHeight: size.height * 0.3,
            // leading: IconButton(icon:Icon(Icons.menu),onPressed: (){},),
            actions: [
              IconButton(
                  onPressed: () async {
                    await _authService.signOutUser(context)
                        ? Navigator.pushReplacementNamed(
                            context, '/SignInScreen')
                        : null;
                  },
                  icon: const Icon(Icons.logout_outlined)),
              const SizedBox(
                width: 12,
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              // centerTitle: true,
              titlePadding:
                  const EdgeInsets.only(left: 10, bottom: 10, right: 10),
              background: ShaderMask(
                  blendMode: BlendMode.hardLight,
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [Colors.transparent, Colors.grey.shade900],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds);
                  },
                  child: imageDownloaded
                      ? FadeTransition(
                          opacity: fadeAnimation,
                          child: Image.file(
                            userProfileFile,
                            fit: BoxFit.fitWidth,
                          ))
                      : Image.asset(
                          "assets/wallpaper.jpg",
                          fit: BoxFit.fill,
                        )),
              title: Text(
                "Chats",
                textAlign: TextAlign.start,
                style: GoogleFonts.alata(fontSize: 20),
              ),
            ),
          ),
          // if(_showSearchBar)
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    focusNode: _searchFocusNode,
                    cursorColor: Colors.white,
                    autocorrect: false,
                    style: GoogleFonts.poppins(color: Colors.white),

                    // keyboardAppearance: Brightness.dark,

                    onChanged: (value) {
                      searchValue = value;
                      setState(() {});
                    },
                    onTapOutside: (event) {
                      // _searchFocusNode.nextFocus();
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        iconColor: Colors.white,
                        focusColor: Colors.white,
                        alignLabelWithHint: true,
                        suffixIconColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            gapPadding: 20.0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            gapPadding: 20.0,
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.5)),
                        labelText: "  Search",
                        labelStyle: GoogleFonts.poppins(color: Colors.white70),
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
                  .collection("KuChatsUsers")
                  .doc(currentUID)
                  .collection("RecentChats")
                  .where("archived", isEqualTo: false)
                  .where("blocked", isEqualTo: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  // log("Home screen:${snapshot.data!.docs.isEmpty}");

                  return getUserList(snapshot);
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white70,
        onPressed: () {
          Navigator.pushNamed(context, '/AddMemberScreen');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  getUserList(snapshot) {
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
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              subtitle: Text(
                doc["lastMessage"],
                style: GoogleFonts.poppins(color: Colors.white30),
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
                          ListTile(
                            leading: const Icon(Icons.archive_outlined),
                            title: Text("Archive ${doc["receivedBy"]}"),
                            iconColor: AppColor.kuWhite70,
                            textColor: AppColor.kuWhite70,
                            onTap: () {
                              _storeServices.updateArchiveStatus(
                                  doc["receiverUID"], true);
                              Navigator.of(context).pop();
                            },
                          ),
                          const Divider(
                            color: AppColor.kuWhite,
                            indent: 65,
                            endIndent: 65,
                          ),
                          ListTile(
                            leading: const Icon(Icons.block),
                            title: Text("Block ${doc["receivedBy"]}"),
                            iconColor: AppColor.kuRed,
                            textColor: AppColor.kuWhite70,
                            onTap: () {
                              _storeServices.updateBlockedStatus(
                                  doc["receiverUID"], true);
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
