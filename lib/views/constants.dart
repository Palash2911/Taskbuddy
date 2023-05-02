import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color kprimaryColor = Colors.blue;
Color ksecondaryColor = Colors.white;
Color? kHighColor = Colors.red[200];
Color? kLowColor = Colors.blue[200];
Color? kMidColor = Colors.yellow[200];

TextStyle kTextPopB24 =
    GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.bold);
TextStyle kTextPopM16 =
    GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w600);
TextStyle kTextPopB16 =
    GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.bold);
TextStyle kTextPopR16 =
    GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w400);
TextStyle kTextPopR14 =
    GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w400);
TextStyle kTextPopB14 =
    GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.bold);
TextStyle kTextPopR12 =
    GoogleFonts.poppins(fontSize: 12.0, fontWeight: FontWeight.w400);

Decoration kInputBox = BoxDecoration(
  color: Colors.white,
  border: Border.all(
    color: Colors.blue.withOpacity(0.5),
    width: 1.0,
  ),
  borderRadius: BorderRadius.circular(8.0),
);
