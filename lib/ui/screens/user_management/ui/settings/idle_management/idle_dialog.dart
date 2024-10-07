// import 'dart:convert';
// import 'dart:html' as html;
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../../../core/provider/timer_service_provider.dart';
// import '../../../../../../core/service/setting_api.dart';
// import '../../../../../../main.dart';
// import '../../../../../shared/utils/utils_browser_refresh_handler.dart';
// import '../../../../../shared/values/colors.dart';
// import '../../../../../shared/widget/alert_dialog/alert_dialogs.dart';
// import '../../../../../shared/widget/alert_dialog/logoutdialogs/alertdialoglogout.dart';
// import '../../../../../shared/widget/containers/dialog.dart';
// import '../../../../../shared/widget/containers/toast.dart';
// import '../../../../../shared/widget/fields/textformfield.dart';
//
// class IdleDialog extends StatefulWidget {
//   final String token;
//   final VoidCallback onInteraction;
//   const IdleDialog({super.key, required this.token, required this.onInteraction});
//
//   @override
//   State<IdleDialog> createState() => _IdleDialogState();
// }
//
// class _IdleDialogState extends State<IdleDialog> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController reLoginController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   void _startTimer() {
//     final timer = Provider.of<TimerProvider>(context, listen: false);
//     timer.startTimer(context)();
//     timer.buildContext = context;
//   }
//
//   void _startDialogTimer() {
//     final timer = Provider.of<TimerProvider>(context, listen: false);
//     timer.startDialogTimer();
//     timer.buildContext = context;
//   }
//
//   // void restartSession() {
//   //   int? resumeSessionValue = Provider.of<SessionProvider>(context, listen: false).sessionValue;
//   //   html.window.localStorage['sessionStartTime'] = '$resumeSessionValue';
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: AppColors.dialogColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5),
//       ),
//       content: Form(
//         key: _formKey,
//         child: SizedBox(
//           height: 200,
//           width: 350,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Image(
//                 image: AssetImage('images/idle.png'),
//                 width: 70,
//               ),
//               const Text(
//                 'User has been idle.',
//                 style: TextStyle(fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Please input your password to resume your progress.',
//                 style: TextStyle(
//                   fontFamily: 'Roboto',
//                   fontSize: 12,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   idleTextField(),
//                   idleButtonLogin(),
//                   idleButtonLogout(),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget idleTextField() {
//     return Expanded(
//       child: SizedBox(
//         height: 40,
//         child: TextFormFieldWidget(
//           controller: reLoginController,
//           contentPadding: 15,
//           borderRadius: 2,
//           obscureText: true,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return '';
//             }
//             return null;
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget idleButtonLogin() {
//     return Container(
//       height: 40,
//       width: 40,
//       color: AppColors.ngoColor,
//       child: IconButton(
//         icon: const Icon(Icons.login_rounded),
//         onPressed: () {
//           if (_formKey.currentState!.validate()) {
//             validatePasswordOnIdle();
//           }
//         },
//         color: Colors.white,
//       ),
//     );
//   }
//
//   Widget idleButtonLogout() {
//     return Container(
//       height: 40,
//       width: 40,
//       decoration: const BoxDecoration(
//         color: AppColors.maroon3,
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(5),
//           bottomRight: Radius.circular(5),
//         ),
//       ),
//       child: IconButton(
//         icon: const Icon(Icons.power_settings_new_rounded),
//         onPressed: () {
//           widget.onInteraction();
//           showLogoutAlertDialog(context);
//           // Navigator.push(context, MaterialPageRoute(builder: (context) => const FdsLogin()));
//           // navigateToLoginPage(context);
//         },
//         color: Colors.white,
//       ),
//     );
//   }
//
//   Future<void> validatePasswordOnIdle() async {
//     String passwordOnIdle = reLoginController.text;
//     String prefToken = widget.token;
//
//     widget.onInteraction();
//     CustomToast.show(context, 'Validating password...');
//     try {
//       final response = await SettingsAPI.validatePasswordOnIdle(passwordOnIdle, prefToken);
//
//       if (response.statusCode == 200 && jsonDecode(response.body)['retCode'] == '200') {
//         final timer = Provider.of<TimerProvider>(navigatorKey.currentContext!, listen: false);
//         timer.CancelCurrentDialogTimer(true);
//         timer.buildContext = navigatorKey.currentContext!;
//
//         BrowserRefreshHandler.setAlertDialogVisibility(navigatorKey.currentContext!, false);
//         // added cancel time after successful validating
//
//         html.window.localStorage['idlePopup'] = '';
//         Navigator.of(context).pop();
//         _startTimer();
//         // restartSession();
//       } else {
//         showSuccessFailAlertDialog();
//       }
//     } catch (error) {
//       showErrorLoginAlertDialog(context);
//     }
//   }
//
//   void showSuccessFailAlertDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialogWidget(
//         titleText: "Invalid Credential",
//         contentText: "Sorry! The user's info was invalid.",
//         positiveButtonText: "Retry",
//         positiveOnPressed: () {
//           Navigator.pop(context);
//           _startDialogTimer();
//         },
//         iconData: Icons.error_outline,
//         titleColor: AppColors.errorColor,
//         iconColor: Colors.white,
//       ),
//     );
//   }
// }
