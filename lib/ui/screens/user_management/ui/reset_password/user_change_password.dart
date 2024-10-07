import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/service/url_getter_setter.dart';
import '../../../../shared/navigations/navigation.dart';
import '../../../../shared/utils/utils_responsive.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/values/image_path.dart';
import '../../../../shared/values/styles.dart';
import '../../../../shared/widget/containers/dialog.dart';
import '../../../../shared/widget/fields/textformfield.dart';

class UserChangePassword extends StatefulWidget {
  const UserChangePassword({super.key});

  @override
  State<UserChangePassword> createState() => _UserChangePasswordState();
}

class _UserChangePasswordState extends State<UserChangePassword> {
  final formKey = GlobalKey<FormState>();
  // TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _hasPasswordNumber = false;
  bool _hasPasswordCapital = false;
  bool _hasPasswordLowerCase = false;
  bool _hasPasswordSpecialChar = false;
  String token = '';

  bool isLoading = false;
  // regular expression to check if string
  RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  double passwordStrength = 0;
  // 0: No password
  // 1/4: Weak
  // 2/4: Medium
  // 3/4: Strong
  //   1:   Great
  //A function that validate user entered password
  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (_password.isEmpty) {
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

    setState(() {
      _hasPasswordNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordNumber = true;

      _hasPasswordCapital = false;
      if (capitalLetterRegex.hasMatch(password)) _hasPasswordCapital = true;

      _hasPasswordLowerCase = false;
      if (lowerLetterRegex.hasMatch(password)) _hasPasswordLowerCase = true;

      _hasPasswordSpecialChar = containsSpecialCharacter(password);
    });
  }

  bool containsSpecialCharacter(String password) {
    // Define the list of special characters
    List<String> specialCharacters = ['!', '@', '#', '\$', '%', '^', '&', '*', '(', ')', '-', '_', '+', '=', '{', '}', '[', ']', '|', '\\', ':', ';', '"', '\'', '<', '>', ',', '.', '/', '?'];

    // Check if the password contains at least one special character
    for (int i = 0; i < password.length; i++) {
      if (specialCharacters.contains(password[i])) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    fetchToken();
  }

  Future<void> fetchToken() async {
    String baseURL = UrlGetter.getURL();
    try {
      final Uri url = Uri.parse('$baseURL/reset/page/token');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final newToken = responseData['data'];
        if (newToken != null) {
          setState(() {
            token = newToken;
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
            Row(
              children: [
                const Spacer(),
                Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height,
                      child: const Image(
                        image: AssetImage('images/resetBorder.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      color: AppColors.ngoColor.withOpacity(0.7),
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ],
                ),
              ],
            ),
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
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    ImagePath.cardIncLogo,
                    height: 50,
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
            image: AssetImage('images/ngobg.png'),
            fit: BoxFit.contain,
          ),
        ));
  }

  Widget buildResetPasswordForm() {
    return Container(
      height: 550,
      width: 400,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [BoxShadow(color: AppColors.ngoColor.withOpacity(0.15), spreadRadius: 0, blurRadius: 40, offset: const Offset(0, 9))]),
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
              // const Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     StringTexts.changePasswordTitle,
              //     style: TextStyles.heavyBold16Black,
              //   ),
              // ),
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
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(color: _hasPasswordCapital ? Colors.green : Colors.transparent, border: _hasPasswordCapital ? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(50)),
                    child: const Center(
                      child: Icon(Icons.check, color: Colors.white, size: 10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Contains an uppercase',
                    style: TextStyles.dataTextStyle,
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(color: _hasPasswordLowerCase ? Colors.green : Colors.transparent, border: _hasPasswordLowerCase ? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(50)),
                    child: const Center(
                      child: Icon(Icons.check, color: Colors.white, size: 10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Contains a lowercase',
                    style: TextStyles.dataTextStyle,
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(color: _hasPasswordNumber ? Colors.green : Colors.transparent, border: _hasPasswordNumber ? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(50)),
                    child: const Center(
                      child: Icon(Icons.check, color: Colors.white, size: 10),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Contains a number",
                    style: TextStyles.dataTextStyle,
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(color: _hasPasswordSpecialChar ? Colors.green : Colors.transparent, border: _hasPasswordSpecialChar ? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(50)),
                    child: const Center(
                      child: Icon(Icons.check, color: Colors.white, size: 10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Contains a special character',
                    style: TextStyles.dataTextStyle,
                  )
                ],
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
                    backgroundColor: AppColors.ngoColor,
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

  // void showAddUserAlertDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => AlertDialogWidget(
  //       titleText: "Change User Password",
  //       contentText: "The password will be changed. An email will be sent to the user.",
  //       positiveButtonText: "Proceed",
  //       negativeButtonText: "Cancel",
  //       negativeOnPressed: () {
  //         Navigator.of(context).pop();
  //       },
  //       positiveOnPressed: () async {
  //         setState(() {
  //           submitForm();
  //           Navigator.of(context).pop();
  //         });
  //       },
  //       iconData: Icons.info_outline,
  //       titleColor: AppColors.infoColor,
  //       iconColor: Colors.white,
  //     ),
  //   );
  // }

  Future<void> submitForm() async {
    // String newPassword = newPasswordController.text;
    //
    // showDialog(
    //   context: navigatorKey.currentContext!,
    //   barrierDismissible: false,
    //   builder: (context) => const Center(
    //     child: SpinKitFadingCircle(color: AppColors.dialogColor),
    //   ),
    // );
    //
    // // Call the API function with the retrieved data
    // final response = await UpdatePasswordAPI.changePasswordViaEmailLink(newPassword);
    // // Remove the loading dialog
    // Navigator.of(navigatorKey.currentContext!).pop();
    //
    // if (response.statusCode == 200 && jsonDecode(response.body)['retCode'] == '200') {
    //   showSubmissionDialog(isSuccess: true);
    // } else if (response.statusCode == 401) {
    //   String errorMessage = jsonDecode(response.body)['message'];
    //   showGeneralErrorAlertDialog(context, errorMessage);
    // } else if (response.statusCode == 400) {
    //   String errorMessage = jsonDecode(response.body)['message'];
    //   showGeneralErrorAlertDialog(context, errorMessage);
    // } else {
    //   showSubmissionDialog(isSuccess: false);
    // }
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
          titleColor: isSuccess ? AppColors.ngoColor : AppColors.warningColor,
          iconColor: isSuccess ? Colors.green : Colors.red,
        ),
      );
    }
  }
}
