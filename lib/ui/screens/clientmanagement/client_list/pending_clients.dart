import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/toast.dart';

import '../../../../core/mfi_whitelist_api/clients/clients_api.dart';
import '../../../../core/service/url_getter_setter.dart';
import '../../../../main.dart';
import '../../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../../shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import '../../../shared/values/colors.dart';
import '../../../shared/values/styles.dart';
import '../../../shared/widget/buttons/button.dart';
import '../../../shared/widget/containers/dialog.dart';
import '../../../shared/widget/pagination/pagination_button.dart';
import '../../../shared/widget/scrollable/scrollable_widget.dart';

class PendingClientPerFile extends StatefulWidget {
  final String fileName;
  final String status;
  final int batchID;
  final Function() onSuccessSubmission;
  const PendingClientPerFile({Key? key, required this.fileName, required this.status, required this.batchID, required this.onSuccessSubmission}) : super(key: key);

  @override
  State<PendingClientPerFile> createState() => _PendingClientPerFileState();
}

class _PendingClientPerFileState extends State<PendingClientPerFile> {
  final urole = getUrole();
  final token = getToken();

  final formKey = GlobalKey<FormState>();
  TextEditingController remarksController = TextEditingController();
  TextEditingController rowPerPageController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController batchUploadIDController = TextEditingController();

  List<Map<String, dynamic>> apiData = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isLoading = true; // Add this variable to track loading state
  int totalRecords = 0;
  int totalPages = 0;

  final bool _sortAscending = true;
  bool lastPageReached = false;
  final int _sortColumnIndex = 0;

  List<String> displayFileName = [];
  List<String> _displayPages = [];
  String _selectedItem = '10';

  // Getter for displayPage
  int get displayPage => (totalRecords == 0) ? 0 : (currentPage + 1);

  @override
  void initState() {
    super.initState();
    fetchRows();
    // Add listeners to the controllers to trigger UI updates
    // fileNameController.addListener(_updateButtonState);
    fileNameController = TextEditingController(text: widget.fileName);
    batchUploadIDController = TextEditingController(text: widget.batchID.toString());
    final selectedBatchID = batchUploadIDController.text;

    fetchData(currentPage + 1, int.parse(_selectedItem), int.parse(selectedBatchID), widget.status);

    // Update state when page changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (displayPage == totalPages) {
        setState(() {
          lastPageReached = true; // Set flag when on the last page
        });
      }
    });
  }

  @override
  void dispose() {
    remarksController.dispose();
    fileNameController.dispose();
    super.dispose();
  }

  ///Continue to call setState as usual in your code.
  ///The overridden method ensures that setState is only called when the widget is mounted.
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

