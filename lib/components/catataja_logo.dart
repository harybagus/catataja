import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CatatAjaLogo extends StatelessWidget {
  final double fontSize;

  const CatatAjaLogo({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Catat",
          style: GoogleFonts.dancingScript(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 15),
        Text(
          "Aja.",
          style: GoogleFonts.dancingScript(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
