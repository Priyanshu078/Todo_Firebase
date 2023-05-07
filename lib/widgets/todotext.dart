import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoText extends StatelessWidget {
  const TodoText({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(color: color),
    );
  }
}
