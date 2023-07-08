import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuchat/Widgets/snack_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../Modals/user_modal.dart';
import '../Services/fire_storage/firebase_storage_services.dart';
import '../Services/fire_store/firebase_store_services.dart';
import '../Utils/theme_color/app_colors.dart';

class GetImage {
  final BuildContext context;
  final Function() setState;
  final String userUID;


  GetImage(
      {required this.context,
      required this.setState,
      required this.userUID,
      });

  final FirebaseStorageServices _storageServices = FirebaseStorageServices();
  final FireStoreServices _storeServices = FireStoreServices();

  Future<String> getImageSource() async{
    String imagePath = "";
    showModalBottomSheet(
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
                          imagePath = await selectImageFromGallery();

                          /*if (imagePath.isNotEmpty) {
                            Navigator.of(context).pop();
                            log(imagePath);
                            setState();
                          } else {
                            showSnackBar(context, "An error occured.");
                          }*/
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
                      XFile imagepath = await selectImageFromCamera();
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
        }
        );
    return imagePath;
  }

  selectImageFromGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      return cropImage(File(file.path));
    } else {
      return "";
    }
  }

  selectImageFromCamera() async {
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
    final cropperdFile = await cropper.cropImage(
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
              toolbarColor: AppColor.kuGrey,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              activeControlsWidgetColor: AppColor.kuWhite),
          IOSUiSettings(
            title: "Image Cropper",
            aspectRatioLockEnabled: false,
            hidesNavigationBar: true,
            doneButtonTitle: 'Chlo',
          )
        ]);
    if (cropperdFile != null) {
      imageCache.clear();
      return cropperdFile.path;
    }
  }

  void deleteProfileFilefromDevice() async {
    final appDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDir.path}/$userUID";

    final file = File(filePath);

    try {
      await file.delete();
    } on Exception catch (e) {
      log("FILE DELETE STATUS: ${e.toString()}");
    }
  }


  startUploadImage(imagePath) async{
    if (imagePath.isNotEmpty) {

      try {
        await _storageServices
            .uploadProfile(
            imagePath: imagePath, imageName: userUID)
            .then((value) async {
          context.read<UserModel>().downloadUrl = value;
          await _storeServices
              .updateProfileURL(url: value)
              .whenComplete(() {
            deleteProfileFilefromDevice();
          });
        });
      } on Exception catch (e) {
        showSnackBar(
            context, "An error occured.Please try again");
      }
      setState();
    }
  }
}
/*BottomSheet(
        backgroundColor: Colors.grey.shade800,
        onClosing: () {},
        enableDrag:true ,
        elevation: 50,


        builder: (context))*/
