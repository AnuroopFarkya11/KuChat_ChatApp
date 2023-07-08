import 'package:flutter/cupertino.dart';
import 'package:kuchat/Services/auth/firebase_auth_services.dart';
import 'package:kuchat/Widgets/snack_bar.dart';
import 'package:provider/provider.dart';

import '../../../../Modals/user_modal.dart';



class SignUpEmailVerificationLogic{
  late String userEmailAddress="";
  late BuildContext stateContext;

  final FirebaseAuthService _authService = FirebaseAuthService();

  onContinuePressed(){
  String uid = _authService.getCurrentUserUID();
  bool res = _authService.checkVerification();
  if(res&&uid.isNotEmpty)
  {
  stateContext.read<UserModel>().userId = uid;
  Navigator.pushReplacementNamed(stateContext,  '/SignUpPassword');
  }
  else{
  //todo give snack bar that indicates not verified


    showSnackBar(stateContext,"Sorry,Email not got verified!");
  }

}





}
