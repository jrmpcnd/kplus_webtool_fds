import 'dart:html' as html;

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

class EncryptionUtils {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.allZerosOfLength(16);

  static String encryptValue(String value) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(value, iv: iv);
    return encrypted.base64;
  }

  static String decryptValue(String encryptedValue) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedValue, iv: iv);
    return decrypted;
  }
}

String encryptValue(String value) {
  try {
    final encryptedValue = EncryptionUtils.encryptValue(value);
    return encryptedValue;
  } catch (error) {
    debugPrint('Error during encryption: $error');
    return '';
  }
}

String decryptValue(String encryptedValue) {
  try {
    final decryptedValue = EncryptionUtils.decryptValue(encryptedValue);
    return decryptedValue;
  } catch (error) {
    debugPrint('Error during decryption: $error');
    return '';
  }
}

class GetDecryptedInfo {
  String? getDecryptedValue(String? encryptedValue) {
    if (encryptedValue != null && encryptedValue.isNotEmpty) {
      try {
        return EncryptionUtils.decryptValue(encryptedValue);
      } catch (error) {
        print('Error during decryption: $error');
      }
    }
    return null;
  }

  String? getFname() {
    final fname = html.window.localStorage['fname'];
    return getDecryptedValue(fname);
  }

  String? getPath() {
    final path = html.window.localStorage['Path'];
    return getDecryptedValue(path);
  }

  String? getLname() {
    final lname = html.window.localStorage['lname'];
    return getDecryptedValue(lname);
  }

  String? getEmail() {
    final email = html.window.localStorage['email'];
    return getDecryptedValue(email);
  }

  String? getUrole() {
    final urole = html.window.localStorage['userrole'];
    return getDecryptedValue(urole);
  }

  String? getInstitution() {
    final insti = html.window.localStorage['insti'];
    return getDecryptedValue(insti);
  }

  String? getUId() {
    final userId = html.window.localStorage['uid'];
    return getDecryptedValue(userId);
  }

  String? getToken() {
    final token = html.window.localStorage['token'];
    debugPrint(getDecryptedValue(token));
    return getDecryptedValue(token);
  }

  String? getInsti() {
    final insti = html.window.localStorage['insti'];
    return getDecryptedValue(insti);
  }
}
