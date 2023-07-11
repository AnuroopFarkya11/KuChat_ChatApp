import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kuchat/Widgets/appbar.dart';
import 'package:kuchat/Widgets/kudrawer.dart';
import 'package:kuchat/Widgets/snack_bar.dart';
import 'package:kuchat/Widgets/subtitle_text.dart';
import 'package:kuchat/Widgets/title_text.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDeveloperScreen extends StatefulWidget {
  const AboutDeveloperScreen({Key? key}) : super(key: key);

  @override
  State<AboutDeveloperScreen> createState() => _AboutDeveloperScreenState();
}

class _AboutDeveloperScreenState extends State<AboutDeveloperScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      drawer: const KuDrawer(),
      body: CustomScrollView(
        slivers: [

          const KuAppBar(kuTitle: "About", kuPath: "dev.PNG",autoLead: false,),


          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  const TitleText(text: "Hello!"),
                  const SubTitleText(text: "This is Anuroop Farkya"),
                  const SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      GestureDetector(onTap: ()async{
                        var url = Uri.parse("https://instagram.com/anuroop_farkya?igshid=MTIzZWMxMTBkOA==");
                        showSnackBar(context, "Opening Instagram");
                        try {
                          await launchUrl(url);

                        } on Exception catch (e) {
                          showSnackBar(context, e.toString());
                        }
                      },
                        child: Container(
                          height: size.height*0.18,
                          width: size.width*0.4,
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.all(Radius.circular(15))

                          ),
                          child: Center(child: Image.asset("assets/instagram.png",height: size.height*0.07,),),
                        ),
                      ),
                      GestureDetector(onTap: ()async{
                        var url = Uri.parse("https://www.linkedin.com/in/anuroopfarkya");
                        showSnackBar(context, "Opening LinkedIn");

                        try {
                          await launchUrl(url);
                        } on Exception catch (e) {
                          // TODO
                        }
                      },
                        child: Container(
                          height: size.height*0.18,
                          width: size.width*0.4,
                          decoration: const BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.all(Radius.circular(15))

                          ),
                          child: Center(child: Image.asset("assets/linkedin.png",height: size.height*0.07,),),
                        ),
                      ),

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
}
