// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../../../core/provider/timer_service_provider.dart';
// import '../session_management/session_setting.dart';
// import 'idle_setting.dart';
//
// class IdleSessionBody extends StatefulWidget {
//   const IdleSessionBody({super.key});
//
//   @override
//   State<IdleSessionBody> createState() => _IdleSessionBodyState();
// }
//
// class _IdleSessionBodyState extends State<IdleSessionBody> {
//   Timer? _timer;
//   bool isLoading = true;
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   void _startTimer() {
//     final timer = Provider.of<TimerProvider>(context, listen: false);
//     timer.startTimer(context)();
//     timer.buildContext = context;
//   }
//
//   void _pauseTimer([_]) {
//     _timer?.cancel();
//     _startTimer();
//     debugPrint('flutter-----(time pause!)');
//   }
//
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     switch (state) {
//       case AppLifecycleState.resumed:
//         _startTimer();
//         break;
//       case AppLifecycleState.inactive:
//         break;
//       case AppLifecycleState.detached:
//         break;
//       case AppLifecycleState.paused:
//         _pauseTimer();
//         break;
//       case AppLifecycleState.hidden:
//         break;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size screenHeight = MediaQuery.of(context).size;
//
//     // if (isLoading) {
//     //   return const Center(
//     //       child: Column(
//     //     mainAxisAlignment: MainAxisAlignment.center,
//     //     children: [
//     //       SpinKitChasingDots(color: AppColors.ngoColor, size: 70),
//     //       Text(
//     //         'Fetching settings data.',
//     //         style: TextStyles.headingTextStyle,
//     //       ),
//     //     ],
//     //   ));
//     // }
//
//     return Listener(
//       behavior: HitTestBehavior.opaque,
//       onPointerMove: _pauseTimer,
//       onPointerHover: _pauseTimer,
//       child: const SingleChildScrollView(
//         child: Wrap(runSpacing: 50, children: [
//           // child: const Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           IdleSetting(),
//           SessionSetting(),
//         ]),
//       ),
//     );
//   }
// }
