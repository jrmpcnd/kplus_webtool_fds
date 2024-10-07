import 'package:flutter/material.dart';

import '../../../../core/api/login_logout/login.dart';
import '../../../../main.dart';
import '../../navigations/navigation.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';
import '../../widget/buttons/button.dart';
import '../../widget/containers/dialog.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const AlertDialog(content: Row(children: [CircularProgressIndicator(), SizedBox(width: 10), Text('In Progress...')])),
  );
}

//LOGIN DIALOGS
void showGeneralErrorLoginAlertDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidget(
      titleText: "Failed to Login",
      contentText: errorMessage,
      positiveButtonText: "Retry",
      positiveOnPressed: () async {
        Navigator.of(context).pop();
      },
      // positiveColor: AppColors.infoColor,
      iconData: Icons.dangerous_outlined,
      titleColor: AppColors.maroon2,
      iconColor: Colors.white,
    ),
  );
}

void showServerDisconnectionAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidget(
      titleText: "Failed to Connect",
      contentText: "Sorry, we are unable to process your request due to connection error.",
      positiveButtonText: "Retry",
      positiveOnPressed: () async {
        Navigator.of(context).pop();
      },
      // positiveColor: AppColors.errorColor,
      iconData: Icons.dangerous_outlined,
      titleColor: AppColors.maroon2,
      iconColor: Colors.white,
    ),
  );
}

void showAlreadyLoginAlertDialog(BuildContext context, VoidCallback callForceLogin) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidget(
      titleText: "Failed to Login",
      contentText: "You are currently logged in on another device.",
      positiveButtonText: "Force Login",
      positiveOnPressed: () async {
        Navigator.of(context).pop();
        callForceLogin();
      },
      iconData: Icons.dangerous_outlined,
      titleColor: AppColors.maroon2,
      iconColor: Colors.white,
    ),
  );
}

void showPasswordExpiredAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: const SizedBox(
          width: 400,
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/resetPass_dialog.png'),
                width: 150,
              ),
              Text(
                "Password Expired.",
                style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Crimson Text', fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Your password has expired for security reasons. Please update your password to continue using the system.",
                style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Crimson Text'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: SizedBox(width: 180, height: 40, child: CustomColoredButton.primaryButtonWithText(context, 5, () => navigateToSendResetLinkPage(context), AppColors.maroon2, 'RESET PASSWORD')),
          ),
        ],
      ),
    ),
  );
}

void showUnauthorizedAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidget(
      titleText: "Unauthorized Login",
      contentText: message,
      positiveButtonText: "Retry",
      positiveOnPressed: () async {
        Navigator.of(context).pop();
      },
      // positiveColor: AppColors.infoColor,
      iconData: Icons.warning_amber,
      titleColor: AppColors.maroon2,
      iconColor: Colors.white,
    ),
  );
}

ConfigReg configReg = ConfigReg();
//date edited | aug 2, 2024
// showEmailVerificationCode(BuildContext context) async {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController codeController = TextEditingController();
//   Widget confirmButton = TextButton(
//     child: const Text(
//       "Confirm",
//       style: TextStyle(
//         color: Color(0xff5F8D4E),
//         fontWeight: FontWeight.bold,
//         fontSize: 14,
//         letterSpacing: 1,
//       ),
//     ),
//     onPressed: () async {
//       showResponse(context);
//     },
//   );
//
//   AlertDialog alert = AlertDialog(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(5),
//     ),
//     title: Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: AppColors.maroon2,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(5.0),
//           topRight: Radius.circular(5.0),
//         ),
//       ),
//       child: const Text("Verification Code", style: TextStyles.bold18White),
//     ),
//     titlePadding: const EdgeInsets.all(0),
//     content: const Text(
//       "Please check your email for the verification \ncode and enter it below.",
//       style: TextStyle(
//         fontSize: 16,
//         letterSpacing: 1.5,
//       ),
//     ),
//     actions: [
//       Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(1.0),
//           child: TextFormField(
//             controller: codeController,
//             //initialValue: UserReg.GetCode(),
//             onChanged: (code) {
//               AddnewUsers.setCode(code);
//             },
//             textInputAction: TextInputAction.next,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             style: Theme.of(context).textTheme.headline6,
//             keyboardType: TextInputType.number,
//             textAlign: TextAlign.center,
//             inputFormatters: [
//               LengthLimitingTextInputFormatter(6),
//               FilteringTextInputFormatter.digitsOnly,
//             ],
//           ),
//         ),
//       ),
//       const SizedBox(
//         height: 20,
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           confirmButton,
//         ],
//       ),
//     ],
//   );
//
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }

