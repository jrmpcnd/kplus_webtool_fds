import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/mfi_whitelist_api/api_endpoints.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/alert_dialog/alert_dialogs.dart';

import '../../../main.dart';
import '../../../ui/shared/navigations/navigation.dart';
import '../../../ui/shared/navigations/router.dart';
import '../../../ui/shared/sessionmanagement/gettoken/gettoken.dart';
import '../../provider/timer_service_provider.dart';

TimerProvider timerProvider = TimerProvider();

Future<void> logout(String? token, bool? isAutomaticLogout) async {
  bool logoutSuccess = false;
  if (getToken() != null) {
    while (!logoutSuccess) {
      try {
        final token = getToken();
        String url = MFIApiEndpoints.logout;
        final http.Response response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        debugPrint('---------LOGOUT API CALLED--------');
        debugPrint(response.body);

        if (response.statusCode == 200) {
          isAutomaticLogout = true;
          debugPrint('Logout stopping timer');
          timerProvider.stop();
          debugPrint('Logout returns 200');
          selectedRoute = '';
          debugPrint('Logout clear storage');
          clearLocalStorage();
          debugPrint('Logout successful');
          navigateToLoginPage();
          logoutSuccess = true;
        } else {
          debugPrint('Logout failed: ${response.statusCode}');
          // Optionally, you can add a delay before retrying
          await Future.delayed(Duration(seconds: 1));
        }
      } catch (error) {
        debugPrint('Error calling logout API: $error');
        // Optionally, you can add a delay before retrying
        await Future.delayed(Duration(seconds: 1));

        Navigator.pop(navigatorKey.currentContext!);
        showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      }
    }
  }
}

Future<void> clearLocalStorage() async {
  selectedRoute = '';
  html.window.localStorage.remove('sessionStartTime');
  html.window.localStorage.remove('fname');
  html.window.localStorage.remove('lname');
  html.window.localStorage.remove('userrole');
  html.window.localStorage.remove('insti');
  html.window.localStorage.remove('submenu');
  html.window.localStorage.remove('Path');
  html.window.localStorage.remove('uid');
  html.window.localStorage.remove('token');
  html.window.localStorage.remove('idleStartTime');
  html.window.localStorage.remove('idlePopup');
}
