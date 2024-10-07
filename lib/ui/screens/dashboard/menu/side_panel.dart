import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mfi_whitelist_admin_portal/core/mfi_whitelist_api/api_endpoints.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/AMLA/amla_batch_upload.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/AMLA/amla_delisted.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/AMLA/amla_reg_client_monitoring.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/AMLA/amla_summary_e_trans.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/AMLA/amla_value_e_trans.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/AMLA/amla_watchlist.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/audit_logs/mfi_auditlogs.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/clientmanagement/batch_upload/batchupload.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/clientmanagement/client_list/approve_disapprove/approved_clients.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/clientmanagement/client_list/approve_disapprove/disapproved_clients.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/clientmanagement/client_list/delisted/delisted.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/clientmanagement/client_list/uploaded_files.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/clientmanagement/single_upload/add_client/add_client.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/reports/delistedreports.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/reports/otplogsreport.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/reports/reportsofwhitelisted.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/reports/userslist.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/teller_management/batch_disburse/batch_disbursement.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/teller_management/batch_topup/batch_wallet_topup.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/teller_management/loan_disburse/loan_clients/loan_disburse_table.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/teller_management/loan_disburse/loan_files/uploaded_loan_files.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/teller_management/single_top_up/single_top_up.dart';
import 'package:provider/provider.dart';

import '../../../../../core/models/user_management/roles_model.dart';
import '../../../../../core/provider/timer_service_provider.dart';
import '../../../../../core/service/role_api.dart';
import '../../../../../main.dart';
import '../../../shared/navigations/navigation.dart';
import '../../../shared/navigations/router.dart';
import '../../../shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import '../../../shared/utils/utils_browser_refresh_handler.dart';
import '../../../shared/utils/utils_responsive.dart';
import '../../../shared/values/colors.dart';
import '../../../shared/values/styles.dart';
import '../../../shared/widget/alert_dialog/logoutdialogs/alertdialoglogout.dart';
import '../../clientmanagement/client_topup_list/uploaded_topup.dart';
import '../../otplogs/otplogs.dart';
import '../../teller_management/topUp_list.dart';
import '../../user_management/ui/not_found/unauthorized_access.dart';
import '../../user_management/ui/role_management/role_management_table.dart';
import '../../user_management/ui/user_management/user_management_table.dart';
import '../dashboard.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  static final GlobalKey<_SideMenuState> sideMenuKey = GlobalKey<_SideMenuState>();

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  Timer? _timer;
  bool isLoading = true;
  String? userRole;
  String? urole = getUrole();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _startTimer();
      // print('flutter=====(Time, Start!)');
    });
    super.initState();
    userRole = getUrole();
    loadData();

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

  @override
  didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        _startTimer();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.paused:
        _pauseTimer();
        break;
      case AppLifecycleState.hidden:
        break;
    }
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

