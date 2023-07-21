import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuchat/Screens/drawer_screens/current_user_profile_screen/current_user_profile_screen.dart';
import 'package:kuchat/Screens/drawer_screens/current_user_profile_screen/current_user_profile_screen_logic.dart';
import 'package:kuchat/Widgets/snack_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../Modals/user_modal.dart';
import '../Services/fire_storage/firebase_storage_services.dart';
import '../Services/fire_store/firebase_store_services.dart';
import '../Utils/theme_color/app_colors.dart';

class GetImage {
  // late BuildContext context;
  late Function() setState;
  late String userUID;

  GetImage({
    // required this.context,
    required this.setState,
    required this.userUID,
  });

/*
* show modal bottom sheet
* show two options: GALLERY AND CAMERA
* TAKE IMAGE PATH
* CALL PROCESS INDICATOR FUNCTION : THIS FUNCTION WILL MAKE TRUE THE INDICATOR BOOL AND CALL SET STATE.
* CALL START UPLOAD METHOD: HERE FIRESTORE WILL UPDATE AND METHOD WILL RETURN A UPDATE PROFILE URL
*
* YHA SE IG RETURN THIS URL TO THE FUNCTION CALL
*
*
*
*
*
*
* */
  final FirebaseStorageServices _storageServices = FirebaseStorageServices();
  final FireStoreServices _storeServices = FireStoreServices();

  Future<String> getImageSource(BuildContext context) async {
    String imagePath = "";
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //    TITLE
              const Text(
                "Select Image!",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //   gallery button
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          try {
                            await selectImageFromGallery().then((value) async {
                              if (value.isNotEmpty) {
                                log("Select GalleryImage Status: $value");
                                imagePath = value;
                                Navigator.of(context).pop();

                                // setState();
                              } else {
                                showSnackBar(context, "An error occurred.");
                              }
                            });
                          } on Exception catch (e) {
                            log("Select GalleryImage Status:${e.toString()}");
                          }
                        },
                        child: const CircleAvatar(
                          backgroundColor: AppColor.kuGrey,
                          backgroundImage:
                              AssetImage('assets/gallerypicture.png'),
                          maxRadius: 50,
                          minRadius: 40,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Gallery',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.white),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      await selectImageFromCamera().then((value) {
                        if (value.isNotEmpty) {
                          log("Select CameraImage Status: $value");
                          imagePath = value;
                          Navigator.of(context).pop();

                          // setState();
                        } else {
                          showSnackBar(context, "An error occurred.");
                        }
                      });
                      // log("${imagepath}");
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircleAvatar(
                          backgroundColor: AppColor.kuGrey,
                          backgroundImage: AssetImage('assets/takepicture.png'),
                          maxRadius: 50,
                          minRadius: 40,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          );
        });
    return imagePath;
  }

  Future selectImageFromGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      return cropImage(File(file.path));
    } else {
      return "";
    }
  }

  Future selectImageFromCamera() async {
    ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      return cropImage(File(file.path));
    } else {
      return "";
    }
  }

  cropImage(File file) async {
    ImageCropper cropper = ImageCropper();
    final croppedFile = await cropper.cropImage(
        sourcePath: file.path,
        cropStyle: CropStyle.rectangle,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets:[CropAspectRatioPreset.square],
        compressQuality: 50,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Crop Picture",
              toolbarColor: AppColor.kuGrey,
              toolbarWidgetColor: Colors.white,
              cropGridColor: AppColor.kuGrey,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              activeControlsWidgetColor: AppColor.kuWhite),
          IOSUiSettings(
            title: "Image Cropper",
            aspectRatioLockEnabled: true,
            hidesNavigationBar: true,
            doneButtonTitle: 'Chlo',


          )
        ]);
    if (croppedFile != null) {
      imageCache.clear();
      return croppedFile.path;
    }
  }

/*  Future startUploadImage(imagePath) async {
    if (imagePath.isNotEmpty) {
      // setState();
      try {
        await _storageServices
            .uploadProfilePictureToStorage(
                imagePath: imagePath, imageName: userUID)
            .then((value) async {
          context.read<UserModel>().downloadUrl = value;
          await _storeServices.updateProfileURL(url: value);
        });
      } on Exception catch (e) {
        throw "An error occurred.Please try again";
        // showSnackBar(context, "An error occurred.Please try again");
      }

    }
  }*/

/*void pushPictureToStorage(imagePath) async {
    String currentUid = context.read<UserModel>().userId;

    await FirebaseStorageServices()
        .uploadProfilePictureToStorage(
            imagePath: imagePath, imageName: currentUid)
        .whenComplete(() {
      showSnackBar(context, "Profile updated successfully!");
      CurrentUserProfileScreenLogic.loadingImage = false;
      setState();
    });
  }*/
}
/*BottomSheet(
        backgroundColor: Colors.grey.shade800,
        onClosing: () {},
        enableDrag:true ,
        elevation: 50,


        builder: (context))*/
