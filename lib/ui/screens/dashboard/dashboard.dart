//================Date Added : 6-17 ; Lea===================//
import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/main.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/base_screen.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/utils/utils_responsive.dart';

import '../../shared/clock/clock.dart';

import 'components/analytics/maker_checker_dashboard.dart';

class Dashboards extends StatefulWidget {
  Dashboards({super.key});

  @override
  State<Dashboards> createState() => _DashboardsState();
}

class _DashboardsState extends State<Dashboards> {
  String? role = getUrole();

  @override
  void initState() {
    super.initState();
    updateUrl('/Home');
  }

  @override
  Widget build(BuildContext context) {
    Widget dashboard;

    // Determine which dashboard to show based on the role
    if (role == 'Kplus Admin') {
      dashboard = const AdminAnalytics();
    } else if (role == 'AMLA') {
      dashboard = const AMLAAnalytics(); // Assuming AmlaDashboard is the widget for AMLA role
    } else {
      dashboard = const Analytics();
    }

    return BaseScreen(
      body: dashboard,
      screenText: '',
      children: const [
        Spacer(),
        Responsive(
          desktop: Clock(),
          mobile: Spacer(),
        )
      ],
    );
  }
}
