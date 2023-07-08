import 'package:flutter/material.dart';
import 'package:kuchat/Screens/authentication_screen/AuthWidgets/bottom_nav_button.dart';
import 'package:kuchat/Widgets/form_fields.dart';
import 'package:kuchat/Screens/authentication_screen/signup_screen/nameEmailScreen/signup_screen_logic.dart';
import 'package:kuchat/Widgets/custom_elevated_button.dart';

import '../../../../Widgets/appbar.dart';
import '../../../../Widgets/step_indicator.dart';
import '../../../../Widgets/subtitle_text.dart';
import '../../../../Widgets/title_text.dart';


class SignUpNameEmailScreen extends StatefulWidget
    with SignUpNameEmailScreenLogic {
  SignUpNameEmailScreen({Key? key}) : super(key: key);

  @override
  State<SignUpNameEmailScreen> createState() => _SignUpNameEmailScreen();
}

class _SignUpNameEmailScreen extends State<SignUpNameEmailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    widget.updateStateFun(() {
      setState(() {});
    }, context);
    // widget.getContext(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: CustomScrollView(
        slivers: [
          const KuAppBar(kuTitle: "Sign Up", kuPath: "egg.png"),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20,
                    width: size.width,
                    child: const StepIndicator(
                      currentStep: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TitleText(
                      text: widget.emailIndicator
                          ? "Helloo ${widget.userName}!! 😎"
                          : "What's your nameeee!!? 💖"),
                  SubTitleText(
                      text: widget.emailIndicator
                          ? "Enter the email address at which you can be contacted.\nA verification link will sent to your mail."
                          : "Please enter your name!?"),
                  const SizedBox(
                    height: 30,
                  ),
                  KuFormField(
                    labelText: "Name",
                    formKey: widget.nameKey,
                    textFormController: widget.nameFieldController,
                    focusNode: widget.myFocusNode,
                    formOnChanged: widget.nameOnChanged,
                    formValidator: widget.nameValidator,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (widget.emailIndicator)
                    KuFormField(
                      labelText: "Email Address",
                      formKey: widget.emailKey,
                      textFormController: widget.emailFieldController,
                      formOnTap: widget.emailOnTap,
                      formOnChanged: widget.emailOnChanged,
                      formValidator: widget.emailValidator,
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  KuButton(
                    onPressed: widget.buttonNextTapped,
                    buttonText: "Next",
                    isLoading: widget.processing,
                  )
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomButton(
        text: "Have an account?",
        onPressed: widget.onBottomPressed,
      ),
    );
  }
}
