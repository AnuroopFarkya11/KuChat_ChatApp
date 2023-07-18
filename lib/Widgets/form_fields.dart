import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';

class KuFormField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final GlobalKey<FormState>? formKey;
  final TextEditingController? textFormController;
  final Function()? formOnTap;
  final Function(String)? formOnChanged;
  final String? Function(String?)? formValidator;
  final bool obscureText;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final int maxLines;

  const KuFormField({
    Key? key,
    this.labelText = "",
    this.hintText = "",
    this.formKey,
    this.textFormController,
    this.formOnTap,
    this.formOnChanged,
    this.formValidator,
    this.suffixIcon,
    this.focusNode,
    this.obscureText = false,
    this.maxLines = 1

  }) : super(key: key);

  @override
  State<KuFormField> createState() => _KuFormFieldState();
}

class _KuFormFieldState extends State<KuFormField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height*0.1,
        minHeight: size.height*0.08

      ),
      // height: size.height*0.1,
      child: Form(
          // todo
          key: widget.formKey,
          child: TextFormField(

            controller: widget.textFormController,
            focusNode: widget.focusNode,
            cursorColor: Colors.white,
            keyboardType: TextInputType.text,
            maxLines: widget.maxLines,
            style: GoogleFonts.poppins(color: Colors.white),
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: 14,color: AppColor.kuWhite70),
              suffixIcon: widget.suffixIcon
            ),
            onTap: widget.formOnTap,
            onChanged: widget.formOnChanged,
            validator: widget.formValidator,

          )),
    );
  }
}
