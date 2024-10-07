import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/settings/password_management/password_setting.dart';
import 'package:provider/provider.dart';

import '../../../../../core/provider/timer_service_provider.dart';
import '../../../../../main.dart';
import '../../../../shared/clock/clock.dart';
import '../../../../shared/utils/utils_browser_refresh_handler.dart';
import '../../../../shared/utils/utils_responsive.dart';
import '../../../../shared/values/colors.dart';
import '../screen_bases/full_screen.dart';
import 'account_deactivation/account_deactivation_setting.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String selectedTile = 'Idle';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // saveSessionData();
    _startTimer();

    // Adding web lifecycle listeners
    html.document.addEventListener('visibilitychange', _handleVisibilityChange);
  }

  // void saveSessionData() {
  //   Provider.of<SessionProvider>(navigatorKey.currentContext!, listen: false).startSessionTimer();
  //   Provider.of<TimerProvider>(navigatorKey.currentContext!, listen: false).startHeartbeat();
  //   html.window.onBeforeUnload.listen((event) async {
  //     int? newSessionValue = Provider.of<SessionProvider>(context, listen: false).sessionValue;
  //     html.window.localStorage['sessionStartTime'] = '$newSessionValue';
  //   });
  // }

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
  //
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       debugPrint('AppLifecycleState is resumed');
  //       _startTimer();
  //       break;
  //     case AppLifecycleState.inactive:
  //       break;
  //     case AppLifecycleState.detached:
  //       break;
  //     case AppLifecycleState.paused:
  //       debugPrint('AppLifecycleState is paused');
  //       _resumeTimer();
  //       break;
  //     case AppLifecycleState.hidden:
  //       debugPrint('AppLifecycleState is hidden');
  //       _pauseTimer();
  //       break;
  //   }
  // }

  final List<Map<String, dynamic>> tileData = [
    {"title": "Idle Management", "icon": Icons.timer_outlined, "key": "Idle"},
    {"title": "Password Management", "icon": Icons.password_outlined, "key": "Password"},
    {"title": "Account Deactivation", "icon": Icons.account_box_outlined, "key": "Account"},
  ];

  @override
  Widget build(BuildContext context) {
    Size screenHeight = MediaQuery.of(context).size;

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerMove: _pauseTimer,
      onPointerHover: _pauseTimer,
      child: FullScreen(
        content: Container(
          padding: const EdgeInsets.only(left: 20),
          // color: Colors.amber.shade200,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  height: screenHeight.height * 0.75,
                  decoration: const BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: ListView(
                    children: tileData.map((data) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Material(
                          elevation: selectedTile == data["key"] ? 4.0 : 3.0,
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(5),
                            hoverColor: Colors.grey.withOpacity(0.1),
                            onTap: () {
                              setState(() {
                                selectedTile = data["key"];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                border: Border.all(
                                  color: selectedTile == data["key"] ? AppColors.ngoColor : Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                              child: Responsive(
                                desktop: ListTile(
                                  leading: Icon(data["icon"]),
                                  title: Text(data["title"]),
                                ),
                                mobile: ListTile(
                                  title: Center(child: Icon(data["icon"], size: 20)),
                                ),
                                tablet: ListTile(
                                  leading: Icon(data["icon"], size: 20),
                                  title: Text(data["title"]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: SizedBox(
                  height: screenHeight.height * 0.75,
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    shadowColor: Colors.grey,
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child:
                            // selectedTile == 'Idle'
                            //     ? const IdleSessionBody()
                            //     :
                            selectedTile == 'Password'
                                ? const PasswordManagement()
                                : selectedTile == 'Account'
                                    ? const AccountDeactivationManagement()
                                    : null),
                  ),
                ),
              ),
            ],
          ),
        ),
        screenText: 'SETTINGS',
        children: const [
          Spacer(),
          Clock(),
        ],
      ),
    );
  }
}
