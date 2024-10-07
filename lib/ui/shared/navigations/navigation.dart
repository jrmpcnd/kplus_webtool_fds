import 'package:flutter/material.dart';

import '../../../main.dart';

// void navigateToRoleListPage(BuildContext context) {
//   Navigator.push(context, MaterialPageRoute(builder: (context) => const RoleManagement()));
// }

void navigateToTopUpPage() {
  Navigator.pushReplacementNamed(
    navigatorKey.currentContext!,
    '/Access/Single_Upload/Insert_Client',
  );
}

void navigateToDashboardPage() {
  Navigator.pushReplacementNamed(
    navigatorKey.currentContext!,
    '/Home',
  );
}

void navigateToLoginPage() {
  Navigator.pushReplacementNamed(
    navigatorKey.currentContext!,
    '/Login',
  );
}

void navigateToResetPasswordPage(BuildContext context) {
  Navigator.pushReplacementNamed(
    context,
    '/MFIResetPass',
  );
}

void navigateToSendResetLinkPage(BuildContext context) {
  Navigator.pushReplacementNamed(
    context,
    '/ResetByEmail',
  );
}
