import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';

class KuAppBar extends StatefulWidget {
  final String kuTitle;
  final String kuPath;
  final double? titleFontSize;
  final bool autoLead;

  const KuAppBar({Key? key, required this.kuTitle, required this.kuPath,this.titleFontSize=30,this.autoLead=true})
      : super(key: key);

  @override
  State<KuAppBar> createState() => _KuAppBarState();
}

class _KuAppBarState extends State<KuAppBar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SliverAppBar(
      pinned: true,
      floating: true,
      // snap: true,
      expandedHeight: size.height * 0.3,
      leadingWidth: 25,
      leading: widget.autoLead?IconButton(icon: const Icon(Icons.arrow_back_ios),onPressed: (){ Navigator.pop(context);},):null,

      title: Text(
        widget.kuTitle,
        style: GoogleFonts.poppins(fontSize: widget.titleFontSize , fontWeight: FontWeight.w500,color: Colors.white),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, BoxConstraints constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.kuBlue,
                  AppColor.kuWhite70,
                  AppColor.kuYellow,
                ],
                begin: Alignment.topLeft,
                end: Alignment.centerRight
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  bottom: -100,
                  right: 10,
                  child: Image.asset(
                    "assets/kuuuu/${widget.kuPath}",
                    height: size.height*0.3,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
