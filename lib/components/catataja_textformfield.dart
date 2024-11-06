import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CatatAjaTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;
  final Icon prefixIcon;
  final Widget? suffixIcon;
  final bool? obsecureText;
  final bool? readOnly;
  final int maxLines;

  const CatatAjaTextFormField({
    super.key,
    required this.controller,
    this.inputFormatters,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obsecureText,
    this.readOnly,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      obscureText: obsecureText ?? false,
      readOnly: readOnly ?? false,
      maxLines: maxLines,
      minLines: 1,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: prefixIcon,
        prefixIconColor: Colors.white,
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey,
        ),
        suffixIcon: suffixIcon,
        suffixIconColor: Colors.white,
      ),
    );
  }
}
