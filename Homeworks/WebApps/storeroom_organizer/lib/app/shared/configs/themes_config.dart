import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors_config.dart';

final ThemeData themeData = ThemeData(
  primaryColor: ColorsConfig.purpleDark,
  textTheme: TextTheme(
    headline1: GoogleFonts.reemKufi(fontWeight: FontWeight.w300, fontSize: 96, letterSpacing: -1.5, color: ColorsConfig.textColor),
    headline2: GoogleFonts.reemKufi(fontWeight: FontWeight.w300, fontSize: 60, letterSpacing: -0.5, color: ColorsConfig.textColor),
    headline3: GoogleFonts.reemKufi(fontWeight: FontWeight.normal, fontSize: 48, color: ColorsConfig.textColor),
    headline4: GoogleFonts.reemKufi(fontWeight: FontWeight.normal, fontSize: 34, color: ColorsConfig.textColor),
    headline5: GoogleFonts.reemKufi(fontWeight: FontWeight.w600, fontSize: 24, color: ColorsConfig.textColor),
    headline6: GoogleFonts.reemKufi(fontWeight: FontWeight.w500, fontSize: 20, letterSpacing: 0.15, color: ColorsConfig.textColor),
    subtitle1: GoogleFonts.reemKufi(fontWeight: FontWeight.normal, fontSize: 16, letterSpacing: 0.15, color: ColorsConfig.textColor),
    subtitle2: GoogleFonts.reemKufi(fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: 0.1, color: ColorsConfig.textColor),
    bodyText1: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 16, letterSpacing: 0.5, color: ColorsConfig.textColor),
    bodyText2: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 14, letterSpacing: 0.25, color: ColorsConfig.textColor),
    button: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: 1.25, color: ColorsConfig.textColor),
    caption: GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 12, letterSpacing: 0.4, color: ColorsConfig.textColor),
    overline: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 10, letterSpacing: 1.5, color: ColorsConfig.textColor),
  ),
);
