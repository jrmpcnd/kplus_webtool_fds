import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/allFilesModel.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/clientmanagement/client_topup_list/topup_provider.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/buttons/button.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/container.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/scrollable/scrollable_widget.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../shared/clock/clock.dart';
import '../../../shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import '../../../shared/utils/utils_responsive.dart';
import '../../../shared/values/colors.dart';
import '../../../shared/widget/containers/search_bar.dart';
import '../../../shared/widget/fields/show_list.dart';
import '../../user_management/ui/screen_bases/header/header.dart';
import '../../user_management/ui/screen_bases/header/header_CTA.dart';
import '../client_list/approve_disapprove/approved_disapproved_actions.dart';
import '../client_list/approve_disapprove/topup_approved_disapproved_actions.dart';
import '../client_topup_list/pending_clients.dart';

class PendingTopUpClients extends StatefulWidget {
  const PendingTopUpClients({super.key});

  @override
  State<PendingTopUpClients> createState() => _PendingTopUpClientsState();
}

class _PendingTopUpClientsState extends State<PendingTopUpClients> {
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
    TopupMFIClientProvider userRows = Provider.of<TopupMFIClientProvider>(context, listen: false);
    userRows.fetchAllFiles();
    refreshTableData();
    updateUrl('/Access/Top_Up/Top_Up_Files');
    // searchController.addListener(_onSearchChanged);

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
    TopupMFIClientProvider userRows = Provider.of<TopupMFIClientProvider>(context, listen: false);
    userRows.fetchAllFiles();
  }

  void _onSearchChanged() {
    final query = searchController.text;
    // debugPrint('Search query: $query');
    Provider.of<TopupMFIClientProvider>(context, listen: false).searchFromFile(query);
  }

  void _updatePageSize(int value) {
    setState(() {
      rowsPerPage = value;
      rowsPerPageController.text = value.toString();
    });
    Provider.of<TopupMFIClientProvider>(context, listen: false).updatePageSize(value);
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
              const HeaderBar(screenText: 'TOP UP FILES'),
              const HeaderCTA(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Uploaded Top Up Files', style: TextStyles.heavyBold16Black),
                    Text(
                      'Manage files for E-wallet top-up.',
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
    return Consumer<TopupMFIClientProvider>(
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
            const Spacer(),
            Column(
              children: [
                Consumer<TopupMFIClientProvider>(
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
                Consumer<TopupMFIClientProvider>(
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
                onPressed: !isLastPage ? userProvider.nextPage : null,
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
      child: Consumer<TopupMFIClientProvider>(builder: (context, userProvider, _) {
        if (userProvider.currentUsers.isEmpty) {
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
          List<AllTopUpUploadedFilesData> userRows = userProvider.currentUsers;
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
                  final AllTopUpUploadedFilesData userManagement = entry.value;
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
                          if (role == 'Checker')
                            SizedBox(
                              height: 40,
                              child: CustomColoredButton.primaryButtonWithText(
                                  context,
                                  5,
                                  () => showGeneralDialog(
                                        context: navigatorKey.currentContext!,
                                        barrierColor: Colors.black54,
                                        transitionDuration: const Duration(milliseconds: 300),
                                        pageBuilder: (context, animation, secondaryAnimation) => PendingTopupClientPerFiles(
                                          fileName: userManagement.fileName!,
                                          batchID: userManagement.batchTopupFileId!,
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
                                      ),
                                  AppColors.infoColor,
                                  'VIEW'),
                            ),
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
                                    pageBuilder: (context, animation, secondaryAnimation) => PendingTopupClientPerFiles(
                                      fileName: userManagement.fileName!,
                                      batchID: userManagement.batchTopupFileId!,
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
                            // Tooltip(
                            //   message: 'Delete File',
                            //   child: InkWell(
                            //     onTap: userManagement.status?.toUpperCase() == 'DISAPPROVED' || userManagement.status?.toUpperCase() == 'PENDING'
                            //         ? () async {
                            //       int batchUploadID = userManagement.batchTopupFileId!;
                            //       String filename = userManagement.fileName!;
                            //       debugPrint('File to delete $filename');
                            //       debugPrint('ID to delete ${batchUploadID.toString()}');
                            //       showDeleteButtonAlertDialog(userManagement.fileName!, () async {
                            //         await ClientActions.deleteClients(batchUploadID, filename, refreshTableData);
                            //       });
                            //     }
                            //         : null,
                            //     child: Icon(Icons.delete, color: userManagement.status?.toUpperCase() == '' ? AppColors.maroon4 : Colors.grey, size: 20),
                            //   ),
                            // ),
                            const SizedBox(width: 5),
                            Tooltip(
                              message: 'Download File',
                              child: InkWell(
                                child: const Icon(Icons.download_rounded, color: AppColors.reLoginColor, size: 20),
                                onTap: () async {
                                  int batchTopupFileId = userManagement.batchTopupFileId!;
                                  String file = userManagement.fileName!;
                                  debugPrint('File to download $file');
                                  debugPrint('ID to download ${batchTopupFileId.toString()}');
                                  showDownloadButtonAlertDialog(userManagement.fileName!, () async {
                                    await ClientTopUpActions.downloadTopUpClients(batchTopupFileId, file, refreshTableData);
                                  });
                                },
                              ),
                            ),
                          ]
                          // else if (role == 'Checker') ...[
                          //   Tooltip(
                          //     message: 'Approve File',
                          //     child: InkWell(
                          //       onTap: userManagement.status?.toUpperCase() == 'PENDING'
                          //           ? () async {
                          //               int batchUploadID = userManagement.batchUploadId!;
                          //               debugPrint('ID to approve ${batchUploadID.toString()}');
                          //               showApproveButtonAlertDialog(userManagement.fileName!, () async {
                          //                 await ClientActions.approveClients(batchUploadID, refreshTableData);
                          //               });
                          //             }
                          //           : null,
                          //       child: Icon(Icons.approval_rounded, color: userManagement.status?.toUpperCase() == 'PENDING' ? AppColors.reLoginColor : Colors.grey, size: 20),
                          //     ),
                          //   ),
                          //   const SizedBox(width: 5),
                          //   Tooltip(
                          //     message: 'Disapprove File',
                          //     child: InkWell(
                          //       onTap: userManagement.status?.toUpperCase() == 'PENDING'
                          //           ? () async {
                          //               int batchUploadID = userManagement.batchUploadId!;
                          //               debugPrint('ID to disapprove ${batchUploadID.toString()}');
                          //               showDisapproveButtonAlertDialog(
                          //                 userManagement.fileName!,
                          //                 (remarks) async {
                          //                   await ClientActions.disapproveClients(batchUploadID, remarks, refreshTableData);
                          //                   debugPrint('Remarks from UI : $remarks');
                          //                 },
                          //               );
                          //             }
                          //           : null,
                          //       child: Icon(Icons.cancel_schedule_send, color: userManagement.status?.toUpperCase() == 'PENDING' ? AppColors.maroon4 : Colors.grey, size: 20),
                          //     ),
                          //   ),
                          // ],
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
