import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuchat/Widgets/form_fields.dart';
import 'package:kuchat/Widgets/custom_elevated_button.dart';

import '../../../../Utils/theme_color/app_colors.dart';
import '../../../../Widgets/appbar.dart';
import '../../../../Widgets/step_indicator.dart';
import '../../../../Widgets/subtitle_text.dart';
import '../../../../Widgets/title_text.dart';
import 'bio_screen_logic.dart';
class SignUpBioScreen extends StatefulWidget {
  const SignUpBioScreen({Key? key}) : super(key: key);

  @override
  State<SignUpBioScreen> createState() => _SignUpBioScreenState();
}

class _SignUpBioScreenState extends State<SignUpBioScreen> with SignUpBioScreenLogic{



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // uid = _authService.getCurrentUserUID();
    // context.read<UserModel>().userId = uid;
    // log("UID RECEIVED SUCCESSFULLY : $uid");

  }
  FocusNode bioFocus=FocusNode();
  @override
  Widget build(BuildContext context) {
    screenState((){setState(() {
    });}, context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: CustomScrollView(

        slivers: [
          const KuAppBar(kuTitle: "Sign Up", kuPath: "search.png"),

          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20,width: size.width,child: const StepIndicator(currentStep: 4,)),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      TitleText(text: "Andddd we gooooo!"),
                      SubTitleText(text: "I wanna know abouttt youu! Please upload your picture and update bio."),
                    ],
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  Column(

                    children: [
                      GestureDetector(
                        onTap: (){
                          selectImageDialog(context);
                        },
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.transparent,
                          backgroundImage: imagePath == ""
                              ? Image.asset("assets/takepicture.png",fit: BoxFit.cover,).image
                              : Image.file(File(imagePath)).image,
                          child: const Align(alignment: Alignment.bottomRight,child: Icon(Icons.add_circle,color: Colors.white,),),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KuFormField(
                        labelText: "Write something about yourself!",
                        hintText: "Hello! I am a KuChatUser!",
                        textFormController:bioController,
                      ),


                      const SizedBox(
                        height: 20,
                      ),

                      KuButton(onPressed: (){onContinue(context);}
                          , buttonText:"Save",isLoading: processing,),
                    ],
                  ),




                ],
              ),
            ),
          )
        ],
      ),

    );
  }
  selectImageDialog(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               const TitleText(text: "Select Image",textColor: AppColor.kuWhite),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () async {
                            imagePath = await selectImageFromGallery();

                            if (imagePath.isNotEmpty) {
                              Navigator.of(context).pop();
                              log(imagePath);
                              setState(() {});
                            } else {
                              // todo snackbar
                            }
                          },
                          child: const CircleAvatar(
                            backgroundColor:AppColor.kuWhite,
                            backgroundImage:
                            AssetImage('assets/gallerypicture.png'),
                            maxRadius: 50,
                            minRadius: 40,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SubTitleText(text: "Gallery",textColor: AppColor.kuWhite,fontSize: 14,)
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children:[
                        InkWell(
                          /*borderRadius: BorderRadius.circular(40),
                      onTap: () async {
                        XFile imagepath = await selectImageFromCamera();
                        log("$imagepath");*/
                          borderRadius: BorderRadius.circular(40),
                          onTap: () async {
                            XFile imagepath = await selectImageFromCamera();
                            log("$imagepath");},
                          child: const CircleAvatar(
                            backgroundColor: AppColor.kuWhite,
                            backgroundImage:
                            AssetImage('assets/takepicture.png'),
                            maxRadius: 50,
                            minRadius: 40,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SubTitleText(text: "Camera",fontSize: 14,textColor: AppColor.kuWhite,)
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

}
