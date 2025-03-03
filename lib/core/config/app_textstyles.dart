import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasknexus/core/config/app_colors.dart';

class AppTextstyles {
  static TextStyle textField = GoogleFonts.manrope(
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    fontSize: 16.5,
    color: AppColors.blackColor,
  );

  static TextStyle textFieldHint = GoogleFonts.manrope(
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    fontSize: 15,
    color: AppColors.lightGreyColor3,
  );

  static TextStyle authFieldHeadings = GoogleFonts.manrope(
    fontWeight: FontWeight.w800,
    letterSpacing: 0.2,
    fontSize: 16,
    color: AppColors.blackColor,
  );
  static TextStyle dontHaveAccountText = GoogleFonts.manrope(
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    wordSpacing: 2,
    fontSize: 14,
    color: AppColors.blackColor,
  );

  static TextStyle enterNameAndPasswordText = GoogleFonts.manrope(
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    wordSpacing: 2,
    fontSize: 12.5,
    color: AppColors.blackColor,
  );

  static TextStyle loginSuperHeading = GoogleFonts.playfairDisplay(
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
    fontSize: 50,
    color: AppColors.blackColor,
    height: 1.05,
  );

  static TextStyle loginMiniQuoteText = GoogleFonts.manrope(
    fontWeight: FontWeight.w500,
    letterSpacing: 2,
    fontSize: 10,
    color: AppColors.whiteColor,
  );

  static TextStyle loginQuoteText = GoogleFonts.manrope(
    height: 1.65,
    fontWeight: FontWeight.w100,
    letterSpacing: 1,
    fontSize: 14,
    color: AppColors.lightGreyColor,
  );

  static TextStyle apptitileText = GoogleFonts.manrope(
    fontWeight: FontWeight.w900,
    letterSpacing: 0.2,
    fontSize: 12,
    color: AppColors.blackColor,
  );
}