// Function to load data
  Future<void> loadData() async {
    try {
      String? userRole = getUrole();
      if (userRole != null) {
        await fetchRoleAccess(userRole);
      }
      await getDashboardData();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final submenu = getSubmenu();
  bool isAllowed = false;
  bool isHover = false;
  bool isExpanded = false;
  bool isSelect = false;

  // bool isHomeSelected=false;
  List<Map<String, dynamic>> dashboards = [];
  Map<String, List<String>> menuItems = {};
  Map<String, Map<String, dynamic>> subMenuItems = {};
  String? selectedDashboard;
  String? selectedMenu;
  String? selectedMenuOrSubMenuName = selectedRoute;
  List<String> allowedDashboardTitles = [];
  List<String> allowedMenuItems = [];
  List<String> allowedSubmenuItems = [];
  final name = getFname();

  List<IconData> menuIcons = [
    // Icons.home, // Icon for the first menu
    Iconsax.folder_2_copy, // Icon for the second menu
    Iconsax.folder_2_copy,
    Iconsax.folder_2_copy,
    Iconsax.folder_2_copy,
    Iconsax.folder_2_copy,
  ];

  List<IconData> mainMenuIcons = [
    Iconsax.category_2_copy,
    Iconsax.category_2_copy,
    Iconsax.category_2_copy,
    Iconsax.category_2_copy,
    Iconsax.category_2_copy,
    Iconsax.category_2_copy,
    Iconsax.category_2_copy,
  ];

  List<IconData> submenuIcons = [
    Iconsax.document_normal_copy, //Single Insert
    Iconsax.document_normal_copy, //Single Update
    Iconsax.document_normal_copy, //Single Delete
    Iconsax.document_normal_copy, //Whitelisted
    Iconsax.document_normal_copy, //Delisted
    Iconsax.document_normal_copy, //Search
    Iconsax.document_normal_copy, //Batch Upload
    Iconsax.document_normal_copy, //Batch Delist
  ];

  Future<void> getDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse(MFIApiEndpoints.getDashboardMenu),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode == 200 && jsonDecode(response.body)['retCode'] == '200') {
        final responseData = json.decode(response.body);
        final List<dynamic> dashboardData = responseData['data'];

        // Sort the dashboardData list based on dashboard_id
        dashboardData.sort((a, b) => a['dashboard_id'].compareTo(b['dashboard_id']));

        setState(() {
          dashboards = List<Map<String, dynamic>>.from(dashboardData);
          for (var dashboard in dashboards) {
            final dashboardTitle = dashboard['dashboard_title'];
            final access = dashboard['access'];

            if (access is List) {
              final menuTitles = access.map<String>((item) => item['menu_title'] as String).toList();
              menuTitles.sort();

              final submenuData = <String, dynamic>{};
              for (var item in access) {
                final menuTitle = item['menu_title'];
                List<dynamic> subMenus = item['sub_menus'];

                // Sort the sub_menus by sub_menu_id
                subMenus.sort((a, b) => a['sub_menu_id'].compareTo(b['sub_menu_id']));
                submenuData[menuTitle] = subMenus;
              }

              menuItems[dashboardTitle] = menuTitles;
              subMenuItems[dashboardTitle] = submenuData;
            } else {
              debugPrint('Invalid access data for dashboard.');
            }
          }
        });
      } else {
        throw Exception('Failed to load dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching dashboard data: $e');
    }
  }

  Future<void> fetchRoleAccess(String roleTitle) async {
    try {
      // Wait for the dashboard data to be fetched and set
      await getDashboardData();

      RoleData userRole = (await GetRoleAccess.getAccessByRole(roleTitle));
      for (var access in userRole.data.matrix) {
        String? dashboardTitle = access.dashboard;

        if (dashboardTitle != null) {
          // Check if dashboardTitle exists in dashboards and add if it does
          for (var dashboard in dashboards) {
            if (dashboard['dashboard_title'] == dashboardTitle) {
              allowedDashboardTitles.add(dashboardTitle);
              // debugPrint('Add: $dashboardTitle');
              break;
            }
          }

          // Add menu items to the list
          for (var menuItem in access.access!) {
            String? menuTitle = menuItem.menuTitle;
            allowedMenuItems.add(menuTitle!);

            // Add submenu items to the list
            if (menuItem.subMenu != null) {
              for (var submenuItem in menuItem.subMenu!) {
                allowedSubmenuItems.add(submenuItem);
              }
            }
          }
        }
      }

      // Ensure allowedDashboardTitles is sorted based on dashboards
      allowedDashboardTitles.sort((a, b) {
        int indexA = dashboards.indexWhere((dashboard) => dashboard['dashboard_title'] == a);
        int indexB = dashboards.indexWhere((dashboard) => dashboard['dashboard_title'] == b);
        return indexA.compareTo(indexB);
      });

      // debugPrint('sorted allowedDashboardTitles: $allowedDashboardTitles');
    } catch (e) {
      debugPrint('Error fetching role access: $e');
    }
  }

  void _onDrawerItemClicked(String dashboardTitle) {
    setState(() {
      if (selectedDashboard == dashboardTitle) {
        selectedDashboard = null;
      } else {
        selectedDashboard = dashboardTitle;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return Center(
    //       child: Material(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const SpinKitChasingDots(color: AppColors.maroon2, size: 70),
    //         Text(
    //           'Hi $name, we are setting up your account.',
    //           style: TextStyles.headingTextStyle,
    //         ),
    //       ],
    //     ),
    //   ));
    // }

    return PopScope(
      canPop: false,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerHover: _pauseTimer,
        onPointerMove: _pauseTimer,
        child: Scaffold(
          body: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  Map<String, Widget> menuWidgetMap = {
                    'Home': Dashboards(),
                    'SMS Sent': allowedMenuItems.contains('SMS Sent') ? const OtpLogsReports() : const UnauthorizedScreenPage(),
                    'Audit Logs': allowedMenuItems.contains('Audit Logs') ? const MFIAuditLogs() : const UnauthorizedScreenPage(),
                    'Users List': allowedMenuItems.contains('Users List') ? const UsersList() : const UnauthorizedScreenPage(),
                    'Whitelisted Reports': allowedMenuItems.contains('Whitelisted Reports') ? const WhiteListedReport() : const UnauthorizedScreenPage(),
                    'Delisted Reports': allowedMenuItems.contains('Delisted Reports') ? const DeListedReports() : const UnauthorizedScreenPage(),
                    'User Access': allowedMenuItems.contains('User Access')
                        ? UserAccessManagement(pauseTimer: () {
                            setState(() {
                              _pauseTimer();
                            });
                          })
                        : const UnauthorizedScreenPage(),
                    'Access Role': allowedMenuItems.contains('Access Role')
                        ? RoleManagement(pauseTimer: () {
                            setState(() {
                              _pauseTimer();
                            });
                          })
                        : const UnauthorizedScreenPage(),
                    'OTP Management': allowedMenuItems.contains('OTP Management') ? const OtpLogs() : const UnauthorizedScreenPage(),

                    //AMLA
                    'AMLA Batch Upload': allowedMenuItems.contains('AMLA Batch Upload') ? const AMLABatchUpload() : const UnauthorizedScreenPage(),
                    'Value E-Transaction': allowedMenuItems.contains('Value E-Transaction') ? const AMLAETrans() : const UnauthorizedScreenPage(),
                    'Summary E-Transaction': allowedMenuItems.contains('Summary E-Transaction') ? const SummaryETransaction() : const UnauthorizedScreenPage(),
                    'Client Monitoring': allowedMenuItems.contains('Client Monitoring') ? const AMLARegistereClientMonitoring() : const UnauthorizedScreenPage(),
                  };

                  Map<String, Widget> subMenuWidgetMap = {
                    'Uploaded Clients': allowedSubmenuItems.contains('Uploaded Clients') ? const PendingClients() : const UnauthorizedScreenPage(),
                    'Approved Clients': allowedSubmenuItems.contains('Approved Clients') ? const ApprovedClients() : const UnauthorizedScreenPage(),
                    'Disapproved Clients': allowedSubmenuItems.contains('Disapproved Clients') ? const DisapprovedClients() : const UnauthorizedScreenPage(),
                    'Delisted Clients': allowedSubmenuItems.contains('Delisted Clients') ? const MFIDelistedClients() : const UnauthorizedScreenPage(),
                    'Insert Client': allowedSubmenuItems.contains('Insert Client') ? const UploadSingleClient() : const UnauthorizedScreenPage(),
                    'Batch Insert': allowedSubmenuItems.contains('Batch Insert') ? const BatchUpload() : const UnauthorizedScreenPage(),
                    'Single Top Up': allowedSubmenuItems.contains('Single Top Up') ? const SingleWalletTopUp() : const UnauthorizedScreenPage(),
                    'Batch Top Up': allowedSubmenuItems.contains('Batch Top Up') ? const WalletBatchUpload() : const UnauthorizedScreenPage(),
                    'Top Up Files': allowedSubmenuItems.contains('Top Up Files') ? const PendingTopUpClients() : const UnauthorizedScreenPage(),
                    'Top Up Clients': allowedSubmenuItems.contains('Top Up Clients') ? const TopUpClients() : const UnauthorizedScreenPage(),
                    'Batch Disburse': allowedSubmenuItems.contains('Batch Disburse') ? const LoanBatchUpload() : const UnauthorizedScreenPage(),
                    'Loan Files': allowedSubmenuItems.contains('Loan Files') ? const UploadedDisburseFilesScreen() : const UnauthorizedScreenPage(),
                    'Loan Clients': allowedSubmenuItems.contains('Loan Clients') ? const LoanDisbursementTable() : const UnauthorizedScreenPage(),

                    //AMLA
                    'Watchlist AMLA': allowedSubmenuItems.contains('Watchlist AMLA') ? const AMLAWatchlist() : const UnauthorizedScreenPage(),
                    'Delisted AMLA': allowedSubmenuItems.contains('Delisted AMLA') ? const AMLADelistedClients() : const UnauthorizedScreenPage(),
                  };

                  Widget? selectedWidget = Container();

                  // Use the selected menu or submenu name to get the corresponding widget
                  if (subMenuWidgetMap.containsKey(selectedMenuOrSubMenuName)) {
                    selectedWidget = subMenuWidgetMap[selectedMenuOrSubMenuName];
                  } else if (menuWidgetMap.containsKey(selectedMenuOrSubMenuName)) {
                    selectedWidget = menuWidgetMap[selectedMenuOrSubMenuName];
                  }

                  return selectedWidget ?? Container();
                },
              ),
              if (isLoading)
                Center(
                    child: Material(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SpinKitChasingDots(color: AppColors.maroon2, size: 70),
                      Text(
                        'Hi $name, we are setting up your account.',
                        style: TextStyles.headingTextStyle,
                      ),
                    ],
                  ),
                )),
              Responsive(
                desktop: MouseRegion(
                  onHover: (event) {
                    setState(() {
                      isHover = true;
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      isHover = false;
                    });
                  },
                  child: webSideMenu(),
                ),
                tablet: GestureDetector(
                  onTap: () {
                    setState(() {
                      isHover = !isHover;
                    });
                  },
                  child: webSideMenu(),
                ),
                mobile: GestureDetector(
                  onTap: () {
                    setState(() {
                      isHover = !isHover;
                    });
                  },
                  child: webSideMenu(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget webSideMenu() {
    return AnimatedContainer(
      padding: const EdgeInsets.all(5),
      duration: Duration(milliseconds: isHover ? 300 : 300),
      width: isHover ? 250 : 90,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.maroon1, AppColors.maroon2, AppColors.maroon3, AppColors.maroon4],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.all(Radius.zero),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: isHover ? 240 : 240,
              height: isHover ? 80 : 80,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    urole == 'AMLA'
                        ? const Image(
                            image: AssetImage(
                              'assets/images/amla_side_menu_logo.png',
                            ),
                          )
                        : const Image(
                            image: AssetImage(
                              'assets/images/kplus.png',
                            ),
                          ),
                    const SizedBox(
                      width: 3,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        urole == 'AMLA'
                            ? Text(
                                'WATCHLIST',
                                style: TextStyle(color: Colors.white, fontSize: isHover ? 25 : 0, fontWeight: FontWeight.bold),
                              )
                            : Text(
                                'WEBTOOL',
                                style: TextStyle(color: Colors.white, fontSize: isHover ? 30 : 0, fontWeight: FontWeight.bold),
                              ),
                        Text(
                          'MANAGEMENT SYSTEM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isHover ? 10 : 0,
                            letterSpacing: 1.5,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.6),
            thickness: 0.5,
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  navigateToDashboardPage();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelect ? AppColors.highlightDash : Colors.white24.withOpacity(0.1),
                    width: 1,
                  ),
                  color: isSelect ? Colors.black.withOpacity(0.2) : Colors.white24.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: customMaterialContainer(
                  title: 'HOME',
                  isSelected: false,
                  padding: const EdgeInsets.only(right: 15),
                  paddingIcon: const EdgeInsets.only(left: 25.0),
                  selectedColor: AppColors.highlightDash,
                  iconData: Iconsax.home_2_copy,
                  // trailingIcon: const Icon(
                  //   Icons.arrow_drop_down_outlined,
                  //   color: Colors.white,
                  // ),
                ),
              ),
            ),
          ),

          //DASHBOARD TITLES
          Expanded(
            child: ListView.builder(
              itemCount: allowedDashboardTitles.length,
              itemBuilder: (context, dashboardIndex) {
                final dashboardTitle = allowedDashboardTitles[dashboardIndex];
                // debugPrint('Allowed Dashboard Title: $dashboardTitle');
                final dashboardData = dashboards.firstWhere((dashboard) => dashboard['dashboard_title'] == dashboardTitle);
                final access = dashboardData['access'];
                int menuIndex = 0;
                int submenuIndex = 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _onDrawerItemClicked(dashboardTitle);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedDashboard == dashboardTitle ? AppColors.highlightDash : Colors.white24.withOpacity(0.1),
                              width: 1,
                            ),
                            color: selectedDashboard == dashboardTitle ? Colors.black.withOpacity(0.2) : Colors.white24.withOpacity(0.1),
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: customMaterialContainer(
                            title: dashboardTitle,
                            isSelected: selectedDashboard == dashboardTitle,
                            padding: const EdgeInsets.only(right: 15),
                            paddingIcon: const EdgeInsets.only(left: 25.0),
                            selectedColor: AppColors.highlightDash,
                            imageUrl: dashboardData['dashboard_icon'],
                            iconData: menuIcons[dashboardIndex],
                            trailingIcon: const Icon(
                              Icons.arrow_drop_down_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (selectedDashboard == dashboardTitle)
                      for (var menu in access) ...[
                        if (allowedMenuItems.contains(menu['menu_title']))
                          if (menu['sub_menus'] != null && menu['sub_menus'].isNotEmpty && menu['sub_menus'].every((subMenu) => subMenu['sub_menu_id'] != null && subMenu['sub_menu_name'] != null))
                            //MENU WITH SUBMENUS - EXPANDING MENU
                            CustomExpansionTitleContainer(
                              title: menu['menu_title'],
                              fontSize: isHover ? 12 : 0,
                              imageUrl: menu['menu_icon'],
                              //NEWLY ADDED
                              isSelected: selectedMenuOrSubMenuName == menu['menu_title'],
                              iconData: mainMenuIcons[menuIndex],
                              selectedColor: AppColors.highlightMenu,
                              backgroundColor: selectedMenuOrSubMenuName == menu['menu_title'] ? Colors.white : Colors.transparent,
                              children: menu['sub_menus'].where((subMenu) => allowedSubmenuItems.contains(subMenu['sub_menu_name'])).map<Widget>((subMenu) {
                                //Populate submenus as children of the Expansion Tile
                                return subMenu['sub_menu_id'] != null && subMenu['sub_menu_name'] != null //Check first if the id and name is not null to generate the material widget
                                    ? customMaterialContainer(
                                        onTap: () {
                                          handleMenuOrSubMenuClick(menu['menu_title'], subMenu['sub_menu_name']);
                                        },
                                        title: subMenu['sub_menu_name'],
                                        isSelected: selectedMenuOrSubMenuName == subMenu['sub_menu_name'],
                                        backgroundColor: selectedMenuOrSubMenuName == subMenu['sub_menu_name'] ? Colors.white : Colors.transparent,
                                        selectedColor: AppColors.highlightSideMenu,
                                        iconData: submenuIcons[submenuIndex],
                                        imageUrl: subMenu['sub_menu_icon'],
                                        paddingIcon: isHover ? const EdgeInsets.only(left: 50.0) : const EdgeInsets.only(left: 40.0),
                                      )
                                    : Container(); //if id and name are null, return this container
                              }).toList(),
                            )
                          else
                            //MENU WITHOUT SUBMENU
                            customMaterialContainer(
                              onTap: () {
                                handleMenuOrSubMenuClick(menu['menu_title']);
                              },
                              title: menu['menu_title'],
                              isSelected: selectedMenuOrSubMenuName == menu['menu_title'],
                              backgroundColor: selectedMenuOrSubMenuName == menu['menu_title'] ? Colors.white : Colors.transparent,
                              selectedColor: AppColors.highlightMenu,
                              iconData: mainMenuIcons[menuIndex],
                              imageUrl: menu['menu_icon'],
                              paddingIcon: const EdgeInsets.only(left: 25.0),
                            ),
                      ],
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 5),
          //SETTINGS
          if (userRole == 'Admin' || userRole == 'FDSAP Admin')
            customMaterialContainer(
              onTap: () {
                Navigator.pushNamed(context, '/Settings');
              },
              title: 'SETTINGS',
              isSelected: false,
              backgroundColor: Colors.transparent,
              selectedColor: Colors.transparent,
              iconData: Icons.settings,
              paddingIcon: const EdgeInsets.only(left: 25.0),
            ),
          customMaterialContainer(
            onTap: () {
              showLogoutAlertDialog(context);
            },
            title: 'LOGOUT',
            isSelected: false,
            backgroundColor: Colors.transparent,
            selectedColor: Colors.transparent,
            iconData: Iconsax.logout_copy,
            paddingIcon: const EdgeInsets.only(left: 25.0),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.6),
            thickness: 0.5,
          ),
          Responsive(mobile: expandingButton(), tablet: expandingButton(), desktop: Container())
        ],
      ),
    );
  }

  Widget expandingButton() {
    return Center(
      child: IconButton(
        onPressed: () {
          setState(() {
            isHover = !isHover;
          });
        },
        icon: Icon(
          isHover ? Icons.chevron_left : Icons.chevron_right,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget customMaterialContainer({
    required String title,
    required bool isSelected,
    required Color selectedColor,
    required IconData iconData,
    String? imageUrl,
    VoidCallback? onTap,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    EdgeInsetsGeometry paddingIcon = EdgeInsets.zero,
    Widget? trailingIcon,
    Color? backgroundColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.white12,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Container(
              padding: padding,
              height: 50.0,
              width: 250.0,
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 475),
                    height: 35.0,
                    width: 5.0,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: paddingIcon,
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            height: 20,
                            width: 20,
                            color: isSelected ? selectedColor : Colors.white,
                          )
                        : Icon(
                            iconData,
                            color: isSelected ? selectedColor : Colors.white,
                            size: 17,
                          ),
                  ),
                  const SizedBox(width: 20),
                  Center(
                    child: Text(
                      title ?? '',
                      style: TextStyle(
                        color: isSelected ? selectedColor : Colors.white,
                        fontSize: isHover ? 12 : 0,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (trailingIcon != null)
                    if (isHover) // Only show trailing on hover
                      (isSelected
                          ? const Icon(
                              Icons.arrow_drop_up_outlined,
                              color: Colors.white,
                              size: 18,
                            )
                          : const Icon(
                              Icons.arrow_drop_down_outlined,
                              color: Colors.white,
                              size: 18,
                            )),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleMenuOrSubMenuClick(String name, [String? subMenuName]) {
    // Check if the clicked submenu name or name matches the allowed items
    bool isAllowed = isMenuItemAllowed(name, subMenuName);

    if (isAllowed) {
      setState(() {
        selectedMenuOrSubMenuName = subMenuName ?? name;
      });
    }
  }

  bool isMenuItemAllowed(String name, [String? subMenuName, Function()? disableWidget]) {
    // Check if the clicked menu or submenu name matches the allowed items
    if (subMenuName != null) {
      // Check if the submenu name is allowed
      bool isAllowed = allowedSubmenuItems.contains(subMenuName);
      return isAllowed;
    } else {
      // Check if the menu name is allowed
      bool isAllowed = allowedMenuItems.contains(name);
      return isAllowed;
    }
  }

  void menuIsNotAllowedSnackBar(BuildContext context, String menuTitle) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: AppColors.toastColor.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: AppColors.maroon3.withOpacity(0.2),
            )),
        child: ListTile(
          leading: const Icon(
            Icons.warning_amber,
            color: Colors.amber,
            size: 30,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Unauthorized Screen Access", style: TextStyles.headingTextStyle),
              Text('You do not have permission to access the $menuTitle page.', style: TextStyles.dataTextStyle),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      width: 600,
      duration: const Duration(seconds: 1),
      dismissDirection: DismissDirection.endToStart,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ));
  }
}

class CustomExpansionTitleContainer extends StatefulWidget {
  final String title;
  final bool isSelected;
  final IconData iconData;
  final String? imageUrl;
  final List<Widget> children;
  final Color? backgroundColor;
  final Color selectedColor;
  final bool changeIcon;
  final double fontSize;

  const CustomExpansionTitleContainer({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.iconData,
    this.imageUrl,
    required this.children,
    this.backgroundColor,
    required this.selectedColor,
    this.changeIcon = false,
    required this.fontSize,
  }) : super(key: key);

  @override
  _CustomExpansionTitleContainerState createState() => _CustomExpansionTitleContainerState();
}

class _CustomExpansionTitleContainerState extends State<CustomExpansionTitleContainer> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.changeIcon;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Container(
                  // color: widget.isSelected ? Colors.amber : Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(25, 5, 15, 5),
                  height: 50.0,
                  width: 250.0,
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 475),
                        height: 35.0,
                        width: 5.0,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      if (widget.imageUrl != null)
                        Image.network(
                          widget.imageUrl!,
                          height: 20,
                          width: 20,
                          color: isExpanded ? AppColors.highlightMenu : Colors.white,
                        )
                      else
                        Icon(
                          widget.iconData,
                          color: isExpanded ? AppColors.highlightMenu : Colors.white,
                          size: 20,
                        ),
                      const SizedBox(width: 20),
                      Center(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            color: isExpanded ? AppColors.highlightMenu : Colors.white,
                            fontSize: widget.fontSize,
                          ),
                        ),
                      ),
                      const Spacer(),
                      ExpandIcon(
                        size: 15,
                        isExpanded: isExpanded,
                        color: Colors.white,
                        expandedColor: AppColors.highlightMenu,
                        onPressed: (bool isExpanded) {
                          setState(() {
                            this.isExpanded = !isExpanded;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isExpanded) ...widget.children,
        ],
      ),
    );
  }
}
