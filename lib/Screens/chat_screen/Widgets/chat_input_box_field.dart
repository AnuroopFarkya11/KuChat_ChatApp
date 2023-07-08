import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';
import 'package:kuchat/Widgets/title_text.dart';
import 'package:provider/provider.dart';

import '../../../Modals/user_modal.dart';
import '../../../Widgets/subtitle_text.dart';

class ChatInputBoxField extends StatefulWidget {
  final Function(BuildContext context, String message)? onSend;

  const ChatInputBoxField({Key? key, required this.onSend}) : super(key: key);

  @override
  State<ChatInputBoxField> createState() => _ChatInputBoxFieldState();
}

class _ChatInputBoxFieldState extends State<ChatInputBoxField> {
  TextEditingController controller = TextEditingController();

  // void onSendMessage(BuildContext context,String roomID,String currentUser) async {
  @override
  Widget build(BuildContext context) {
    String currentUserName = context.read<UserModel>().name;
    return Container(
      color: Colors.grey.shade900,
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 200,
                        // color: AppCo,
                        child: Center(
                          child: SubTitleText(
                              text: "KuChat team is working on this feature!!"),
                        ),
                      );
                    });
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              )),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 2,
              style: GoogleFonts.poppins(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "Type here...",
                  hintStyle: GoogleFonts.poppins(color: Colors.white)
                  // border: InputBorder.none
                  ),
            ),
          ),
          IconButton(
              onPressed: () {
                widget.onSend!(context, controller.text);
                controller.clear();
              },
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}
