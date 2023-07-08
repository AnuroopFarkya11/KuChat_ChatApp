import 'package:flutter/material.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';
class SettingsScreenLogic{

  Widget listItem(
      {required IconData leading,
        required String title,
        required Function() onTap,
        }) {
    return ListTile(
      leading: Icon(
        leading,
        color: AppColor.kuWhite70,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14,color: AppColor.kuWhite70),
      ),
      onTap: onTap,

      // selectedTileColor: Colors.white10,
      // iconColor: Colors.white,
    );
  }
}