import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../core/service/user_api.dart';
import '../../../../../main.dart';
import '../../../../shared/navigations/navigation.dart';
import '../../../../shared/utils/utils_responsive.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/values/strings.dart';
import '../../../../shared/values/styles.dart';
import '../../../../shared/widget/alert_dialog/alert_dialogs.dart';
import '../../../../shared/widget/containers/dialog.dart';
import '../../../../shared/widget/fields/textformfield.dart';

class ResetPasswordPage extends StatefulWidget {
  static const String route = '/ResetPassword';
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailAddressController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          // Row(
          //   children: [
          //     const Spacer(),
          //     Stack(
          //       children: [
          //         SizedBox(
          //           width: MediaQuery.of(context).size.width * 0.2,
          //           height: MediaQuery.of(context).size.height,
          //           child: const Image(
          //             image: AssetImage('images/resetBorder.png'),
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //         Container(
          //           color: AppColors.ngoColor.withOpacity(0.7),
          //           width: MediaQuery.of(context).size.width * 0.2,
          //           height: MediaQuery.of(context).size.height,
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          Center(
            child: Responsive(
              desktop: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  resetImage(500),
                  const SizedBox(width: 50),
                  resetFormBody(),
                ],
              ),
              tablet: Wrap(
                spacing: 20,
                crossAxisAlignment: WrapCrossAlignment.center,
                // alignment: WrapAlignment.center,
                children: [
                  resetImage(400),
                  resetFormBody(),
                ],
              ),
              mobile: Center(child: resetFormBody()),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/Login');
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image(
                  image: AssetImage('images/kplus_webtool_logo.png'),
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget resetImage(double width) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: width,
        child: const Center(
          child: Image(
            image: AssetImage('images/mwap_batch_upload.png'),
            fit: BoxFit.contain,
          ),
        ));
  }

  Widget resetFormBody() {
    return Container(
      padding: const EdgeInsets.all(50),
      width: 350,
      height: 430,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.grey.shade50,
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, spreadRadius: 0.0, blurRadius: 3, offset: const Offset(3.0, 3.0)),
          BoxShadow(color: Colors.grey.shade300, spreadRadius: 0.0, blurRadius: 3 / 2.0, offset: const Offset(3.0, 3.0)),
          const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3, offset: Offset(-3.0, -3.0)),
          const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3 / 2, offset: Offset(-3.0, -3.0)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          const Text(
            'Change',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const Text(
            'Your Password?',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Text(
            StringTexts.resetPasswordPhrase,
            style: TextStyles.dataTextStyle,
          ),
          const SizedBox(height: 15),
          Form(
            key: formKey,
            child: TextFormFieldWidget(
              textInputAction: TextInputAction.next,
              controller: emailAddressController,
              borderRadius: 5,
              emailAddressField: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Requiring an email address';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  resetOnPressed();
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 3,
                shadowColor: AppColors.sidePanel1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: AppColors.maroon2,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Send Reset Instructions',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              child: const Text(
                'Back to Login',
                style: TextStyles.normal12Green,
              ),
              onPressed: () {
                navigateToLoginPage();
              },
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  void resetOnPressed() async {
    final email = emailAddressController.text;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitFadingCircle(color: AppColors.dialogColor),
      ),
    );

    // Perform the async operation
    final response = await ResetPassEmail().crossCheckEmailPasswordReset(email);

    // Close the loading dialog
    Navigator.pop(navigatorKey.currentContext!);

    // Handle the response
    if (response.statusCode == 200 && jsonDecode(response.body)['retCode'] == '200') {
      showSubmissionDialog(isSuccess: true);
    } else if (response.statusCode == 401) {
      String errorMessage = jsonDecode(response.body)['message'];
      showGeneralErrorLoginAlertDialog(context, errorMessage);
    } else {
      showSubmissionDialog(isSuccess: false);
    }
  }

  void showSubmissionDialog({required bool isSuccess}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        titleText: isSuccess ? 'Successfully Sent' : 'Failure to Send',
        contentText: isSuccess ? 'Password recovery sent to your email.' : 'Sorry, we are unable to process your request.\nPlease ensure to input a registered email address.',
        positiveButtonText: isSuccess ? "Done" : "Retry",
        positiveOnPressed: () {
          Navigator.pop(context); // Close the dialog first
          if (isSuccess) {
            print('login called');
            navigatorKey.currentState!.pushReplacementNamed('/Login');
          }
        },
        iconData: isSuccess ? Icons.check_circle_outline : Icons.error_outline,
        titleColor: isSuccess ? AppColors.ngoColor : AppColors.maroon2,
        iconColor: Colors.white,
      ),
    );
  }
}