//date added | aug 2, 2024 || set for modification same day
// void showEmailVerificationCode(BuildContext context) async {
//   final _formKey = GlobalKey<FormState>();
//   final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
//   final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
//
//   void _submitOtp() {
//     String otp = _controllers.map((controller) => controller.text).join();
//     print("Entered OTP: $otp");
//     AddnewUsers.setCode(otp);
//     showResponse(context);
//   }
//
//   Widget _buildOtpTextField(int index) {
//     return Container(
//       width: 40,
//       margin: EdgeInsets.symmetric(horizontal: 5),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.blue, width: 2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: TextFormField(
//         controller: _controllers[index],
//         focusNode: _focusNodes[index],
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         maxLength: 1,
//         decoration: InputDecoration(
//           counterText: '', // hides the character counter
//           border: InputBorder.none, // removes the default underline
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5.0),
//             borderSide: BorderSide(color: AppColors.green3, width: 2),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5.0),
//             borderSide: const BorderSide(color: AppColors.ngoColor),
//           ),
//           disabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5.0),
//             borderSide: BorderSide(color: Colors.grey),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5.0),
//             borderSide: const BorderSide(color: AppColors.maroon4),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5.0),
//             borderSide: const BorderSide(color: AppColors.maroon4, width: 2),
//           ),
//         ),
//         style: Theme.of(context).textTheme.headline6,
//         inputFormatters: [
//           FilteringTextInputFormatter.digitsOnly,
//         ],
//         onChanged: (value) {
//           if (value.length == 1 && index < _focusNodes.length - 1) {
//             _focusNodes[index + 1].requestFocus();
//           } else if (value.isEmpty && index > 0) {
//             _focusNodes[index - 1].requestFocus();
//           } else if (value.length == 1 && index == _focusNodes.length - 1) {
//             _focusNodes[index].unfocus();
//             _submitOtp();
//           }
//         },
//       ),
//     );
//   }
//
//   // Widget confirmButton = TextButton(
//   //   child: const Text(
//   //     "",
//   //     style: TextStyle(
//   //       color: Color(0xff5F8D4E),
//   //       fontWeight: FontWeight.bold,
//   //       fontSize: 14,
//   //       letterSpacing: 1,
//   //     ),
//   //   ),
//   //   onPressed: () async {
//   //     _submitOtp();
//   //   },
//   // );
//
//   AlertDialog alert = AlertDialog(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(5),
//     ),
//     title: Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: AppColors.maroon2,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(5.0),
//           topRight: Radius.circular(5.0),
//         ),
//       ),
//       child: const Text("Verification Code", style: TextStyles.bold18White),
//     ),
//     titlePadding: const EdgeInsets.all(0),
//     content: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Text(
//           "Please check your email for the verification code and enter it below.",
//           style: TextStyle(
//             fontSize: 16,
//             letterSpacing: 1.5,
//           ),
//         ),
//         SizedBox(height: 20),
//         Form(
//           key: _formKey,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(6, (index) => _buildOtpTextField(index)),
//           ),
//         ),
//       ],
//     ),
//     // actions: [
//     //   Row(
//     //     mainAxisAlignment: MainAxisAlignment.center,
//     //     crossAxisAlignment: CrossAxisAlignment.center,
//     //     children: [
//     //       confirmButton,
//     //     ],
//     //   ),
//     // ],
//   );
//
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }

