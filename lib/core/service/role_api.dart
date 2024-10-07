import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/mfi_whitelist_api/api_endpoints.dart';
import 'package:mfi_whitelist_admin_portal/main.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/alert_dialog/alert_dialogs.dart';

import '../../ui/shared/sessionmanagement/gettoken/gettoken.dart';
import '../models/user_management/roles_model.dart';
import 'url_getter_setter.dart';

final token = getToken();

class UserRoleAPI {
  static String baseURL = UrlGetter.getURL();
  static final token = getToken();

  static final StreamController<Map<String, dynamic>> _accessStreamController = StreamController.broadcast();
  static Stream<Map<String, dynamic>> get accessStream => _accessStreamController.stream;

  //GET ALL ROLES
  static Future<List<Role>> getAllUserRoleTitlesAndStatus() async {
    final response = await http.get(
      Uri.parse(MFIApiEndpoints.getALLRoles),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token', 'Accept-Charset': 'UTF-8'},
    );
    try {
      if (response.statusCode == 200) {
        final List<dynamic> rolesData = jsonDecode(response.body)['data'];
        return rolesData.map((json) => Role.fromJson(json)).toList();
      } else {
        print(response.body);
        print(response.statusCode);
        throw Exception('Failed to load roles');
      }
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      throw Exception('Failed to parse API response: $e');
    }
  }

  //GET ROLE DETAILS/ACCESS
  static Future<Map<String, dynamic>> getAccessByRole(String roleTitle) async {
    // var roleUrl = '$baseURL/role/access/$roleTitle';
    var roleUrl = MFIApiEndpoints.getRoleAccessByTitle(roleTitle);
    http.Response response = await http.get(
      Uri.parse(roleUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

    try {
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _accessStreamController.add(responseData['data']); // Emit access data to the stream
        return responseData['data'] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load the access of the user role');
      }
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      throw Exception('Failed to connect to the API: $e');
    }
  }

  //UPDATE ROLE STATUS
  static Future<bool> switchRoleStatus(int roleId, String token) async {
    try {
      final response = await http.put(
        Uri.parse(MFIApiEndpoints.switchRoleStatusByID(roleId)),
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
      debugPrint('An error occurred during updating of user status: $e');
      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      return false;
    }
  }
}

class FetchRoleAPI {
  static String baseURL = UrlGetter.getURL();

  static Future<List<Map<String, dynamic>>> fetchRoles() async {
    final response = await http.get(
      Uri.parse(MFIApiEndpoints.getALLRoles),
      headers: {'Authorization': 'Bearer $token'},
    );
    try {
      if (response.statusCode == 200) {
        final List<dynamic> rolesData = json.decode(response.body)['data'];
        return rolesData.map((data) => data as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load roles');
      }
    } catch (error) {
      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      throw Exception('Error fetching roles data: $error');
    }
  }
}

//GET ALL DASHBOARD ITEMS/MENUS
class DisplayAccess {
  static String baseURL = UrlGetter.getURL();
  Future<List<Dashboard>> fetchDashboards() async {
    final url = Uri.parse(MFIApiEndpoints.getDashboardMenu);

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      debugPrint('Dashboard data: $responseData');
      final List<dynamic> dashboardData = responseData['data'];

      // Map each dashboard object to a Dashboard instance
      List<Dashboard> dashboards = dashboardData.map((data) => Dashboard.fromJson(data)).toList();
      return dashboards;
    } else {
      throw Exception('Failed to load dashboards');
    }
  }
}

class GetRoleAccess {
  static String baseURL = UrlGetter.getURL();

  static Future<RoleData> getAccessByRole(String roleTitle) async {
    final token = getToken();
    var roleUrl = MFIApiEndpoints.getRoleAccessByTitle(roleTitle);

    http.Response response = await http.get(
      Uri.parse(roleUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return RoleData.fromJson(jsonData);
      } else if (response.statusCode == 401 && jsonDecode(response.body)['retCode'] == '401') {
        throw Exception('Unauthorized: ${jsonDecode(response.body)['message']}');
      } else {
        throw Exception('Failed to load role access data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to parse JSON: $e');
    }
  }
}
