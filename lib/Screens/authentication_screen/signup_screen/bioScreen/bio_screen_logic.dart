import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuchat/Services/auth/firebase_auth_services.dart';
import 'package:kuchat/Services/fire_storage/firebase_storage_services.dart';
import 'package:kuchat/Services/fire_store/firebase_store_services.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../Modals/user_modal.dart';

class SignUpBioScreenLogic{
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseStorageServices _storageServices = FirebaseStorageServices();
  final FireStoreServices _storeServices = FireStoreServices();
  String imagePath = "";
  late String imageName = "";
  late String imageUrl;
  // late String uid;
  bool processing = false;
  TextEditingController bioController= TextEditingController();

  late BuildContext stateContext;
  late Function() updateState;

  void screenState(Function() _, stateContext)
  {
    updateState = _;
    this.stateContext = stateContext;
  }

  Future<void> onContinue(BuildContext stateContext) async {
    String uid = _authService.getCurrentUserUID();
    stateContext.read<UserModel>().userId = uid;
    // todo get data from bio field save it globally

    String userBio = bioController.text;
    if(userBio.isNotEmpty)
    {
      stateContext.read<UserModel>().userBio = userBio;
    }
    else{
      stateContext.read<UserModel>().userBio = "I am a KuChatUser!!";
    }

    processing = true;
    updateState();

    //  IF USER HAVE NOT SELECTED A PROFILE PICTURE THEN A DEFAULT PROFILE PICTURE WILL BE UPLOADED TO DATABASE
    if (imagePath.isNotEmpty) {
      // String name = stateContext.read<UserModel>().name;
      String url = await _storageServices.uploadProfile(imagePath: imagePath, imageName: uid);

      // Creating/calling a global class object
      stateContext.read<UserModel>().profilePicturePath = imagePath;
      stateContext.read<UserModel>().downloadUrl = url;
    } else {
      String defaultImageUrl =
          "https://firebasestorage.googleapis.com/v0/b/kuchat-2ef55.appspot.com/o/ProfileImages%2FdefaultImage.png?alt=media&token=f8b13f8e-a8e0-45f7-be92-19d6abc81abc";

      stateContext.read<UserModel>().downloadUrl = defaultImageUrl;

      await _storeServices.pushUserDetailsToStore(context: stateContext)
          .then((value) => {processing = false});
    }

    // This function will push the entire user details to firestorm
    await _storeServices.pushUserDetailsToStore(context: stateContext).whenComplete((){
      processing = false;
      Navigator.pushNamedAndRemoveUntil(stateContext, '/HomeScreen', (route) => false);
    });
  }


  selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);
    log(file!.path);

    if (file!=null) {
      return cropImage(File(file.path));
    } else {
      return "";
    }
  }
  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);

    if (file != null) {
      return file.path;
    } else {
      return "";
    }
  }
  cropImage(File file) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        cropStyle: CropStyle.rectangle,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Crop Picture",
              toolbarColor: AppColor.kuBlue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              activeControlsWidgetColor: AppColor.kuYellow),
          IOSUiSettings(
            title: "Image Cropper",
            aspectRatioLockEnabled: false,
            hidesNavigationBar: true,
            doneButtonTitle: 'Chlo',
          )
        ]);

    if (croppedFile != null) {
      imageCache.clear();
      return croppedFile.path;
    }
  }


}