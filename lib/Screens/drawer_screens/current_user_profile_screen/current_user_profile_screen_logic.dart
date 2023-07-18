import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuchat/Services/fire_storage/firebase_storage_services.dart';
import 'package:kuchat/Services/fire_store/firebase_store_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../Modals/user_modal.dart';
import '../../../Widgets/get_image_from_source.dart';
import '../../../Widgets/snack_bar.dart';

class CurrentUserProfileScreenLogic{

  late String url = "";
  late String userName = "";
  late String userEmailAddress = "";
  late String userBio = "";
  late String userUID = "";

  final TextEditingController _changeUserNameController = TextEditingController();
  final _changeUserNameKey = GlobalKey<FormState>();

  late GetImage getImage;
  bool loadingImage = false;


  final FireStoreServices storeServices = FireStoreServices();
  final FirebaseStorageServices _storageServices = FirebaseStorageServices();
  late Function() setCurrentState;

  void updateState(Function() _){

    setCurrentState = _;

  }




  void changeUserName(context) {
    _changeUserNameController.text = userName;
    showDialog(
        useSafeArea: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade900,
            scrollable: true,
            title: const Text(
              "Change UserName",
            ),
            // shape: StadiumBorder(),
            titleTextStyle: GoogleFonts.poppins(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
            // contentPadding: EdgeInsets.all(10),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Form(
                    key: _changeUserNameKey,
                    onChanged: () {
                      _changeUserNameKey.currentState!.validate();
                    },
                    child: TextFormField(
                      controller: _changeUserNameController,
                      style: GoogleFonts.poppins(color: Colors.white),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field can't be empty.";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        //todo
                        labelText: "Name",
                        labelStyle: const TextStyle(color: Colors.white),

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.5)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                width: 1.5, color: Colors.red)),
                        errorMaxLines: 1,
                        errorStyle: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_changeUserNameKey.currentState!.validate()) {
                        await storeServices.updateUserName(
                            newUserName: _changeUserNameController.text)
                            .then((value) {
                          if (value) {
                            userName = _changeUserNameController.text;
                            context.read<UserModel>().name = userName;
                            setCurrentState();
                          } else {
                            showSnackBar(
                                context, "Sorry! Failed to update username");
                          }
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(), backgroundColor: Colors.white),
                    child: Text(
                      "Save",
                      style: GoogleFonts.poppins(color: Colors.grey.shade900),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  final TextEditingController _changeUserBioController = TextEditingController();
  final _changeUserBioKey = GlobalKey<FormState>();

  void changeUserBio(context) {
    _changeUserBioController.text = userBio;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade900,
            title: const Text("Change Bio"),
            titleTextStyle: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w500),
            scrollable: true,
            contentPadding: const EdgeInsets.all(10),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Form(
                    key: _changeUserBioKey,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 2,
                      controller: _changeUserBioController,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        //todo
                        labelText: "Bio",
                        labelStyle: const TextStyle(color: Colors.white),

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.5)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                width: 1.5, color: Colors.red)),
                        errorMaxLines: 1,
                        errorStyle: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await storeServices.updateUserBio(
                          newUserBio: _changeUserBioController.text)
                          .then((value) {
                        if (value) {
                          Navigator.of(context).pop();
                          userBio = _changeUserBioController.text;
                          context.read<UserModel>().userBio = userBio;
                        } else {
                          showSnackBar(
                              context, "Sorry,Unable to update User-Bio");
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      "Save",
                      style: GoogleFonts.poppins(color: Colors.grey.shade900),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future deleteProfileFilefromDevice() async {
    log(name:"DELETE IMAGE STATUS","CALLED");
    final appDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDir.path}/$userUID";
    log(name:"DELETE IMAGE STATUS FILEPATH ",filePath);


    final file = File(filePath);

    try {
      await file.delete();
      log(name:"DELETE IMAGE STATUS","IMAGE DELETED SUCCESSFULLY");

    } on Exception catch (e) {
      log("FILE DELETE STATUS: ${e.toString()}");
    }
  }



  
}