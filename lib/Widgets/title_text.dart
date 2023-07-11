import 'package:flutter/material.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';

class TitleText extends StatelessWidget {
  final String text;
  final Color textColor;

  const TitleText({Key? key, required this.text,this.textColor=AppColor.kuWhite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Text(text,
        style: TextStyle(
            fontSize: size.height*0.025, fontWeight: FontWeight.w500,color:textColor ));
  }
}
