import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';
import 'package:kuchat/Widgets/get_image_from_source.dart';
import 'package:kuchat/Widgets/snack_bar.dart';
import 'package:provider/provider.dart';

import '../../../Modals/user_modal.dart';
import '../../../Widgets/bottom_image_sources.dart';
import '../../../Widgets/kudrawer.dart';
import 'current_user_profile_screen_logic.dart';

class CurrentUserProfileScreen extends StatefulWidget {
  const CurrentUserProfileScreen({Key? key}) : super(key: key);

  @override
  State<CurrentUserProfileScreen> createState() =>
      _CurrentUserProfileScreenState();
}

class _CurrentUserProfileScreenState extends State<CurrentUserProfileScreen>
    with CurrentUserProfileScreenLogic {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userName = context.read<UserModel>().name;
    userEmailAddress = context.read<UserModel>().email;
    userBio = context.read<UserModel>().userBio;
    userUID = context.read<UserModel>().userId;
    url = context.read<UserModel>().downloadUrl;
    getImage = GetImage(

        setState: () {
          setState(() {});
        },
        userUID: userUID);
  }

  @override
  Widget build(BuildContext context) {
    log(name: "CURRENT PROFILE STATUS ", "CALLED");


    Size size = MediaQuery.of(context).size;
    updateState(() {
      setState(() {});
    });

    return Scaffold(
      drawer: const KuDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.3,
            elevation: 22,
            actions: [
              IconButton(
                  onPressed: () async {
                    // Navigator.pushNamed(context, "/BottomImageSource");
                    // context.read<UserModel>().downloadUrl="";
                    await getImage.getImageSource(context).then((value)async{

                      log(name:"IMAGE UPDATE TO CURRENT SCREEN STATUS",value);

                      if(value.isNotEmpty)
                        {
                          showSnackBar(context, "Uploading your profile photo.");
                          loadingImage = true;
                          setState(() {
                          });
                          await storeServices.startUploadImage(value).then((value)async{
                            await deleteProfileFilefromDevice().whenComplete((){

                              context.read<UserModel>().downloadUrl = value;
                              url = value;
                              loadingImage=false;
                              setState(() {

                              });
                            });

                          });
                        }


                    });
                    /*TODO
                      * make a function jisse apn process indicator update kr va ske:
                      * pass the function as the parameter
                      *
                      *
                      * call startUpload() method jisse hame upload hone ke baad url mil jaayega
                      *
                      * uss url ko usermodel ke download url me rkhna pdega
                      *
                      *
                      *
                      *
                      * */
                  },
                  icon: const Icon(Icons.edit))
            ],
            flexibleSpace: FlexibleSpaceBar(
              //CurrentUserProfileScreenLogic.loadingImage
              background:loadingImage
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: AppColor.kuWhite,
                    ))
                  : ShaderMask(
                      blendMode: BlendMode.hardLight,
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: [Colors.transparent, AppColor.kuGrey],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds);
                      },
                      // todo 1
                      child: GestureDetector(
                        onTap: (){
                          showDialog(context: context,barrierColor: Colors.black87, builder: (context){
                            return Center(child:GestureDetector(child: CachedNetworkImage(imageUrl: url,)) );
                          });
                        },
                        child: CachedNetworkImage(
                          placeholderFadeInDuration: const Duration(seconds: 2),
                          fadeOutDuration: const Duration(seconds: 2),
                          fadeInDuration: const Duration(seconds: 5),
                          imageUrl: url,
                          fit: BoxFit.fitWidth,
                          errorWidget: (context, url, error) => Image.asset(
                              "assets/wallpaper.jpg",
                              fit: BoxFit.fill),
                          placeholder: (context, url) => Image.asset(
                            "assets/wallpaper.jpg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      )),
              titlePadding: const EdgeInsets.only(left: 12),
              title: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userName,
                    softWrap: true,
                    maxLines: 1,
                  ),
                  IconButton(
                      onPressed: () {
                        changeUserName(context);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 15,
                      ))
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Email Address",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        userEmailAddress,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    changeUserBio(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Bio",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              Icon(
                                Icons.edit,
                                size: 15,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            userBio,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          )
                        ],
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// appBar: AppBar(
//   backgroundColor: Colors.transparent,
//   elevation: 0,
//   centerTitle:true,
//   title: Text("Contact Info",style: GoogleFonts.poppins(color: Colors.black),),
// ),

// body: Column(
// // mainAxisAlignment: MainAxisAlignment.center,
// // crossAxisAlignment: CrossAxisAlignment.start,
// children: [
//
//
// Image.asset("assets/titleimage.jpg")
//
//
// // CachedNetworkImage(imageUrl: )
//
// // Center(
// //   child: Column(
// //     children: [
// //       CircleAvatar(
// //         radius: 100,
// //         backgroundImage: Image.asset("assets/kuuuu/hello.png").image,
// //
// //       ),
// //
// //       SizedBox(height: 20,),
// //       Text("User Name",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 17),),
// //       Text("000000000",style: GoogleFonts.poppins(),)
// //
// //     ],
// //   ),
// //
// //
// //
// // )
//
// ],
// ),



/*    await _storeServices
                                    .startUploadImage(imagePath)
                                    .then((value){
                                  log(
                                      name: "PROFILE UPDATE STATUS:",
                                      "UPLOAD COMPLETE $value");
                                  imageUrl = value;
                                  // statecontext.read<UserModel>().downloadUrl = value;
                                  // setState();
                                 /* await deleteProfileFilefromDevice()
                                      .whenComplete(() {
                                    showSnackBar(context,
                                        "Profile updated successfully!");
                                    CurrentUserProfileScreenLogic.loadingImage =
                                        false;
                                    setState();
                                  });*/
                                });*/