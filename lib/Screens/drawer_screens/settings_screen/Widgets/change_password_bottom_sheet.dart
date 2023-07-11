import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kuchat/Services/auth/firebase_auth_services.dart';
import 'package:kuchat/Widgets/custom_elevated_button.dart';
import 'package:kuchat/Widgets/form_fields.dart';
import 'package:kuchat/Widgets/subtitle_text.dart';
import 'package:kuchat/Widgets/title_text.dart';

import '../../../../Modals/user_modal.dart';
import '../../../../Widgets/snack_bar.dart';

class ChangePasswordManager {
  final _passwordKey = GlobalKey<FormState>();

  final _existingPasswordKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController existingPasswordController =
      TextEditingController();

  bool _isExistingPassVisible = false;
  bool _isNewPassPassVisible = false;

  bool _isLoading = false;

  late final Size size;

  final FirebaseAuthService _authService = FirebaseAuthService();

  void changeUserPassword(context, userEmail) {
    size = MediaQuery
        .of(context)
        .size;
    // String userEmail = context.read<UserModel>().email;
    showModalBottomSheet(
      // backgroundColor: Colors.grey.shade900,
        useSafeArea: true,
        // enableDrag: true,
        useRootNavigator: true,
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: size.height * 0.9),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext bottomContext,
                void Function(void Function()) setState) {
              return Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Divider(
                      height: 30,
                      indent: size.width * 0.25,
                      endIndent: size.width * 0.25,
                      color: Colors.white,
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const TitleText(text: "Change Password"),
                    const SizedBox(
                      height: 10,
                    ),
                    const SubTitleText(
                        text: "Set new password for your account."),
                    /* const Text(
                      "Set new password for your account.",
                      style: TextStyle(color: Colors.white70),
                    ),*/
                    const SizedBox(
                      height: 30,
                    ),
                    KuFormField(
                      labelText: "Existing Password",
                      formKey: _existingPasswordKey,
                      textFormController: existingPasswordController,
                      obscureText: !_isExistingPassVisible,
                      suffixIcon: IconButton(
                        icon: _isExistingPassVisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () {
                          _isExistingPassVisible = !_isExistingPassVisible;
                          setState(() {});
                        },
                      ),
                      formOnTap: () {},
                      formValidator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your existing password";
                        }
                        return null;
                      },
                    ),
                    /*   Form(
                      key: _existingPasswordKey,
                      child: TextFormField(
                        controller: existingPasswordController,
                        obscureText: !_isVisible,
                        onTap: () {
                          // _emailKey.currentState!.validate();
                        },
                        validator: (value) {
                          //todo
                          if (value!.isEmpty) {
                            return "Please enter your existing password";
                          }
                          return null;
                        },
                        style: GoogleFonts.poppins(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          errorText: null,
                          filled: true,
                          fillColor: Colors.white70,
                          // prefixIcon: Icon(Icons.lock_outline),
                          //todo
                          labelText: "Existing Password",
                          labelStyle: TextStyle(color: Colors.white),

                          border: OutlineInputBorder(
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
                          errorStyle: GoogleFonts.poppins(),

                          suffixIcon: IconButton(
                            icon: _isVisible
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onPressed: () {
                              _isVisible = !_isVisible;
                              setState(() {});
                            },
                          ),
                          suffixIconColor: Colors.white,
                        ),
                      ),
                    ),*/
                    const SizedBox(
                      height: 20,
                    ),
                    KuFormField(
                        labelText: "Password",
                        formKey: _passwordKey,
                        textFormController: passwordController,
                        obscureText: !_isNewPassPassVisible,
                        formOnTap: () {
                          _existingPasswordKey.currentState!.validate();
                        },
                        formValidator: (value) {
                          //todo
                          if (value!.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: _isNewPassPassVisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                          onPressed: () {
                            _isNewPassPassVisible = !_isNewPassPassVisible;
                            setState(() {});
                          },
                        )),
                    /* Form(
                      key: _passwordKey,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: !_isVisible,
                        onTap: () {
                          _existingPasswordKey.currentState!.validate();
                        },
                        validator: (value) {
                          //todo
                          if (value!.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                        style: GoogleFonts.poppins(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          errorText: null,
                          filled: true,
                          fillColor: Colors.white70,
                          // prefixIcon: Icon(Icons.lock_outline),
                          //todo
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.white),

                          border: OutlineInputBorder(
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
                          errorStyle: GoogleFonts.poppins(),

                          suffixIcon: IconButton(
                            icon: _isVisible
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onPressed: () {
                              _isVisible = !_isVisible;
                              setState(() {});
                            },
                          ),
                          suffixIconColor: Colors.white,
                        ),
                      ),
                    ),*/
                    const SizedBox(
                      height: 20,
                    ),
                    KuButton(
                      onPressed: () async {
                        log("Before sending: ${passwordController
                            .text},${existingPasswordController.text}");

                        if (_existingPasswordKey.currentState!.validate() &&
                            _passwordKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          await _authService
                              .changePassword(
                              userEmail: userEmail,
                              existingPassword:
                              existingPasswordController.text,
                              newPassword: passwordController.text)
                              .then((value) {
                            setState(() {
                              _isLoading = false;
                            });

                            if (value) {
                              Navigator.pop(bottomContext);

                              showSnackBar(
                                  context, "Password Changed Successfully!");
                            } else {
                              Navigator.pop(bottomContext);
                              showSnackBar(context,
                                  "Sorry, Try again once after login!");
                            }
                            passwordController.clear();
                            existingPasswordController.clear();
                          });
                        }
                      },
                      buttonText: "Continue",
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              );
            },
          );
        });
  }}
