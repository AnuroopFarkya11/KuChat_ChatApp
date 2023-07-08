import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kuchat/Screens/splash_screen/splash_screen_logic.dart';
import 'package:kuchat/Services/internet_manager/internet_manager.dart';

import '../../Utils/theme_color/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashScreenLogic _splashScreenLogic;
  final InternetManager _internetManager = InternetManager();

  @override
  void initState() {
    super.initState();
    _splashScreenLogic = SplashScreenLogic(context: context);
    /*
    * BRIEF SUMMARY: Checks the user's authentication status and handles navigation accordingly.
    *                If the user is signed in, the function imports the user data to the screen's providers and navigates to the home screen.
    *                If the user is signed out, the user navigates to sign in screen.
    *
    * Edge cases and error handling:
    *                If there is an error during authentication or user data loading, the user will be informed
    *                with an appropriate error message or UI notification.
    *
    * */


    _internetManager.checkInternetSourceStatus(context);

    _splashScreenLogic.checkAuthToFetch();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [AppColor.kuGrey, AppColor.kuBlue, AppColor.kuWhite],
          end: Alignment.bottomRight,
          begin: Alignment.topLeft,
        )),
        child: Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                /* CircleAvatar(
                  radius: size.width * 0.2,
                  backgroundColor: Colors.white70,
                  child: Image.asset(
                    "assets/kuuuu/hello.png",
                    height: size.height * 0.15,
                  ),
                ),*/
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
