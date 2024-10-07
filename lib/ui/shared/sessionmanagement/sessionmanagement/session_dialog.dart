import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';

import '../../../../core/api/login_logout/logout.dart';
import '../../values/colors.dart';
import '../../widget/buttons/button.dart';

class SessionAlertDialog extends StatefulWidget {
  const SessionAlertDialog({super.key});

  @override
  State<SessionAlertDialog> createState() => _SessionAlertDialogState();
}

class _SessionAlertDialogState extends State<SessionAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.grey,
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          content: const SizedBox(
            width: 400,
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('images/session_timeout.png'),
                  width: 150,
                ),
                Text(
                  "Idle Timeout.",
                  style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Crimson Text', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "You have been away for a while. For your security, kindly login your account.",
                  style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Crimson Text'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: SizedBox(width: 120, height: 40, child: CustomColoredButton.primaryButtonWithText(context, 5, () => logout(getToken(), true), AppColors.maroon2, 'LOGIN')),

              // child: SizedBox(width: 100, height: 40, child: CustomColoredButton.secondaryButtonWithText(context, 5, () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FdsLogin())), AppColors.maroon3, 'LOGIN PAGE')),
            ),
          ],
        ),
      ),
    );
  }
}
