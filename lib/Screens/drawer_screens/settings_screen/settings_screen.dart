import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuchat/Modals/user_modal.dart';
import 'package:kuchat/Screens/drawer_screens/settings_screen/Widgets/change_password_bottom_sheet.dart';
import 'package:kuchat/Screens/drawer_screens/settings_screen/Widgets/delete_account_bottom_sheet.dart';
import 'package:kuchat/Screens/drawer_screens/settings_screen/settings_screen_logic.dart';
import 'package:kuchat/Services/shared_preferences/shared_preference_manager.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';
import 'package:kuchat/Widgets/kudrawer.dart';
import 'package:kuchat/Widgets/snack_bar.dart';
import 'package:kuchat/Widgets/title_text.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/appbar.dart';
import '../../../Widgets/subtitle_text.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with SettingsScreenLogic {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const KuDrawer(),
      body: CustomScrollView(
        slivers: [
          const KuAppBar(
              kuTitle: "Settings",
              autoLead: false,
              kuPath: "sailor.png",
              titleFontSize: 25),
          SliverFixedExtentList(
              delegate: SliverChildListDelegate([
                listItem(
                    leading: Icons.notifications_active,
                    title: "Notifications",
                    onTap: () {

                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      SharedPreferenceManager.notificationPreference(status: true);
                                      Navigator.of(context).pop();
                                      showSnackBar(
                                          context, "Notification turned on!");
                                      log(SharedPreferenceManager.getNotificationPreferenceStatus().toString());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: AppColor.kuWhite12,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.notifications_active,
                                            color: AppColor.kuWhite,
                                            size: size.width * 0.1,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const SubTitleText(
                                              text: "Turn On Notification")
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      SharedPreferenceManager.notificationPreference(status: false);
                                      Navigator.of(context).pop();
                                      showSnackBar(
                                          context, "Notification turned off!");
                                      log(SharedPreferenceManager.getNotificationPreferenceStatus().toString());

                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: AppColor.kuWhite12,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.notifications_off_rounded,
                                            color: AppColor.kuWhite,
                                            size: size.width * 0.1,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const SubTitleText(
                                              text: "Turn Off Notification")
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    }),
                /* ListTile(
                  iconColor: Colors.black,
                  leading: Icon(Icons.notifications_active),
                  title: Text("Notifications"),
                ),*/

                listItem(
                    leading: Icons.lock,
                    title: "Change password",
                    onTap: () {
                      String userMail = context.read<UserModel>().email;
                      ChangePasswordManager()
                          .changeUserPassword(context, userMail);
                    }),
                listItem(
                    leading: Icons.delete,
                    title: "Delete Account",
                    onTap: () {
                      String userMail = context.read<UserModel>().email;
                      AccountDeleteManager()
                          .deleteAccountSheet(context, userMail);
                    }),
                listItem(
                    leading: Icons.sunny,
                    title: "Change Theme",
                    onTap: () {
                      showSnackBar(
                          context, "Sorry, this feature is under development");
                    })
              ]),
              itemExtent: 70)
        ],
      ),
    );
  }
}