// void showEmailVerificationCode(BuildContext context) async {
//   final _formKey = GlobalKey<FormState>();
//   final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
//   final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
//   final ValueNotifier<bool> _isValidCode = ValueNotifier<bool>(true);
//
//   void _submitOtp() {
//     String otp = _controllers.map((controller) => controller.text).join();
//     print("Entered OTP: $otp");
//
//     // Mock validation: replace with actual validation logic
//     if (otp == "123456") { // Assuming 123456 is the valid OTP for demonstration
//       AddnewUsers.setCode(otp);
//       _isValidCode.value = true; // Set as valid since the OTP is correct
//       Navigator.of(context).pop(); // Close the dialog on success
//       showResponse(context);
//     } else {
//       _isValidCode.value = false; // Set error state if invalid
//     }
//   }
//
//   Widget _buildOtpTextField(int index) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: _isValidCode,
//       builder: (context, isValid, child) {
//         return Container(
//           width: 40,
//           margin: EdgeInsets.symmetric(horizontal: 5),
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: isValid ? Colors.blue : Colors.red, // Change border color based on validity
//               width: 2,
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: TextFormField(
//             controller: _controllers[index],
//             focusNode: _focusNodes[index],
//             keyboardType: TextInputType.number,
//             textAlign: TextAlign.center,
//             maxLength: 1,
//             decoration: InputDecoration(
//               counterText: '', // hides the character counter
//               border: InputBorder.none, // removes the default underline
//             ),
//             style: Theme.of(context).textTheme.headline6,
//             inputFormatters: [
//               FilteringTextInputFormatter.digitsOnly,
//             ],
//             onChanged: (value) {
//               if (value.length == 1 && index < _focusNodes.length - 1) {
//                 _focusNodes[index + 1].requestFocus();
//               } else if (value.isEmpty && index > 0) {
//                 _focusNodes[index - 1].requestFocus();
//               } else if (value.length == 1 && index == _focusNodes.length - 1) {
//                 _focusNodes[index].unfocus();
//                 _submitOtp();
//               }
//               _isValidCode.value = true; // Reset error state on input change
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   AlertDialog alert = AlertDialog(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(5),
//     ),
//     title: Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: AppColors.maroon2,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(5.0),
//           topRight: Radius.circular(5.0),
//         ),
//       ),
//       child: const Text("Verification Code", style: TextStyles.bold18White),
//     ),
//     titlePadding: const EdgeInsets.all(0),
//     content: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Text(
//           "Please check your email for the verification code and enter it below.",
//           style: TextStyle(
//             fontSize: 16,
//             letterSpacing: 1.5,
//           ),
//         ),
//         SizedBox(height: 20),
//         Form(
//           key: _formKey,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(6, (index) => _buildOtpTextField(index)),
//           ),
//         ),
//       ],
//     ),
//     actions: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           TextButton(
//             child: const Text(
//               "Confirm",
//               style: TextStyle(
//                 color: Color(0xff5F8D4E),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//                 letterSpacing: 1,
//               ),
//             ),
//             onPressed: _submitOtp,
//           ),
//         ],
//       ),
//     ],
//   );
//
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }

//MISSING FIELDS DIALOG
void showRequiredFieldAlertDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (context) => AlertDialogWidget(
      titleText: " Action Required",
      contentText: errorMessage,
      positiveButtonText: "Retry",
      positiveOnPressed: () {
        Navigator.pop(context);
      },
      // positiveColor: AppColors.infoColor,
      iconData: Icons.warning_amber,
      titleColor: AppColors.infoColor,
      iconColor: Colors.white,
    ),
  );
}

void showFillFieldAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidget(
      titleText: "Required Fields",
      contentText: "Please fill out the empty fields.",
      positiveButtonText: "Proceed",
      positiveOnPressed: () async {
        Navigator.of(context).pop();
      },
      // positiveColor: AppColors.infoColor,
      iconData: Icons.warning_amber,
      titleColor: AppColors.infoColor,
      iconColor: Colors.white,
    ),
  );
}

