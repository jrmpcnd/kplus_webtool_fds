import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../ui/shared/sessionmanagement/gettoken/gettoken.dart';
import '../models/user_management/setting_model.dart';
import 'url_getter_setter.dart';

class SettingsAPI {
  static String baseURL = UrlGetter.getURL();
  static final token = getToken();

  // Create a broadcast stream controller to broadcast updates
  // static final StreamController<IdleData> _idleDataController = StreamController.broadcast();
  // static final StreamController<SessionData> _sessionDataController = StreamController.broadcast();
  // // Getter for the idle time stream
  // static Stream<IdleData> get idleDataStream => _idleDataController.stream;
  // static Stream<SessionData> get sessionDataStream => _sessionDataController.stream;

  //POSTING IDLE DURATION
  static FutureOr<http.Response> updateIdleTime(int idleTime, String idleFormat) async {
    try {
      IdleData updateIdle = IdleData(duration: idleTime, format: idleFormat);

      final response = await http.put(
        Uri.parse('$baseURL/update/idle/time'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateIdle.toJson()),
      );

      debugPrint('---------UPDATED IDLE DATA--------');
      debugPrint(response.statusCode.toString());
      // _idleDataController.add(updateIdle); // Notify listeners of the update
      return response;
    } catch (e) {
      debugPrint('An error occurred during update: $e');
      rethrow;
    }
  }

  //GETTING IDLE DURATION
  static Future<IdleData> getIdleTime() async {
    final response = await http.get(
      Uri.parse('$baseURL/get/idle/time'),
      headers: {
        // 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      IdleData idleData = IdleData.fromJson(jsonData['data']);
      //_idleDataController.add(idleData); // Add fetched idle data to the stream
      return idleData;
    } else {
      throw Exception('Failed to load idle time');
    }
  }

  static Future<bool> switchIdleStatus() async {
    try {
      final response = await http.put(
        Uri.parse('$baseURL/update/idle/status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //VALIDATE PASSWORD FOR RE-LOGIN UPON IDLE
  static Future<http.Response> validatePasswordOnIdle(String password, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/user/relogin'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(<String, String>{'password': password}),
      );

      debugPrint('Re-login Response Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        return response;
      } else {
        debugPrint('Re-login Response Code: ${response.statusCode}');
        return response;
      }
    } catch (error) {
      rethrow;
    }
  }

  //POSTING SESSION DURATION
  static FutureOr<http.Response> updateSessionTime(int sessionTime, String sessionFormat) async {
    try {
      SessionData updateSession = SessionData(duration: sessionTime, format: sessionFormat);

      final response = await http.put(
        Uri.parse('$baseURL/update/token/time'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateSession.toJson()),
      );

      debugPrint('---------UPDATED SESSION DATA--------');
      debugPrint(response.statusCode.toString());
      //_sessionDataController.add(updateSession);
      return response;
    } catch (e) {
      debugPrint('An error occurred during update: $e');
      rethrow;
    }
  }

  //GETTING SESSION DURATION
  static Future<SessionData> getSessionTime() async {
    final response = await http.get(
      Uri.parse('$baseURL/get/token/time'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      SessionData sessionData = SessionData.fromJson(jsonData['data']);
      //_sessionDataController.add(sessionData);
      return sessionData;
    } else {
      throw Exception('Failed to load session time');
    }
  }

  static FutureOr<http.Response> updatePasswordTime(int passwordTime, String passwordFormat) async {
    try {
      PasswordData updatePassword = PasswordData(duration: passwordTime, format: passwordFormat);

      final response = await http.put(
        Uri.parse('$baseURL/update/password/duration'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updatePassword.toJson()),
      );

      debugPrint('---------UPDATED PASSWORD DATA--------');
      debugPrint(response.statusCode.toString());
      return response;
    } catch (e) {
      debugPrint('An error occurred during update: $e');
      rethrow;
    }
  }

  //GETTING PASSWORD DURATION
  static Future<PasswordData> getPasswordTime() async {
    final response = await http.get(
      Uri.parse('$baseURL/get/password/duration'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return PasswordData.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load password time');
    }
  }

  //POSTING ACCOUNT DEACTIVATION DURATION
  static FutureOr<http.Response> updateAccountDeactivationTime(int accountDeactivationTime, String accountDeactivationFormat) async {
    try {
      AccountDeactivationData updateAccountDeactivation = AccountDeactivationData(duration: accountDeactivationTime, format: accountDeactivationFormat);

      final response = await http.put(
        Uri.parse('$baseURL/update/account/duration'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateAccountDeactivation.toJson()),
      );

      debugPrint('---------UPDATED ACCOUNT DEACTIVATION DATA--------');
      debugPrint(response.statusCode.toString());
      return response;
    } catch (e) {
      debugPrint('An error occurred during update: $e');
      rethrow;
    }
  }

  //GETTING ACCOUNT DEACTIVATION DURATION
  static Future<AccountDeactivationData> getAccountDeactivationTime() async {
    final response = await http.get(
      Uri.parse('$baseURL/get/account/duration'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return AccountDeactivationData.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load idle time');
    }
  }
}
