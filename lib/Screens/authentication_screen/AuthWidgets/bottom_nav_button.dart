import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class BottomButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const BottomButton({Key? key,required this.text,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:onPressed,
      child: Text(
        text,
        style: GoogleFonts.poppins(
            color: Colors.white, fontWeight: FontWeight.w500),
      ),

      style: TextButton.styleFrom(foregroundColor: Colors.white),
    );
  }
}
