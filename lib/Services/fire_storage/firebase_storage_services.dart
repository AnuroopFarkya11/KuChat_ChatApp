import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kuchat/Widgets/snack_bar.dart';

class FirebaseStorageServices {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadProfile(
      {required String imagePath, required String imageName}) async {
    String imageUrl = "";

    // REFERENCE TO THE PROFILE IMAGE FOLDER
    Reference profileFolderRef = _firebaseStorage.ref('ProfileImages');

    // Creating a file named as per image name
    Reference imageREf = profileFolderRef.child(imageName);

    // uploading
    try {

        await imageREf.putFile(File(imagePath));
        log("Google FireStorage Status: FILE UPLOADED!");

    } on FirebaseException catch (e) {
      log("USER PROFILE UPLOAD STATUS: ${e.message}");
    }

    try {
      imageUrl = await imageREf.getDownloadURL();
    } on FirebaseException catch (e) {
      log("FETCHING IMAGE URL STATUS: ${e.message.toString()}");
    }

    return imageUrl;
  }
}
