import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kuchat/Services/auth/firebase_auth_services.dart';
import 'package:provider/provider.dart';

import '../../../../Modals/user_modal.dart';

class PasswordScreenLogic{
  final FirebaseAuthService _authService = FirebaseAuthService();
  final passwordKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  bool isVisible = false;

  bool isLoading = false;



  late final Function() updateState;
  late BuildContext stateContext;

  void updateStateFun(Function() _,context)
  {
    updateState = _;
    stateContext = context;
  }
  void getContext(context){
    stateContext = context;
    log("called");
  }


  String? passwordValidator(String? value)
  {
    if (value!.isEmpty) {
      return "Please enter your password";
    }
    return null;
  }


  Future onButtonPressed()async{
    isLoading = true;
    updateState();
    String email = stateContext.read<UserModel>().email;
    String userEnteredPassword = passwordController.text;
    log("User entered password: $userEnteredPassword");
    if(passwordKey.currentState!.validate())
    {
      await _authService.updatePassword(email,userEnteredPassword).then((value){
        if(value)
        {
          Navigator.pushReplacementNamed(stateContext, '/SignUpBio');
        }
      });
    }
    else{
      isLoading = false;
      updateState();
    }
  }


}