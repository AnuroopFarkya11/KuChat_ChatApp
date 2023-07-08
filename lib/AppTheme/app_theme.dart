import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KuAppTheme {
  int radi = 10;
  static ThemeData lightTheme = ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      // useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
          .copyWith(background: Colors.white10),
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.black12,
        border: OutlineInputBorder(),
      ));

  static ThemeData darkTheme = ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      scaffoldBackgroundColor: Colors.grey.shade900,
      appBarTheme: const AppBarTheme(color: Colors.transparent, elevation: 0),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey,
      ),
      snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          insetPadding: const EdgeInsets.all(10.0),
          contentTextStyle: GoogleFonts.poppins(
              color: Colors.grey.shade900, fontWeight: FontWeight.w500),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)))),
      inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white70,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.white,
              ),
              gapPadding: 10.0),
          focusColor: Colors.white,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: Colors.white, width: 1.5),
              gapPadding: 10.0),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(width: 1.5, color: Colors.red)),
          errorMaxLines: 1,
          labelStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),
          errorStyle: TextStyle(color: Colors.red),
          suffixIconColor: Colors.white

          // prefixIcon: Icon(Icons.alternate_email,color: Colors.white,),
          //todo
          // labelText: widget.labelText,
          // labelStyle: TextStyle(color: AppColor.kuWhite),

          /*  border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0)),

      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide:
          BorderSide(color: Colors.white, width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide:
          BorderSide(width: 1.5, color: Colors.red)),
      errorMaxLines: 1,
      errorStyle: GoogleFonts.poppins(),*/
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              enableFeedback: true,
              shadowColor: Colors.white,
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              shape: const StadiumBorder())),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedLabelStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xff212121),

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        )),
      ),
      drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xff212121), surfaceTintColor: Colors.white),
      dialogTheme: const DialogTheme(
          backgroundColor: Color(0xff212121),
          iconColor: Colors.white,
          contentTextStyle: TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)))));
}
