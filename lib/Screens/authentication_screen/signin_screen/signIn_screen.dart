import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuchat/Screens/authentication_screen/AuthWidgets/bottom_nav_button.dart';
import 'package:kuchat/Services/auth/firebase_auth_services.dart';
import 'package:kuchat/Widgets/form_fields.dart';
import 'package:kuchat/Screens/authentication_screen/signin_screen/signIn_screen_logic.dart';
import 'package:kuchat/Widgets/custom_elevated_button.dart';

import '../../../Widgets/appbar.dart';
import '../../../Widgets/snack_bar.dart';
import '../../../Widgets/subtitle_text.dart';
import '../../../Widgets/title_text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SignInScreenLogic {
  final ScrollController scrollController = ScrollController();

  // final emailKey = GlobalKey<FormState>();

  String passwordErrorText = "";

  late Size size;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateState(() {
      setState(() {});
    }, context);
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          const KuAppBar(
            kuTitle: "Sign In",
            kuPath: "hello.png",
            autoLead: false,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const TitleText(text:"Hello!" ),
                  const SubTitleText(text: "Welcome! I was eagerly waiting for youuu!"),


                  const SizedBox(
                    height: 30,
                  ),

                  KuFormField(

                    hintText: "Email Address",
                    formKey: emailKey,
                    textFormController: emailController,
                    formOnChanged: emailOnChanged,
                    formValidator: emailValidators,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  KuFormField(
                    hintText: "Password",
                    formKey: passwordKey,
                    textFormController: passwordController,
                    obscureText: !isVisible,
                    formOnTap: passwordOnTap,
                    formValidator: passwordValidator,
                    suffixIcon: IconButton(
                      icon: isVisible
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () {
                        isVisible = !isVisible;
                        setState(() {});
                      },
                    ),
                  ),

                  // PASSWORD TEXTFIELD

                  const SizedBox(
                    height: 30,
                  ),

                  KuButton(
                      onPressed: onContinuePressed,
                      buttonText: "Continue",
                      isLoading: isLoading),

                  Divider(
                    color: Colors.white,
                    height: 50,
                    thickness: 0.5,
                    indent: size.width * 0.15,
                    endIndent: size.width * 0.15,
                  ),

                  TextButton(
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      onPressed: () {
                        forgotPassword();
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomButton(
        onPressed: bottomOnPressed,
        text: "Create an Account",
      ),
    );
  }

  bool _isLoading = false;
  final _emailForgotPasswordKey = GlobalKey<FormState>();
  final TextEditingController _emailForgotPasswordCOntroller =
      TextEditingController();

  void forgotPassword() {
    showModalBottomSheet(
        backgroundColor: Colors.grey.shade900,
        constraints: BoxConstraints(maxHeight: size.height * 0.9),
        enableDrag: true,
        isScrollControlled: true,
        useRootNavigator: true,
        useSafeArea: true,
        context: context,

        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        builder: (context) {
          return StatefulBuilder(builder:
              (BuildContext contextt, void Function(void Function()) setState) {
            return Container(
              padding: const EdgeInsets.all(10),
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(
                    height: 30,
                    indent: size.width * 0.25,
                    endIndent: size.width * 0.25,
                    color: Colors.white,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TitleText(text:"Forgot Password"),

                  SizedBox(
                    height: 10,
                  ),
                  SubTitleText(text:"Please enter the email address associated with your account. We will send a verification link to reset your password.",
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _emailForgotPasswordKey,
                    child: TextFormField(
                      controller: _emailForgotPasswordCOntroller,
                      onTap: () {
                        // _emailKey.currentState!.validate();
                        // _emailForgotPasswordKey.currentState!.validate();
                      },
                      validator: (value) {
                        //todo
                        if (value!.isEmpty) {
                          return "Please enter your email address.";
                        }
                        return null;
                      },
                      style: GoogleFonts.poppins(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        errorText: null,
                        filled: true,
                        fillColor: Colors.white70,
                        // prefixIcon: Icon(Icons.lock_outline),
                        //todo
                        labelText: "Email address",
                        labelStyle: TextStyle(color: Colors.white),

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.5)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                                BorderSide(width: 1.5, color: Colors.red)),
                        errorMaxLines: 1,
                        errorStyle: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_emailForgotPasswordKey.currentState!.validate()) {
                        _isLoading = true;
                        setState(() {});

                        await FirebaseAuthService().userForgotPassword(userEmail: _emailForgotPasswordCOntroller.text).then((value){
                          _emailForgotPasswordCOntroller.clear();
                          Navigator.of(context).pop();
                          showSnackBar(context, value.toString());


                        });
                      }
                    },
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.grey.shade900, strokeWidth: 2),
                          )
                        : Text("Continue",
                            style: GoogleFonts.poppins(
                                color: Colors.grey.shade900,
                                fontWeight: FontWeight.w500)),
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(), backgroundColor: Colors.white),
                  ),
                ],
              ),
            );
          });
        });
  }
}
