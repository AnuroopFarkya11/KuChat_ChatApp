import 'package:flutter/material.dart';
import 'package:kuchat/Modals/user_modal.dart';
import 'package:kuchat/Services/fire_store/firebase_store_services.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/snack_bar.dart';

class HelpSupportScreenLogic {
  final FireStoreServices _storeServices = FireStoreServices();
  late BuildContext context;
  late Function setCurrentState;
  bool isLoading = false;
  GlobalKey<FormState> requestKey = GlobalKey<FormState>();
  TextEditingController requestController = TextEditingController();

  String? requestValidator(String? text) {
    if (text!.isEmpty) {
      return "Please add your request....";
    } else {
      return null;
    }
  }

  void onContinue() {
    String uid = context.read<UserModel>().userId;


    if (requestKey.currentState!.validate()) {
      isLoading = true;
      setCurrentState();
      _storeServices
          .sendRequestHelp(uid, requestController.text)
          .then((bool res) {
        isLoading = false;
        setCurrentState();
        if (res) {
          requestController.clear();
          showSnackBar(context,
              "Thank you for submitting your request.\nOur dedicated team will respond to your email promptly 💙");
        } else {
          showSnackBar(context,
              "We apologize for the inconvenience. Please try again later as we resolve the issue.");
        }
      });
    }
  }
}
