import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/service/url_getter_setter.dart';
import '../../../../../core/service/user_api.dart';
import '../../../../../main.dart';
import '../../../../shared/navigations/navigation.dart';
import '../../../../shared/utils/utils_responsive.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/values/styles.dart';
import '../../../../shared/widget/alert_dialog/alert_dialogs.dart';
import '../../../../shared/widget/containers/dialog.dart';
import '../../../../shared/widget/fields/textformfield.dart';

class MFIChangePassforEmail extends StatefulWidget {
  const MFIChangePassforEmail({Key? key}) : super(key: key);

  @override
  State<MFIChangePassforEmail> createState() => _MFIChangePassforEmailState();
}

class _MFIChangePassforEmailState extends State<MFIChangePassforEmail> {
  final formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _hasPasswordNumber = false;
  bool _hasPasswordCapital = false;
  bool _hasPasswordLowerCase = false;
  bool _hasPasswordSpecialChar = false;
  bool _hasPasswordMinLength = false;
  String token = '';

  bool isLoading = false;
  // regular expression to check if string
  RegExp passValid = RegExp(r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[_!@#$%^&*(),.?":{}|<>/+=~`;-])');
  double passwordStrength = 0;
  //A function that validate user entered password
  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (_password.isEmpty || _password == null) {
      setState(() {
        passwordStrength = 0;
      });
    } else if (_password.length < 6) {
      setState(() {
        passwordStrength = 1 / 4;
      });
    } else if (_password.length < 8) {
      setState(() {
        passwordStrength = 2 / 4;
      });
    } else {
      if (passValid.hasMatch(_password)) {
        setState(() {
          passwordStrength = 4 / 4;
        });
        return true;
      } else {
        setState(() {
          passwordStrength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final capitalLetterRegex = RegExp(r'[A-Z]');
    final lowerLetterRegex = RegExp(r'[a-z]');
    final symbols = RegExp(r'[`~:|!@#$%^&*()_=+<>,./?{}-]');

    setState(() {
      _hasPasswordNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordNumber = true;

      _hasPasswordCapital = false;
      if (capitalLetterRegex.hasMatch(password)) _hasPasswordCapital = true;

      _hasPasswordLowerCase = false;
      if (lowerLetterRegex.hasMatch(password)) _hasPasswordLowerCase = true;

      _hasPasswordSpecialChar = false;
      if (symbols.hasMatch(password)) _hasPasswordSpecialChar = true;

      _hasPasswordMinLength = false;
      if (password.length >= 8) _hasPasswordMinLength = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchToken();
    print("============$fetchToken()");
  }

  Future<void> fetchToken() async {
    String baseURL = UrlGetter.getURL();
    try {
      final Uri url = Uri.parse('$baseURL/credentials/test/reset/page/token');
      final response = await http.get(
        url,
        headers: {"content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final newToken = responseData['data'];
        if (newToken != null) {
          setState(() {
            token = newToken;
            print('==============$token');
          });
          html.window.localStorage['token'] = token;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token is required'),
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }
      } else {
        throw Exception('Failed to load token: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
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
                    changePasswordImage(500),
                    const SizedBox(width: 50),
                    buildResetPasswordForm(),
                  ],
                ),
                tablet: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    changePasswordImage(500),
                    const SizedBox(width: 50),
                    buildResetPasswordForm(),
                  ],
                ),
                mobile: Center(child: buildResetPasswordForm()),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/Login');
                },
                child: const Align(
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
      ),
    );
  }

  Widget changePasswordImage(double width) {
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

  Widget buildResetPasswordForm() {
    return Container(
      height: 700,
      width: 400,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [BoxShadow(color: AppColors.maroon2.withOpacity(0.15), spreadRadius: 0, blurRadius: 40, offset: const Offset(0, 9))]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Change',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Password',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(height: 20),
              TextFormFieldWidget(
                title: 'Current Password',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: oldPasswordController,
                enabled: true,
              ),
              const SizedBox(height: 20),
              TextFormFieldWidget(
                title: 'New Password',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: newPasswordController,
                obscureText: true,
                onChanged: (password) {
                  if (password == null || password.isEmpty) {
                    setState(() {
                      passwordStrength = 0;
                    });
                  } else {
                    formKey.currentState!.validate();
                  }
                  onPasswordChanged(password);
                },
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return "Password must be set.";
                  } else {
                    //call function to check password
                    bool result = validatePassword(password);
                    if (result) {
                      // create account event
                      return null;
                    }
                    onPasswordChanged(password);
                  }
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.deny(RegExp(r"[ ]")),
                ],
              ),
              const SizedBox(height: 5),
              //DESIGN FOR LINEAR INDICATOR
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: LinearProgressIndicator(
                    value: passwordStrength,
                    backgroundColor: Colors.grey[300],
                    minHeight: 5,
                    color: passwordStrength == 0
                        ? Colors.red
                        : passwordStrength <= 1 / 4
                            ? Colors.red
                            : passwordStrength == 2 / 4
                                ? Colors.yellow
                                : passwordStrength == 3 / 4
                                    ? Colors.blue
                                    : Colors.green),
              ),

              //================Date Added : 6-17 ; Lea===================//
              PasswordCriteriaItem(
                isMet: _hasPasswordCapital,
                text: 'Contains an uppercase',
              ),
              const SizedBox(height: 10),
              PasswordCriteriaItem(
                isMet: _hasPasswordLowerCase,
                text: 'Contains a lowercase',
              ),
              const SizedBox(height: 10),
              PasswordCriteriaItem(
                isMet: _hasPasswordNumber,
                text: 'Contains a number',
              ),
              const SizedBox(height: 10),
              PasswordCriteriaItem(
                isMet: _hasPasswordSpecialChar,
                text: 'Contains a special character',
              ),
              const SizedBox(height: 10),
              PasswordCriteriaItem(
                isMet: _hasPasswordMinLength,
                text: 'Contains at least 8 characters',
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: passwordStrength == 1,
                child: TextFormFieldWidget(
                  title: 'Confirm Password',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: confirmPasswordController,
                  obscureText: true,
                  onChanged: (value) {
                    formKey.currentState!.validate();
                  },
                  validator: (value) {
                    // Check if the confirm password matches the new password
                    if (confirmPasswordController.text.isNotEmpty && value != newPasswordController.text) {
                      return 'Passwords do not match';
                    } else {
                      return null;
                    }
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(RegExp(r"\s")),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.maroon2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    // elevation: 5,
                  ),
                  onPressed: passwordStrength == 1 && newPasswordController.text == confirmPasswordController.text
                      ? () {
                          resetOnPressed();
                        }
                      : null,
                  child: const SizedBox(
                      height: 40,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                          child: Text(
                            "RESET PASSWORD",
                            style: TextStyles.bold14White,
                          ),
                        ),
                      ))),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void resetOnPressed() {
    // Check if the new password matches the confirmed password
    if (newPasswordController.text != confirmPasswordController.text) {
      // If passwords don't match, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // showAddUserAlertDialog(context);//deleted the confirm dialog
      submitForm();
    }
  }

  Future<void> submitForm() async {
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitFadingCircle(color: AppColors.dialogColor),
      ),
    );

    //================Date Added : 6-17 ; Lea===================//
    //change position: from oldPassword, newPassword => newPassword, oldPassword
    // Call the API function with the retrieved data
    final response = await UpdatePasswordAPI.changePasswordViaEmailLink(newPassword, oldPassword);

    Navigator.pop(context);

    // Perform any necessary operations after the API call
    if (response.statusCode == 200) {
      // Show success dialog
      showSubmissionDialog(isSuccess: true);
    } else {
      // Show failure dialog
      // showSubmissionDialogFalse();
      String errorMessage = jsonDecode(response.body)['message'];
      showGeneralErrorAlertDialog(navigatorKey.currentContext!, errorMessage);
    }
  }

  void showSubmissionDialog({required bool isSuccess}) {
    if (isSuccess = true) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
          titleText: isSuccess ? 'Successfully Reset' : 'Failed to Reset',
          contentText: isSuccess ? 'Password changed successfully.' : 'Sorry, we are unable to process your request.',
          positiveButtonText: isSuccess ? "Done" : "Retry",
          positiveOnPressed: () {
            if (isSuccess == true) {
              Navigator.pop(context);
              navigateToLoginPage();
            }
            Navigator.pop(context);
          },
          iconData: isSuccess ? Icons.check_circle_outline : Icons.error_outline,
          titleColor: isSuccess ? AppColors.ngoColor : AppColors.maroon2,
          iconColor: Colors.white,
        ),
      );
    }
  }
}

//================Date Added : 6-17 ; Lea===================//
class PasswordCriteriaItem extends StatelessWidget {
  final bool isMet;
  final String text;

  PasswordCriteriaItem({
    required this.isMet,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: isMet ? Colors.green : Colors.transparent,
            border: isMet ? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: Icon(Icons.check, color: Colors.white, size: 10),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyles.dataTextStyle, // Replace with TextStyles.dataTextStyle if defined
        ),
      ],
    );
  }
}

//Remove the other version
