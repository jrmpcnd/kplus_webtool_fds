import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/mfi_whitelist_api/api_endpoints.dart';
import 'package:mfi_whitelist_admin_portal/main.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/alert_dialog/alert_dialogs.dart';

import '../../../ui/shared/sessionmanagement/gettoken/gettoken.dart';
import '../../models/login/login.dart';
import '../../service/url_getter_setter.dart';

class LoginAPI {
  static String baseURL = UrlGetter.getURL();
  FutureOr<http.Response> LogInFunction(String username, String password) async {
    try {
      String url = MFIApiEndpoints.login;

      LoginModel logInModel = LoginModel(
        username: username,
        password: password,
      );

      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(logInModel.toJson()),
      );

      return response;
    } catch (error) {
      if (kDebugMode) {
        print('Error during login request API: $error');
      }
      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      rethrow;
    }
  }

  Future<http.Response> forceLoginFunction(String username, String password) async {
    final String url = '$baseURL/login/test/force';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    return response;
  }
}

class ConfigReg {
  Future<http.Response> configReg(String code) async {
    final token = getToken();
    final http.Response response = await http.post(
      Uri.parse(MFIApiEndpoints.verifyOTPCode),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'code': code}),
    );
    // print(response.body);
    return response;
  }
}
