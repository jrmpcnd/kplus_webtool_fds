import 'dart:html' as html;
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mfi_whitelist_admin_portal/core/provider/mfi/loan_disburse_provider.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/clientmanagement/client_topup_list/topup_provider.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/login/loginpage.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/not_found/page_not_found.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/navigations/router.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'core/api/login_logout/logout.dart';
import 'core/provider/code/code_provider.dart';
//import 'core/provider/role_provider.dart';
import 'core/provider/mfi/mfi_client_all_provider.dart';
import 'core/provider/mfi/top_up_provider.dart';
import 'core/provider/role_provider.dart';
import 'core/provider/timer_service_provider.dart';
import 'core/provider/user_provider.dart';
import 'core/service/AuthService.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // WidgetsBindingObserver;
  setPathUrlStrategy();
  runApp(const MyApp());

  html.window.onBeforeUnload.listen((html.Event e) async {
    // Get the token from local storage
    final token = getToken();

    if (token != null) {
      // Call your logout function with the token
      await logout(getToken(), true);
      // Remove the token from local storage after logout
      html.window.localStorage.remove('token');
    }
  });
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

void updateUrl(String newUrl) {
  context.callMethod('eval', ['window.history.replaceState(null, "", "$newUrl");']);
  html.window.localStorage['Path'] = newUrl;
}

final path = getPath();

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        // ChangeNotifierProvider(create: (_) => LogsProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserRoleProvider()),
        ChangeNotifierProvider(create: (_) => UserByStaffIDProvider()),
        ChangeNotifierProvider(create: (_) => CodeProvider()),
        ChangeNotifierProvider(create: (_) => MFIClientProvider()),
        ChangeNotifierProvider(create: (_) => TopupMFIClientProvider()),
        ChangeNotifierProvider(create: (_) => TopUpProvider()),
        ChangeNotifierProvider(create: (_) => LoanDisbursementProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black87), visualDensity: VisualDensity.adaptivePlatformDensity),
        navigatorKey: navigatorKey,
        routes: screenRoutes,
        onGenerateRoute: (settings) => generateRoute(context, settings),
        initialRoute: path,
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const NotFoundPage());
        },
        home: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              isNotLocalStorageEmpty(context);
              return const Center(child: LoginScreen());
            },
          ),
        ),
      ),
    );
  }
}
