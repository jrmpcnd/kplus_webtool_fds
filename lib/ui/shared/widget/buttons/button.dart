import 'package:flutter/material.dart';

import '../../values/colors.dart';

class CustomIconButton {
  static iconButtonOnly(BuildContext context, IconData iconData, Function() onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.blue.shade900.withOpacity(0.5)),
        child: Icon(
          iconData,
          color: Colors.blue.shade200,
        ),
      ),
    );
  }
}

class CustomColoredButton {
  static primaryButton(BuildContext context, double borderRadius, Function() onPressed, Color backgroundColor, String buttonText, TextStyle style, double height, double width) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        // elevation: 5,
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
            child: Text(
              buttonText.toUpperCase(),
              style: style,
            ),
          ),
        ),
      ),
    );
  }

  static primaryButtonWithText(BuildContext context, double borderRadius, Function() onPressed, Color backgroundColor, String buttonText) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: backgroundColor,
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Text(
              buttonText.toUpperCase(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.whiteColor),
            ),
          ),
        ),
      ),
    );
  }

  static secondaryButtonWithText(BuildContext context, double borderRadius, Function() onPressed, Color backgroundColor, String buttonText) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.maroon2), // Border color
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: backgroundColor,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Text(
            buttonText.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.maroon2, // Text color
            ),
          ),
        ),
      ),
    );
  }
}

class MyButton {
  static buttonWithLabel(BuildContext context, Function() onPressed, String? label, IconData? icon, Color color) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 3,
      onPressed: onPressed,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.whiteColor,
              size: 18,
            ),
            const SizedBox(width: 5),
            Text(
              label ?? '',
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static previousButtonWithLabel(BuildContext context, Function() onPressed, String? label, IconData? icon, Color color) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 3,
      onPressed: onPressed,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.whiteColor,
              size: 18,
            ),
            const SizedBox(width: 5),
            Text(
              label ?? '',
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static nextButtonWithLabel(BuildContext context, Function() onPressed, String? label, IconData? icon, Color color) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 3,
      onPressed: onPressed,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Text(
              label ?? '',
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              icon,
              color: AppColors.whiteColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class MLNIButtons {
  static Widget circleButtonWithIcon(
    BuildContext context,
    IconData icon,
    double iconSize,
    Color iconColor,
    Color splashColor,
    Color containerColor,
    double containerSize,
    Function()? onPressed,
  ) {
    return Material(
      color: Colors.transparent,
      shape: CircleBorder(),
      child: Ink(
        decoration: BoxDecoration(
          color: containerColor,
          shape: BoxShape.circle,
        ),
        child: InkWell(
          onTap: onPressed,
          customBorder: CircleBorder(),
          highlightColor: Colors.grey.shade400,
          splashColor: splashColor,
          child: SizedBox(
            width: containerSize,
            height: containerSize,
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
