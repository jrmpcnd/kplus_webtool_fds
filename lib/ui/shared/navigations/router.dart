import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/clientmanagement/batch_upload/mfi_batch_delist.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/reset_password/mfi_resetpass_email.dart';

import '../../../core/service/AuthGuard.dart';
import '../../screens/dashboard/menu/side_panel.dart';
import '../../screens/login/loginpage.dart';
import '../../screens/user_management/ui/not_found/page_not_found.dart';
import '../../screens/user_management/ui/reset_password/reset_password.dart';
import '../../screens/user_management/ui/settings/setting_screen.dart';

Widget buildPage(BuildContext context, String menuName) {
  selectedRoute = menuName;
  return const SideMenu();
}

final Map<String, WidgetBuilder> screenRoutes = {
  //DASHBOARD
  '/Home': (context) => AuthGuard(builder: (context) => buildPage(context, 'Home')),
  //USER MANAGEMENT
  '/User_Management/Access_Management': (context) => AuthGuard(builder: (context) => buildPage(context, 'User Access')),
  '/User_Management/Access_Role': (context) => AuthGuard(builder: (context) => buildPage(context, 'Access Role')),

  //REPORTS
  '/Reports/Otp_Logs_Reports': (context) => AuthGuard(builder: (context) => buildPage(context, 'SMS Sent')),
  '/Reports/Users_List': (context) => AuthGuard(builder: (context) => buildPage(context, 'Users List')),
  '/Reports/Whitelisted_Reports': (context) => AuthGuard(builder: (context) => buildPage(context, 'Whitelisted Reports')),
  '/Reports/Audit_Trail_Reports': (context) => AuthGuard(builder: (context) => buildPage(context, 'Audit Trail')),
  '/Reports/Delisted_Reports': (context) => AuthGuard(builder: (context) => buildPage(context, 'Delisted Reports')),

  //CLIENT MANAGEMENT
  '/Access/Client_List/Disapproved_Clients': (context) => AuthGuard(builder: (context) => buildPage(context, 'Disapproved Clients')),
  '/Access/Client_List/Uploaded_Clients': (context) => AuthGuard(builder: (context) => buildPage(context, 'Uploaded Clients')),
  '/Access/Client_List/Approved_Clients': (context) => AuthGuard(builder: (context) => buildPage(context, 'Approved Clients')),
  '/Access/Client_List/Delisted_Clients': (context) => AuthGuard(builder: (context) => buildPage(context, 'Delisted Clients')),
  '/Access/Single_Upload/Insert_Client': (context) => AuthGuard(builder: (context) => buildPage(context, 'Insert Client')),
  '/Access/Batch_Upload/Batch_Insert': (context) => AuthGuard(builder: (context) => buildPage(context, 'Batch Insert')),

  //TELLER MANAGEMENT
  '/Access/Top_Up/Single_Top_Up': (context) => AuthGuard(builder: (context) => buildPage(context, 'Single Top Up')),
  '/Access/Top_Up/Batch_Top_Up': (context) => AuthGuard(builder: (context) => buildPage(context, 'Batch Top Up')),
  '/Access/Top_Up/Top_Up_Files': (context) => AuthGuard(builder: (context) => buildPage(context, 'Top Up Files')),
  '/Access/Top_Up/Top_Up_Clients': (context) => AuthGuard(builder: (context) => buildPage(context, 'Top Up Clients')),
  '/Access/Loan_Disbursement/Batch_Disbursement': (context) => AuthGuard(builder: (context) => buildPage(context, 'Batch Disburse')),
  '/Access/Loan_Disbursement/Loan_Disbursement_Files': (context) => AuthGuard(builder: (context) => buildPage(context, 'Loan Files')),
  '/Access/Loan_Disbursement/Loan_Disbursement_Clients': (context) => AuthGuard(builder: (context) => buildPage(context, 'Loan Clients')),

  // AUDIT MANAGEMENT
  '/Audit_Logs': (context) => AuthGuard(builder: (context) => buildPage(context, 'Audit Logs')),

  //AMLA
  '/AMLA/Batch_Upload': (context) => AuthGuard(builder: (context) => buildPage(context, 'AMLA Batch Upload')),
  '/AMLA/Watchlist': (context) => AuthGuard(builder: (context) => buildPage(context, 'Watchlist AMLA')),
  '/AMLA/Delisted': (context) => AuthGuard(builder: (context) => buildPage(context, 'Delisted AMLA')),
  '/AMLA/ValueETrans': (context) => AuthGuard(builder: (context) => buildPage(context, 'Value E-Transaction')),
  '/AMLA/SummaryETrans': (context) => AuthGuard(builder: (context) => buildPage(context, 'Summary E-Transaction')),
  '/AMLA/Registered_Client_Monitoring': (context) => AuthGuard(builder: (context) => buildPage(context, 'Client Monitoring')),

  // LOGIN
  '/Login': (context) => AuthCheck(builder: (context) => const LoginScreen()),

  // Navigator.pushNamed(context, '/Login')
  // RESET PASSWORD
  // '/ResetPassword': (context) => const UserChangePassword(),
  '/ResetByEmail': (context) => const ResetPasswordPage(),

  //SETTINGS
  '/Access/Batch_Upload/Batch_Delist': (context) => AuthGuard(builder: (context) => const MFIBatchDelist()),
  // '/User_Profile': (context) => AuthGuard(builder: (context) => const UserProfile()),
  '/Settings': (context) => AuthGuard(builder: (context) => const Settings()),
  '/MFIResetPass': (context) => const MFIChangePassforEmail(),
};

Route<dynamic> generateRoute(BuildContext context, RouteSettings settings) {
  final routeName = settings.name;
  return _getPageRoute(routeName!, context);
}

String selectedRoute = '/Home';

PageRoute _getPageRoute(String routeName, BuildContext context) {
  final builder = screenRoutes[routeName];
  if (builder != null) {
    return _FadeRoute(child: builder(context));
  } else {
    // Handle route not found (using _FadeRoute)
    return _FadeRoute(child: const NotFoundPage());
  }
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  _FadeRoute({required this.child})
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                child,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                FadeTransition(
                  opacity: animation,
                  child: child,
                ));
}
