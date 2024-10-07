// import 'dart:async';
// import 'dart:html' as html;
//
// import 'package:flutter/material.dart';
// import 'package:mfi_whitelist_admin_portal/core/api/login_logout/logout.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';
//
// import '../../main.dart';
// import '../../ui/shared/sessionmanagement/sessionmanagement/session_dialog.dart';
//
// enum TimerStatus { active, inactive }
//
// // SETS THE ENTIRE TIMER FOR THE INACTIVITY TIMEOUT
// // class TimerProvider extends ChangeNotifier {
// //   BuildContext? _buildContext;
// //   Timer? _timer;
// //   Timer? _dialogTimer;
// //   Timer? _heartbeatTimer;
// //   final token = getToken();
// //   int _idleDuration = 0;
// //   String _status = '';
// //   bool showDialogOnce = false;
// //   bool ValiDated = false;
// //   String idleAutoLogout = 'AutoLogout';
// //   int? remainingIdleTime;
// //
// //   bool get isTimerActive => _timer?.isActive ?? false;
// //   int get idleDuration => _idleDuration;
// //   String get status => _status;
// //   BuildContext get buildContext => _buildContext!;
// //   int? get idleValue => remainingIdleTime;
// //
// //   set idleDuration(int value) {
// //     _idleDuration = value;
// //     notifyListeners();
// //   }
// //
// //   set buildContext(BuildContext value) {
// //     _buildContext = value;
// //     Future.delayed(Duration.zero, () => notifyListeners());
// //   }
// //
// //   //GET TIMER FROM API
// //   Future<void> updateIdleTimer() async {
// //     bool dataRetrieved = false;
// //
// //     while (!dataRetrieved) {
// //       try {
// //         // Retrieve data from settings or wherever it's stored
// //         // final idleData = await SettingsAPI.getIdleTime();
// //         // final duration = idleData.duration;
// //         // final format = idleData.format;
// //         // final status = idleData.status;
// //         // final convertedToSeconds = convertTimeToSeconds(duration, format);
// //         //
// //         // // Update idle duration in the timer provider and directly call startTimer
// //         // updateIdleDuration(convertedToSeconds);
// //         // updateIdleStatus(status!);
// //
// //         dataRetrieved = true;
// //       } catch (error) {
// //         debugPrint('Error updating idle timer: $error');
// //         // Optionally, you can add a delay before retrying
// //         await Future.delayed(Duration(seconds: 1));
// //       }
// //     }
// //   }
// //
// //   //STORE THE VALUE FROM API
// //   void updateIdleDuration(int newDuration) {
// //     _cancelCurrentTimer();
// //     _idleDuration = newDuration;
// //
// //     // debugPrint('updateIdleDuration HAS: $_idleDuration');
// //     html.window.localStorage['idleStartTime'] = _idleDuration.toString();
// //
// //     debugPrint('Idle initial value: ${html.window.localStorage['idleStartTime']}');
// //     notifyListeners();
// //     _timer?.cancel();
// //     startTimer();
// //   }
// //
// //   Future<void> dialogIdle() async {
// //     try {
// //       if (navigatorKey.currentContext != null && token != null) {
// //         WidgetsBinding.instance.addPostFrameCallback((_) {
// //           showDialog(
// //             barrierDismissible: false,
// //             context: navigatorKey.currentContext!,
// //             builder: (BuildContext context) {
// //               ValiDated = false; // condition for idle dialog time to cancel
// //               startDialogTimer(); // start idle dialog time
// //               BrowserRefreshHandler.setAlertDialogVisibility(context, true);
// //               return PopScope(
// //                 canPop: false,
// //                 child: IdleDialog(
// //                   token: token!,
// //                   onInteraction: () {
// //                     _dialogTimer?.cancel(); // Cancel the dialog timer
// //                   },
// //                 ),
// //               );
// //             },
// //           );
// //         });
// //       } else {
// //         debugPrint('Context or token is null');
// //       }
// //     } catch (e) {
// //       debugPrint('Error showing dialog: $e');
// //     }
// //   }
// //
// //   //START IDLE TIMER
// //   void startTimer() async {
// //     _cancelCurrentTimer();
// //     stopDialogTimer();
// //     TimerStatus status;
// //     if (_status.toLowerCase() == 'active' && _idleDuration > 0) {
// //       status = TimerStatus.active;
// //     } else {
// //       status = TimerStatus.inactive;
// //     }
// //     switch (status) {
// //       case TimerStatus.active:
// //         int remainingSeconds = _idleDuration;
// //         _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
// //           remainingSeconds--;
// //           debugPrint('Remaining time for idle: $remainingSeconds seconds');
// //           if (remainingSeconds <= 0) {
// //             timer.cancel();
// //             html.window.localStorage['idlePopup'] = idleAutoLogout;
// //             dialogIdle();
// //           }
// //         });
// //         break;
// //
// //       case TimerStatus.inactive:
// //         if (_timer?.isActive == true) {
// //           _timer?.cancel();
// //           debugPrint('timer true');
// //         }
// //
// //         if (html.window.localStorage['idlePopup'] == 'AutoLogout') {
// //           if (showDialogOnce != true) {
// //             await dialogIdle().then((_) {
// //               showDialogOnce = true;
// //               // saveSessionData();
// //             });
// //           }
// //         } else {
// //           updateIdleTimer();
// //         }
// //         break;
// //     }
// //   }
// //
// //   // void saveSessionData() {
// //   //   Provider.of<SessionProvider>(navigatorKey.currentContext!, listen: false).startSessionTimer();
// //   //   Provider.of<TimerProvider>(navigatorKey.currentContext!, listen: false).startHeartbeat();
// //   //   html.window.onBeforeUnload.listen((event) async {
// //   //     int? newSessionValue = Provider.of<SessionProvider>(navigatorKey.currentContext!, listen: false).sessionValue;
// //   //     html.window.localStorage['sessionStartTime'] = '$newSessionValue';
// //   //   });
// //   // }
// //
// //   //CANCEL CURRENT IDLE TIMER
// //   void _cancelCurrentTimer() {
// //     if (_timer != null && _timer!.isActive) {
// //       _timer!.cancel();
// //     }
// //   }
// //
// //   //STOP CURRENT IDLE TIMER
// //   Future<void> stopTimer() async {
// //     final timer = Provider.of<TimerProvider>(navigatorKey.currentContext!, listen: false);
// //     timer._cancelCurrentTimer();
// //     timer.buildContext = navigatorKey.currentContext!;
// //   }
// //
// //   //CANCEL CURRENT DIALOG TIMER
// //   void _cancelCurrentDialogTimer() {
// //     if (_dialogTimer != null && _dialogTimer!.isActive) {
// //       _dialogTimer!.cancel();
// //       _dialogTimer = null;
// //     }
// //   }
// //
// //   //CANCEL CURRENT DIALOG TIMER
// //   void CancelCurrentDialogTimer(bool validatedData) {
// //     ValiDated = validatedData;
// //   }
// //
// //   //STOP CURRENT DIALOG TIMER
// //   Future<void> stopDialogTimer() async {
// //     final timer = Provider.of<TimerProvider>(navigatorKey.currentContext!, listen: false);
// //     timer._cancelCurrentDialogTimer();
// //     timer.buildContext = navigatorKey.currentContext!;
// //   }
// //
// //   //START DIALOG TIMER
// //
// //   // Sending Hearbeat
// //   void startHeartbeat() {
// //     _heartbeatTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
// //       // sendHeartbeat();
// //     });
// //   }
// //
// // //START TIMER FOR DIALOG DISPLAY
// //   void startDialogTimer() {
// //     int dialogTimeoutDuration = int.parse(html.window.localStorage['idleStartTime']!); // Set your desired timeout duration in seconds
// //     int remainingDialogSeconds = dialogTimeoutDuration;
// //     _dialogTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
// //       remainingDialogSeconds--;
// //       // debugPrint('Dialog time remaining: $remainingDialogSeconds seconds');
// //       if (remainingDialogSeconds <= 0) {
// //         timer.cancel();
// //         logout(getToken());
// //       }
// //
// //       if (ValiDated == true) {
// //         timer.cancel();
// //       }
// //     });
// //   }
// //
// //   void updateIdleStatus(String newStatus) {
// //     _status = newStatus;
// //     if (_status == 'Active' && _idleDuration > 0) {
// //       startTimer();
// //     } else {
// //       _cancelCurrentTimer();
// //     }
// //     notifyListeners();
// //   }
// // }
// //
// // // class SessionProvider extends ChangeNotifier {
// // //   TimerProvider timerProvider = TimerProvider();
// // //
// // //   BuildContext? _buildContext;
// // //   Timer? _timer;
// // //   int _sessionDuration = 0;
// // //   int? remainingSessionTime;
// // //
// // //   bool get isTimerActive => _timer?.isActive ?? false;
// // //   int get sessionDuration => _sessionDuration;
// // //   BuildContext get buildContext => _buildContext!;
// // //   int? get sessionValue => remainingSessionTime;
// // //
// // //   set sessionDuration(int value) {
// // //     _sessionDuration = value;
// // //     notifyListeners();
// // //   }
// // //
// // //   set buildContext(BuildContext value) {
// // //     _buildContext = value;
// // //     Future.delayed(Duration.zero, () => notifyListeners());
// // //   }
// // //
// // //   //GET SESSION FROM API
// // //   Future<void> updateSessionTimer() async {
// // //     bool dataRetrieved = false;
// // //     while (!dataRetrieved) {
// // //       try {
// // //         final sessionTokenData = await SettingsAPI.getSessionTime();
// // //         final duration = sessionTokenData.duration;
// // //         final format = sessionTokenData.format;
// // //         final convertedToSeconds = convertTimeToSeconds(duration, format);
// // //         debugPrint('SESSION INITIAL VALUE:$convertedToSeconds');
// // //
// // //         updateSessionDuration(convertedToSeconds);
// // //         dataRetrieved = true;
// // //       } catch (error) {
// // //         rethrow;
// // //       }
// // //     }
// // //   }
// // //
// // //   //STORE SESSION VALUE FROM API
// // //   void updateSessionDuration(int newDuration) {
// // //     _cancelSessionTimer();
// // //
// // //     // SAVE SESSION TIME TO LOCALSTORAGE AS STRING AND THE VALUE IS NUMBER/INTEGER
// // //     final sessionStartTime = newDuration;
// // //     html.window.localStorage['sessionStartTime'] = sessionStartTime.toString();
// // //     debugPrint('Session time has: ${html.window.localStorage['sessionStartTime']}');
// // //
// // //     // SESSION TIME INITIATION
// // //     startSessionTimer();
// // //     notifyListeners();
// // //   }
// // //
// // //   // void startSessionTimer() async {
// // //   //   _cancelSessionTimer();
// // //   //
// // //   //   // Wait for the session start time to be set
// // //   //   final sessionStartTimeStr = html.window.localStorage['sessionStartTime'];
// // //   //   // debugPrint('Session start time received: $sessionStartTimeStr');
// // //   //
// // //   //   if (sessionStartTimeStr != null) {
// // //   //     int remainingSeconds = int.parse(sessionStartTimeStr);
// // //   //     if (remainingSeconds > 0) {
// // //   //       _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
// // //   //         if (remainingSeconds > 0) {
// // //   //           remainingSeconds--;
// // //   //           debugPrint('Remaining time for session: $remainingSeconds seconds');
// // //   //           remainingSessionTime = remainingSeconds; // Assign remaining seconds as remaining session time
// // //   //           if (remainingSeconds == 5) {
// // //   //             dialogSession();
// // //   //             timerProvider.stopTimer();
// // //   //           }
// // //   //         } else {
// // //   //           timer.cancel();
// // //   //           logout();
// // //   //         }
// // //   //       });
// // //   //     }
// // //   //     // else {
// // //   //     //   dialogSession();
// // //   //     // }
// // //   //   } else {
// // //   //     debugPrint('Session start time is not available. Waiting for it to be set.');
// // //   //     // Handle the case when the session start time is not available yet
// // //   //   }
// // //   // }
// // //
// // //   void startSessionTimer() async {
// // //     _cancelSessionTimer();
// // //     final sessionStartTimeStr = html.window.localStorage['sessionStartTime'];
// // //     // debugPrint('Session start time received: $sessionStartTimeStr');
// // //     int remainingSeconds = int.parse(sessionStartTimeStr!);
// // //     if (remainingSeconds > 0) {
// // //       _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
// // //         if (remainingSeconds > 0) {
// // //           remainingSeconds--;
// // //           // debugPrint('Remaining time for session: $remainingSeconds seconds');
// // //           remainingSessionTime = remainingSeconds; //new added assign remaining seconds as remaining session time
// // //           if (remainingSeconds == 10) {
// // //             dialogSession();
// // //             timerProvider.stopTimer();
// // //           }
// // //         } else {
// // //           timer.cancel();
// // //           logout();
// // //         }
// // //       });
// // //     }
// // //     // else {
// // //     //   dialogSession();
// // //     // }
// // //   }
// // //
// // //   //SHOW SESSION DIALOG WHEN TIMER HITS 10 SEC
// // //   Future<void> dialogSession() async {
// // //     try {
// // //       if (navigatorKey.currentContext != null) {
// // //         WidgetsBinding.instance.addPostFrameCallback((_) {
// // //           showDialog(
// // //             barrierDismissible: false,
// // //             context: navigatorKey.currentContext!,
// // //             builder: (BuildContext context) {
// // //               BrowserRefreshHandler.setAlertDialogVisibility(context, true);
// // //               return const PopScope(
// // //                 canPop: false,
// // //                 child: SessionAlertDialog(),
// // //               );
// // //             },
// // //           );
// // //         });
// // //       } else {
// // //         debugPrint('Context or token is null');
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error showing dialog: $e');
// // //     }
// // //   }
// // //
// // //   void _cancelSessionTimer() {
// // //     if (_timer != null && _timer!.isActive) {
// // //       _timer!.cancel();
// // //     }
// // //   }
// // //
// // //   Future<void> stopTimer() async {
// // //     final timer = Provider.of<SessionProvider>(navigatorKey.currentContext!, listen: false);
// // //     timer._cancelSessionTimer();
// // //     timer.buildContext = navigatorKey.currentContext!;
// // //   }
// // // }
// //
// // class TimeParametersProvider with ChangeNotifier {
// //   IdleData? idleTime;
// //   String? status;
// //
// //   String get duration => idleTime?.duration.toString() ?? '';
// //
// //   String get format => idleTime?.format ?? '';
// //
// //   Future<IdleData> fetchIdleTime() async {
// //     try {
// //       final idleData = await SettingsAPI.getIdleTime();
// //       idleTime = idleData;
// //       notifyListeners();
// //       return idleData;
// //     } catch (error) {
// //       // debugPrint('Error fetching idle data: $error');
// //       rethrow;
// //     }
// //   }
// //
// //   //GET IDLE STATUS
// //   void handleIdleStatusChange(String newStatus, BuildContext context) {
// //     final timerProvider = Provider.of<TimerProvider>(context, listen: false);
// //     timerProvider.updateIdleStatus(newStatus);
// //   }
// //
// //   Future<String?> fetchIdleStatus() async {
// //     try {
// //       final responseData = await SettingsAPI.getIdleTime();
// //       status = responseData.status;
// //       // debugPrint('Idle status: $status');
// //       notifyListeners();
// //       return status;
// //     } catch (e) {
// //       return null;
// //     }
// //   }
// //
// //   SessionData? sessionTime;
// //
// //   String get sessionDuration => sessionTime?.duration.toString() ?? '';
// //
// //   String get sessionFormat => sessionTime?.format ?? '';
// //
// //   Future<SessionData> fetchSessionTime() async {
// //     try {
// //       final sessionData = await SettingsAPI.getSessionTime();
// //       sessionTime = sessionData;
// //       notifyListeners();
// //       return sessionData;
// //     } catch (error) {
// //       // debugPrint('Error fetching session data: $error');
// //       rethrow;
// //     }
// //   }
// //
// //   PasswordData? passwordTime;
// //
// //   String get passwordDuration => passwordTime?.duration.toString() ?? '';
// //
// //   String get passwordFormat => passwordTime?.format ?? '';
// //
// //   Future<PasswordData> fetchPasswordTime() async {
// //     try {
// //       final passwordData = await SettingsAPI.getPasswordTime();
// //       passwordTime = passwordData;
// //       notifyListeners();
// //       return passwordData;
// //     } catch (error) {
// //       // debugPrint('Error fetching password data: $error');
// //       rethrow;
// //     }
// //   }
// //
// //   //ACCOUNT PROVIDER
// //   AccountDeactivationData? accountDeactivationTime;
// //
// //   String get accountDeactivationDuration => accountDeactivationTime?.duration.toString() ?? '';
// //
// //   String get accountDeactivationFormat => accountDeactivationTime?.format ?? '';
// //
// //   Future<AccountDeactivationData> fetchAccountDeactivationTime() async {
// //     try {
// //       final accountDeactivationData = await SettingsAPI.getAccountDeactivationTime();
// //       accountDeactivationTime = accountDeactivationData;
// //       notifyListeners();
// //       return accountDeactivationData;
// //     } catch (error) {
// //       // debugPrint('Error fetching account deactivation data: $error');
// //       rethrow;
// //     }
// //   }
// // }
// //
// //
// //
//
// class TimerProvider extends ChangeNotifier {
//   Timer _timer = Timer(Duration.zero, () {});
//   late BuildContext _buildContext;
//   bool get isTimerActive => _timer.isActive;
//   bool showDialogOnce = false;
//   String idleAutoLogout = 'AutoLogout';
//   int _idleDuration = 5; //Change the time duration here
//   final token = getToken();
//
//   BuildContext get buildContext => _buildContext;
//
//   set buildContext(BuildContext value) {
//     _buildContext = value;
//     notifyListeners();
//   }
//
//   Timer get timer => _timer;
//
//   set timer(Timer value) {
//     _timer = value;
//     notifyListeners();
//   }
//
//   Future<void> stop() async {
//     _timer.cancel();
//     _timer = Timer(Duration.zero, () {});
//     // _navigateToLoginScreen;
//     print('flutter-----(time stop!)');
//   }
//   // void _navigateToLoginScreen(BuildContext context) {
//   //   Navigator.pushReplacementNamed(context, '/Main_Screen'); // Replace current screen with login screen
//   // }
//
//   Future<void> dialogIdle() async {
//     if (navigatorKey.currentContext != null && token != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         showDialog(
//           barrierDismissible: false,
//           context: navigatorKey.currentContext!,
//           builder: (BuildContext context) {
//             return const PopScope(
//               canPop: false,
//               child: SessionAlertDialog(),
//             );
//           },
//         );
//       });
//     }
//   }
//
//   void startTimer() async {
//     debugPrint('flutter-----(time start!)');
//     if (_timer != Timer(Duration.zero, () {})) {
//       _timer.cancel();
//     }
//     _timer = Timer(Duration(minutes: _idleDuration), () {
//       stop();
//       // Timer callback function
//       debugPrint('Time has elapsed');
//       dialogIdle().then((_) {
//         // Introduce a delay of 30 seconds after showing the dialog
//         Future.delayed(const Duration(seconds: 10), () {
//           logout(token, true);
//         });
//       });
//       html.window.localStorage['idlePopup'] = idleAutoLogout;
//     });
//
//     //Call this when the page was refreshed, to show again the dialog
//     if (html.window.localStorage['idlePopup'] == 'AutoLogout') {
//       if (showDialogOnce != true) {
//         logout(token, true);
//         // await dialogIdle().then((_) {
//         //   showDialogOnce = true;
//         // });
//       }
//     }
//   }
//
//   // void startTimer() {
//   //   if (_timer != Timer(Duration.zero, () {})) {
//   //     _timer.cancel();
//   //   }
//   //   _timer = Timer(const Duration(minutes: 1), () async {
//   //     // final token = getToken();
//   //     // logout(token);
//   //
//   //     // Set a flag in localStorage to detect reload
//   //     html.window.localStorage['reloading'] = 'true';
//   //     html.window.localStorage.remove('Path');
//   //     // Fluttertoast.showToast(
//   //     //   msg: 'Session Expired!',
//   //     //   toastLength: Toast.LENGTH_SHORT,
//   //     //   gravity: ToastGravity.CENTER,
//   //     //   timeInSecForIosWeb: 3,
//   //     //   textColor: const Color(0xff630606),
//   //     //   fontSize: 15.0,
//   //     //   webBgColor: "#ffffff",
//   //     //   webPosition: 'center',
//   //     // );
//   //     // await Future.delayed(const Duration(seconds: 3));
//   //
//   //     stop();
//   //
//   //     showDialog(
//   //       context: navigatorKey.currentContext!,
//   //       barrierDismissible: false,
//   //       builder: (BuildContext context) {
//   //         return const SessionAlertDialog();
//   //       },
//   //     );
//   //     // Navigator.of(_buildContext).pushReplacementNamed('/Login'); // Change this to your login screen route
//   //   });
//   // }
// }

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/toast.dart';

