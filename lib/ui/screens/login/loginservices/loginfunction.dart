import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';

import '../../../../core/api/login_logout/login.dart';
import '../../../../core/provider/timer_service_provider.dart';
import '../../../shared/widget/alert_dialog/alert_dialogs.dart';
import 'code_verification.dart';

TimerProvider timerProvider = TimerProvider();
Future<void> login(
  BuildContext context,
  TextEditingController usercontroller,
  TextEditingController passcontroller,
) async {
  String username = usercontroller.text;
  String password = passcontroller.text;

  if (username.isEmpty && password.isEmpty) {
    showUnauthorizedAlertDialog(context, "Credentials not found."); // Stop further execution
  } else if (username.isEmpty || password.isEmpty) {
    showUnauthorizedAlertDialog(context, "Invalid credentials"); // Stop further execution
  } else {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)), // Set the border radius to zero
          ),
          contentPadding: const EdgeInsets.all(50),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(image: AssetImage('images/kplus_webtool_logo1.png'), height: 50),
              // const Text('Whitelist Management'),
              //Image(image: AssetImage('images/cgby.png'), height: 100),
              const SizedBox(height: 10),
              Container(
                height: 20,
                width: 20,
                child: const CircularProgressIndicator(color: AppColors.maroon2),
              ),
              const SizedBox(height: 10),
              const Text(
                "Signing in...",
                style: TextStyle(color: Colors.black54, fontSize: 12, fontFamily: "RobotoThin"),
              ),
            ],
          ),
        );
      },
    );

    try {
      final response = await LoginAPI().LogInFunction(username, password);
      final responseJson = json.decode(response.body);

      Navigator.pop(context);

      if (response.statusCode == 200 && jsonDecode(response.body)['retCode'] == '200') {
        final token = responseJson['data']['token'];
        final fname = responseJson['data']['fname'];
        final lname = responseJson['data']['lname'];
        final insti = responseJson['data']['insti'];
        final userrole = responseJson['data']['userrole'];
        final uid = responseJson['data']['uid']; // added by lea
        //
        html.window.localStorage['token'] = token;
        html.window.localStorage['fname'] = fname;
        html.window.localStorage['lname'] = lname;
        html.window.localStorage['userrole'] = userrole;
        html.window.localStorage['insti'] = insti;
        html.window.localStorage['uid'] = uid; // added by lea
        html.window.localStorage['idlePopup'] = ''; //do not delete, tracking variable for idle

        timerProvider.stop();

        //date added | june 17, 2024
        showEmailVerificationCode(context);
      } else if (response.statusCode == 401 && jsonDecode(response.body)['message'] == 'Password Already Expired') {
        showPasswordExpiredAlertDialog(context);
      }
      // else if (response.statusCode == 401 && jsonDecode(response.body)['message'] == 'You are currently logged in on another device') {
      //   showAlreadyLoginAlertDialog(context, () async {
      //     await successLogin(context, username, password);
      //   });
      // }
      else {
        String errorMessage = jsonDecode(response.body)['message'];
        showGeneralErrorLoginAlertDialog(context, errorMessage);
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error during login request LOGIN: $error');
      }
      Navigator.pop(context);
      showServerDisconnectionAlertDialog(context);
    }
  }
}

//FORCE LOGIN
Future<void> successLogin(BuildContext context, String username, String password) async {
  // Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)), // Set the border radius to zero
        ),
        contentPadding: const EdgeInsets.all(50),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(image: AssetImage('images/kplus_webtool_logo1.png'), height: 50),
            // const Text('Whitelist Management'),
            //Image(image: AssetImage('images/cgby.png'), height: 100),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: 20,
              child: const CircularProgressIndicator(color: AppColors.maroon2),
            ),
            const SizedBox(height: 10),
            const Text(
              "Signing in...",
              style: TextStyle(color: Colors.black54, fontSize: 12, fontFamily: "RobotoThin"),
            ),
          ],
        ),
      );
    },
  );

  try {
    final response = await LoginAPI().forceLoginFunction(username, password);
    final responseJson = json.decode(response.body);

    // Close the loading dialog
    Navigator.pop(context);

    if (response.statusCode == 200 && responseJson['retCode'] == '200') {
      final token = responseJson['data']['token'];
      final fname = responseJson['data']['fname'];
      final lname = responseJson['data']['lname'];
      final insti = responseJson['data']['insti'];
      final userrole = responseJson['data']['userrole'];
      final uid = responseJson['data']['uid']; // added by lea

      html.window.localStorage['token'] = token;
      html.window.localStorage['fname'] = fname;
      html.window.localStorage['lname'] = lname;
      html.window.localStorage['userrole'] = userrole;
      html.window.localStorage['insti'] = insti;
      html.window.localStorage['uid'] = uid; // added by lea

      showEmailVerificationCode(context);
    } else {
      print('API call failed: ${responseJson['message']}');
    }
  } catch (error) {
    // Close the loading dialog in case of error
    Navigator.pop(context);
    print('Error during API call: $error');
  }
}
//
// void _startIdleTimer(BuildContext context) async {
//   await Provider.of<TimerProvider>(context, listen: false).updateIdleTimer();
// }

// void _startStatusChecker() async {
//   Provider.of<UserProvider>(navigatorKey.currentContext!, listen: false).startUserStatusCheck();
// }
