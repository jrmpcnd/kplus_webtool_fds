import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/stepper/stepper_circle.dart';

import '../../values/colors.dart';
import '../../values/styles.dart';

class AlertDialogWidget extends StatelessWidget {
  final String titleText;
  final String contentText;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final Function()? positiveOnPressed;
  final Function()? negativeOnPressed;
  // final Color? positiveColor;
  // final Color? negativeColor;
  final Color titleColor;
  final Color iconColor;
  final IconData? iconData;

  const AlertDialogWidget({
    Key? key,
    required this.titleText,
    required this.contentText,
    this.positiveButtonText,
    this.negativeButtonText,
    this.positiveOnPressed,
    this.negativeOnPressed,
    // this.positiveColor,
    // this.negativeColor,
    required this.titleColor,
    required this.iconColor,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: titleColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 25,
            ),
            const SizedBox(width: 5),
            Text(titleText, style: TextStyles.bold18White),
          ],
        ),
      ),
      titlePadding: const EdgeInsets.all(0),
      content: Text(contentText, style: TextStyles.normal14Black),
      actions: [
        Container(
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0), // Matches the container's borderRadius
                ),
              ),
              overlayColor: MaterialStateProperty.all<Color>(
                Colors.blueGrey.withOpacity(0.2), // Customize the splash color
              ),
            ),
            onPressed: negativeOnPressed,
            child: Text(
              negativeButtonText ?? '',
              style: TextStyles.normal14Black,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(color: titleColor, borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: TextButton(
            onPressed: positiveOnPressed,
            child: Text(
              positiveButtonText ?? '',
              style: TextStyles.normal14White,
            ),
          ),
        ),
        // TextButton(
        //   onPressed: negativeOnPressed,
        //   style: ButtonStyle(
        //     side: MaterialStateProperty.all(
        //       BorderSide(color: negativeColor ?? Colors.transparent, width: 1.0),
        //     ),
        //     shape: MaterialStateProperty.all(
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
        //     ),
        //   ),
        //   child: Text(
        //     negativeButtonText ?? '',
        //     style: TextStyles.normal14Green,
        //   ),
        // ),
        // TextButton(
        //   onPressed: positiveOnPressed,
        //   child: Card(
        //     color: positiveColor,
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
        //     child: Padding(
        //       padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        //       child: Text(
        //         positiveButtonText ?? '',
        //         style: TextStyles.bold14White,
        //         textAlign: TextAlign.center,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class MFIAlertDialogWidget extends StatelessWidget {
  final String titleText;
  final Color titleColor;
  final Color iconColor;
  final IconData? iconData;

  const MFIAlertDialogWidget({
    Key? key,
    required this.titleText,
    required this.titleColor,
    required this.iconColor,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: titleColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 25,
            ),
            const SizedBox(width: 5),
            Text(titleText, style: const TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
      titlePadding: const EdgeInsets.all(0),
    );
  }
}

showTopCenterDialog(BuildContext context, MFIAlertDialogWidget dialog, {required MFIAlertDialogWidget child}) async {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
      return SafeArea(
        child: Builder(
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: Colors.transparent,
                  child: dialog,
                ),
              ],
            );
          },
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

// class MFIAlertDialogWidget extends StatelessWidget {
//   final String titleText;
//   final Color titleColor;
//   final Color iconColor;
//   final IconData? iconData;
//
//   const MFIAlertDialogWidget({
//     Key? key,
//     required this.titleText,
//     required this.titleColor,
//     required this.iconColor,
//     this.iconData,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5),
//       ),
//       title: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: titleColor,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(5.0),
//             topRight: Radius.circular(5.0),
//           ),
//         ),
//         child: Row(
//           children: [
//             if (iconData != null)
//               Icon(
//                 iconData,
//                 color: iconColor,
//                 size: 25,
//               ),
//             const SizedBox(width: 5),
//             Expanded(
//               child: Text(
//                 titleText,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//       titlePadding: const EdgeInsets.all(0),
//       content: const SizedBox.shrink(),
//     );
//   }
// }
//
// showTopCenterDialog(BuildContext context, MFIAlertDialogWidget dialog) async {
//   return showGeneralDialog(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//     barrierColor: Colors.black54,
//     transitionDuration: const Duration(milliseconds: 200),
//     pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
//       return SafeArea(
//         child: Builder(
//           builder: (BuildContext context) {
//             return Align(
//               // alignment: Alignment.topCenter,
//               child: Container(
//                 // margin: const EdgeInsets.only(top: 50.0),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: dialog,
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     },
//     transitionBuilder: (context, animation, secondaryAnimation, child) {
//       return SlideTransition(
//         position: Tween<Offset>(
//           begin: const Offset(0, -1),
//           end: Offset.zero,
//         ).animate(animation),
//         child: child,
//       );
//     },
//   );
// }

class AlertDialogWidgetWithShadow extends StatelessWidget {
  final String titleText;
  final String contentText;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final Function()? positiveOnPressed;
  final Function()? negativeOnPressed;
  final Color mainColor;
  final Color circleOutsideColor;
  final Color circleMiddleColor;
  final Color circleInsideColor;
  final IconData? iconData;

  const AlertDialogWidgetWithShadow({
    Key? key,
    required this.titleText,
    required this.contentText,
    this.positiveButtonText,
    this.negativeButtonText,
    this.positiveOnPressed,
    this.negativeOnPressed,
    required this.mainColor,
    required this.circleOutsideColor,
    required this.circleMiddleColor,
    required this.circleInsideColor,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Get a dynamic width for the shadow container based on the dialog width
          double shadowContainerWidth = constraints.maxWidth * 0.6; // Adjust this ratio as needed

          // Ensure the shadow container doesn't exceed a certain maximum width
          if (shadowContainerWidth > 250) {
            shadowContainerWidth = 250; // Set a max width if needed
          }

          return Stack(
            clipBehavior: Clip.none, // This allows the icon to overflow the dialog
            alignment: Alignment.topCenter,
            children: <Widget>[
              Positioned(
                bottom: -10,
                child: Container(
                  width: shadowContainerWidth, // Adjust width to half of the dialog
                  height: 30,
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 60.0, // Space for the icon
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      titleText,
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w900,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      contentText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    SizedBox(
                      width: 300,
                      child: Center(
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 10,
                          children: [
                            if (negativeButtonText != null) // Only display negative button if provided
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                        color: mainColor,
                                        width: 1.5,
                                      )),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                  if (negativeOnPressed != null) negativeOnPressed!();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                                  child: Text(
                                    negativeButtonText ?? '',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor, // Button background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                if (positiveOnPressed != null) positiveOnPressed!();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                                child: Text(
                                  positiveButtonText ?? '',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -30, // Adjust the position to have half of it outside
                child: CircleStepper(
                  borderColor: circleOutsideColor,
                  secondBorderColor: circleOutsideColor,
                  stepperColor: circleMiddleColor,
                  padding: 20,
                  shadowColor: circleInsideColor,
                  child: CircleAvatar(
                    backgroundColor: circleInsideColor, //first circle
                    radius: 30,
                    child: Icon(
                      iconData,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
