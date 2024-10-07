import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/timer_service_provider.dart';

class BrowserRefreshHandler {
  static bool isAlertDialogShown = false;

  // static void setAlertDialogVisibility(BuildContext context, bool isVisible) {
  //   debugPrint('Setting alert dialog visibility to: $isVisible');
  //   isAlertDialogShown = isVisible;
  //   if (isVisible) {
  //     // Dialog is being shown, disable browser refresh
  //     _disableBrowserRefresh(context);
  //   } else {
  //     // Dialog is being hidden, re-enable browser refresh
  //     _enableBrowserRefresh();
  //   }
  // }
  //
  // // static void _disableBrowserRefresh(BuildContext context) {
  // //   html.window.onBeforeUnload.listen((html.Event event) {
  // //     event.preventDefault();
  // //   });
  // // }
  //
  // static void _disableBrowserRefresh(BuildContext context) {
  //   Future.delayed(Duration.zero, () async {
  //     final timerProvider = Provider.of<TimerProvider>(context, listen: false);
  //     if (timerProvider.isTimerActive) {
  //       html.window.onBeforeUnload.listen((html.Event event) {
  //         event.preventDefault();
  //       });
  //     } else {
  //       debugPrint('Timer is not active, browser refresh allowed');
  //     }
  //   });
  // }

  static void _enableBrowserRefresh() {
    html.window.onBeforeUnload.listen((html.Event event) {});
  }
}
