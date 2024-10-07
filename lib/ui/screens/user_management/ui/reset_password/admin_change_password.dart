import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../../../core/provider/user_provider.dart';
import '../../../../../core/service/user_api.dart';
import '../../../../../main.dart';
import '../../../../shared/utils/utils_generate_random_password.dart';
import '../../../../shared/utils/utils_responsive.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/values/strings.dart';
import '../../../../shared/values/styles.dart';
import '../../../../shared/widget/alert_dialog/alert_dialogs.dart';
import '../../../../shared/widget/containers/dialog.dart';
import '../../../../shared/widget/fields/textformfield.dart';

class AdminChangePassword extends StatefulWidget {
  AdminChangePassword({super.key});

  @override
  State<AdminChangePassword> createState() => _AdminChangePasswordState();
}

class _AdminChangePasswordState extends State<AdminChangePassword> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _hasPasswordNumber = false;
  bool _hasPasswordCapital = false;
  bool _hasPasswordLowerCase = false;
  bool _hasPasswordSpecialChar = false;
  bool _hasPasswordMinLength = false;

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
    UserProvider editPasswordProvider = Provider.of<UserProvider>(context, listen: false);
    emailController.text = editPasswordProvider.mwapemail;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      surfaceTintColor: Colors.white,
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('/images/mwap_header.png'), fit: BoxFit.cover, opacity: 0.5),
          color: AppColors.maroon2,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
        ),
        child: Wrap(
          spacing: 10,
          children: [
            Responsive(
              desktop: lockIcon(),
              tablet: lockIcon(),
              mobile: Container(),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringTexts.changePasswordTitle,
                  style: TextStyles.bold18White,
                ),
                SizedBox(height: 5),
                Text(
                  StringTexts.changePasswordPhrase,
                  style: TextStyles.normal12White,
                ),
              ],
            ),
          ],
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500),
        child: SingleChildScrollView(
          child: Column(
            children: [
              changePasswordBody(),
              changePasswordButton(),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget lockIcon() {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1.0,
        ),
      ),
      child: const Icon(
        Icons.lock_reset_outlined,
        size: 35,
        color: Colors.white,
      ),
    );
  }

  Widget changePasswordBody() {
    return SizedBox(
      width: 500,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            TextFormFieldWidget(
              title: 'To:',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              controller: emailController,
              enabled: false,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10), // Adjust the right padding
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
                                      : Colors.green,
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Generate random password',
                  child: GestureDetector(
                    onTap: () {
                      String password = generateRandomPassword();
                      newPasswordController.text = password;
                      onPasswordChanged(password); // Update criteria here
                      setState(() {
                        // Call function to check password
                        validatePassword(password); // Ensure validation is run
                      });
                    },
                    child: const Icon(
                      Icons.shuffle,
                      size: 20,
                      color: AppColors.loadingColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
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
          ],
        ),
      ),
    );
  }

  Widget changePasswordButton() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.maroon2),
                borderRadius: BorderRadius.circular(5),
              ),
              // elevation: 5,
            ),
            onPressed: () => showDisregardAlertDialog(context),
            child: const SizedBox(
                height: 40,
                width: 190,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                    child: Text(
                      "Discard Changes",
                      style: TextStyles.normal14Black,
                    ),
                  ),
                ))),
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
                width: 190,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                    child: Text(
                      "Change Password",
                      style: TextStyles.bold14White,
                    ),
                  ),
                )))
      ],
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
      showChangePasswordAlertDialog(context);
    }
  }

  void showChangePasswordAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Change User Password",
        contentText: "The password will be changed. An email will be sent to the user.",
        positiveButtonText: "Proceed",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          setState(() {
            Navigator.of(context).pop();
            submitForm();
          });
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  void showDisregardAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Discard Any Changes",
        contentText: "This will discard the changes made so far.",
        positiveButtonText: "Proceed",
        negativeButtonText: "Continue Editing",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  void submitForm() async {
    String email = emailController.text;
    String newPassword = newPasswordController.text;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitFadingCircle(color: AppColors.dialogColor),
      ),
    );
    // Call the API function with the retrieved data
    final response = await UpdatePasswordAPI.changePasswordViaAdmin(email, newPassword);
    Navigator.pop(navigatorKey.currentContext!);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['retCode'] == '200') {
        showSubmissionDialog(isSuccess: true);
      } else {
        String errorMessage = jsonDecode(response.body)['message'];
        showGeneralErrorLoginAlertDialog(navigatorKey.currentContext!, errorMessage);
      }
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      showGeneralErrorLoginAlertDialog(navigatorKey.currentContext!, errorMessage);
    }
  }

  void showSubmissionDialog({required bool isSuccess}) {
    if (isSuccess == true) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
          titleText: isSuccess ? 'Successfully Reset' : 'Failed to Reset',
          contentText: isSuccess ? 'Password changed successfully.' : 'Sorry, we are unable to process your request.',
          positiveButtonText: isSuccess ? "Done" : "Retry",
          positiveOnPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          iconData: isSuccess ? Icons.check_circle_outline : Icons.error_outline,
          titleColor: isSuccess ? AppColors.ngoColor : AppColors.maroon2,
          iconColor: Colors.white,
        ),
      );
    }
  }
}

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
