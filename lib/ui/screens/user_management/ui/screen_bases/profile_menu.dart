import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
import 'package:provider/provider.dart';

import '../../../../../core/provider/timer_service_provider.dart';
import '../../../../../main.dart';
import '../../../../shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import '../../../../shared/utils/utils_browser_refresh_handler.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/widget/alert_dialog/logoutdialogs/alertdialoglogout.dart';
import '../reset_password/logged_user_change_password.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({super.key});

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  final _userRole = getUrole(); // Assuming getUrole() retrieves the user role

  // Getter for userRole (optional, see explanation below)
  String? get userRole => _userRole;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Adding web lifecycle listeners
    html.document.addEventListener('visibilitychange', _handleVisibilityChange);
  }

  @override
  void dispose() {
    _timer?.cancel();

    // Removing web lifecycle listeners
    html.document.removeEventListener('visibilitychange', _handleVisibilityChange);
    super.dispose();
  }

  void _startTimer() {
    final timer = Provider.of<TimerProvider>(context, listen: false);
    timer.startTimer(context);
    timer.buildContext = context;
  }

  void _pauseTimer([_]) {
    _timer?.cancel();
    _startTimer();
    // debugPrint('flutter-----(time pause!)');
  }

  void _handleVisibilityChange(html.Event event) {
    if (html.document.visibilityState == 'visible') {
      if (BrowserRefreshHandler.isAlertDialogShown) {
        final timer = Provider.of<TimerProvider>(navigatorKey.currentContext!, listen: false);
        timer.stop(); // Stop the timer if the alert dialog is shown
      }
    } else if (html.document.visibilityState == 'hidden') {
      if (BrowserRefreshHandler.isAlertDialogShown) {
        final timer = Provider.of<TimerProvider>(navigatorKey.currentContext!, listen: false);
        timer.stop(); // Stop the timer if the alert dialog is shown
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: const Icon(
          Icons.arrow_drop_down_outlined,
          color: AppColors.ngoColor,
        ),
        onSelected: (String value) {
          //============Updated by Lea : June 18, 1:10=================//
          // if (value == 'user_profile') {
          //   // Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfile()));
          //   // Navigator.pushNamed(context, '/User_Profile');
          // } else if (value == 'settings') {
          //   // Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
          //   Navigator.pushNamed(context, '/Settings');
          // } else
          if (value == 'change_password') {
            showGeneralDialog(
              context: navigatorKey.currentContext!,
              barrierColor: Colors.black54,
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) => LoggedUserChangePassword(pauseTimer: () {
                setState(() {
                  _pauseTimer();
                });
              }),
              barrierDismissible: false,
              transitionBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -2),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
            // showDialog(
            //     context: context,
            //     builder: (BuildContext context) => LoggedUserChangePassword(pauseTimer: () {
            //           setState(() {
            //             _pauseTimer();
            //           });
            //         }),
            //     barrierDismissible: false);
          } else if (value == 'logout') {
            showLogoutAlertDialog(context);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          //============Updated by Lea : June 18, 1:10=================//
          // const PopupMenuItem<String>(
          //   padding: EdgeInsets.only(left: 20, right: 20),
          //   value: 'user_profile',
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Icon(
          //         Icons.account_circle_rounded,
          //         color: Colors.black54,
          //         size: 20,
          //       ),
          //       SizedBox(
          //         width: 10,
          //       ),
          //       Text(
          //         'User Profile',
          //         style: TextStyle(
          //           fontFamily: 'RobotoThin',
          //           color: Colors.black54,
          //           // fontFamily: 'Crimson Text',
          //           fontSize: 11,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const PopupMenuItem<String>(
            padding: EdgeInsets.only(left: 20, right: 20),
            value: 'change_password',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.lock_reset_outlined,
                  color: Colors.black54,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Change Password',
                  style: TextStyles.dataTextStyle,
                ),
              ],
            ),
          ),

          //============Updated by Lea : June 18, 1:10=================//
          // if (_userRole == 'Admin' || _userRole == 'FDSAP Admin') // Show Settings only for Admin or FDSAP Admin
          //   const PopupMenuItem<String>(
          //     padding: EdgeInsets.only(left: 20, right: 20),
          //     value: 'settings',
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Icon(
          //           Icons.settings,
          //           color: Colors.black54,
          //           size: 20,
          //         ),
          //         SizedBox(
          //           width: 10,
          //         ),
          //         Text(
          //           'Settings',
          //           style: TextStyle(
          //             fontFamily: 'RobotoThin',
          //             color: Colors.black54,
          //             fontSize: 11,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          const PopupMenuItem<String>(
            padding: EdgeInsets.only(left: 20, right: 20),
            value: 'logout',
            child: Row(
              children: [
                Icon(
                  Icons.logout_outlined,
                  color: Colors.black54,
                  size: 19,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Logout',
                  style: TextStyles.dataTextStyle,
                )
              ],
            ),
          ),
        ],
        offset: const Offset(0, 40), // Adjust the offset as needed
        elevation: 8,
      ),
    );
  }
}
