import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/service/user_api.dart';

String? getFname() {
  final fname = html.window.localStorage['fname'];
  return fname;
}

String? getPath() {
  final path = html.window.localStorage['Path'];
  return path;
}

String? getStatus() {
  final status = html.window.localStorage['status'];
  return status;
}

String? getLname() {
  final lname = html.window.localStorage['lname'];
  return lname;
}

String? getEmail() {
  final email = html.window.localStorage['email'];
  return email;
}

String? getUrole() {
  final urole = html.window.localStorage['userrole'];
  return urole;
}

Future<String?> getUname() async {
  final hcis = getUId();
  final getUname = await UserAPI.getInfoToProfile(hcis!);
  return getUname.username;
}

Future<void> saveUsername(String username) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
  debugPrint('Saved username: $username');
}

Future<String?> getSavedUsername() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

String? getInstitution() {
  final insti = html.window.localStorage['insti'];
  return insti;
}

String? getCurrentpage() {
  final cPage = html.window.localStorage['currentpage'];
  return cPage;
}

String? getUId() {
  final userId = html.window.localStorage['uid'];
  return userId;
}

String? getSubmenu() {
  final sMenu = html.window.localStorage['submenu'];
  return sMenu;
}

// import '../../utils/utils_encrypt_local_data.dart';
//
// String? getDecryptedValue(String? encryptedValue) {
//   if (encryptedValue != null && encryptedValue.isNotEmpty) {
//     try {
//       return EncryptionUtils.decryptValue(encryptedValue);
//     } catch (error) {
//       print('Error during decryption: $error');
//     }
//   }
//   return null;
// }
//
// String? getFname() {
//   final fname = html.window.localStorage['fname'];
//   return getDecryptedValue(fname);
// }
//
// String? getPath() {
//   final path = html.window.localStorage['Path'];
//   return getDecryptedValue(path);
// }
//
// String? getLname() {
//   final lname = html.window.localStorage['lname'];
//   return getDecryptedValue(lname);
// }
//
// String? getEmail() {
//   final email = html.window.localStorage['email'];
//   return getDecryptedValue(email);
// }
//
// String? getUrole() {
//   final urole = html.window.localStorage['userrole'];
//   return getDecryptedValue(urole);
// }
//
// String? getInstitution() {
//   final insti = html.window.localStorage['insti'];
//   return getDecryptedValue(insti);
// }
//
// String? getCurrentpage() {
//   final cPage = html.window.localStorage['currentpage'];
//   return getDecryptedValue(cPage);
// }
//
// String? getUId() {
//   final userId = html.window.localStorage['uid'];
//   return getDecryptedValue(userId);
// }
//
// String? getSubmenu() {
//   final sMenu = html.window.localStorage['submenu'];
//   return getDecryptedValue(sMenu);
// }
