import 'package:flutter/foundation.dart';

import '../../models/user_management/login_model.dart';

class LoginProvider extends ChangeNotifier {
  LoginData? _loginData;
  LoginData? get loginData => _loginData;

  // Getter for the first name
  String get firstName => _loginData?.firstName ?? '';

  // Getter for the last name
  String get lastName => _loginData?.lastName ?? '';

  // Getter for the insti
  String get institution => _loginData?.insti ?? '';

  // Getter for the uid
  String get uid => _loginData?.uid ?? '';

  // Getter for the role
  String get role => _loginData?.userrole ?? '';

  // Getter for token
  String get token => _loginData?.token ?? '';

  // Method to perform logout
  void logout() {
    _loginData = null;
    notifyListeners();
  }
}

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
