import 'package:flutter/material.dart';
import 'package:kuchat/Services/auth/firebase_auth_services.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';

class KuDrawer extends StatefulWidget {
  const KuDrawer({Key? key}) : super(key: key);

  @override
  State<KuDrawer> createState() => _KuDrawerState();
}

class _KuDrawerState extends State<KuDrawer> {
  static int selectedTileIndex = 0;

  void selectedTile(int index) {
    setState(() {
      selectedTileIndex = index;
    });
  }

  Widget listItem(
      {required IconData leading,
      required String title,
      required Function() onTap,
      required int index}) {
    return ListTile(
      leading: Icon(
        leading,
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      onTap: onTap,
      selected: selectedTileIndex == index,
      selectedColor: Colors.white,
      selectedTileColor: Colors.white10,
      // selectedTileColor: Colors.white10,
      // iconColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade800,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              AppColor.kuBlue,
              AppColor.kuWhite,
              AppColor.kuYellow
            ])),
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundColor: AppColor.kuWhite70,
                    backgroundImage:
                        Image.asset("assets/kuuuu/hello.png").image,
                    radius: 45,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("KuChat"),
              ],
            ),
          ),
          listItem(
              leading: Icons.home,
              title: "Home",
              onTap: () {
                selectedTile(0);
                Navigator.pushReplacementNamed(context, '/HomeScreen');
              },
              index: 0),
          listItem(
              leading: Icons.person,
              title: "Profile",
              onTap: () {
                selectedTile(1);
                

               /* Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/CurrentProfileScreen', (route){
                  selectedTileIndex =0;
                  return true;
                });*/
                Navigator.pushReplacementNamed(
                    context, '/CurrentProfileScreen');
                // Navigator.pop(context);
              },
              index: 1),
          listItem(
              leading: Icons.archive,
              title: "Archive Chats",
              onTap: () {
                selectedTile(2);
                Navigator.pushReplacementNamed(context, '/ArchiveChatScreen');
                // Navigator.pop(context);
              },
              index: 2),
          listItem(
              leading: Icons.block,
              title: "Blocked Chats",
              onTap: () {
                selectedTile(3);
                Navigator.pushReplacementNamed(context, '/BlockedUsersScreen');
                // Navigator.pop(context);
              },
              index: 3),
          listItem(
              leading: Icons.settings,
              title: "Settings",
              onTap: () {
                selectedTile(4);
                Navigator.pushReplacementNamed(context, '/SettingScreen');
              },
              index: 4),
          listItem(
              leading: Icons.help,
              title: "Help or Support",
              onTap: () {
                selectedTile(5);
                Navigator.pushReplacementNamed(context, "/HelpAndSupportScreen");
              },
              index: 5),
/*          listItem(
              leading: Icons.feedback,
              title: "Feedback or Report",
              onTap: () {
                selectedTile(6);
              },
              index: 6),*/
          listItem(
              leading: Icons.logout_outlined,
              title: "Logout",
              onTap: () {
                selectedTile(6);
                FirebaseAuthService().signOutUser(context).then((bool res){
                  if(res)
                    {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, "/SignInScreen");
                      selectedTileIndex =0;
                    }
                });
              },
              index: 6),
          listItem(
              leading: Icons.adb,
              title: "About Developer",
              onTap: () {
                selectedTile(7);
                Navigator.pushReplacementNamed(context, "/AboutDeveloperScreen");
              },
              index: 7),
        ],
      ),
    );
  }
}
