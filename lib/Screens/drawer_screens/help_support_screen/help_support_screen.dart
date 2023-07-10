import 'package:flutter/material.dart';
import 'package:kuchat/Screens/drawer_screens/help_support_screen/help_support_screen_logic.dart';
import 'package:kuchat/Widgets/appbar.dart';
import 'package:kuchat/Widgets/custom_elevated_button.dart';
import 'package:kuchat/Widgets/form_fields.dart';
import 'package:kuchat/Widgets/kudrawer.dart';
import 'package:kuchat/Widgets/subtitle_text.dart';

import '../../../Widgets/title_text.dart';

class HelpSupportScreen extends StatefulWidget with HelpSupportScreenLogic {
  HelpSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  Widget build(BuildContext context) {
    widget.context = context;
    widget.setCurrentState  = (){setState(() {});};
    return Scaffold(
      drawer: const KuDrawer(),
      body: CustomScrollView(
        slivers: [
          const KuAppBar(kuTitle: "Help & Support", kuPath: "flower.png",autoLead: false,),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TitleText(text: "How can we help you!?"),
                  const SizedBox(
                    height: 10,
                  ),
                  const SubTitleText(
                      text:
                          "It looks like you are experiencing problems with KuChat.\n"
                          "We are here to help please get in touch with us."),
                  const SizedBox(
                    height: 20,
                  ),
                  KuFormField(
                    formKey: widget.requestKey,
                    labelText: "Type here..",
                    maxLines: 3,
                    formValidator: widget.requestValidator,
                    textFormController: widget.requestController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  KuButton(onPressed: widget.onContinue, buttonText: "Continue",isLoading: widget.isLoading,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
