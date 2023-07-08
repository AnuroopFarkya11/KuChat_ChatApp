import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../Widgets/snack_bar.dart';

class InternetManager {
  bool checkInternetSourceStatus(context){
    try {
      Connectivity().checkConnectivity().then((ConnectivityResult res) async{
        if (res == ConnectivityResult.none) {
          showSnackBar(context, "No internet connection!");
          return false;
        } else {
          return true;
        }
      });
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<bool> checkInternetStatus() async {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult res) async {
      try {
        await InternetConnectionChecker().hasConnection.then((bool res) {

          return res;
        });
      } on Exception catch (e) {
        log("Internet status: ${e.toString()}");
      }
    });
    return false;
  }
}


/*
* {
          showSnackBar(context, "Checking internet status");
          await checkInternetStatus().then((bool res){

            if(res)
              {
                showSnackBar(context, "Yay!Connection successful!!");
                return;

              }
            else{
              showSnackBar(context, "Yay!Connection unsuccessful!!");
              return;
            }

          });
        }*/