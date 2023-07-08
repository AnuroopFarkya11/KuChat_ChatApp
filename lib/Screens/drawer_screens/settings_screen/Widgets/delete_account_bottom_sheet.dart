import 'package:flutter/material.dart';
import 'package:kuchat/Widgets/custom_elevated_button.dart';

import '../../../../Widgets/form_fields.dart';
import '../../../../Widgets/subtitle_text.dart';
import '../../../../Widgets/title_text.dart';

class AccountDeleteManager {

  final _existingPasswordKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController existingPasswordController = TextEditingController();

  bool _isVisible = false;

  void deleteAccountSheet(context, userMail) {
    Size size = MediaQuery
        .of(context)
        .size;

    showModalBottomSheet(

        useSafeArea: true,
        isScrollControlled: true,
        useRootNavigator: true,
        constraints: BoxConstraints(maxHeight: size.height * 0.9,minHeight: size.height * 0.9),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext contextt,
                void Function(void Function()) setState) {
              return SingleChildScrollView(
                child: Container(
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
                      const TitleText(text: "Delete Account"),

                      const SizedBox(
                        height: 10,
                      ),
                      const SubTitleText(
                          text: "Are you sure you want to delete your account?"
                              " \nThis action is irreversible and will permanently delete all your data."),

                      const SizedBox(
                        height: 20,
                      ),
                      const SubTitleText(
                        text: "Before proceeding, we need to verify your identity. Please enter your account password below to continue.",

                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      KuFormField(
                          labelText: "Existing Password",
                          formKey: _existingPasswordKey,
                          obscureText: !_isVisible,
                          formOnTap: () {
                            // _emailKey.currentState!.validate();
                          },
                          formValidator: (value) {
                            //todo
                            if (value!.isEmpty) {
                              return "Please enter your existing password";
                            }
                            return null;
                          }


                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      KuButton(onPressed: (){_existingPasswordKey.currentState!.validate();}, buttonText: "Continue",isLoading: _isVisible,),

                      const SizedBox(
                        height: 30,
                      ),
                      const SubTitleText(text:"Before proceeding, we encourage you to download or save any important data or files associated with your account, as they will be permanently lost",
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        });
  }


}


