import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/provider/timer_service_provider.dart';
import '../../../../../../core/service/setting_api.dart';
import '../../../../../shared/formatters/formatter.dart';
import '../../../../../shared/utils/utils_responsive.dart';
import '../../../../../shared/values/colors.dart';
import '../../../../../shared/values/styles.dart';
import '../../../../../shared/widget/buttons/button.dart';
import '../../../../../shared/widget/containers/dialog.dart';
import '../../../../../shared/widget/fields/textformfield.dart';

class AccountDeactivationManagement extends StatefulWidget {
  const AccountDeactivationManagement({super.key});

  @override
  State<AccountDeactivationManagement> createState() => _AccountDeactivationManagementState();
}

class _AccountDeactivationManagementState extends State<AccountDeactivationManagement> {
  Timer? _timer;

  void _startTimer() {
    final timer = Provider.of<TimerProvider>(context, listen: false);
    timer.startTimer(context);
    timer.buildContext = context;
  }

  void _pauseTimer([_]) {
    _timer?.cancel();
    _startTimer();
    debugPrint('flutter-----(time pause!)');
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        _startTimer();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.paused:
        _pauseTimer();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  TextEditingController timeoutNumberController = TextEditingController();
  TextEditingController timeoutFormatController = TextEditingController();
  late bool isSwitched = false;
  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer()
    ..onTap = () {
      // Handle the tap event
    };

  @override
  void initState() {
    _startTimer();
    super.initState();

    // initializeAccountInfo();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Future<void> initializeAccountInfo() async {
  //   TimerProvider accountDeactivationTimeProvider = Provider.of<TimerProvider>(context, listen: false);
  //   await accountDeactivationTimeProvider.fetchAccountDeactivationTime();
  //   timeoutNumberController.text = accountDeactivationTimeProvider.accountDeactivationDuration;
  //   timeoutFormatController.text = accountDeactivationTimeProvider.accountDeactivationFormat;
  //
  //   debugPrint('Fetched Account Deactivation Time: ${accountDeactivationTimeProvider.accountDeactivationDuration}');
  //   debugPrint('Fetched Account Deactivation Format: ${accountDeactivationTimeProvider.accountDeactivationFormat}');
  // }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerHover: _pauseTimer,
      onPointerMove: _pauseTimer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Account Deactivation",
            style: TextStyles.heavyBold16Black,
          ),
          const SizedBox(height: 10),
          Responsive(
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                accountPhraseBody(),
                accountTimeFields(),
              ],
            ),
            mobile: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                accountPhraseBody(),
                accountTimeFields(),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                const Spacer(),
                MyButton.buttonWithLabel(context, () => submitUpdateAccountTime(), 'Save Changes', Icons.save_outlined, AppColors.ngoColor),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget accountPhraseBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Automatically deactivates a user's account.",
          style: TextStyles.headingTextStyle,
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Force deactivation of user account with no system interactivity. ',
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

  Widget accountTimeFields() {
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
                    debugPrint(value);
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
                  // DropdownMenuEntry(value: 'hours', label: 'hours'),
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

  void submitUpdateAccountTime() async {
    // Retrieve data from controllers
    int accountTime = int.parse(timeoutNumberController.text);
    String accountFormat = timeoutFormatController.text;

    debugPrint('Fetched Account Deactivation Format: $accountFormat');
    debugPrint('Fetched Account Deactivation Duration: ${accountTime.toString()}');

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
              'Saving new account deactivation timeout...',
              style: TextStyles.bold14White,
            ),
          ],
        ),
      ),
    );

    // Call the API function with the retrieved data
    final response = await SettingsAPI.updateAccountDeactivationTime(
      accountTime,
      accountFormat,
    );

    Navigator.pop(context);

    if (response.statusCode == 200 && jsonDecode(response.body)['retCode'] == '200') {
      showSuccessFailAlertDialog(isSuccess: true);
      // initializeAccountInfo();
    } else {
      showSuccessFailAlertDialog(isSuccess: false);
    }
  }

  Future<void> showSuccessFailAlertDialog({required bool isSuccess}) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        titleText: isSuccess ? "Account Deactivation Parameter Updated" : "Failed to Update",
        contentText: isSuccess ? "The account deactivation was updated successfully." : "Sorry! The deactivation's parameter was not updated.",
        // positiveButtonText: isSuccess ? "Done" : "Retry",
        // positiveOnPressed: () {
        //   if (isSuccess) {
        //     Navigator.pop(context);
        //     initializeAccountInfo();
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
