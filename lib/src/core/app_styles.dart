import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hhu_helper/src/core/size_config.dart';

// COLORS
const kWhiteColor = Color(0xffffffff);
const kBlackColor = Color(0xff000000);
const kGrayColor = Color(0xffD4D4D4);
const kDarkGrayColor = Color(0xff464646);
const kLimeColor = Color(0xFF98D85C);
const kBlueColor = Color(0xFF24CFFA);
const kAmberColor = Color.fromARGB(255, 235, 204, 28);

// DIMENSIONS
final double kPaddingHorizontal = SizeConfig.blockSizeHorizontal! * 3;
const double kBorderRadius = 10.0;

//  FONTS
final kQuestrialBold = GoogleFonts.questrial(
  fontWeight: FontWeight.w700,
);

final kQuestrialSemibold = GoogleFonts.questrial(
  fontWeight: FontWeight.w600,
);

final kQuestrialMedium = GoogleFonts.questrial(
  fontWeight: FontWeight.w500,
);

final kQuestrialRegular = GoogleFonts.questrial(
  fontWeight: FontWeight.w400,
);
