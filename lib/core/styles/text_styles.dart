import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

const TextStyle regularTextStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontFamily: "PoppinsRegular",
  fontSize: 14,
  color: darkColor,
);
const TextStyle boldTextStyle = TextStyle(
  fontWeight: FontWeight.w700,
  fontFamily: "PoppinsBold",
  fontSize: 15,
  color: darkColor,
);
const TextStyle semiBoldTextStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontFamily: "PoppinsSemiBold",
  fontSize: 14,
  color: darkColor,
);
const TextStyle mediumTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontFamily: "PoppinsMedium",
  fontSize: 14,
  color: darkColor,
);

TextStyle biggestTextStyle = const TextStyle(
        fontFamily: 'Brand Bold',
        fontSize: 24,
        letterSpacing: 1,
        color: primaryColor,
      );

TextStyle dangerTextStyle = const TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.red,
);

TextStyle biggerTextStyle = const TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,
  color: primaryColor,
);
TextStyle bigTextStyle = const TextStyle(
  fontSize: 17,
  color: primaryColor,
);
TextStyle normalTextStyle = const TextStyle(
  fontSize: 15,
);

TextStyle buttonTextStyle =
    const TextStyle(color: primaryColor, fontWeight: FontWeight.w700);

TextStyle buttonTextStyleWithColor(Color? color) {
  return TextStyle(color: color ?? primaryColor, fontWeight: FontWeight.w700);
}

TextStyle smallTextStyle = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w300,
);