import '../../ui/shared/sessionmanagement/gettoken/gettoken.dart';
import '../api/login_logout/logout.dart';

class TimerProvider extends ChangeNotifier {
  Timer _timer = Timer(Duration.zero, () {});
  late BuildContext _buildContext;

  BuildContext get buildContext => _buildContext;

  set buildContext(BuildContext value) {
    _buildContext = value;
    notifyListeners();
  }

  Timer get timer => _timer;

  set timer(Timer value) {
    _timer = value;
    notifyListeners();
  }

  Future<void> stop() async {
    _timer.cancel();
    _timer = Timer(Duration.zero, () {});
    // _navigateToLoginScreen;
    print('flutter-----(time stop!)');
  }
  // void _navigateToLoginScreen(BuildContext context) {
  //   Navigator.pushReplacementNamed(context, '/Main_Screen'); // Replace current screen with login screen
  // }

  void startTimer(BuildContext context) {
    if (_timer != Timer(Duration.zero, () {})) {
      _timer.cancel();
    }
    _timer = Timer(const Duration(minutes: 30), () async {
      final token = getToken();
      logout(token, false);
      CustomTopToast.show(context, 'Idle Timeout', 60);
//       Fluttertoast.showToast(
//         msg: 'Session Expired!',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 3,
//         textColor: const Color(0xff630606),
//         fontSize: 15.0,
//         webBgColor: "#ffffff",
//         webPosition: 'center',
//       );
      await Future.delayed(const Duration(seconds: 3));

      stop();
      Navigator.of(_buildContext).pushReplacementNamed('/Login'); // Change this to your login screen route
    });
  }

// void startTimer() {
//   if (_timer != Timer(Duration.zero, () {})) {
//     _timer.cancel();
//   }
//   _timer = Timer(const Duration(minutes: 1), () async {
//     // final token = getToken();
//     // logout(token);
//
//     // Set a flag in localStorage to detect reload
//     html.window.localStorage['reloading'] = 'true';
//     html.window.localStorage.remove('Path');
//     // Fluttertoast.showToast(
//     //   msg: 'Session Expired!',
//     //   toastLength: Toast.LENGTH_SHORT,
//     //   gravity: ToastGravity.CENTER,
//     //   timeInSecForIosWeb: 3,
//     //   textColor: const Color(0xff630606),
//     //   fontSize: 15.0,
//     //   webBgColor: "#ffffff",
//     //   webPosition: 'center',
//     // );
//     // await Future.delayed(const Duration(seconds: 3));
//
//     stop();
//
//     showDialog(
//       context: navigatorKey.currentContext!,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return const SessionAlertDialog();
//       },
//     );
//     // Navigator.of(_buildContext).pushReplacementNamed('/Login'); // Change this to your login screen route
//   });
// }
}
