import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;



class ChatScreenLogic{
  late Size size;
  late Map<String, dynamic> arguments;
  late Map<String, dynamic> receiverMap={};
  late Map<String, dynamic> senderMap={};
  late final String roomID ;
  late final String currentUserName ;
  late final String receiverUserName ;
  late final String receiverUserId ;
  late final String receiverProfilePicture;
  late AnimationController animationController;
  late File userProfileFile;
  bool imageDownloaded = false;
  bool receiverDataReceived = false;
  bool senderDataReceived = false;
  late Function() updateState;

  void setUpdateState(Function () _){
    updateState = _;
  }


  getImageFileFromUrl() async {
    final filename = receiverUserId;
    final appDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDir.path}/$filename';

    animationController.forward();

    //checking if file exits
    final file = File(filePath);
    if (file.existsSync()) {
      log("Receiver file exists");
      userProfileFile = file;
      imageDownloaded = true;
      updateState();
      return file;
    } else {
      final response = await http.get(Uri.parse(receiverProfilePicture));
      await file.writeAsBytes(response.bodyBytes).whenComplete(() {
        userProfileFile = file;
        imageDownloaded = true;
        updateState();
      });
      return file;
    }
  }


}