import 'package:flutter/material.dart';
import 'package:kuchat/Screens/authentication_screen/AuthWidgets/bottom_nav_button.dart';
import 'package:kuchat/Services/auth/firebase_auth_services.dart';
import 'package:kuchat/Widgets/custom_elevated_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../Modals/user_modal.dart';
import '../../../../Widgets/appbar.dart';
import '../../../../Widgets/step_indicator.dart';
import '../../../../Widgets/subtitle_text.dart';
import '../../../../Widgets/title_text.dart';
import 'email_verification_logic.dart';


class SignUpEmailVerification extends StatefulWidget
    with SignUpEmailVerificationLogic {
  SignUpEmailVerification({Key? key}) : super(key: key);

  @override
  State<SignUpEmailVerification> createState() =>
      _SignUpEmailVerificationState();
}

class _SignUpEmailVerificationState extends State<SignUpEmailVerification> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.stateContext = context;

    widget.userEmailAddress = context.read<UserModel>().email;
    _authService.autoEmailVerification(context);
  }

  @override
  Widget build(BuildContext context) {
    widget.stateContext = context;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: CustomScrollView(
        slivers: [
          const KuAppBar(kuTitle: "Sign Up", kuPath: "egg.png"),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.space,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                      height: 20,
                      width: size.width,
                      child: StepIndicator(
                        currentStep: 2,
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TitleText(
                          text:
                              "A verification mail sent to \n${widget.userEmailAddress}"),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Lottie.asset(
                            "assets/mail.json",
                            height: size.height * 0.2,

                            fit: BoxFit.fitHeight),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const SubTitleText(
                          text:
                              "Click to the link received in the mail.This will verify your email address.\nIf not auto redirected after verification, click on the continue button"),
                      const SizedBox(
                        height: 20,
                      ),
                      KuButton(
                          onPressed: widget.onContinuePressed,
                          buttonText: "Continue")
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomButton(
        onPressed: () {},
        text: "Have not received the mail yet?",
      ),
    );
  }
}
