import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KuFormField extends StatefulWidget {
  final String? labelText;
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
    return Form(
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
            suffixIcon: widget.suffixIcon
          ),
          onTap: widget.formOnTap,
          onChanged: widget.formOnChanged,
          validator: widget.formValidator,

        ));
  }
}
