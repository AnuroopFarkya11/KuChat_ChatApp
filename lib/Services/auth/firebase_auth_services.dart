import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Widgets/snack_bar.dart';



class FirebaseAuthService{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static late String uid;




  String firebaseAuthStatus(){
    try {
      User? user = _firebaseAuth.currentUser;
      if(user!=null)
      {
        getCurrentUserUID();
        log("USER AUTH STATUS: SIGNED IN!: $uid");

        return "true";
      }
      else {
        log("USER AUTH STATUS: SIGNED OUT!");

        // showSnackBar(context, "Signed out!");

        return "false";
      }

    } on FirebaseException catch (e) {
      return e.message.toString();
    }


  }

  String getCurrentUserUID(){
    try {

        uid = _firebaseAuth.currentUser!.uid;
        log("UID:$uid");

      return uid;

    } on FirebaseAuthException catch (e) {

      log("CURRENT USER UID error: ${e.message.toString()}");
      return "";
    }

  }

  Future<bool> signInUser({required BuildContext context,required String email,required String password}) async{

    log("$email$password");



    // TODO INVALID EMAIL YA PASSWORD PR EXCEPTION LE AUR SNACKBAR KO DE


    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch(e)
    {
      // log("Firebase login status : ${errore}");
      // showSnackBar(context, e.code);
      if(e.code == 'user-not found'){
        showSnackBar(context,"Sorry! No User found");
        log("SIGN IN SCREEN : NO USER FOUND");
      }
      else if(e.code=='wrong-password')
      {
        showSnackBar(context, "Oops! Invalid Password!\nTry Again.");
        log("SIGN IN SCREEN : INVALID PASSWORD");
      }
      else {
        showSnackBar(context, e.message.toString());
      }
    }
    catch(e){
      log("$e");
    }

    return false;
  }

  Future<Map<dynamic,dynamic>> sendMail(String displayName,String emailAddress)async{


    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email:emailAddress , password: "kuUser123");
      await _firebaseAuth.currentUser!.updateDisplayName(displayName);
      await _firebaseAuth.currentUser!.sendEmailVerification().whenComplete((){
        log("Mail sent successfully!");
        getCurrentUserUID();

      });



      return {"Res":true,"Status":"Account Created & mail sent!"};
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());

      return {"Res":false,"Status":e.message.toString()};

      // TODO
    }

  }

  void autoEmailVerification(context){


    var timer = Timer.periodic(const Duration(seconds: 3), (timer) {

      _firebaseAuth.currentUser!.reload();
      if(_firebaseAuth.currentUser!.emailVerified)
      {
        timer.cancel();
        // navigate
        log("Verified!");
        Navigator.pushReplacementNamed(context, '/SignUpPassword');


      }
      else{

        log("AUTO-EMAIL VERIFICATION: NOT RECEIVED CONFIRMATION");


      }

    });
  }


  bool checkVerification(){
    if(_firebaseAuth.currentUser!.emailVerified) {
      return true;
    } else {
      return false;
    }
  }


  Future<bool> updatePassword(email,newPassword)
  async{

    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: "kuUser123");
      await _firebaseAuth.currentUser!.updatePassword(newPassword);
      log("Password Updated Successfully!");
      return true;


    }on FirebaseException catch(e)
    {
      log(e.message.toString());
    }
    return false;

  }

  Future<bool> signOutUser(context) async
  {
    try
    {
      await _firebaseAuth.signOut();
      showSnackBar(context, "Logout Successfully");
      return true;
    }on FirebaseAuthException catch(e){
      showSnackBar(context, e.code);
      return false;
    }
  }

  Future<bool> changePassword({required String userEmail,required String existingPassword,required String newPassword})async{
    log("$userEmail,$existingPassword,$newPassword");
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: userEmail, password: existingPassword);
      await _firebaseAuth.currentUser!.updatePassword(newPassword);
      return true;
    } on FirebaseException catch (e) {

      log("CHANGE PASSWORD STATUS: ${e.message}");



    }
    return false;

  }


}