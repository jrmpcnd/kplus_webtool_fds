import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/fields/show_list.dart';
import 'package:provider/provider.dart';

import '../../../../../core/models/user_management/user_model.dart';
import '../../../../../core/provider/user_provider.dart';
import '../../../../../core/service/url_getter_setter.dart';
import '../../../../../main.dart';
import '../../../../shared/clock/clock.dart';
import '../../../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../../../shared/utils/utils_responsive.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/values/image_path.dart';
import '../../../../shared/values/styles.dart';
import '../../../../shared/widget/buttons/button.dart';
import '../../../../shared/widget/containers/container.dart';
import '../../../../shared/widget/containers/dialog.dart';
import '../reset_password/admin_change_password.dart';
import '../screen_bases/header/header.dart';
import '../screen_bases/header/header_CTA.dart';
import 'add_user.dart';
import 'edit_user.dart';

class UserAccessManagement extends StatefulWidget {
  final VoidCallback pauseTimer;
  const UserAccessManagement({super.key, required this.pauseTimer});

  @override
  State<UserAccessManagement> createState() => _UserAccessManagementState();
}

class _UserAccessManagementState extends State<UserAccessManagement> {
  final userAccessColumns = ['Staff ID', 'Username', 'Name', 'Institution', 'Position', 'Email', 'User Role', 'Status', 'Actions'];
  TextEditingController rowsPerPageController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  // ValueNotifier to track which row is hovered
  ValueNotifier<int?> hoveredRowIndex = ValueNotifier<int?>(null);

  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
          label: Text(
            column.toUpperCase(),
            style: TextStyles.heavyBold16Black,
          ),
        ),
      )
      .toList();

  @override
  void initState() {
    super.initState();
    UserProvider userRows = Provider.of<UserProvider>(context, listen: false);
    userRows.fetchAllUsers();
    refreshTableData();
    updateUrl('/User_Management/Access_Management');
    rowsPerPageController.text = '10';
    // searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    rowsPerPageController.dispose();
    super.dispose();
  }

  //REFRESH ALL DATA OF THE TABLE, USED IN A CALLBACK FUNCTION OF ADD AND EDIT USER
  void refreshTableData() {
    UserProvider userRows = Provider.of<UserProvider>(context, listen: false);
    userRows.fetchAllUsers();
  }

  void _updatePageSize(int value) {
    setState(() {
      rowsPerPageController.text = value.toString();
    });
    Provider.of<UserProvider>(context, listen: false).updatePageSize(value);
  }

  // void _onSearchChanged() {
  //   final query = searchController.text;
  //   // debugPrint('Search query: $query');
  //   Provider.of<UserProvider>(context, listen: false).searchUsers(query);
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        padding: const EdgeInsets.only(left: 90),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderBar(screenText: 'USER MANAGEMENT'),
              const SizedBox(height: 5),
              const HeaderCTA(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User Access', style: TextStyles.heavyBold16Black),
                    Text(
                      'Manage accounts with preferred configurations.',
                      style: TextStyles.dataTextStyle,
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ],
                ),
                Spacer(),
                Responsive(desktop: Clock(), mobile: Spacer()),
              ]),
              const SizedBox(height: 25),
              //USER HEADER IS THE ADD BUTTON
              showList(),
              const Divider(color: Colors.black12),
              //THIS IS THE MAIN CONTENT
              Expanded(
                child: userTable(),
              ),
              const SizedBox(height: 10),
              paginationControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget userTable() {
    List<String> headers = ['Staff ID', 'Username', 'Name', 'Institution', 'Position', 'Email', 'User Role', 'Status', 'Actions'];

    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      if (userProvider.currentUsers.isEmpty) {
        return FutureBuilder(
          future: Future.delayed(const Duration(seconds: 2)), // Delay for 2 seconds
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.loadingColor,
                ),
              );
            } else {
              return const Center(child: NoUserFound());
            }
          },
        );
      } else {
        List<AllUserData> userRows = userProvider.currentUsers;

        // Prepare data for column width calculation
        List<Map<String, dynamic>> data = userRows.map((user) {
          return {
            'Staff ID': user.hcisId,
            'Username': user.username,
            'Name': "${user.firstName} ${user.middleName} ${user.lastName}",
            'Institution': user.institution,
            'Position': user.position,
            'Email': user.email,
            'User Role': user.role,
            'Status': user.status,
            'Actions': '', // Placeholder for actions
          };
        }).toList();

        // Calculate column widths based on headers and data
        List<double> columnWidths = getColumnWidths(headers, data);

        ///HOVER VERSION
        // return Stack(
        //   alignment: AlignmentDirectional.center,
        //   children: [
        //     SingleChildScrollView(
        //       scrollDirection: Axis.horizontal,
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Container(
        //             padding: const EdgeInsets.only(left: 30),
        //             decoration: BoxDecoration(color: Colors.black12, border: Border.all(width: 0.5, color: Colors.black12)),
        //             height: 50,
        //             child: Row(
        //               children: buildHeaderCells(headers, columnWidths),
        //             ),
        //           ),
        //           Expanded(
        //             child: SingleChildScrollView(
        //               scrollDirection: Axis.vertical,
        //               child: Column(
        //                 children: userRows.asMap().entries.map((entry) {
        //                   int index = entry.key;
        //                   AllUserData user = entry.value;
        //
        //                   final Color color = index % 2 == 0 ? Colors.transparent : Colors.white;
        //                   final String fullName = "${user.firstName} ${user.middleName} ${user.lastName}";
        //
        //                   return MouseRegion(
        //                     onEnter: (_) => hoveredRowIndex.value = index,
        //                     onExit: (_) => hoveredRowIndex.value = null,
        //                     child: ValueListenableBuilder<int?>(
        //                       valueListenable: hoveredRowIndex,
        //                       builder: (context, hoveredIndex, _) {
        //                         bool isHovered = hoveredIndex == index;
        //
        //                         return Container(
        //                           padding: const EdgeInsets.only(left: 30),
        //                           decoration: BoxDecoration(
        //                             color: color,
        //                             border: const Border(
        //                               top: BorderSide.none,
        //                               bottom: BorderSide(width: 0.5, color: Colors.black12),
        //                               left: BorderSide(width: 0.5, color: Colors.black12),
        //                               right: BorderSide(width: 0.5, color: Colors.black12),
        //                             ),
        //                           ),
        //                           child: Row(
        //                             children: [
        //                               buildDataCell(user.hcisId.toString(), columnWidths[0]),
        //                               buildDataCell(user.username!, columnWidths[1]),
        //                               buildDataCell(fullName, columnWidths[2]),
        //                               buildDataCell(user.institution!, columnWidths[3]),
        //                               buildDataCell(user.position!, columnWidths[4]),
        //                               buildDataCell(user.email!, columnWidths[5]),
        //                               buildDataCell(user.role!, columnWidths[6]),
        //                               Container(
        //                                 width: columnWidths[7],
        //                                 padding: const EdgeInsets.all(10),
        //                                 child: Row(
        //                                   children: [
        //                                     Container(
        //                                       margin: const EdgeInsets.only(right: 3),
        //                                       decoration: BoxDecoration(
        //                                         color: user.status == 'Active' ? AppColors.sidePanel4 : AppColors.maroon4,
        //                                         shape: BoxShape.circle,
        //                                       ),
        //                                       width: 8,
        //                                       height: 8,
        //                                     ),
        //                                     Text(user.status ?? ''),
        //                                   ],
        //                                 ),
        //                               ),
        //                               if (isHovered)
        //                                 Stack(
        //                                   children: [
        //                                     Container(
        //                                       width: columnWidths[8],
        //                                       padding: const EdgeInsets.all(10),
        //                                       child: Row(
        //                                         children: [
        //                                           Tooltip(
        //                                             message: 'Edit user',
        //                                             child: InkWell(
        //                                               child: Image.asset(
        //                                                 fit: BoxFit.fitHeight,
        //                                                 ImagePath.editIcon,
        //                                                 height: 15,
        //                                                 width: 15,
        //                                               ),
        //                                               onTap: () async {
        //                                                 final getUserID = Provider.of<UserProvider>(context, listen: false);
        //                                                 await getUserID.fetchSingleUser(user.id!);
        //                                                 final setUserID = user.id!;
        //                                                 AddNewUser.setID(setUserID);
        //                                                 showGeneralDialog(
        //                                                   context: navigatorKey.currentContext!,
        //                                                   barrierColor: Colors.black54,
        //                                                   transitionDuration: Duration(milliseconds: 200),
        //                                                   pageBuilder: (context, animation, secondaryAnimation) => EditUserPage(
        //                                                     user: AllUserData(
        //                                                       id: 0,
        //                                                       institution: '',
        //                                                       hcisId: '',
        //                                                       role: '',
        //                                                       firstName: '',
        //                                                       middleName: '',
        //                                                       lastName: '',
        //                                                       position: '',
        //                                                       contact: '',
        //                                                       email: '',
        //                                                       username: '',
        //                                                       branch: '',
        //                                                       unit: '',
        //                                                       centerCode: '',
        //                                                       birthday: '',
        //                                                     ),
        //                                                     onSuccessSubmission: refreshTableData,
        //                                                   ),
        //                                                   barrierDismissible: false,
        //                                                   transitionBuilder: (context, animation, secondaryAnimation, child) {
        //                                                     return FadeTransition(
        //                                                       opacity: animation,
        //                                                       child: child,
        //                                                     );
        //                                                   },
        //                                                 );
        //                                               },
        //                                             ),
        //                                           ),
        //                                           const SizedBox(width: 5),
        //                                           const SizedBox(width: 5),
        //                                           SizedBox(
        //                                             width: 20,
        //                                             child: Transform.scale(
        //                                               scale: 0.4,
        //                                               child: Switch.adaptive(
        //                                                 activeColor: Colors.green.shade900,
        //                                                 inactiveThumbColor: Colors.grey,
        //                                                 inactiveTrackColor: Colors.grey.shade400,
        //                                                 value: userProvider.switchStates[user.id] ?? false,
        //                                                 onChanged: (value) {
        //                                                   _showAlertDialog(context, value, user.id!);
        //                                                 },
        //                                               ),
        //                                             ),
        //                                           ),
        //                                           const SizedBox(width: 5),
        //                                           Tooltip(
        //                                             message: 'Reset password',
        //                                             child: InkWell(
        //                                               child: Image.asset(
        //                                                 fit: BoxFit.fitHeight,
        //                                                 ImagePath.resetPasswordIcon,
        //                                                 height: 15,
        //                                                 width: 15,
        //                                               ),
        //                                               onTap: () async {
        //                                                 final getUserID = Provider.of<UserProvider>(context, listen: false);
        //                                                 await getUserID.fetchSingleUser(user.id!);
        //                                                 final setUserID = user.id!;
        //                                                 final userEmail = getUserID.mwapemail;
        //                                                 AddNewUser.setID(setUserID);
        //                                                 AddNewUser.setEmailAddress(userEmail);
        //                                                 showGeneralDialog(
        //                                                   context: navigatorKey.currentContext!,
        //                                                   barrierColor: Colors.black54,
        //                                                   transitionDuration: Duration(milliseconds: 500),
        //                                                   pageBuilder: (context, animation, secondaryAnimation) => AdminChangePassword(),
        //                                                   barrierDismissible: false,
        //                                                   transitionBuilder: (context, animation, secondaryAnimation, child) {
        //                                                     return SlideTransition(
        //                                                       position: Tween<Offset>(
        //                                                         begin: const Offset(0, -2),
        //                                                         end: Offset.zero,
        //                                                       ).animate(animation),
        //                                                       child: child,
        //                                                     );
        //                                                   },
        //                                                 );
        //                                               },
        //                                             ),
        //                                           ),
        //                                         ],
        //                                       ),
        //                                     ),
        //                                   ],
        //                                 ),
        //                             ],
        //                           ),
        //                         );
        //                       },
        //                     ),
        //                   );
        //                 }).toList(),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     if (userRows.isEmpty) const NoRecordsFound()
        //   ],
        // );

        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Frozen Header
                  Container(
                    padding: const EdgeInsets.only(left: 30),
                    decoration: BoxDecoration(color: Colors.black12, border: Border.all(width: 0.5, color: Colors.black12)),
                    height: 50,
                    child: Row(
                      children: buildHeaderCells(headers, columnWidths),
                    ),
                  ),
                  // Scrollable Body
                  if (userRows.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: userRows.map<Widget>((user) {
                            final Color color = userRows.indexOf(user) % 2 == 0 ? Colors.transparent : Colors.white;

                            final String fullName = "${user.firstName} ${user.middleName} ${user.lastName}";

                            return Container(
                              padding: const EdgeInsets.only(left: 30),
                              decoration: BoxDecoration(
                                color: color,
                                border: const Border(
                                  top: BorderSide.none,
                                  bottom: BorderSide(width: 0.5, color: Colors.black12),
                                  left: BorderSide(width: 0.5, color: Colors.black12),
                                  right: BorderSide(width: 0.5, color: Colors.black12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  buildDataCell(user.hcisId.toString(), columnWidths[0]),
                                  buildDataCell(user.username!, columnWidths[1]),
                                  buildDataCell(fullName, columnWidths[2]),
                                  buildDataCell(user.institution!, columnWidths[3]),
                                  buildDataCell(user.position!, columnWidths[4]),
                                  buildDataCell(user.email!, columnWidths[5]),
                                  buildDataCell(user.role!, columnWidths[6]),
                                  // Status with a small colored circle
                                  Container(
                                    width: columnWidths[7],
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(right: 3),
                                          decoration: BoxDecoration(
                                            color: user.status == 'Active' ? AppColors.sidePanel4 : AppColors.maroon4,
                                            shape: BoxShape.circle,
                                          ),
                                          width: 8,
                                          height: 8,
                                        ),
                                        Text(user.status ?? ''),
                                      ],
                                    ),
                                  ),
                                  // Actions (Edit and Reset Password icons)
                                  Container(
                                    width: columnWidths[8],
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Tooltip(
                                          message: 'Edit user',
                                          child: InkWell(
                                            child: Image.asset(
                                              fit: BoxFit.fitHeight,
                                              ImagePath.editIcon,
                                              height: 15,
                                              width: 15,
                                            ),
                                            onTap: () async {
                                              final getUserID = Provider.of<UserProvider>(context, listen: false);
                                              await getUserID.fetchSingleUser(user.id!);
                                              final setUserID = user.id!;
                                              AddNewUser.setID(setUserID);
                                              showGeneralDialog(
                                                context: navigatorKey.currentContext!,
                                                barrierColor: Colors.black54,
                                                transitionDuration: Duration(milliseconds: 200),
                                                pageBuilder: (context, animation, secondaryAnimation) => EditUserPage(
                                                  user: AllUserData(
                                                    id: 0,
                                                    institution: '',
                                                    hcisId: '',
                                                    role: '',
                                                    firstName: '',
                                                    middleName: '',
                                                    lastName: '',
                                                    position: '',
                                                    contact: '',
                                                    email: '',
                                                    username: '',
                                                    branch: '',
                                                    unit: '',
                                                    centerCode: '',
                                                    birthday: '',
                                                  ),
                                                  onSuccessSubmission: refreshTableData,
                                                ),
                                                barrierDismissible: false,
                                                transitionBuilder: (context, animation, secondaryAnimation, child) {
                                                  return FadeTransition(
                                                    opacity: animation,
                                                    child: child,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          width: 20,
                                          child: Transform.scale(
                                            scale: 0.4,
                                            child: Switch.adaptive(
                                              activeColor: Colors.green.shade900,
                                              inactiveThumbColor: Colors.grey,
                                              inactiveTrackColor: Colors.grey.shade400,
                                              value: userProvider.switchStates[user.id] ?? false,
                                              onChanged: (value) {
                                                _showAlertDialog(context, value, user.id!);
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Tooltip(
                                          message: 'Reset password',
                                          child: InkWell(
                                            child: Image.asset(
                                              fit: BoxFit.fitHeight,
                                              ImagePath.resetPasswordIcon,
                                              height: 15,
                                              width: 15,
                                            ),
                                            onTap: () async {
                                              final getUserID = Provider.of<UserProvider>(context, listen: false);
                                              await getUserID.fetchSingleUser(user.id!);
                                              final setUserID = user.id!;
                                              final userEmail = getUserID.mwapemail;
                                              AddNewUser.setID(setUserID);
                                              AddNewUser.setEmailAddress(userEmail);
                                              showGeneralDialog(
                                                context: navigatorKey.currentContext!,
                                                barrierColor: Colors.black54,
                                                transitionDuration: Duration(milliseconds: 500),
                                                pageBuilder: (context, animation, secondaryAnimation) => AdminChangePassword(),
                                                barrierDismissible: false,
                                                transitionBuilder: (context, animation, secondaryAnimation, child) {
                                                  return SlideTransition(
                                                    position: Tween<Offset>(
                                                      begin: const Offset(0, -2),
                                                      end: Offset.zero,
                                                    ).animate(animation),
                                                    child: child,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (userRows.isEmpty) const NoRecordsFound()
          ],
        );
      }
    });
  }

  //ROW DATA CELLS
  Widget buildDataCell(String? text, double width) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      width: width,
      // color: Colors.amber,
      height: 40,
      padding: const EdgeInsets.all(10),
      child: Text(
        text ?? '',
        style: TextStyles.dataTextStyle,
        textAlign: TextAlign.left,
      ),
    );
  }

// Helper method to build header cells with specified width
  List<Widget> buildHeaderCells(List<String> headers, List<double> columnWidths) {
    return headers.asMap().entries.map((entry) {
      int index = entry.key;
      String header = entry.value;
      return Container(
        width: columnWidths[index],
        // color: Colors.cyan,
        padding: const EdgeInsets.all(10),
        child: Text(
          header,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.6),
            letterSpacing: .5,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList();
  }

  //Compute maximum width required for each column
  List<double> getColumnWidths(List<String> headers, List<Map<String, dynamic>> data) {
    // Create a list to store the width of each column. Initially set all widths to 0.
    final List<double> widths = List.filled(headers.length, 0.0);

    // Measure the width of each header text.
    for (int i = 0; i < headers.length; i++) {
      final TextPainter painter = TextPainter(
        text: TextSpan(
          text: headers[i],
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      widths[i] = painter.size.width;
    }

    // Measure the width of each data cell and adjust the width of the corresponding column.
    for (var row in data) {
      for (int i = 0; i < headers.length; i++) {
        final value = row[headers[i]] ?? ''; // Get the value for the current column or use an empty string if null
        final TextPainter painter = TextPainter(
          text: TextSpan(
            text: value.toString(),
            style: const TextStyle(fontSize: 14),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        widths[i] = widths[i] > painter.size.width ? widths[i] : painter.size.width;
      }
    }

    // Add padding to each column width to prevent the text from being too close to the edges.
    const double padding = 70.0; // Adjust padding as needed
    for (int i = 0; i < widths.length; i++) {
      widths[i] += padding;
    }

    return widths;
  }
  // Widget userTable() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //         color: Colors.black54,
  //         width: 0.1,
  //         style: BorderStyle.solid,
  //       ),
  //     ),
  //     height: MediaQuery.of(context).size.height,
  //     width: MediaQuery.of(context).size.width,
  //     child: Consumer<UserProvider>(builder: (context, userProvider, _) {
  //       if (userProvider.currentUsers.isEmpty) {
  //         return FutureBuilder(
  //           future: Future.delayed(const Duration(seconds: 2)), // Delay for 2 seconds
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               // Show loading indicator while waiting
  //               return const Center(
  //                 child: CircularProgressIndicator(
  //                   color: AppColors.loadingColor,
  //                 ),
  //               );
  //             } else {
  //               // Show NoUserFound widget after delay
  //               return const Center(
  //                 child: NoUserFound(),
  //               );
  //             }
  //           },
  //         );
  //       } else {
  //         List<AllUserData> userRows = userProvider.currentUsers;
  //
  //         return ScrollBarWidget(
  //           child: DataTableTheme(
  //             data: const DataTableThemeData(
  //               dividerThickness: 0.1,
  //             ),
  //             child: DataTable(
  //               columnSpacing: 85,
  //               border: TableBorder.all(width: 0.1, color: Colors.black54.withOpacity(0.5)),
  //               headingRowColor: MaterialStateColor.resolveWith(
  //                 (states) => Colors.black54.withOpacity(0.2),
  //               ),
  //               headingRowHeight: 60,
  //               dataRowMinHeight: 40,
  //               dataRowMaxHeight: 60,
  //               dataTextStyle: TextStyles.dataTextStyle,
  //               columns: getColumns(userAccessColumns),
  //               rows: userRows.asMap().entries.map((entry) {
  //                 final int index = entry.key;
  //                 final AllUserData userManagement = entry.value;
  //                 final Color color = index % 2 == 0 ? Colors.transparent : Colors.white;
  //                 final fullname = userManagement.firstName! + " " + userManagement.middleName! + " " + userManagement.lastName!;
  //                 return DataRow(
  //                   color: MaterialStateProperty.all(color),
  //                   cells: [
  //                     //date change june 13, 2024
  //                     // DataCell(Text(userManagement.staffID ?? '')),
  //                     // DataCell(Text(userManagement.username ?? '')),
  //                     // DataCell(Text(userManagement.fullName)),
  //                     // DataCell(Text(userManagement.institution ?? '')),
  //                     // DataCell(Text(userManagement.position ?? '')),
  //                     // DataCell(Text(userManagement.emailAddress ?? '')),
  //                     // DataCell(Text(userManagement.userRole ?? '')),
  //
  //                     //mfi_whitelist_admin_portal
  //                     DataCell(Text((userManagement.hcisId ?? 0).toString())),
  //                     DataCell(Text(userManagement.username ?? '')),
  //                     DataCell(Text(fullname ?? '')),
  //                     DataCell(Text(userManagement.institution ?? '')),
  //                     DataCell(Text(userManagement.position ?? '')),
  //                     DataCell(Text(userManagement.email ?? '')),
  //                     DataCell(Text(userManagement.role ?? '')),
  //
  //                     // DataCell(child)
  //
  //                     DataCell(Row(
  //                       children: [
  //                         Container(
  //                           margin: const EdgeInsets.only(right: 3),
  //                           decoration: BoxDecoration(
  //                             color: userManagement.status == 'Active' ? AppColors.sidePanel4 : AppColors.maroon4,
  //                             shape: BoxShape.circle,
  //                           ),
  //                           width: 8,
  //                           height: 8,
  //                         ),
  //                         Text(userManagement.status ?? ''),
  //                       ],
  //                     )),
  //                     DataCell(
  //                       Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Tooltip(
  //                             message: 'Edit user',
  //                             child: InkWell(
  //                               child: Image.asset(
  //                                 fit: BoxFit.fitHeight,
  //                                 ImagePath.editIcon,
  //                                 height: 15,
  //                                 width: 15,
  //                               ),
  //                               onTap: () async {
  //                                 final getUserID = Provider.of<UserProvider>(context, listen: false);
  //                                 await getUserID.fetchSingleUser(userManagement.id!);
  //                                 final setUserID = userManagement.id!;
  //
  //                                 AddNewUser.setID(setUserID);
  //
  //                                 // print('store in provider from usermanagement== ${userManagement.role}');
  //                                 // print('store in provider from usermanagement== ${userManagement.institution}');
  //                                 // print('store in provider from usermanagement== ${userManagement.centerCode}');
  //
  //                                 showGeneralDialog(
  //                                   context: navigatorKey.currentContext!,
  //                                   barrierColor: Colors.black54,
  //                                   transitionDuration: Duration(milliseconds: 200),
  //                                   pageBuilder: (context, animation, secondaryAnimation) => EditUserPage(
  //                                       user: AllUserData(
  //                                         id: 0,
  //                                         institution: '',
  //                                         hcisId: '',
  //                                         role: '',
  //                                         firstName: '',
  //                                         middleName: '',
  //                                         lastName: '',
  //                                         position: '',
  //                                         contact: '',
  //                                         email: '',
  //                                         username: '',
  //                                         branch: '',
  //                                         unit: '',
  //                                         centerCode: '',
  //                                         birthday: '',
  //                                       ),
  //                                       onSuccessSubmission: refreshTableData),
  //                                   barrierDismissible: false,
  //                                   transitionBuilder: (context, animation, secondaryAnimation, child) {
  //                                     return FadeTransition(
  //                                       opacity: animation,
  //                                       child: child,
  //                                     );
  //                                   },
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //                           const SizedBox(width: 5),
  //                           SizedBox(
  //                             width: 20,
  //                             child: Transform.scale(
  //                               scale: 0.4,
  //                               child: Switch.adaptive(
  //                                 activeColor: Colors.green.shade900,
  //                                 inactiveThumbColor: Colors.grey,
  //                                 inactiveTrackColor: Colors.grey.shade400,
  //                                 value: userProvider.switchStates[userManagement.id] ?? false,
  //                                 onChanged: (value) {
  //                                   _showAlertDialog(context, value, userManagement.id!);
  //                                 },
  //                               ),
  //                             ),
  //                           ),
  //                           const SizedBox(width: 5),
  //                           Tooltip(
  //                             message: 'Reset password',
  //                             child: InkWell(
  //                               child: Image.asset(
  //                                 fit: BoxFit.fitHeight,
  //                                 ImagePath.resetPasswordIcon,
  //                                 height: 15,
  //                                 width: 15,
  //                               ),
  //                               onTap: () async {
  //                                 final getUserID = Provider.of<UserProvider>(context, listen: false);
  //                                 await getUserID.fetchSingleUser(userManagement.id!);
  //                                 final setUserID = userManagement.id!;
  //                                 final userEmail = getUserID.mwapemail;
  //                                 AddNewUser.setID(setUserID);
  //                                 AddNewUser.setEmailAddress(userEmail);
  //
  //                                 showGeneralDialog(
  //                                   context: navigatorKey.currentContext!,
  //                                   barrierColor: Colors.black54,
  //                                   transitionDuration: Duration(milliseconds: 500),
  //                                   pageBuilder: (context, animation, secondaryAnimation) => AdminChangePassword(),
  //                                   barrierDismissible: false,
  //                                   transitionBuilder: (context, animation, secondaryAnimation, child) {
  //                                     return SlideTransition(
  //                                       position: Tween<Offset>(
  //                                         begin: const Offset(0, -2),
  //                                         end: Offset.zero,
  //                                       ).animate(animation),
  //                                       child: child,
  //                                     );
  //                                   },
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   ],
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         );
  //       }
  //     }),
  //   );
  // }

  void _showAlertDialog(BuildContext context, bool newValue, int userId) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialogWidget(
        titleText: "Confirmation",
        contentText: newValue ? "Are you sure you want to activate this user?" : "Are you sure you want to deactivate this user?",
        positiveButtonText: newValue ? "Activate" : "Deactivate",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          Navigator.of(context).pop(); // Close dialog
          activatedDeactivateUser(newValue, userId); // Activate or deactivate user with specific ID
        },
        iconData: newValue ? Icons.info_outline : Icons.warning_amber,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  void activatedDeactivateUser(bool activate, int userId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = getToken();
    await userProvider.setUserStatus(userId, token!, activate);
    userProvider.fetchAllUsers(); // Refresh the user data after update
  }

  Widget paginationControls() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        bool isFirstPage = userProvider.currentPage == 0;
        bool isLastPage = userProvider.currentPage == userProvider.totalPages - 1;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: !isFirstPage ? AppColors.maroon2 : Colors.grey.shade400,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 12,
                ),
                color: Colors.white,
                onPressed: !isFirstPage ? userProvider.previousPage : null,
              ),
            ),
            const SizedBox(width: 30),
            Column(
              children: [
                Consumer<UserProvider>(
                  builder: (context, userProvider, _) {
                    return Text(
                      'PAGE ${userProvider.currentPage + 1} OF ${userProvider.totalPages}',
                      style: const TextStyle(
                        fontFamily: 'RobotoThin',
                        fontSize: 10,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    );
                  },
                ),
                Consumer<UserProvider>(
                  builder: (context, userProvider, _) {
                    return Text(
                      'Total Number of Users: ${userProvider.totalRecords}',
                      style: const TextStyle(
                        fontFamily: 'RobotoThin',
                        fontSize: 10,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(width: 30),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: !isLastPage ? AppColors.maroon2 : Colors.grey.shade400,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: IconButton(
                color: Colors.white,
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                ),
                onPressed: !isLastPage ? userProvider.nextPage : null,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget rowShowList() {
    return ShowListWidget(rowsPerPageController: rowsPerPageController, rowsPerPage: rowsPerPageController.text, onPageSizeChange: _updatePageSize);
    // return Row(
    //   children: [
    //     const Text(
    //       'Show',
    //       style: TextStyle(fontFamily: 'RobotoThin', color: Colors.black54, fontSize: 12),
    //     ),
    //     const SizedBox(width: 5),
    //     SizedBox(
    //       width: 35,
    //       height: 30,
    //       child: TextField(
    //         style: const TextStyle(fontFamily: 'RobotoThin', fontSize: 11, color: Colors.black54),
    //         controller: rowsPerPageController,
    //         textAlignVertical: TextAlignVertical.top,
    //         cursorColor: AppColors.maroon2,
    //         cursorWidth: 1,
    //         cursorRadius: const Radius.circular(5),
    //         decoration: InputDecoration(
    //           contentPadding: const EdgeInsets.all(10),
    //           filled: true,
    //           fillColor: Colors.transparent,
    //           focusedBorder: const OutlineInputBorder(
    //             borderSide: BorderSide(
    //               color: AppColors.maroon2,
    //               width: 0.5,
    //             ),
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(5),
    //               bottomLeft: Radius.circular(5),
    //               topRight: Radius.circular(0),
    //               bottomRight: Radius.circular(0),
    //             ),
    //           ),
    //           enabledBorder: const OutlineInputBorder(
    //             borderSide: BorderSide(
    //               color: AppColors.maroon2,
    //               width: 0.5,
    //             ),
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(5),
    //               bottomLeft: Radius.circular(5),
    //               topRight: Radius.circular(0),
    //               bottomRight: Radius.circular(0),
    //             ),
    //           ),
    //           border: const OutlineInputBorder(
    //             borderSide: BorderSide(
    //               style: BorderStyle.solid,
    //               color: AppColors.maroon2,
    //               width: 0.5,
    //             ),
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(5),
    //               bottomLeft: Radius.circular(5),
    //               topRight: Radius.circular(0),
    //               bottomRight: Radius.circular(0),
    //             ),
    //           ),
    //           hintText: rowsPerPageController.text,
    //           hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 11, color: Colors.black54),
    //         ),
    //         readOnly: true,
    //       ),
    //     ),
    //     Container(
    //       height: 30,
    //       decoration: const BoxDecoration(
    //         border: Border(
    //           top: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
    //           right: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
    //           bottom: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
    //         ),
    //         borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
    //         color: AppColors.maroon2,
    //       ),
    //       child: PopupMenuButton<int>(
    //         splashRadius: 20,
    //         icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.white),
    //         onSelected: _updatePageSize,
    //         itemBuilder: (BuildContext context) {
    //           return [10, 20, 30, 40, 50].map((int value) {
    //             return PopupMenuItem<int>(
    //               height: 20,
    //               value: value,
    //               child: Center(
    //                 child: Text(
    //                   value.toString(),
    //                   style: const TextStyle(
    //                     fontFamily: 'RobotoThin',
    //                     color: Colors.black54,
    //                     fontSize: 12,
    //                   ),
    //                 ),
    //               ),
    //             );
    //           }).toList();
    //         },
    //         elevation: 8,
    //       ),
    //     ),
    //     const SizedBox(width: 5),
    //     const Text(
    //       'List',
    //       style: TextStyle(fontFamily: 'RobotoThin', color: Colors.black54, fontSize: 12),
    //     ),
    //   ],
    // );
  }

  Widget showList() {
    return Row(
      children: [
        rowShowList(),
        const SizedBox(width: 10),
        // DynamicSearchBar(
        //   searchWidth: 180,
        //   searchHeight: 30,
        //   radius: 5.0,
        //   color: AppColors.dialogColor,
        //   controller: searchController,
        //   onChanged: (value) {
        //     _onSearchChanged();
        //   },
        // ),
        const Spacer(),
        MyButton.buttonWithLabel(
            context,
            () => showGeneralDialog(
                  context: navigatorKey.currentContext!,
                  barrierColor: Colors.black54,
                  transitionDuration: Duration(milliseconds: 200),
                  pageBuilder: (context, animation, secondaryAnimation) => AddUser(onSuccessSubmission: refreshTableData),
                  barrierDismissible: false,
                  transitionBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
            'Add User',
            Icons.add,
            AppColors.maroon2),
      ],
    );
  }
}
