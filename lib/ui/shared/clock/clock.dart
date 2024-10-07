import 'dart:async';

import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  @override
  Widget build(BuildContext context) {
    return DigitalClock();
  }
}

class DigitalClock extends StatefulWidget {
  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  late Timer _timer;
  String _currentTime = '';
  String _amPmIndicator = '';
  String _currentDate = '';

  @override
  void initState() {
    super.initState();
    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
      if (mounted) {
        setState(() {});
      }
    });
    // Initial time update
    _updateTime();
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final amPm = now.hour >= 12 ? 'PM' : 'AM';

    final formattedTime = "${_formatTimeComponent(hour)}:${_formatTimeComponent(now.minute)}:${_formatTimeComponent(now.second)}";

    final formattedDate = "${_getMonthName(now.month)} ${_formatTimeComponent(now.day)}, ${now.year}";

    setState(() {
      _currentTime = formattedTime;
      _amPmIndicator = amPm;
      _currentDate = formattedDate;
    });
  }

  String _formatTimeComponent(int timeComponent) {
    return timeComponent < 10 ? '0$timeComponent' : '$timeComponent';
  }

  String _getMonthName(int month) {
    final monthNames = [
      '', // Leave an empty string at index 0 for 1-based month indexing
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December',
    ];
    return monthNames[month];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentTime,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoThin',
                  letterSpacing: 1,
                  color: Colors.black54
              ),
            ),
            const SizedBox(width: 5,),
            Text(
              _amPmIndicator,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoThin',
                  color: Colors.black54
              ),
            ),
          ],
        ),
        Text(
          _currentDate,
          style: const TextStyle(
            fontSize: 10.0,
            // fontWeight: FontWeight.bold,
            fontFamily: 'RobotoThin',
            color:  Colors.black54,
          ),
        ),
      ],
    );
  }
}
