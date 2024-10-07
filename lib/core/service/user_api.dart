import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/mfi_whitelist_api/api_endpoints.dart';

import '../../ui/shared/sessionmanagement/gettoken/gettoken.dart';
import '../models/user_management/user_model.dart';
import 'url_getter_setter.dart';

class UserAPI {
  static String baseURL = UrlGetter.getURL();
  static final token = getToken();

  //GET ALL USERS
  static Future<List<AllUserData>> getAllUser() async {
    final response = await http.get(
      Uri.parse(MFIApiEndpoints.getAllUsers),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json; charset=UTF-8'},
    );
    try {
      if (response.statusCode == 200) {
        // print(response.body);
        final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes))['data'];
        return jsonData.map((json) => AllUserData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  static Future<AllUserData> getUserByID(int id) async {
    final response = await http.get(
      Uri.parse(MFIApiEndpoints.getSingleUserByID(id)),
      headers: {'Content-Type': 'application/json; charset=utf-8', 'Authorization': 'Bearer $token'},
    );
    try {
      if (response.statusCode == 200) {
        // print(response.body);
        final jsonData = jsonDecode(response.body);
        return AllUserData.fromJson(jsonData['data']);
      } else {
        throw Exception('API: Failed to fetch the user data');
      }
    } catch (e) {
      throw Exception('API: $e');
    }
  }

  //DISPLAY USER INFO IN THE PROFILE BY HCIS
  static Future<AllUserData> getInfoToProfile(String hcis) async {
    final response = await http.get(
      Uri.parse(MFIApiEndpoints.getUserProfile(hcis)),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    try {
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return AllUserData.fromJson(jsonData['data']);
      } else {
        throw Exception('API: Failed to fetch the user data');
      }
    } catch (e) {
      throw Exception('API: $e');
    }
  }

  //UPDATE USER STATUS
  static Future<bool> switchUserStatus(int userId, String token, bool activate) async {
    try {
      final response = await http.put(
        Uri.parse(MFIApiEndpoints.switchUserStatus(userId)),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('An error occurred during updating of user status: $e');
      return false;
    }
  }
}

//ADD NEW USER
class AddUserAPI {
  String baseURL = UrlGetter.getURL();
  final token = getToken();

  FutureOr<http.Response> createUser(
    // int id,
    int instiId,
    String hcisId,
    int roleId,
    String? firstName,
    String? middleName,
    String? lastName,
    String? position,
    String? email,
    String? username,
    String? contact,
    String? branch,
    String? unit,
    String? center,
    String? birthday,
    String? contactType,
  ) async {
    // try {
    final addUser = User(
        // id: id,
        institutionID: instiId,
        staffID: hcisId,
        roleID: roleId,
        firstName: firstName!,
        middleName: middleName,
        lastName: lastName!,
        position: position!,
        emailAddress: email!,
        username: username!,
        contact: contact,
        brCode: branch,
        unitCode: unit,
        centerCode: center,
        contactType: contactType,
        birthday: birthday);

    final token = getToken();
    final response = await http.post(
      Uri.parse(MFIApiEndpoints.addNewUser),
      headers: <String, String>{'Content-Type': 'application/json; charset=utf-8', 'Authorization': 'Bearer $token'},
      body: jsonEncode(addUser.toJson()),
    );

    debugPrint(response.body);
    debugPrint('${response.statusCode}');
    //
    // debugPrint('---------ADDED USER DATA--------');
    // debugPrint(response.statusCode.toString());
    // debugPrint(response.body);
    // debugPrint('Save cid from FE via API: $cid');
    // debugPrint('Save brCode from FE via API: $brCode');
    // debugPrint('Save unitCode from FE via API: $unitCode');
    // debugPrint('Save centerCode from FE via API: $centerCode');
    return response;
    // } catch (e) {
    //   debugPrint('An error occurred during creating: $e');
    //   rethrow;
    // }
  }
}

//UPDATE A USER
class UpdateUserAPI {
  final token = getToken();
  String baseURL = UrlGetter.getURL();
  Future<http.Response> updateUserInfo(
    int id,
    int instiId,
    String hcisId,
    int roleId,
    String? firstName,
    String? middleName,
    String? lastName,
    String? position,
    String? email,
    String? username,
    String? contactType,
    String? contact,
    String? cid,
    String? branch,
    String? unit,
    String? center,
    String? birthday,
  ) async {
    try {
      User updateUser = User(id: id, institutionID: instiId, staffID: hcisId, roleID: roleId, firstName: firstName!, middleName: middleName, lastName: lastName!, position: position!, emailAddress: email!, username: username!, contact: contact, cid: cid, brCode: branch, unitCode: unit, centerCode: center, birthday: birthday);

      print('Received from ui: $roleId');
      final response = await http.put(
        Uri.parse(MFIApiEndpoints.updateAUser(id)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateUser.toJson()),
      );

      debugPrint('---------UPDATED USER DATA--------');
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      debugPrint('Upon saving: ${updateUser.toJson()}');

      return response;
    } catch (e) {
      debugPrint('An error occurred during update: $e');
      rethrow;
    }
  }
}

class ResetPassEmail {
  static String baseURL = UrlGetter.getURL();
  FutureOr<http.Response> crossCheckEmailPasswordReset(String email) async {
    final url = Uri.parse(MFIApiEndpoints.checkEmail);
    final response = await http.post(
      url,
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    // debugPrint('Status Code: ${response.statusCode}');
    // debugPrint('Response Body: ${response.body}');

    try {
      if (response.statusCode == 200) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      throw Exception('Failed to decode response: $e');
    }
  }
}

class UpdatePasswordAPI {
  static String baseURL = UrlGetter.getURL();
  static final token = getToken();

  //RESET PASSWORD VIA ADMIN ACCOUNT
  static FutureOr<http.Response> changePasswordViaAdmin(String email, String newPassword) async {
    try {
      AdminChangeUserPassword updateUser = AdminChangeUserPassword(email: email, password: newPassword);
      final response = await http.put(
        Uri.parse(MFIApiEndpoints.changePasswordByAdmin),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateUser.toJson()),
      );

      // debugPrint('---------PASSWORD VIA ADMIN WAS CHANGED--------');
      // debugPrint(response.statusCode.toString());
      // debugPrint(response.body);
      // debugPrint(token);
      return response;
    } catch (e) {
      debugPrint('An error occurred during updating of password: $e');
      rethrow;
    }
  }

  //CHANGE PASSWORD VIA USER PROFILE
  static FutureOr<http.Response> changePasswordViaUser(String oldPassword, String newPassword) async {
    try {
      UserChangePassword updateUser = UserChangePassword(existingPassword: oldPassword, password: newPassword);

      final response = await http.put(
        Uri.parse(MFIApiEndpoints.changePasswordByUser),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Connection': 'keep-alive',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateUser.toJson()),
      );

      debugPrint('---------PASSWORD VIA PROFILE WAS CHANGED--------');
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      // debugPrint(token);
      return response;
    } catch (e) {
      debugPrint('An error occurred during updating of password: $e');
      rethrow;
    }
  }

  //CHANGE PASSWORD VIA EMAIL LINK
  static FutureOr<http.Response> changePasswordViaEmailLink(String newPassword, String oldPassword) async {
    try {
      EmailLinkChangePassword updateUser = EmailLinkChangePassword(password: newPassword, oldPass: oldPassword);

      //================Date Added : 6-17 ; Lea===================//
      final response = await http.put(
        Uri.parse(MFIApiEndpoints.changePasswordByEmail),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Connection': 'keep-alive',
          'Authorization': '$token',
        },
        body: jsonEncode(updateUser.toJson()),
      );

      // debugPrint('---------PASSWORD VIA EMAIL LINK WAS CHANGED--------');
      // debugPrint(response.statusCode.toString());
      // debugPrint(response.body);
      return response;
    } catch (e) {
      debugPrint('An error occurred during updating of password: $e');
      rethrow;
    }
  }
}
