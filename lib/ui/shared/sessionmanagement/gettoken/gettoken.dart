import 'dart:core';
import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../../utils/utils_encrypt_local_data.dart';

String? getDecryptedValue(String? encryptedValue) {
  if (encryptedValue != null && encryptedValue.isNotEmpty) {
    try {
      return EncryptionUtils.decryptValue(encryptedValue);
    } catch (error) {
      debugPrint('Error during decryption: $error');
    }
  }
  return null;
}

// String? getToken() {
//   final token = html.window.localStorage['token'];
//   debugPrint(getDecryptedValue(token));
//   return getDecryptedValue(token);
// }
//
// String? getInsti() {
//   final insti = html.window.localStorage['insti'];
//   return getDecryptedValue(insti);
// }
//
String? getToken() {
  final token = html.window.localStorage['token'];
  return token;
}

String? getInsti() {
  final insti = html.window.localStorage['insti'];
  return insti;
}
