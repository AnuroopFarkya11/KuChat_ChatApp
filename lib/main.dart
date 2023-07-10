import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kuchat/AppTheme/app_theme.dart';
import 'package:kuchat/Modals/user_modal.dart';
import 'package:kuchat/Screens/add_member_screen/add_members_screen.dart';
import 'package:kuchat/Screens/chat_screen/chat_screen_logic.dart';
import 'package:kuchat/Screens/drawer_screens/archive_chat_screen/archive_chat_screen.dart';
import 'package:kuchat/Screens/drawer_screens/blocked_users_screen/blocked_users_screen.dart';
import 'package:kuchat/Screens/drawer_screens/help_support_screen/help_support_screen.dart';
import 'package:kuchat/Screens/drawer_screens/settings_screen/settings_screen.dart';
import 'package:kuchat/Screens/no_internet_Screen/no_internet_screen.dart';
import 'package:kuchat/Screens/splash_screen/splash_screen.dart';
import 'package:kuchat/Services/internet_manager/internet_manager.dart';
import 'package:provider/provider.dart';
import 'Screens/authentication_screen/signin_screen/signIn_screen.dart';
import 'Screens/authentication_screen/signup_screen/bioScreen/bio_screen.dart';
import 'Screens/authentication_screen/signup_screen/emailVerification/email_verification.dart';
import 'Screens/authentication_screen/signup_screen/nameEmailScreen/signup_screen.dart';
import 'Screens/authentication_screen/signup_screen/passwordScreen/password_screen.dart';
import 'Screens/chat_screen/chat_screen.dart';
import 'Screens/drawer_screens/current_user_profile_screen/current_user_profile_screen.dart';
import 'Screens/drawer_screens/home_screen/home_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Provider(
    create: (context) => UserModel(),
    child: const KuApp(),
  ));
}

class KuApp extends StatelessWidget {
  const KuApp({super.key});





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: KuAppTheme.darkTheme,
      home:const SplashScreen(),
      routes: {
        "SplashScreen":(context)=>const SplashScreen(),
        "/SignInScreen": (context) => const SignInScreen(),
        "/SignUpNameEmailScreen": (context) => SignUpNameEmailScreen(),
        "/SignUpPassword":(context)=>SignUpPasswordScreen(),
        "/SignUpEmailVerification":(context)=>SignUpEmailVerification(),
        "/SignUpBio":(context)=>const SignUpBioScreen(),
        "/HomeScreen":(context)=>const HomeScreen(),
        "/AddMemberScreen":(context)=>const AddMemberScreen(),
        "/ChatScreen":(context)=>const ChatScreen(),
        "/CurrentProfileScreen":(context)=>const CurrentUserProfileScreen(),
        "/ArchiveChatScreen":(context)=>const ArchiveChatScreen(),
        "/BlockedUsersScreen":(context)=>const BlockedUsersScreen(),
        "/HelpAndSupportScreen":(context)=>HelpSupportScreen(),
        "/SettingScreen":(context)=>const SettingScreen()
      },
    );
  }
}
