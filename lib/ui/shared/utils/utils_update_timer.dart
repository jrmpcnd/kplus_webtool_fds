// import 'package:cagabay_whitelist_2/ui/shared/utils/utils_time_converter.dart';
// import 'package:flutter/material.dart';
//
// import '../../../core/provider/timer_service_provider.dart';
// import '../../../core/service/setting_api.dart';
// import '../sessionmanagement/sessionmanagement/sessionmanagement.dart';

// final TimeParametersProvider timeParameterProvider = TimeParametersProvider();
// Future<void> updateSessionTimer() async {
//   try {
//     // Retrieve data from settings API
//     final sessionTokenData = await SettingsAPI.getSessionTime();
//     final duration = sessionTokenData.duration;
//     final format = sessionTokenData.format;
//     final convertedToSeconds = convertTimeToSeconds(duration, format);
//
//     updateSessionDuration(convertedToSeconds);
//     debugPrint('Session timer updated: $convertedToSeconds seconds');
//
//     // Call setIdleDuration to update provider and restart timer
//     setSessionDuration();
//   } catch (error) {
//     debugPrint('Error updating session timer: $error');
//   }
// }