void showUserNotFoundAlertDialog() {
  showDialog(
    context: navigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidget(
      titleText: "User Not Found",
      contentText: "The user with the provided staff ID was not found.",
      positiveButtonText: "Retry",
      positiveOnPressed: () async {
        Navigator.of(context).pop();
      },
      // positiveColor: AppColors.infoColor,
      iconData: Icons.warning_amber,
      titleColor: AppColors.infoColor,
      iconColor: Colors.white,
    ),
  );
}

//DEACTIVATE ACCOUNT DIALOG
void handleUserDeactivationDialog() async {
  showDialog(
    barrierDismissible: false,
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: const SizedBox(
          width: 400,
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/warning.png'),
                width: 200,
              ),
              Text(
                "Your account has been deactivated.",
                style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Crimson Text', fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "You will be redirected to the login page. For your security, kindly contact your administrator.",
                style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Crimson Text'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}

//REFRESH PAGE UPON CHANGE IN ROLE
void handleChangeInRoleDialog() async {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: const SizedBox(
          width: 400,
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/refresh.png'),
                width: 200,
              ),
              Text(
                "Your role has been updated.",
                style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Crimson Text', fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "You may refresh the page if you wish to continue using your new role access.",
                style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Crimson Text'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Proceed',
              style: TextStyles.normal14Black,
            ),
          ),
        ],
      );
    },
  );
}

//REFRESH PAGE UPON CHANGE IN INSTI
void handleChangeInstitutionDialog() async {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: const SizedBox(
          width: 400,
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/refresh.png'),
                width: 200,
              ),
              Text(
                "Your institution has been updated.",
                style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Crimson Text', fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "You may refresh the page to display your new institution.",
                style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Crimson Text'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Proceed',
              style: TextStyles.normal14Black,
            ),
          ),
        ],
      );
    },
  );
}

//REFRESH PAGE UPON CHANGE IN USERNAME
void handleChangeUsernameDialog() async {
  showDialog(
    barrierDismissible: false,
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: const SizedBox(
          width: 400,
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/warning.png'),
                width: 200,
              ),
              Text(
                "Your username has been updated.",
                style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Crimson Text', fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "You will be redirected to the login page.",
                style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Crimson Text'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}

//DEACTIVATE ROLE DIALOG
void handleRoleDeactivationDialog() async {
  showDialog(
    barrierDismissible: false,
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: const SizedBox(
          width: 400,
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/warning.png'),
                width: 200,
              ),
              Text(
                "Your role has been deactivated.",
                style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Crimson Text', fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "You will be redirected to the login page. For your security, kindly contact your administrator.",
                style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Crimson Text'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showGeneralErrorAlertDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidget(
      titleText: "Unsuccessful Attempt",
      contentText: errorMessage,
      positiveButtonText: "Retry",
      positiveOnPressed: () async {
        Navigator.of(context).pop();
      },
      iconData: Icons.dangerous_outlined,
      titleColor: AppColors.maroon2,
      iconColor: Colors.white,
    ),
  );
}

//EXISTING DATA
void showExistingDataAlertDialog(BuildContext context, Map<dynamic, dynamic> errorMessage, String errorTitle) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.maroon2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.dangerous_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                  const SizedBox(width: 5),
                  Text(errorTitle, style: TextStyles.bold18White),
                ],
              ),
            ),
            titlePadding: const EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: ListBody(
                children: errorMessage.entries.map((entry) {
                  return Text('${entry.key}: ${entry.value}', style: TextStyles.normal14Black);
                }).toList(),
              ),
            ),
            actions: [
              Container(
                decoration: const BoxDecoration(color: AppColors.maroon2, borderRadius: BorderRadius.all(Radius.circular(5))),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Retry',
                    style: TextStyles.normal14White,
                  ),
                ),
              ),
            ],
          ));
}

