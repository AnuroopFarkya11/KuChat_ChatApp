import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kuchat/Services/auth/firebase_auth_services.dart';
import 'package:provider/provider.dart';

import '../../../../Modals/user_modal.dart';
import '../../../../Widgets/snack_bar.dart';



class SignUpNameEmailScreenLogic {
  final GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  final FirebaseAuthService _authService = FirebaseAuthService();

  final TextEditingController emailFieldController = TextEditingController();

  late bool processing = false;
  late bool emailIndicator = false;

  late String userName = "";
  final FocusNode myFocusNode = FocusNode();
  final nameKey = GlobalKey<FormState>();
  final TextEditingController nameFieldController = TextEditingController();

  late Function() updateState;
  late BuildContext stateContext;

  void updateStateFun(Function() _, context) {
    updateState = _;
    stateContext = context;
  }

  void getContext(context) {
    stateContext = context;
    log("called");
  }

  void nameOnChanged(String value) {
    if (value.length == 0) {
      nameKey.currentState!.validate();
    }
  }

  String? nameValidator(String? value) {
    //todo
    if (value!.isEmpty) {
      return "Please enter your name...🥺🥺";
    } else {
      return null;
    }
  }

  void emailOnTap() {
    userName = nameFieldController.text;
    nameKey.currentState!.validate();
    updateState();
  }

  void emailOnChanged(String? value) {
    if (value!.isEmpty) {
      emailKey.currentState!.validate();
    }
  }

  String? emailValidator(String? value) {
    {
      //todo
      if (value!.isEmpty) {
        return "Please enter your email address to continue.";
      } else if (value.length == 1 || (value.length > 1 && value.length < 10)) {
        return "Enter a complete email address";
      } else if (!validateEmail(value)) {
        return "Invalid Email Address";
      } else {
        return null;
      }
    }
  }

  bool validateEmail(String email) {
    String pattern =
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void buttonNextTapped() async {
    if (!emailIndicator&&nameKey.currentState!.validate()) {
      emailIndicator = true;
      userName = nameFieldController.text;

      updateState();

      Timer(const Duration(milliseconds: 100), () {
        myFocusNode.nextFocus();
      });
    }
    if (emailIndicator && emailKey.currentState!.validate()) {
      processing = true;

      updateState();

      stateContext.read<UserModel>().name = nameFieldController.text;
      stateContext.read<UserModel>().email = emailFieldController.text;

      await _authService.sendMail(nameFieldController.text,emailFieldController.text).then((value) {
        log(value.toString());
        if (value['Res']) {
          Navigator.pushNamed(stateContext, '/SignUpEmailVerification');
          log(value['Status']);
          processing = false;
        } else {
          showSnackBar(stateContext, value['Status']);
          processing = false;
          updateState();
          //todo pop some error
        }
      });
    } else {
      processing = false;
      updateState();
    }
  }

  void onBottomPressed() {
    Navigator.of(stateContext).pop();
    // Navigator.pop(stateContext);
  }
}
