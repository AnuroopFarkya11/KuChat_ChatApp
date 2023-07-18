import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kuchat/Widgets/snack_bar.dart';

class FirebaseStorageServices {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadProfilePictureToStorage(
      {required String imagePath, required String imageName}) async {
    String imageUrl =
        "https://firebasestorage.googleapis.com/v0/b/kuchat-2ef55.appspot.com/o/ProfileImages%2FdefaultImage.png?alt=media&token=f8b13f8e-a8e0-45f7-be92-19d6abc81abc";

    // REFERENCE TO THE PROFILE IMAGE FOLDER
    Reference profileFolderRef = _firebaseStorage.ref('ProfileImages');

    // Creating a file named as per image name
    Reference imageREf = profileFolderRef.child(imageName);

    // uploading
    try {
      await imageREf.putFile(File(imagePath)).whenComplete(() async {
        await imageREf.getDownloadURL().then((value) {
          imageUrl = value;
          log("USER PROFILE UPLOAD STATUS: FILE UPLOADED!");
        });
      });

    } on FirebaseException catch (e) {
      log("USER PROFILE UPLOAD STATUS: ${e.message}");
      throw "Sorry 🥺, Error caused while uploading your profile picture!";
    }

    /*  try {
    } on FirebaseException catch (e) {
      log("FETCHING IMAGE URL STATUS: ${e.message.toString()}");
    }*/

    return imageUrl;
  }
}
