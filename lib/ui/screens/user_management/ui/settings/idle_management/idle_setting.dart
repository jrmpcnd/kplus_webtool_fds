// import 'dart:convert';
//
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../../../core/provider/timer_service_provider.dart';
// import '../../../../../../core/service/setting_api.dart';
// import '../../../../../shared/formatters/formatter.dart';
// import '../../../../../shared/utils/utils_responsive.dart';
// import '../../../../../shared/values/colors.dart';
// import '../../../../../shared/values/styles.dart';
// import '../../../../../shared/widget/buttons/button.dart';
// import '../../../../../shared/widget/containers/dialog.dart';
// import '../../../../../shared/widget/fields/textformfield.dart';
//
// class IdleSetting extends StatefulWidget {
//   const IdleSetting({super.key});
//
//   @override
//   State<IdleSetting> createState() => _IdleSettingState();
// }
//
// class _IdleSettingState extends State<IdleSetting> {
//   TextEditingController timeoutNumberController = TextEditingController();
//   TextEditingController timeoutFormatController = TextEditingController();
//   late bool isSwitched = false;
//   final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer()
//     ..onTap = () {
//       // Handle the tap event
//     };
//
//   @override
//   void initState() {
//     super.initState();
//     // initializeIdleInfo();
//     // getIdleStatus();
//   }
//
//   // Future<void> getIdleStatus() async {
//   //   final idleStatusProvider = Provider.of<TimeParametersProvider>(context, listen: false);
//   //   final status = await idleStatusProvider.fetchIdleStatus();
//   //   setState(() {
//   //     isSwitched = status == 'Active';
//   //   });
//   // }
//   //
//   // Future<void> initializeIdleInfo() async {
//   //   TimerProvider idleTimeProvider = Provider.of<TimerProvider>(context, listen: false);
//   //   await idleTimeProvider.fetchIdleTime();
//   //   timeoutNumberController.text = idleTimeProvider.duration;
//   //   timeoutFormatController.text = idleTimeProvider.format;
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     Size screenHeight = MediaQuery.of(context).size;
//     return Column(
//       // mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Idle Timeout",
//           style: TextStyles.heavyBold16Black,
//         ),
//         const SizedBox(height: 10),
//         Responsive(
//           desktop: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               idlePhraseBody(),
//               idleTimeFields(),
//             ],
//           ),
//           mobile: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               idlePhraseBody(),
//               idleTimeFields(),
//             ],
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.only(top: 20),
//           child: Row(
//             children: [
//               const Spacer(),
//               MyButton.buttonWithLabel(context, () => submitUpdateIdle(), 'Save Changes', Icons.save_outlined, AppColors.ngoColor),
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   Widget idlePhraseBody() {
//     return Column(
//       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Wrap(
//           spacing: 10,
//           children: [
//             // SizedBox(
//             //   // color: Colors.yellow.shade100,
//             //   width: 25,
//             //   height: 20,
//             //   child: Transform.scale(
//             //     scale: 0.5,
//             //     child: Switch.adaptive(
//             //       activeColor: AppColors.ngoColor,
//             //       value: isSwitched,
//             //       onChanged: (value) {
//             //         _showAlertDialog(context, value);
//             //       },
//             //     ),
//             //   ),
//             // ),
//             Text(
//               "Prompt user to re-enter the password to continue.",
//               style: TextStyles.headingTextStyle,
//               maxLines: 2,
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         RichText(
//           text: TextSpan(
//             children: [
//               const TextSpan(
//                 text: 'Temporarily lockout the user after a period of inactivity. ',
//                 style: TextStyles.dataTextStyle,
//               ),
//               TextSpan(
//                 text: 'Learn more',
//                 style: const TextStyle(
//                   color: Colors.blue,
//                   fontSize: 12,
//                   decoration: TextDecoration.underline,
//                 ),
//                 recognizer: _tapGestureRecognizer,
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   Widget idleTimeFields() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Set Timeout Limit',
//           style: TextStyles.dataTextStyle,
//         ),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: [
//             SizedBox(
//               // color: Colors.deepPurpleAccent.shade100,
//               width: 120,
//               height: 50,
//               child: Tooltip(
//                 message: 'Set length of duration',
//                 child: TextFormFieldWidget(
//                   contentPadding: 20,
//                   borderRadius: 3,
//                   controller: timeoutNumberController,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [TwoDigitInputFormatter(), ZeroFormat()],
//                   onChanged: (value) {
//                     setState(() {});
//                   },
//                 ),
//               ),
//             ),
//             Tooltip(
//               message: 'Set timeout format',
//               child: DropdownMenu(
//                 controller: timeoutFormatController,
//                 textStyle: TextStyles.dataTextStyle,
//                 width: 120,
//                 dropdownMenuEntries: const [
//                   DropdownMenuEntry(value: 'seconds', label: 'seconds'),
//                   DropdownMenuEntry(value: 'minutes', label: 'minutes'),
//                   DropdownMenuEntry(value: 'hours', label: 'hours'),
//                 ],
//                 inputDecorationTheme: InputDecorationTheme(
//                   outlineBorder: const BorderSide(color: AppColors.ngoColor, style: BorderStyle.solid),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5),
//                     borderSide: const BorderSide(color: AppColors.green3, width: 2),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5),
//                     borderSide: const BorderSide(color: AppColors.ngoColor),
//                   ),
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5),
//                     borderSide: const BorderSide(color: Colors.red, width: 2),
//                   ),
//                 ),
//                 onSelected: (value) {
//                   // Handle the selected value here
//                   debugPrint('Selected value: $value');
//                   // You can store the selected value in a variable or use it as needed
//                 },
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   // void _showAlertDialog(BuildContext context, bool newValue) {
//   //   showDialog(
//   //     barrierDismissible: false,
//   //     context: context,
//   //     builder: (context) => AlertDialogWidget(
//   //       titleText: "Confirmation",
//   //       contentText: newValue ? "The idle timeout will be turned on." : "The idle timeout will be turned off.",
//   //       positiveButtonText: newValue ? "Turn On" : "Turn Off",
//   //       negativeButtonText: "Cancel",
//   //       negativeOnPressed: () {
//   //         Navigator.of(context).pop();
//   //       },
//   //       positiveOnPressed: () {
//   //         Navigator.of(context).pop();
//   //         setState(() {
//   //           isSwitched = newValue;
//   //         });
//   //         if (newValue) {
//   //           activatedDeactivateIdle();
//   //         } else {
//   //           activatedDeactivateIdle();
//   //         }
//   //       },
//   //       iconData: newValue ? Icons.info_outline : Icons.warning_amber,
//   //       titleColor: newValue ? AppColors.infoColor : AppColors.warningColor,
//   //       iconColor: newValue ? Colors.white : Colors.white,
//   //     ),
//   //   );
//   // }
//
//   void submitUpdateIdle() async {
//     // Retrieve data from controllers
//     int idleTime = int.parse(timeoutNumberController.text);
//     String idleFormat = timeoutFormatController.text;
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(
//         child: Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           alignment: WrapAlignment.center,
//           runAlignment: WrapAlignment.center,
//           crossAxisAlignment: WrapCrossAlignment.center,
//           children: [
//             SpinKitFadingCircle(color: AppColors.dialogColor),
//             Text(
//               'Saving new idle data...',
//               style: TextStyles.bold14White,
//             ),
//           ],
//         ),
//       ),
//     );
//
//     // Call the API function with the retrieved data
//     final response = await SettingsAPI.updateIdleTime(
//       idleTime,
//       idleFormat,
//     );
//
//     Navigator.pop(context);
//
//     if (response.statusCode == 200 && jsonDecode(response.body)['retCode'] == '200') {
//       showSuccessFailAlertDialog(isSuccess: true);
//       // initializeIdleInfo();
//       await Provider.of<TimerProvider>(context, listen: false).updateIdleTimer();
//     } else {
//       showSuccessFailAlertDialog(isSuccess: false);
//     }
//   }
//
//   Future<void> showSuccessFailAlertDialog({required bool isSuccess}) async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialogWidget(
//         titleText: isSuccess ? "Idle Parameter Updated" : "Failed to Update",
//         contentText: isSuccess ? "The idle timeout was updated successfully." : "Sorry! The idle's info was not updated.",
//         // positiveButtonText: isSuccess ? "Done" : "Retry",
//         // positiveOnPressed: () {
//         //   if (isSuccess) {
//         //     Navigator.pop(context);
//         //     initializeIdleInfo();
//         //   }
//         // },
//         iconData: isSuccess ? Icons.check_circle_outline : Icons.error_outline,
//         titleColor: isSuccess ? AppColors.ngoColor : AppColors.errorColor,
//         iconColor: isSuccess ? Colors.green : Colors.white,
//       ),
//     );
//
//     if (isSuccess) {
//       await Future.delayed(const Duration(seconds: 1));
//       Navigator.pop(context);
//     }
//   }
// }
