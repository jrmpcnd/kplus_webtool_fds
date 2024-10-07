import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/disburse_model.dart';
import 'package:mfi_whitelist_admin_portal/core/provider/mfi/loan_disburse_provider.dart';
import 'package:mfi_whitelist_admin_portal/main.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/clientmanagement/client_list/approve_disapprove/approved_disapproved_actions.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/clientmanagement/client_list/approve_disapprove/topup_approved_disapproved_actions.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/teller_management/loan_disburse/loan_files/preview_loan_file.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/header/header.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/header/header_CTA.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/clock/clock.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/container.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/search_bar.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/fields/show_list.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/scrollable/scrollable_widget.dart';
import 'package:provider/provider.dart';

import '../../../../shared/utils/utils_responsive.dart';

class UploadedDisburseFilesScreen extends StatefulWidget {
  const UploadedDisburseFilesScreen({super.key});

  @override
  State<UploadedDisburseFilesScreen> createState() => _UploadedDisburseFilesScreenState();
}

class _UploadedDisburseFilesScreenState extends State<UploadedDisburseFilesScreen> {
  final buildColumnItems = ['File Name', 'Date and Time Uploaded', 'Teller', 'Status', 'HCIS', 'Institution', 'Actions'];
  final role = getUrole();
  final formKey = GlobalKey<FormState>();
  TextEditingController rowsPerPageController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  int rowsPerPage = 10; // Initial value

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
    LoanDisbursementProvider userRows = Provider.of<LoanDisbursementProvider>(context, listen: false);
    userRows.fetchAllFiles();
    refreshTableData();
    updateUrl('/Access/Loan_Disbursement/Loan_Disbursement_Files');
    rowsPerPageController.text = rowsPerPage.toString();
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
    LoanDisbursementProvider userRows = Provider.of<LoanDisbursementProvider>(context, listen: false);
    userRows.fetchAllFiles();
  }

  void _onSearchChanged() {
    final query = searchController.text;
    // debugPrint('Search query: $query');
    Provider.of<LoanDisbursementProvider>(context, listen: false).searchFromFile(query);
  }

  void _updatePageSize(int value) {
    setState(() {
      rowsPerPage = value;
      rowsPerPageController.text = value.toString();
    });
    Provider.of<LoanDisbursementProvider>(context, listen: false).updatePageSize(value);
  }

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HeaderBar(screenText: 'LOAN DISBURSEMENT FILES'),
              const HeaderCTA(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Uploaded Loan Disbursed', style: TextStyles.heavyBold16Black),
                    Text(
                      'Manage files for disbursed loans.',
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
              Responsive(
                desktop: Row(
                  children: [showList(), const Spacer(), showSearchBar()],
                ),
                mobile: Wrap(
                  runSpacing: 10,
                  children: [showList(), showSearchBar()],
                ),
              ),
              const SizedBox(height: 20),
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

  Widget showList() {
    return ShowListWidget(
      rowsPerPageController: rowsPerPageController,
      rowsPerPage: rowsPerPageController.text,
      onPageSizeChange: _updatePageSize,
    );
  }

  Widget showSearchBar() {
    return DynamicSearchBar(
      searchWidth: 400,
      searchHeight: 35,
      radius: 5.0,
      hintText: 'Search by file name',
      color: Colors.transparent,
      controller: searchController,
      onChanged: (value) {
        _onSearchChanged();
      },
    );
  }

  Widget paginationControls() {
    return Consumer<LoanDisbursementProvider>(
      builder: (context, disburseProvider, _) {
        bool isFirstPage = disburseProvider.currentPage == 0;
        bool isLastPage = disburseProvider.currentPage == disburseProvider.totalPages - 1;
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
                onPressed: !isFirstPage ? disburseProvider.previousPage : null,
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Consumer<LoanDisbursementProvider>(
                  builder: (context, disburseProvider, _) {
                    return Text(
                      'PAGE ${disburseProvider.currentPage + 1} OF ${disburseProvider.totalPages}',
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
                Consumer<LoanDisbursementProvider>(
                  builder: (context, fileProvider, _) {
                    return Text(
                      'Total Number of Files: ${fileProvider.totalRecords}',
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
            const Spacer(),
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
                onPressed: !isLastPage ? disburseProvider.nextPage : null,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget userTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
          width: 0.1,
          style: BorderStyle.solid,
        ),
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Consumer<LoanDisbursementProvider>(builder: (context, disburseProvider, _) {
        if (disburseProvider.currentUsers.isEmpty) {
          return FutureBuilder(
            future: Future.delayed(const Duration(seconds: 2)), // Delay for 2 seconds
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading indicator while waiting
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.maroon2,
                  ),
                );
              } else {
                // Show NoUserFound widget after delay
                return const Center(
                  child: NoFileFound(),
                );
              }
            },
          );
        } else {
          List<UploadedLoanDisburseFile> userRows = disburseProvider.currentUsers;
          return ScrollBarWidget(
            child: DataTableTheme(
              data: const DataTableThemeData(
                dividerThickness: 0.1,
              ),
              child: DataTable(
                columnSpacing: 100,
                // border: TableBorder.all(width: 0.1, color: Colors.black54.withOpacity(0.5)),
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.blueGrey.withOpacity(0.2),
                ),
                headingRowHeight: 70,
                dataRowMinHeight: 40,
                dataRowMaxHeight: 60,
                dataTextStyle: TextStyles.normal14Black,
                columns: getColumns(buildColumnItems),
                rows: userRows.asMap().entries.map((entry) {
                  // final int index = entry.key;
                  final UploadedLoanDisburseFile userManagement = entry.value;
                  // final Color color = index % 2 == 0 ? Colors.transparent : Colors.white;
                  return DataRow(
                    // color: MaterialStateProperty.all(color),
                    cells: [
                      //mfi_whitelist_admin_portal
                      DataCell(Text(userManagement.fileName ?? '')),
                      DataCell(Text(DateFormat('yyyy MMM d hh:mm:ss a').format(DateTime.parse(userManagement.dateAndTimeUploaded!)))),
                      DataCell(Text(userManagement.maker ?? '')),
                      DataCell(
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              width: 150,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: _getStatusColor(userManagement.status).withOpacity(0.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getStatusColor(userManagement.status).withOpacity(0.2), // Shadow color
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(3, 3), // Shadow position
                                  ),
                                  const BoxShadow(
                                    color: Colors.white,
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(-3, -3), // Inset shadow position
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  userManagement.status?.toUpperCase() ?? '', // Ensure text is uppercase
                                  style: TextStyle(
                                    color: _getStatusColor(userManagement.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(
                        userManagement.hcisId ?? '',
                        maxLines: 2,
                      )),
                      DataCell(Text(userManagement.insti ?? '')),
                      DataCell(Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (role == 'Maker' || role == 'Teller')
                            Tooltip(
                              message: 'Preview File',
                              child: InkWell(
                                child: const Icon(Icons.remove_red_eye, color: AppColors.infoColor, size: 20),
                                onTap: () async {
                                  showGeneralDialog(
                                    context: navigatorKey.currentContext!,
                                    barrierColor: Colors.black54,
                                    transitionDuration: const Duration(milliseconds: 300),
                                    pageBuilder: (context, animation, secondaryAnimation) => PreviewLoanDisburseFile(
                                      fileName: userManagement.fileName!,
                                      batchID: userManagement.batchLoanDisbursementFileId!,
                                      status: userManagement.status!,
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
                          if (role == 'Maker' || role == 'Teller') ...[
                            const SizedBox(width: 5),
                            Tooltip(
                              message: 'Download File',
                              child: InkWell(
                                child: const Icon(Icons.download_rounded, color: AppColors.reLoginColor, size: 20),
                                onTap: () async {
                                  int batchDisburseFileId = userManagement.batchLoanDisbursementFileId!;
                                  String file = userManagement.fileName!;
                                  debugPrint('File to download $file');
                                  debugPrint('ID to download ${batchDisburseFileId.toString()}');
                                  showDownloadButtonAlertDialog(userManagement.fileName!, () async {
                                    await ClientTopUpActions.downloadLoanDisbursementFile(batchDisburseFileId, file, refreshTableData);
                                  });
                                },
                              ),
                            ),
                          ]
                        ],
                      ))
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        }
      }),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'UPLOADED':
        return Colors.orange.shade600; // Yellow color for Pending status
      case '':
        return Colors.green.shade600; // Green color for Approved status
      default:
        return Colors.transparent; // Default color (you can change this as per your design)
    }
  }
}
