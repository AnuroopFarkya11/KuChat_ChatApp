import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kuchat/Services/auth/firebase_auth_services.dart';
import 'package:kuchat/Services/fire_store/firebase_store_services.dart';
import 'package:kuchat/Widgets/snack_bar.dart';
import 'package:provider/provider.dart';

import '../../../../Modals/user_modal.dart';

class PasswordScreenLogic {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FireStoreServices _storeServices = FireStoreServices();

  final passwordKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  bool isVisible = false;
  bool isLoading = false;
  late final Function() updateState;
  late BuildContext stateContext;

  void updateStateFun(Function() _, context) {
    updateState = _;
    stateContext = context;
  }

  void getContext(context) {
    stateContext = context;
    log("called");
  }

  String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return "Please enter your password";
    }
    return null;
  }

  Future onButtonPressed() async {
    isLoading = true;
    updateState();
    String email = stateContext.read<UserModel>().email;
    String userEnteredPassword = passwordController.text;

    log("User entered password: $userEnteredPassword");

    if (passwordKey.currentState!.validate()) {
      showSnackBar(stateContext, "Creating your KuAccount!🫰");

      String uid = _authService.getCurrentUserUID();
      stateContext.read<UserModel>().userId = uid;

      //               UPDATING PASSWORD
      try {
        await _authService
            .updatePassword(email, userEnteredPassword)
            .then((value) async {
          if (value) {
            Map<String, dynamic> userModel =
                stateContext.read<UserModel>().toJSON();

            //       CREATING USER DOC IN FIRESTORE

            await _storeServices
                .createUserInStore(userModel: userModel)
                .then((value) {
              log("CREATING ACCOUNT IN STORE STATUS:$value");
              Navigator.pushReplacementNamed(stateContext, '/SignUpBio');
            });
          }
        });
      } on Exception catch (e) {
        showSnackBar(stateContext,
            "Sorry🫣, some error caused! Please try again later.");
        // TODO
      }
    }
    // if password strength is low
    else {
      isLoading = false;
      updateState();
    }
  }
}
