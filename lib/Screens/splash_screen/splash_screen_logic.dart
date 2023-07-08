import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:kuchat/Services/auth/firebase_auth_services.dart';
import 'package:kuchat/Services/fire_store/firebase_store_services.dart';
import 'package:kuchat/Widgets/snack_bar.dart';

class SplashScreenLogic{
  final BuildContext context;
  SplashScreenLogic({required this.context});

  final FirebaseAuthService _authService = FirebaseAuthService();
  final FireStoreServices _storeServices = FireStoreServices();

  void checkAuthToFetch(){
    String status = _authService.firebaseAuthStatus();

    if(status=="true")
    {
      // todo add a check whether the data loaded successfully or not
      // todo error handling if user data failed to load
      _storeServices.loadCurrentUser(context).whenComplete((){
        Future.delayed(Duration(seconds: 2),(){

          Navigator.pushReplacementNamed(context, '/HomeScreen');

        });
      });
    }
    else if (status == "false"){
      Timer(Duration(seconds: 2),(){
        Navigator.pushReplacementNamed(context, '/SignInScreen');

      });


    } else {

      Timer(const Duration(seconds: 1),(){
        showSnackBar(context, status);
      });


    }

  }




}