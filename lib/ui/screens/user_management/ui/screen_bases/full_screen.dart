import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/provider/timer_service_provider.dart';
import '../../../../../main.dart';
import '../../../../shared/utils/utils_browser_refresh_handler.dart';
import 'header/header.dart';
import 'header/header_CTA.dart';

class FullScreen extends StatefulWidget {
  final Widget content;
  final List<Widget> children;
  final String screenText;
  const FullScreen({super.key, required this.content, required this.children, required this.screenText});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
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
        child: baseContainer(),
      ),
    );
  }

  Widget baseContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeaderBar(screenText: widget.screenText),
          HeaderCTA(children: widget.children),
          const SizedBox(height: 15),
          //THIS IS THE MAIN CONTENT
          Container(
            child: widget.content,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
