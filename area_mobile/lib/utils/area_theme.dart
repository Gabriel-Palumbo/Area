import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AreaTheme {
  Color backgroundPage = const Color(0xff0D0D0D);
  Color backgroundContainer = const Color(0xff191919);

  Color green = const Color(0xff1BB766);

  Color navBar = Colors.black.withOpacity(0.3);
  Color appBar = Colors.black.withOpacity(0.3);

  Color white = const Color(0xffFFFFFF);
  Color subGrey = const Color(0xff414141);
  Color subSubGrey = const Color(0xff1D1D1D);
  Color gr = const Color(0xff161616);

  Color blackGrey = const Color(0xff151515);

  Color bleu = const Color(0xff274FF5);

  Color red = const Color(0xffCF272D);

  /// Font
  TextStyle? textWhite_14;
  TextStyle? textBoldGrey_14;

  TextStyle? textGrey_16;
  TextStyle? textWhite_16;
  TextStyle? textWhiteBold_16;
  TextStyle? textGreen_16;

  TextStyle? textWhite_18;
  TextStyle? textBoldWhite_18;

  TextStyle? textGrey_20;
  TextStyle? textSubGrey_20;
  TextStyle? textWhite_20;

  TextStyle? textWhite_26;

  TextStyle? textTitleWhiteBold;
  TextStyle? textTitleGrey;

  TextStyle? textAppBarAreaLogo;

  AreaTheme() {
    textWhite_14 = GoogleFonts.inter(
      fontSize: 14,
      letterSpacing: -1,
      color: white,
    );
    textBoldGrey_14 = GoogleFonts.inter(
        fontSize: 14,
        letterSpacing: -0.7,
        color: subGrey,
        height: 1,
        fontWeight: FontWeight.w500);
    textGreen_16 = GoogleFonts.inter(
      fontSize: 16,
      letterSpacing: -0.5,
      color: green,
    );
    textGrey_16 = GoogleFonts.inter(
      fontSize: 16,
      letterSpacing: -0.5,
      color: subGrey,
    );
    textWhite_16 = GoogleFonts.inter(
      fontSize: 16,
      height: 0,
      letterSpacing: -0.5,
      color: white,
    );
    textWhiteBold_16 = GoogleFonts.inter(
      fontSize: 16,
      letterSpacing: -0.5,
      height: 1,
      fontWeight: FontWeight.w500,
      color: white,
    );
    textWhite_18 = GoogleFonts.inter(
      fontSize: 18,
      height: 0,
      letterSpacing: -1,
      color: white,
    );
    textBoldWhite_18 = GoogleFonts.inter(
      fontSize: 18,
      letterSpacing: -1,
      fontWeight: FontWeight.w500,
      color: white,
    );
    textWhite_20 = GoogleFonts.inter(
      fontSize: 20,
      letterSpacing: -0.5,
      fontWeight: FontWeight.w500,
      color: white,
    );
    textWhite_26 = GoogleFonts.inter(
      fontSize: 26,
      letterSpacing: -1,
      fontWeight: FontWeight.w500,
      color: white,
    );
    textSubGrey_20 = GoogleFonts.inter(
      fontSize: 20,
      letterSpacing: -0.5,
      fontWeight: FontWeight.w500,
      color: subGrey,
    );

    textTitleWhiteBold = GoogleFonts.inter(
      fontSize: 26,
      letterSpacing: -1.5,
      fontWeight: FontWeight.w500,
      color: white,
    );
    textTitleGrey = GoogleFonts.inter(
      fontSize: 26,
      letterSpacing: -1.5,
      fontWeight: FontWeight.w500,
      color: subGrey,
    );

    textAppBarAreaLogo = GoogleFonts.inter(
        fontSize: 28,
        letterSpacing: -2,
        fontWeight: FontWeight.w600,
        color: white);
  }
}
