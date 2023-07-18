import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:kuchat/AppTheme/app_theme.dart';
import 'package:kuchat/Modals/user_modal.dart';
import 'package:kuchat/Screens/add_member_screen/add_members_screen.dart';
import 'package:kuchat/Screens/chat_screen/chat_screen_logic.dart';
import 'package:kuchat/Screens/drawer_screens/about_developer_screen/about_developer_screen.dart';
import 'package:kuchat/Screens/drawer_screens/archive_chat_screen/archive_chat_screen.dart';
import 'package:kuchat/Screens/drawer_screens/blocked_users_screen/blocked_users_screen.dart';
import 'package:kuchat/Screens/drawer_screens/help_support_screen/help_support_screen.dart';
import 'package:kuchat/Screens/drawer_screens/settings_screen/settings_screen.dart';
import 'package:kuchat/Screens/no_internet_Screen/no_internet_screen.dart';
import 'package:kuchat/Screens/splash_screen/splash_screen.dart';
import 'package:kuchat/Services/fire_store/firebase_store_services.dart';
import 'package:kuchat/Services/internet_manager/internet_manager.dart';
import 'package:kuchat/Services/notification_manager/notifcation_manager.dart';
import 'package:kuchat/Services/shared_preferences/shared_preference_manager.dart';
import 'package:kuchat/Widgets/bottom_image_sources.dart';
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
  await SharedPreferenceManager.initializePreferences();
  await initializeNotificationChannel();
  await NotificationManager.getFirebaseNotificationToken();
  runApp(Provider(
    create: (context) => UserModel(),
    child: const KuApp(),
  ));
}

initializeNotificationChannel()async{
  log("Notification bell status: ${SharedPreferenceManager.getNotificationPreferenceStatus()}");
  bool? bell = SharedPreferenceManager.getNotificationPreferenceStatus();
  if(bell == null)
    {
      bell = true;
    }
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'Chat Notifications',
    id: 'KuChat117',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'KuChats',
    visibility: bell?NotificationVisibility.VISIBILITY_PUBLIC:NotificationVisibility.VISIBILITY_SECRET,
    // allowBubbles: true,
    // enableVibration: true,
    // enableSound: true,
    // showBadge: true,

  );
  log("Notification Channel status: $result");
}

class KuApp extends StatefulWidget {
  const KuApp({super.key});

  @override
  State<KuApp> createState() => _KuAppState();
}

class _KuAppState extends State<KuApp> with WidgetsBindingObserver {

  final FireStoreServices _storeServices = FireStoreServices();

  @override
  void initState() {
    log("Main INit");
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed)
    {
      _storeServices.setActiveStatus(true);
    }
    else{
      _storeServices.setActiveStatus(false);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    log("Main: disposed");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: KuAppTheme.darkTheme,
      home:const SplashScreen(),
      routes: {
        "/SplashScreen":(context)=>const SplashScreen(),
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
        "/SettingScreen":(context)=>const SettingScreen(),
        "/AboutDeveloperScreen":(context)=>const AboutDeveloperScreen(),
        // "/BottomImageSource":(context)=>BottomImageSources()
      },
    );
  }
}
