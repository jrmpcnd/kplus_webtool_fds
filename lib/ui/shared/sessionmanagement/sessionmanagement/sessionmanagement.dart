// import 'package:cagabay_whitelist_2/core/provider/timer_service_provider.dart';
//
// TimerProvider timerProvider = TimerProvider();
// SessionProvider sessionProvider = SessionProvider();
// Future<void> logout() async {
//   debugPrint('CALLS LOGOUT API');
//   LogoutAPI logoutAPI = LogoutAPI();
//   try {
//     final response = await logoutAPI.logoutFunction();
//     if (response.statusCode == 200) {
//       debugPrint('Logout returns 200');
//       selectedRoute = '';
//       debugPrint('Logout clear storage');
//       clearLocalStorage();
//       debugPrint('Logout stopping timer');
//       sessionProvider.stopTimer();
//       timerProvider.stopTimer();
//       debugPrint('Logout successful');
//       reload();
//       navigateToLoginPage();
//     } else {
//       debugPrint('Logout failed: ${response.statusCode}');
//     }
//   } catch (error) {
//     debugPrint('Error calling logout API: $error');
//   }
// }

// Future<void> logout() async {
//   debugPrint('CALLS LOGOUT API');
//   LogoutAPI logoutAPI = LogoutAPI();
//   bool logoutSuccess = false;
//
//   while (!logoutSuccess) {
//     try {
//       final response = await logoutAPI.logoutFunction();
//       if (response.statusCode == 200) {
//         debugPrint('Logout stopping timer');
//         sessionProvider.stopTimer();
//         timerProvider.stopTimer();
//         debugPrint('Logout returns 200');
//         selectedRoute = '';
//         debugPrint('Logout clear storage');
//         clearLocalStorage();
//         debugPrint('Logout successful');
//         reload();
//         navigateToLoginPage();
//         logoutSuccess = true;
//       }
//       // else {
//       //   debugPrint('Logout failed: ${response.statusCode}');
//       //   // Optionally, you can add a delay before retrying
//       //   await Future.delayed(Duration(seconds: 1));
//       // }
//     } catch (error) {
//       debugPrint('Error calling logout API: $error');
//       // Optionally, you can add a delay before retrying
//       await Future.delayed(Duration(seconds: 1));
//     }
//   }
// }

// reload() async {
//   await Future.delayed(Duration(milliseconds: 500));
//   html.window.location.reload();
// }

// void navigateToLogin(BuildContext context) {
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return const SessionAlertDialog();
//     },
//   );
// }
