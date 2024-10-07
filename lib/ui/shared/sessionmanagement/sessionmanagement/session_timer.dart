// session_timer.dart

// import 'dart:async';
//
// import 'package:cagabay_whitelist_2/ui/shared/sessionmanagement/sessionmanagement/sessionmanagement.dart';
// import 'package:flutter/material.dart';
//
// class SessionTimer {
//   int sessionDuration;
//   Timer? _sessionTimer;
//   Timer? _countdownTimer;
//
//   SessionTimer({required this.sessionDuration});
//
//   void startSessionTimer(BuildContext context, int newSessionDuration) {
//     // Cancel the current timers if they exist
//     stopSessionTimer();
//
//     // Update the session duration
//     sessionDuration = newSessionDuration;
//     debugPrint('New session timer set to start: $sessionDuration seconds');
//
//     // Start the countdown timer to debug print remaining time
//     _countdownTimer = Timer.periodic(
//       const Duration(seconds: 1),
//       (timer) {
//         if (sessionDuration > 0) {
//           sessionDuration--;
//           debugPrint('Session time remaining: $sessionDuration seconds');
//         } else {
//           _countdownTimer?.cancel();
//         }
//       },
//     );
//
//     // Start the session timer with the updated session duration
//     _sessionTimer = Timer(
//       Duration(seconds: newSessionDuration),
//       () async {
//         debugPrint('Checking for session timeout...');
//         handleSessionTimeout(context);
//       },
//     );
//   }
//
//   void stopSessionTimer() {
//     _sessionTimer?.cancel();
//     _sessionTimer = null;
//     _countdownTimer?.cancel();
//     _countdownTimer = null;
//   }
//
//   void handleSessionTimeout(BuildContext context) async {
//     debugPrint('Session timed out.');
//     // Check for timeout and perform actions (e.g., logout, navigate)
//     if (isSessionTimeoutReached()) {
//       navigateToLogin(context);
//       logout();
//     }
//   }
// }

// class SessionTimer {
//   int sessionDuration;
//   Timer? _sessionTimer;
//
//   SessionTimer({required this.sessionDuration});
//   void startSessionTimer(BuildContext context, int newSessionDuration) {
//     // Cancel the current timer if it exists
//     _sessionTimer?.cancel();
//
//     // Update the session duration
//     sessionDuration = newSessionDuration;
//     debugPrint('New session timer set to start: $sessionDuration');
//
//     // Start a new timer with the updated session duration
//     _sessionTimer = Timer.periodic(
//       Duration(seconds: sessionDuration),
//       (timer) async {
//         debugPrint('Checking for session timeout...');
//         handleSessionTimeout(context);
//       },
//     );
//   }
//
//   // void startSessionTimer(BuildContext context, int newSessionDuration) {
//   //   sessionDuration = newSessionDuration;
//   //   _sessionTimer = Timer.periodic(
//   //     Duration(minutes: sessionDuration),
//   //     (timer) async {
//   //       debugPrint('Checking for session timeout...');
//   //       handleSessionTimeout(context);
//   //     },
//   //   );
//   // }
//
//   void stopSessionTimer() {
//     _sessionTimer?.cancel();
//     _sessionTimer = null;
//   }
//
//   void handleSessionTimeout(BuildContext context) async {
//     debugPrint('Session had timed out.');
//     // Check for timeout and perform actions (e.g., logout, navigate)
//     if (isSessionTimeoutReached()) {
//       navigateToLogin(context);
//       logout();
//     }
//   }
// }