//for sorting function
//   void _sortData(int columnIndex, bool ascending) {
//     setState(() {
//       _sortColumnIndex = columnIndex;
//       _sortAscending = ascending;
//
//       apiData.sort((a, b) {
//         dynamic aValue = a.values.toList()[columnIndex];
//         dynamic bValue = b.values.toList()[columnIndex];
//
//         if (aValue is String && bValue is String) {
//           return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
//         } else if (aValue is int && bValue is int) {
//           return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
//         } else if (aValue is DateTime && bValue is DateTime) {
//           return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
//         } else {
//           // Handle other types as needed
//           return 0;
//         }
//       });
//     });
//   }

  Uri generateUrl(int page, int perPage, int batchUploadID, String status) {
    final baseUrl = UrlGetter.getURL();
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Uri.parse('$baseUrl/clients/test/get/all/pending?page=$page&perPage=$perPage&batch_upload_id=$batchUploadID');
      case 'APPROVED':
        return Uri.parse('$baseUrl/clients/test/get/all/approved?page=$page&perPage=$perPage&batch_upload_id=$batchUploadID');
      case 'DISAPPROVED':
        return Uri.parse('$baseUrl/clients/test/get/all/disapproved?page=$page&perPage=$perPage&batch_upload_id=$batchUploadID');
      default:
        throw Exception('Invalid status: $status');
    }
  }

  void fetchData(int page, int perPage, int batchUploadId, String status) async {
    setState(() {
      isLoading = true;
    });

    try {
      final token = getToken();
      final url = generateUrl(page, perPage, batchUploadId, status);
      debugPrint('Request URL $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        if (jsonData['retCode'] == '200') {
          final data = jsonData['data'];

          var batchUploadID = jsonData['data'][0]['batch_upload_id'];
          batchUploadIDController.text = batchUploadID.toString();
          debugPrint('Fetched batch upload id: $batchUploadID');

          if (data is List) {
            setState(() {
              apiData = List<Map<String, dynamic>>.from(data);
              totalRecords = jsonData['totalRecords'];
              totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
              isLoading = false;
              lastPageReached = (currentPage + 1 >= totalPages);
            });
          } else {
            debugPrint('JSON data is not in the expected format');
            setState(() {
              if (mounted) {
                // Update state variables here
                isLoading = false;
                apiData = []; // Clear existing data or update with new data
              }
            });
          }
        } else {
          debugPrint('NO DATA AVAILABLE');
          setState(() {
            if (mounted) {
              // Update state variables here
              isLoading = false;
              apiData = []; // Clear existing data or update with new data
            }
          });
        }
      } else {
        debugPrint('No data fetched: ${response.body}');
        setState(() {
          if (mounted) {
            // Update state variables here
            isLoading = false;
            apiData = []; // Clear existing data or update with new data
          }
        });
      }
    } catch (error) {
      debugPrint('Error fetching data: $error');
      setState(() {
        if (mounted) {
          // Update state variables here
          isLoading = false;
          apiData = []; // Clear existing data or update with new data
        }
      });
    }
  }

  void _initializeData() {
    fetchData(1, int.parse(_selectedItem), widget.batchID, widget.status);
    fetchRows();
  }

  Future<void> fetchRows() async {
    final response = await http.get(
      Uri.parse('${UrlGetter.getURL()}/filters/test/get/all/displaypage'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['retCode'] == '200') {
        final List<dynamic> displayPageList = data['displaypage'];
        setState(() {
          _displayPages = displayPageList.map((page) => page.toString()).toList();
        });
      } else {
        // Handle the case where the response code in the JSON is not '200'
        debugPrint('Error: ${data['message']}');
      }
    } else {
      // Handle the case where the HTTP status code is not 200
      debugPrint('Error: ${response.statusCode}');
    }
  }

  //========Create templated data cell for PAGINATED ROWS=============//
  List<DataRow> getPaginatedRows() {
    const textStyle = TextStyles.dataTextStyle;

    DataCell buildDataCell(String? text, {bool isWatchlisted = false, String? watchlistedType}) {
      return DataCell(
        Center(
          child: isWatchlisted
              ? Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: 150,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: _getWatchlistClassificationColor(watchlistedType).withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: _getWatchlistClassificationColor(watchlistedType).withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(3, 3),
                      ),
                      const BoxShadow(
                        color: Colors.white,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(-3, -3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      watchlistedType?.toUpperCase() ?? '',
                      style: TextStyle(
                        color: _getWatchlistClassificationColor(watchlistedType), // Text color to match the background
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : SelectableText(
                  text ?? '',
                  style: textStyle,
                ),
        ),
      );
    }

    return List<DataRow>.generate(apiData.length, (index) {
      final rowData = apiData[index];
      final color = index % 2 == 0 ? Colors.transparent : Colors.white;

      // Determine if the row should be marked as "Watchlisted"
      final isWatchlisted = rowData['isWatchlisted'] == true;
      final watchlistType = rowData['watchlistedType'];

      return DataRow(
        color: MaterialStateProperty.all(color),
        cells: [
          buildDataCell(isWatchlisted ? 'Watchlist' : '', isWatchlisted: isWatchlisted, watchlistedType: watchlistType),
          buildDataCell(rowData['cid']),
          buildDataCell(rowData['firstName']),
          buildDataCell(rowData['middleName']),
          buildDataCell(rowData['lastName']),
          buildDataCell(rowData['maidenFName']),
          buildDataCell(rowData['maidenMName']),
          buildDataCell(rowData['maidenLName']),
          buildDataCell(rowData['mobileNumber']),
          buildDataCell(rowData['birthday']),
          buildDataCell(rowData['placeOfBirth']),
          buildDataCell(rowData['religion']),
          buildDataCell(rowData['gender']),
          buildDataCell(rowData['civilStatus']),
          buildDataCell(rowData['citizenship']),
          buildDataCell(rowData['presentAddress']),
          buildDataCell(rowData['permanentAddress']),
          buildDataCell(rowData['city']),
          buildDataCell(rowData['province']),
          buildDataCell(rowData['postalCode']),
          buildDataCell(rowData['memberMaidenFName']),
          buildDataCell(rowData['memberMaidenMName']),
          buildDataCell(rowData['memberMaidenLName']),
          buildDataCell(rowData['email']),
          buildDataCell(rowData['institutionCode']),
          buildDataCell(rowData['unitCode']),
          buildDataCell(rowData['centerCode']),
          buildDataCell(rowData['branchCode']),
          buildDataCell(rowData['memberClassification']),
          buildDataCell(rowData['sourceOfFund']),
          buildDataCell(rowData['employerOrBusinessName']),
          buildDataCell(rowData['employerOrBusinessAddress']),
          buildDataCell(rowData['status']),
          buildDataCell(rowData['createdAt']),
          // buildDataCell(rowData['clientClassification']),
        ],
      );
    });
  }

  //========Create templated data cell for COLUMNS=============//
  List<DataColumn> buildDataColumns() {
    final textStyle = TextStyle(
      fontSize: 14,
      color: Colors.black.withOpacity(0.6),
      letterSpacing: .5,
      fontWeight: FontWeight.bold,
    );

    //onTap is an optional function
    DataColumn buildDataColumn(String label, {void Function()? onTap}) {
      return DataColumn(
        label: Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: textStyle),
                if (onTap != null)
                  Icon(
                    _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    color: Colors.black54,
                    size: 15,
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return [
      buildDataColumn('Watchlist'),
      buildDataColumn('CID'),
      buildDataColumn('First Name'),
      buildDataColumn('Middle Name'),
      buildDataColumn('Last Name'),
      buildDataColumn('Spouse First Name'),
      buildDataColumn('Spouse Middle Name'),
      buildDataColumn('Spouse Last Name'),
      buildDataColumn('Mobile Number'),
      buildDataColumn('Birthday'),
      buildDataColumn('Place of Birth'),
      buildDataColumn('Religion'),
      buildDataColumn('Gender'),
      buildDataColumn('Civil Status'),
      buildDataColumn('Citizenship'),
      buildDataColumn('Present Address'),
      buildDataColumn('Permanent Address'),
      buildDataColumn('Present City'),
      buildDataColumn('Present Province'),
      buildDataColumn('Present Postal Code'),
      buildDataColumn('Client Maiden First Name'),
      buildDataColumn('Client Maiden Middle Name'),
      buildDataColumn('Client Maiden Last Name'),
      buildDataColumn('Email'),
      buildDataColumn('Institution Name'),
      buildDataColumn('Unit Name'),
      buildDataColumn('Center Name'),
      buildDataColumn('Branch Name'),
      buildDataColumn('Client Classification'),
      buildDataColumn('Source of Fund'),
      buildDataColumn('Employer/Business Name'),
      buildDataColumn('Employer/Business Address'),
      // buildDataColumn('Government ID'),
      buildDataColumn('Status'),
      buildDataColumn('Created Date'),
      // buildDataColumn('Client Classification'),
    ];
  }

  void nextPage() {
    if (currentPage + 1 < totalPages) {
      setState(() {
        currentPage++; // Update currentPage
      });
      // print('nextPage : $currentPage');
      fetchData(displayPage, int.parse(_selectedItem), widget.batchID, widget.status); // Fetch the next page of data
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--; // Update currentPage
      });
      // print('previousPage : $currentPage');
      fetchData(displayPage, int.parse(_selectedItem), widget.batchID, widget.status); // Fetch the previous page of data
    }
  }

  void _onPageSelected(int page) {
    print('Current page selected : $page');
    setState(() {
      currentPage = page;
      fetchData(currentPage, int.parse(_selectedItem), widget.batchID, widget.status);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the buttons should be enabled
    bool areButtonsEnabled = fileNameController.text.isNotEmpty;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      surfaceTintColor: Colors.white,
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('/images/mwap_header.png'), fit: BoxFit.cover, opacity: 0.5),
          color: AppColors.maroon2,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
        ),
        child: Row(
          children: [
            Text('View Uploaded File : ${widget.status} Clients', style: TextStyles.bold18White),
            const Spacer(),
            Container(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.cancel_presentation,
                    color: Colors.white,
                    size: 30,
                  ),
                )),
          ],
        ),
      ),
      content: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10, top: 5),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //rows&clock
                  Container(
                    padding: const EdgeInsets.only(left: 3, right: 10, top: 5, bottom: 5),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    height: 40,
                    width: 200,
                    child: Row(
                      children: [
                        const Text(
                          'Show',
                          style: TextStyle(
                              fontFamily: 'RobotoThin',
                              // color: Color(0xff1E5128),
                              color: Colors.black54,
                              fontSize: 12),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: TextField(
                            controller: rowPerPageController,
                            textAlignVertical: TextAlignVertical.top,
                            cursorColor: AppColors.maroon2,
                            cursorWidth: 1,
                            cursorRadius: const Radius.circular(5),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: -20, left: 10),
                              filled: true,
                              fillColor: Colors.transparent,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.maroon2,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  topRight: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.maroon2,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  topRight: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  color: AppColors.maroon2,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  topRight: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                ),
                              ),
                              hintText: _selectedItem,
                              hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 11, color: Colors.black54),
                            ),
                            readOnly: true,
                          ),
                        ),
                        Container(
                          height: 40,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
                              right: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
                              bottom: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
                              // left: BorderSide(color: Color(0xff1E5128), width: 0, style: BorderStyle.solid),
                            ),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                            // color: Colors.black26,
                            color: AppColors.maroon2,
                          ),
                          child: PopupMenuButton<String>(
                            splashRadius: 20,
                            icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.white),
                            onSelected: (String selectedItem) {
                              setState(() {
                                _selectedItem = selectedItem;
                                currentPage = 0;
                                _initializeData();
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return _displayPages.map((String type) {
                                return PopupMenuItem<String>(
                                  height: 20,
                                  value: type,
                                  child: Center(
                                    child: Text(
                                      type,
                                      style: const TextStyle(
                                        fontFamily: 'RobotoThin',
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            elevation: 8,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'List',
                          style: TextStyle(fontFamily: 'RobotoThin', color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),

            //FILE TEXT FIELD AND OTHER CTAs
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 3, right: 10, top: 5, bottom: 5),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  height: 40,
                  child: Row(
                    children: [
                      const Text('File Name : ', style: TextStyles.hintText),
                      //file textfield
                      SizedBox(
                        width: 300,
                        height: 35,
                        child: TextField(
                          style: TextStyles.dataTextStyle,
                          controller: fileNameController,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: AppColors.maroon2,
                          cursorWidth: 1,
                          cursorRadius: const Radius.circular(5),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            filled: true,
                            fillColor: Colors.transparent,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.maroon2,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.maroon2,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: AppColors.maroon2,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            // suffixIcon: InkWell(
                            //     onTap: () {
                            //       setState(() {
                            //         fileNameController.clear();
                            //         selectedFileName = '';
                            //         apiData = [];
                            //       });
                            //     },
                            //     child: const Icon(Icons.close, size: 20)),
                            hintText: widget.fileName,
                            hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 11, color: Colors.black54),
                          ),
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(width: 10),
                const Spacer(),
                if (urole == 'Checker' && widget.status.toUpperCase() == 'PENDING')
                  Row(
                    children: [
                      MyButton.buttonWithLabel(
                        context,
                        () => areButtonsEnabled && lastPageReached ? showApproveButtonAlertDialog(context) : null,
                        'Approve',
                        Icons.approval_rounded,
                        lastPageReached ? AppColors.maroon2 : Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      MyButton.buttonWithLabel(
                        context,
                        () => areButtonsEnabled && lastPageReached ? showDisapproveButtonAlertDialog(context) : null,
                        'Disapprove',
                        Icons.cancel_schedule_send,
                        lastPageReached ? AppColors.maroon2 : Colors.grey,
                      ),
                    ],
                  )
                // Row(
                //   children: [
                //     MyButton.buttonWithLabel(
                //       context,
                //       () {
                //         print('Approve Button Clicked: Current Page: $currentPage, Total Pages: $totalPages');
                //         if (areButtonsEnabled && displayPage == totalPages) {
                //           showApproveButtonAlertDialog(context);
                //         } else {
                //           print('Approve button disabled. Current Page: $currentPage, Total Pages: $totalPages');
                //         }
                //       },
                //       'Approve',
                //       Icons.approval_rounded,
                //       areButtonsEnabled && displayPage == totalPages ? AppColors.maroon2 : Colors.grey,
                //     ),
                //     const SizedBox(width: 5),
                //     MyButton.buttonWithLabel(
                //       context,
                //       () {
                //         print('Disapprove Button Clicked: Current Page: $currentPage, Total Pages: $totalPages');
                //         if (areButtonsEnabled && displayPage == totalPages) {
                //           showDisapproveButtonAlertDialog(context);
                //         } else {
                //           print('Disapprove button disabled. Current Page: $currentPage, Total Pages: $totalPages');
                //         }
                //       },
                //       'Disapprove',
                //       Icons.cancel_schedule_send,
                //       areButtonsEnabled && displayPage == totalPages ? AppColors.maroon2 : Colors.grey,
                //     ),
                //   ],
                // )

                // Row(
                //   children: [
                //     MyButton.buttonWithLabel(
                //       context,
                //       () => areButtonsEnabled
                //           ? currentPage == totalPages
                //               ? showApproveButtonAlertDialog(context)
                //               : null
                //           : null,
                //       'Approve',
                //       Icons.approval_rounded,
                //       areButtonsEnabled
                //           ? currentPage == totalPages
                //               ? AppColors.maroon2
                //               : Colors.grey
                //           : Colors.grey,
                //     ),
                //     const SizedBox(width: 5),
                //     MyButton.buttonWithLabel(
                //       context,
                //       () => areButtonsEnabled
                //           ? currentPage == totalPages
                //               ? showDisapproveButtonAlertDialog(context)
                //               : null
                //           : null,
                //       'Disapprove',
                //       Icons.cancel_schedule_send,
                //       areButtonsEnabled
                //           ? currentPage == totalPages
                //               ? AppColors.maroon2
                //               : Colors.grey
                //           : Colors.grey,
                //     ),
                //   ],
                // )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
                // flex: 9,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black54,
                        width: 0.1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.maroon2,
                            ),
                          )
                        : apiData.isEmpty
                            ? Center(
                                child: Text(
                                  'NO DATA AVAILABLE',
                                  style: TextStyle(
                                    fontFamily: 'RobotoThin',
                                    color: Colors.black54.withOpacity(0.5),
                                  ),
                                ),
                              )
                            : ScrollBarWidget(
                                child: DataTableTheme(
                                  data: const DataTableThemeData(
                                    dividerThickness: 0.1,
                                  ),
                                  child: DataTable(
                                    sortColumnIndex: _sortColumnIndex,
                                    sortAscending: _sortAscending,
                                    border: TableBorder.all(width: 0.1, color: Colors.black54.withOpacity(0.5)),
                                    headingRowColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.black54.withOpacity(0.2),
                                    ),
                                    headingRowHeight: 50,
                                    columns: buildDataColumns(),
                                    rows: getPaginatedRows(),
                                  ),
                                ),
                              )
                    // : const NoClientsFound()),
                    )),
            const SizedBox(height: 10),

            //PAGINATION BUTTON CODE
            PaginationControls(currentPage: displayPage, totalPages: totalPages, totalRecords: totalRecords, onPreviousPage: previousPage, onNextPage: nextPage, title: 'Clients')
          ],
        ),
      ),
    );
  }

  Future<void> approvedClientsButton() async {
    int batchUploadID = int.parse(batchUploadIDController.text);
    // debugPrint(batchUploadID.toString());
    // Show loading dialog
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 350,
          height: 100,
          decoration: const BoxDecoration(color: AppColors.dialogColor, borderRadius: BorderRadius.all(Radius.circular(5))),
          child: const SpinKitFadingCircle(color: AppColors.maroon2),
        ),
      ),
    );

    final approvingResponse = await ApproveClientListAPI().approveClientList(batchUploadID);

    Navigator.pop(navigatorKey.currentContext!); //Close the spin kit dialog

    if (approvingResponse.statusCode == 200) {
      showResponseAlertDialog(
        context: navigatorKey.currentContext!,
        isSuccess: true,
        successMessage: "The list of pending clients were approved successfully.",
      );
    } else {
      // String errorMessage = jsonDecode(approvingResponse.body)['message'];
      // showGeneralErrorAlertDialog(context, errorMessage);
      showResponseAlertDialog(
        context: navigatorKey.currentContext!,
        isSuccess: false,
        failureMessage: jsonDecode(approvingResponse.body)['message'],
      );
    }
  }

  Future<void> disapprovedClientsButton(int batchUploadID, String remarks) async {
    // Show loading dialog
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 350,
          height: 100,
          decoration: const BoxDecoration(color: AppColors.dialogColor, borderRadius: BorderRadius.all(Radius.circular(5))),
          child: const SpinKitFadingCircle(color: AppColors.maroon2),
        ),
      ),
    );

    final disapprovingResponse = await DisapproveClientListAPI().disapproveClientList(batchUploadID, remarks);

    Navigator.pop(navigatorKey.currentContext!); //Close the spin kit dialog

    if (disapprovingResponse.statusCode == 200) {
      showResponseAlertDialog(
        context: navigatorKey.currentContext!,
        isSuccess: true,
        successMessage: "The list of pending clients were disapproved.",
      );
    } else {
      // String errorMessage = jsonDecode(disapprovingResponse.body)['message'];
      // showGeneralErrorAlertDialog(context, errorMessage);
      showResponseAlertDialog(
        context: navigatorKey.currentContext!,
        isSuccess: false,
        failureMessage: jsonDecode(disapprovingResponse.body)['message'],
      );
    }
  }

  void showApproveButtonAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Approving Client List",
        contentText: "You will be approving the list of clients from ${widget.fileName}",
        positiveButtonText: "Proceed",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          Navigator.of(context).pop();
          approvedClientsButton();
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  void showDisapproveButtonAlertDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              title: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.infoColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                  ),
                ),
                child: const Text("Disapproving Client List", style: TextStyles.bold18White),
              ),
              titlePadding: const EdgeInsets.all(0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("You will be disapproving the list of clients from ${widget.fileName}", style: TextStyles.normal14Black),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: remarksController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: Theme.of(context).textTheme.labelSmall,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      maxLength: 100,
                    ),
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyles.normal14Black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (remarksController.text.isEmpty) {
                          CustomToast.show(context, 'Kindly write your disapproval remarks.');
                        } else {
                          Navigator.of(context).pop();
                          int batchUploadID = int.parse(batchUploadIDController.text);
                          String remarks = remarksController.text;
                          debugPrint('ID to disapprove ${batchUploadID.toString()}');
                          debugPrint('Remarks $remarks');
                          disapprovedClientsButton(batchUploadID, remarks);
                        }
                      },
                      // onPressed: remarksController.text.isNotEmpty
                      //     ? () async {
                      //         Navigator.of(context).pop();
                      //         int batchUploadID = int.parse(batchUploadIDController.text);
                      //         String remarks = remarksController.text;
                      //         debugPrint('ID to disapprove ${batchUploadID.toString()}');
                      //         debugPrint('Remarks $remarks');
                      //         disapprovedClientsButton(batchUploadID, remarks);
                      //       }
                      //     : CustomToast.show(context, 'Please write a remarks of your disapproval.'),
                      child: const Text(
                        "Proceed",
                        style: TextStyles.normal14Black,
                      ), // Disable button when remarksController is empty
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showResponseAlertDialog({
    required BuildContext context,
    required bool isSuccess,
    String? successMessage,
    String? failureMessage,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        titleText: isSuccess ? "Success" : "Failed",
        contentText: isSuccess ? successMessage ?? '' : failureMessage ?? '',
        positiveButtonText: isSuccess ? "Done" : "Retry",
        positiveOnPressed: () {
          if (isSuccess) {
            Navigator.pop(context);
            Navigator.pop(context);
            widget.onSuccessSubmission();
            // Navigator.pushNamed(context, '/Access/Client_List/Uploaded_Files');
            //Reload the window on success
            // html.window.location.reload();
          } else {
            Navigator.pop(context);
          }
        },
        iconData: isSuccess ? Icons.check_circle_outline : Icons.error_outline,
        titleColor: isSuccess ? AppColors.ngoColor : AppColors.maroon2,
        iconColor: Colors.white,
      ),
    );
  }

  Color _getWatchlistClassificationColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'WATCHLIST':
        return Colors.amberAccent; // Yellow color for Pending status
      case 'HIGH RISK':
        return Colors.orangeAccent; // Yellow color for Pending status
      case 'BLACKLISTED':
        return Colors.red.shade600; // Green color for Approved status
      default:
        return Colors.transparent; // Default color (you can change this as per your design)
    }
  }
}
