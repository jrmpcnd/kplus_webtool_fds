import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/provider/timer_service_provider.dart';
import '../../../../../main.dart';
import '../../../../shared/utils/utils_browser_refresh_handler.dart';
import '../../../../shared/utils/utils_responsive.dart';
import 'header/header.dart';
import 'header/header_CTA.dart';

class BaseScreen extends StatefulWidget {
  final Widget body;
  final List<Widget> children;
  final String screenText;
  const BaseScreen({super.key, required this.body, required this.children, required this.screenText});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
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
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerHover: _pauseTimer,
      onPointerMove: _pauseTimer,
      child: Material(
        child: Responsive(
          desktop: baseContainer(90),
          mobile: baseContainer(90),
        ),
      ),
    );
  }

  Widget baseContainer(double padding) {
    return Container(
      // color: AppColors.bgColor,
      padding: EdgeInsets.only(left: padding),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderBar(screenText: widget.screenText),
            const SizedBox(height: 5),
            HeaderCTA(children: widget.children),
            const SizedBox(height: 15),
            //THIS IS THE MAIN CONTENT
            Expanded(
              child: widget.body,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Widget _buildDrawer() {
  //   return const Drawer(child: SideMenu());
  // }
}
