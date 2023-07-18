import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';

class BottomImageSources extends StatelessWidget {
  BuildContext stateContext;
  BottomImageSources({Key? key,required this.stateContext}) : super(key: key);

  @override
  Widget build(stateContext) {

    log(name: "Bottom sheet status","Called");
    return BottomSheet(
        backgroundColor: Colors.black87,
        onClosing: () {},
        builder: (context) {
          return Container(height: 200,);
        });
  }
}
