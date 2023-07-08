import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuchat/Services/fire_store/firebase_store_services.dart';

import '../../../Services/auth/firebase_auth_services.dart';

class SignInScreenLogic {


  final _firebaseAuthService = FirebaseAuthService();
  final FireStoreServices _storeServices = FireStoreServices();
  final emailKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  bool isVisible = false;
  bool isLoading = false;
  // late void Function(void Function()) setScreenState;
  late Function() setScreenState;
  late BuildContext context;

  void updateState(Function() _,context){
    setScreenState = _;
    this.context=context;
  }

  void emailOnChanged(String value) {
    if (value.isEmpty) {
      emailKey.currentState!.validate();
    }
  }

  String? emailValidators(String? value) {
    if (value!.isEmpty) {
      return "Please enter your email address";
    } else if (value.length == 1 || (value.length > 1 && value.length < 10)) {
      return "Incorrect email address";
    } else {
      return null;
    }
  }

  void passwordOnTap() {
    emailKey.currentState!.validate();
  }

  String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return "Please enter your password";
    }
    return null;
  }

  void onContinuePressed() async {
    if (true) {

      isLoading = true;
      log(isLoading.toString());
      setScreenState();



      await _firebaseAuthService.signInUser(
              context: context,
              email: emailController.text,
              password: passwordController.text)
          .then((value) async {
        if (value) {
          await _storeServices.loadCurrentUser(context).whenComplete(() {
            Navigator.pushReplacementNamed(context, '/HomeScreen');
          });
        } else {
          isLoading = false;
          setScreenState();

        }
      });
      // yha sign in wali method ko call kr user name password daal

      // todo error code ke hisaab se errormesage set krna hoga do alg alg strings me
    }
  }




  void bottomOnPressed(){
    Navigator.pushNamed(context,"/SignUpNameEmailScreen" );
  }
}
