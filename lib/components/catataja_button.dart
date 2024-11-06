import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CatatAjaButton extends StatelessWidget {
  final Function()? onPressed;
  final Color color;
  final String text;

  const CatatAjaButton({
    super.key,
    required this.onPressed,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: color,
        foregroundColor: Colors.white,
        fixedSize: Size(MediaQuery.sizeOf(context).width, 65),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
