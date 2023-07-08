import 'package:flutter/material.dart';
import 'package:kuchat/Widgets/form_fields.dart';
import 'package:kuchat/Screens/authentication_screen/signup_screen/passwordScreen/password_screen_logic.dart';
import 'package:kuchat/Widgets/custom_elevated_button.dart';

import '../../../../Widgets/appbar.dart';
import '../../../../Widgets/step_indicator.dart';
import '../../../../Widgets/subtitle_text.dart';
import '../../../../Widgets/title_text.dart';

class SignUpPasswordScreen extends StatefulWidget{
  SignUpPasswordScreen({Key? key}) : super(key: key);

  @override
  State<SignUpPasswordScreen> createState() => _SignUpPasswordScreenState();
}

class _SignUpPasswordScreenState extends State<SignUpPasswordScreen>  with PasswordScreenLogic{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateStateFun((){setState(() {

    });},context);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: CustomScrollView(

        slivers: [
          const KuAppBar(kuTitle: "Sign Up", kuPath:"egg.png" ),

          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                      height: 20,
                      width: size.width,
                      child: const StepIndicator(
                        currentStep: 3,
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  const TitleText(text: "Create a password?" ),
                  const SubTitleText(text: "Create a password with at least 6 letters or numbers."),
                  const SizedBox(
                    height: 30,
                  ),

                  KuFormField(
                    labelText: "Password",
                    formKey: passwordKey,
                    textFormController: passwordController,
                    obscureText: !isVisible,
                    formValidator: passwordValidator,

                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  KuButton(onPressed: onButtonPressed, buttonText: "Next",isLoading: isLoading,),


                ],
              ),
            ),
          )
        ],
      ),

    );
  }
}