//GET USER BY HCIS WITH BLANK VALUES
void showHCISWithBlankValuesAlertDialog() {
  showDialog(
    context: navigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidget(
      titleText: "Unsuccessful Attempt",
      contentText: "Unable to get user info due to server disconnection.",
      positiveButtonText: "Retry",
      positiveOnPressed: () async {
        Navigator.of(context).pop();
      },
      // positiveColor: AppColors.infoColor,
      iconData: Icons.error_outline,
      titleColor: AppColors.maroon2,
      iconColor: Colors.white,
    ),
  );
}

//BLANK MATRIX ROLE
void showBlankMatrixAlertDialog() {
  showDialog(
    context: navigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidget(
      titleText: "Required Fields",
      contentText: "Please select the matrix checkboxes.",
      positiveButtonText: "Proceed",
      positiveOnPressed: () async {
        Navigator.of(context).pop();
      },
      // positiveColor: AppColors.infoColor,
      iconData: Icons.warning_amber,
      titleColor: AppColors.infoColor,
      iconColor: Colors.white,
    ),
  );
}

void showBlankRoleNameAlertDialog() {
  showDialog(
    context: navigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidget(
      titleText: "Required Fields",
      contentText: "Please fill out the role name field.",
      positiveButtonText: "Proceed",
      positiveOnPressed: () async {
        Navigator.of(context).pop();
      },
      // positiveColor: AppColors.infoColor,
      iconData: Icons.warning_amber,
      titleColor: AppColors.infoColor,
      iconColor: Colors.white,
    ),
  );
}

void showCancelAlertDialog(BuildContext context, VoidCallback clearFields) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidget(
      titleText: "Confirmation",
      contentText: "This will discard all the changes made so far.",
      positiveButtonText: "Proceed",
      negativeButtonText: "Cancel",
      negativeOnPressed: () {
        // Navigator.of(context).pop();
      },
      positiveOnPressed: () async {
        clearFields();
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
      },
      iconData: Icons.info_outline,
      titleColor: AppColors.infoColor,
      iconColor: Colors.white,
    ),
  );
}

void showRequiredFieldsAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidget(
      titleText: "Missing Information",
      contentText: "Kindly complete filling out the required info.",
      positiveButtonText: "Proceed",
      positiveOnPressed: () {
        Navigator.of(context).pop();
      },
      iconData: Icons.info_outline,
      titleColor: AppColors.infoColor,
      iconColor: Colors.white,
    ),
  );
}

///NEWLY ADDED DIALOG - AUG 19 : LEA
void showSuccessAlertDialog(BuildContext context, String message, {VoidCallback? onPositiveButtonPressed}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialogWidget(
      titleText: "Success",
      contentText: message,
      positiveButtonText: "Done",
      positiveOnPressed: () async {
        Navigator.of(context).pop(); // Close dialog
        if (onPositiveButtonPressed != null) {
          onPositiveButtonPressed();
        }
      },
      iconData: Icons.check_circle_outline,
      titleColor: AppColors.ngoColor,
      iconColor: Colors.white,
    ),
  );
}

void showFailedDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidgetWithShadow(
      titleText: 'Failed!',
      contentText: message,
      mainColor: AppColors.maroon4,
      iconData: Icons.error_rounded,
      circleOutsideColor: AppColors.maroon5,
      circleMiddleColor: AppColors.maroon4,
      circleInsideColor: AppColors.maroon3,
      positiveButtonText: 'Retry',
    ),
  );
}

void showSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidgetWithShadow(
      titleText: 'Success!',
      contentText: message,
      mainColor: AppColors.sidePanel2,
      iconData: Icons.check_rounded,
      circleOutsideColor: AppColors.sidePanel3,
      circleMiddleColor: AppColors.sidePanel2,
      circleInsideColor: AppColors.ngoColor,
      positiveButtonText: 'Retry',
    ),
  );
}

void showInfoDialog(BuildContext context, String titleText, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialogWidgetWithShadow(
      titleText: titleText,
      contentText: message,
      mainColor: AppColors.infoColor,
      iconData: Icons.info,
      circleOutsideColor: AppColors.blue2,
      circleMiddleColor: AppColors.blue3,
      circleInsideColor: AppColors.infoColor,
      positiveButtonText: 'Retry',
    ),
  );
}
