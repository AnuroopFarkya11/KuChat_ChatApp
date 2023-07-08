import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';

class KuButton extends StatelessWidget {
  final bool isLoading;
  final String buttonText;
  final Function()? onPressed;

  const KuButton(
      {Key? key,
      required this.onPressed,
      required this.buttonText,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: isLoading
          ? SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                  color: AppColor.kuGrey, strokeWidth: 2.0),
            )
          : Text(
              buttonText,
              style: GoogleFonts.poppins(color: AppColor.kuGrey),
            ),
    );
  }
}
