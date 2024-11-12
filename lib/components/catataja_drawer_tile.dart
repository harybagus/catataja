import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CatatAjaDrawerTile extends StatelessWidget {
  final void Function() onTap;
  final IconData icon;
  final String text;

  const CatatAjaDrawerTile({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 25),
      title: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}
