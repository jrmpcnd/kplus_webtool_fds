import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../ui/shared/sessionmanagement/gettoken/gettoken.dart';
import '../../models/dashboard_values/dashboard_values_model.dart';
import '../../service/url_getter_setter.dart';

class ClientStatusCountsAPI {
  final token = getToken();

  Future<ClientStatusCounts?> fetchClientStatusCounts() async {
    final token = await getToken(); // Ensure token fetching is awaited

    try {
      final response = await http.get(
        Uri.parse('${UrlGetter.getURL()}/filters/test/count/all/distinct/status'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['retCode'] == '200') {
          return ClientStatusCounts.fromJson(data['data']);
        }
      } else {
        debugPrint('Dashboard Values Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Exception caught: $e');
      // showErrorLoginAlertDialog(navigatorKey.currentContext!);
    }
    return null;
  }
}

class UserStatusCountsAPI {
  final token = getToken();

  Future<UserStatusCounts?> fetchUserStatusCounts() async {
    final token = getToken(); // Ensure token fetching is awaited

    try {
      final response = await http.get(
        Uri.parse('${UrlGetter.getURL()}/filters/test/count/all/distinct/user/role'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['retCode'] == '200') {
          return UserStatusCounts.fromJson(data['data']);
        }
      } else {
        debugPrint('Dashboard Values Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Exception caught: $e');
    }
    return null;
  }
}

class AMLAStatusCountsAPI {
  final token = getToken();

  Future<AMLAStatusCounts?> fetchAMLAStatusCounts() async {
    final token = getToken(); // Ensure token fetching is awaited

    try {
      final response = await http.get(
        Uri.parse('${UrlGetter.getURL()}/amla/test/count/all/distinct/watchlist'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['retCode'] == '200') {
          return AMLAStatusCounts.fromJson(data['data']);
        }
      } else {
        debugPrint('Dashboard Values Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Exception caught: $e');
    }
    return null;
  }
}
