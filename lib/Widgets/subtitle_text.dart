import 'package:flutter/material.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';

class SubTitleText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? fontSize;

  const SubTitleText({Key? key, required this.text,this.textColor=AppColor.kuWhite,this.fontSize=13}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      maxLines: 2,
      style: TextStyle(
          fontSize: fontSize, fontWeight: FontWeight.w500, color: textColor),
    );
  }
}
