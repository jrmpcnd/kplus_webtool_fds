import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../../core/service/setting_api.dart';
import '../../../../../shared/formatters/formatter.dart';
import '../../../../../shared/utils/utils_responsive.dart';
import '../../../../../shared/values/colors.dart';
import '../../../../../shared/values/styles.dart';
import '../../../../../shared/widget/buttons/button.dart';
import '../../../../../shared/widget/containers/dialog.dart';
import '../../../../../shared/widget/fields/textformfield.dart';

class SessionSetting extends StatefulWidget {
  const SessionSetting({super.key});

  @override
  State<SessionSetting> createState() => _SessionSettingState();
}

class _SessionSettingState extends State<SessionSetting> {
  TextEditingController timeoutNumberController = TextEditingController();
  TextEditingController timeoutFormatController = TextEditingController();
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer()
    ..onTap = () {
      // Handle the tap event
    };

  @override
  void initState() {
    super.initState();
    // initializeSessionInfo();
  }

  // Future<void> initializeSessionInfo() async {
  //   TimerProvider sessionTimeProvider = Provider.of<TimerProvider>(context, listen: false);
  //   await sessionTimeProvider.fetchSessionTime();
  //   timeoutNumberController.text = sessionTimeProvider.sessionDuration;
  //   timeoutFormatController.text = sessionTimeProvider.sessionFormat;
  //
  //   debugPrint('Fetched Session Time: ${sessionTimeProvider.sessionDuration}');
  //   debugPrint('Fetched Session Format: ${sessionTimeProvider.sessionFormat}');
  // }

  @override
  Widget build(BuildContext context) {
    Size screenHeight = MediaQuery.of(context).size;
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Session Timeout",
          style: TextStyles.heavyBold16Black,
        ),
        const SizedBox(height: 10),
        Responsive(
          desktop: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sessionPhraseBody(),
              sessionTimeFields(),
            ],
          ),
          mobile: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sessionPhraseBody(),
              sessionTimeFields(),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Row(
            children: [
              const Spacer(),
              MyButton.buttonWithLabel(context, () => submitUpdateSession(), 'Save Changes', Icons.save_outlined, AppColors.ngoColor),
            ],
          ),
        )
      ],
    );
  }

  Widget sessionPhraseBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Automatically log out user.",
          style: TextStyles.headingTextStyle,
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Force users to logout upon expiration of the session token. ',
                style: TextStyles.dataTextStyle,
              ),
              TextSpan(
                text: 'Learn more',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
                recognizer: _tapGestureRecognizer,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget sessionTimeFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Set Timeout Limit',
          style: TextStyles.dataTextStyle,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              // color: Colors.deepPurpleAccent.shade100,
              width: 120,
              height: 50,
              child: Tooltip(
                message: 'Set length of duration',
                child: TextFormFieldWidget(
                  contentPadding: 20,
                  borderRadius: 3,
                  controller: timeoutNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [TwoDigitInputFormatter()],
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
            // const SizedBox(width: 10),
            Tooltip(
              message: 'Set timeout format',
              child: DropdownMenu(
                controller: timeoutFormatController,
                textStyle: TextStyles.dataTextStyle,
                width: 120,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 'minutes', label: 'minutes'),
                  DropdownMenuEntry(value: 'hours', label: 'hours'),
                  DropdownMenuEntry(value: 'days', label: 'days'),
                ],
                inputDecorationTheme: InputDecorationTheme(
                  outlineBorder: const BorderSide(color: AppColors.ngoColor, style: BorderStyle.solid),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: AppColors.green3, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: AppColors.ngoColor),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                onSelected: (value) {
                  // Handle the selected value here
                  // debugPrint('Selected value: $value');
                  // You can store the selected value in a variable or use it as needed
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void submitUpdateSession() async {
    // Retrieve data from controllers
    int sessionTime = int.parse(timeoutNumberController.text);
    String sessionFormat = timeoutFormatController.text;

    debugPrint('Fetched Session Format: $sessionFormat');
    debugPrint('Fetched Session Duration: ${sessionTime.toString()}');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SpinKitFadingCircle(color: AppColors.dialogColor),
            Text(
              'Saving new session data...',
              style: TextStyles.bold14White,
            ),
          ],
        ),
      ),
    );

    // Call the API function with the retrieved data
    final response = await SettingsAPI.updateSessionTime(
      sessionTime,
      sessionFormat,
    );

    Navigator.pop(context);

    if (response.statusCode == 200 && jsonDecode(response.body)['retCode'] == '200') {
      showSuccessFailAlertDialog(isSuccess: true);
      // initializeSessionInfo();
      // setSessionDuration();
      // await Provider.of<SessionProvider>(context, listen: false).updateSessionTimer();
    } else {
      showSuccessFailAlertDialog(isSuccess: false);
    }
  }

  void showSuccessFailAlertDialog({required bool isSuccess}) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        titleText: isSuccess ? "Session Parameter Updated" : "Failed to Update",
        contentText: isSuccess ? "The session timeout was updated successfully." : "Sorry! The session's info was not updated.",
        // positiveButtonText: isSuccess ? "Done" : "Retry",
        // positiveOnPressed: () {
        //   if (isSuccess) {
        //     Navigator.pop(context);
        //     initializeSessionInfo();
        //   }
        // },
        iconData: isSuccess ? Icons.check_circle_outline : Icons.error_outline,
        titleColor: isSuccess ? AppColors.ngoColor : AppColors.errorColor,
        iconColor: isSuccess ? Colors.green : Colors.white,
      ),
    );
    if (isSuccess) {
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context);
    }
  }
}
