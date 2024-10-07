import 'package:flutter/cupertino.dart';

import '../../main.dart';
import '../../ui/shared/sessionmanagement/gettoken/gettoken.dart';
import '../../ui/shared/sessionmanagement/getuserinfo/getuserinfo.dart';

class AuthService {
  Future<bool> isAuthenticated() async {
    final insti = getInsti();
    final lname = getLname();
    final path = getPath();
    final uid = getUId();
    final urole = getUrole();
    final token = getToken();
    final fname = getFname();

    return token != null && urole != null && uid != null && fname != null && lname != null && insti != null && path != null;
  }

  Future<String?> getInitialPath() async {
    bool authenticated = await isAuthenticated();
    return authenticated ? path : '/Login';
  }
}

Future<void> isNotLocalStorageEmpty(BuildContext context) async {
  bool authenticated = await AuthService().isAuthenticated();
  if (authenticated) {
    Navigator.pushReplacementNamed(context, path!);
  }
}
