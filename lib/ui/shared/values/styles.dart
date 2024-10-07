import 'package:flutter/material.dart';

import 'colors.dart';

class TextStyles {
  //HINT
  static const TextStyle hintText = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 11.0,
    color: Colors.black45,
  );

  static const TextStyle heavyBold20Black = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 20.0,
    color: Colors.black45,
  );

  static const TextStyle heavyBold16Black = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 16.0,
    color: Colors.black87,
  );

  static const TextStyle headingTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14.0,
    color: Colors.black87,
  );

  static const TextStyle dataTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
    color: Colors.black87,
  );

  static const TextStyle bold14Black = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14.0,
    color: Colors.black87,
  );

  static const TextStyle bold12Black = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12.0,
    color: Colors.black87,
  );

  //WHITE TEXTS
  static const TextStyle bold18White = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
    color: AppColors.whiteColor,
  );

  static const TextStyle bold14White = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14.0,
    color: AppColors.whiteColor,
  );

  static const TextStyle normal12White = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
    color: AppColors.whiteColor,
  );

  static const TextStyle normal14White = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
    color: AppColors.whiteColor,
  );

  //BLACK TEXTS

  static const TextStyle normal14Black = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
    color: Colors.black87,
  );

  static const TextStyle normal12Black = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
    color: Colors.black87,
  );

  //GREEN TEXTS=
  static const TextStyle normal12Green = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
    color: AppColors.ngoColor,
  );

  static const TextStyle normal14Green = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
    color: AppColors.ngoColor,
  );

  static const TextStyle normal16Green = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
    color: AppColors.ngoColor,
  );

  static const TextStyle normal12Maroon = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
    color: AppColors.maroon2,
  );
}

Widget mainTitleTextWhite(String text) {
  return Align(alignment: Alignment.centerLeft, child: Text(text, style: TextStyles.bold14White));
}

Widget mainTitleTextBlack(String text) {
  return Align(alignment: Alignment.centerLeft, child: Text(text, style: TextStyles.heavyBold16Black));
}

Widget mainTitleTextBlack16(String text) {
  return Align(alignment: Alignment.centerLeft, child: Text(text, style: TextStyles.heavyBold16Black));
}

Widget titleText(String text) {
  return Align(alignment: Alignment.centerLeft, child: Text(text, style: TextStyles.heavyBold16Black));
}

Widget subtitleText(String text) {
  return Align(alignment: Alignment.centerLeft, child: Text(text, style: TextStyles.normal14Black));
}

Widget bodyText(String text) {
  return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyles.normal14Black,
        textAlign: TextAlign.justify,
      ));
}

Widget bodyText12(String text) {
  return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyles.normal12Black,
        textAlign: TextAlign.justify,
      ));
}
