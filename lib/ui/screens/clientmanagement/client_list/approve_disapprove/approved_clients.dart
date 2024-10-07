import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/provider/mfi/mfi_client_all_provider.dart';
import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/header/header.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/clock/clock.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/utils/utils_responsive.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/container.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/dialog.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/fields/show_list.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/pagination/pagination_button.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/scrollable/scrollable_widget.dart';
import 'package:provider/provider.dart';

import '../../../../../core/mfi_whitelist_api/clients/update_client.dart';
import '../../../../../core/models/mfi_whitelist_admin_portal/clientModel.dart';
import '../../../../../core/models/mfi_whitelist_admin_portal/whitelistModel.dart';
import '../../../../../main.dart';
import '../../../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../../../shared/values/styles.dart';
import '../../../../shared/widget/alert_dialog/alert_dialogs.dart';
import '../../../../shared/widget/calendar/date_picker.dart';

class ApprovedClients extends StatefulWidget {
  const ApprovedClients({Key? key}) : super(key: key);

  @override
  State<ApprovedClients> createState() => _ApprovedClientsState();
}

class _ApprovedClientsState extends State<ApprovedClients> {
  final token = getToken();
  final userRole = getUrole();
  late RowData rowData;

  final TextEditingController _rowsPerPageController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController batchUploadIDController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List<RowData> apiData = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  int totalRecords = 0;
  int totalPages = 0;
  String selectedFileName = '';
  String selectedUnit = '';
  String selectedCenter = '';
  String selectedFrom = '';
  String selectedTo = '';
  DateTime initialDate = DateTime.now();

  final int _sortColumnIndex = 0;

  List<String> displayFileName = [];
  List<String> _displayPages = [];
  String _selectedItem = '10';

  ///BOOLEAN VALUES
  bool isEditing = false;
  bool hasChanges = false;
  final bool _sortAscending = true;
  bool isLoading = true; // Add this variable to track loading state

  final List<String> editableFields = [
    'firstName',
    'middleName',
    'lastName',
    'maidenFName',
    'maidenMName',
    'maidenLName',
    'mobileNumber',
    'birthday',
    'placeOfBirth',
    'religion',
    'civilStatus',
    'citizenship',
    'presentAddress',
    'permanentAddress',
    'city',
    'province',
    'postalCode',
    'memberMaidenFName',
    'memberMaidenMName',
    'memberMaidenLName',
    'email',
    'sourceOfFund',
    'employerOrBusinessName',
    'employerOrBusinessAddress',
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
    updateUrl('/Access/Client_List/Approved_Clients');
  }

  @override
  void dispose() {
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

  ///FETCH DATA FROM API
  Map<String, String> fileBatchUploadMap = {};

  Future<void> fetchDistinct() async {
    try {
      final token = getToken();
      final response = await http.get(
        Uri.parse('${UrlGetter.getURL()}/filters/test/get/all/distinct/approved'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        debugPrint('Distinct ${responseData.toString()}');

        if (responseData['distinctData'] != null) {
          fileBatchUploadMap.clear(); // Clear the previous mapping if any
          for (var item in responseData['distinctData']) {
            if (item['fileName'] != null && item['batchUploadId'] != null) {
              fileBatchUploadMap[item['fileName']] = item['batchUploadId'].toString();
            }
          }
        }

        // Print the map contents
        debugPrint('File Batch Upload Map: $fileBatchUploadMap');

        setState(() {
          displayFileName = fileBatchUploadMap.keys.toList(); // Update the display file names
        });
      } else {
        debugPrint('FAILED');
        debugPrint(response.body);
        throw Exception('Failed to load menu data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
    }
  }

  void fetchData(int page, int perPage, String? batchUploadID) async {
    setState(() {
      isLoading = true;
    });

    String? fetchedBatchUploadID = fileBatchUploadMap[selectedFileName];

    if (fetchedBatchUploadID != null) {
      batchUploadIDController.text = fetchedBatchUploadID;
      debugPrint('Fetched batch upload id: $fetchedBatchUploadID');
    }

    // Print the map contents
    debugPrint('File Batch Upload Map: $fileBatchUploadMap');

    try {
      final token = getToken();
      final url = Uri.parse('${UrlGetter.getURL()}/clients/test/get/all/approved?page=$page&perPage=$perPage&batch_upload_id=${batchUploadID ?? ''}');
      debugPrint('Value of file name: $selectedFileName');
      fileNameController.text = selectedFileName!;

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

          if (data is List) {
            setState(() {
              apiData = List<RowData>.from(data.map((item) => RowData(
                    isEditing: false,
                    data: Map<String, dynamic>.from(item),
                  )));
              totalRecords = jsonData['totalRecords'];
              totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
              isLoading = false;
            });
          } else {
            debugPrint('JSON data is not in the expected format');
            setState(() {
              if (mounted) {
                isLoading = false;
                apiData = []; // Clear existing data or update with new data
              }
            });
          }
        } else {
          debugPrint('NO DATA AVAILABLE');
          setState(() {
            if (mounted) {
              isLoading = false;
              apiData = []; // Clear existing data or update with new data
            }
          });
        }
      } else {
        debugPrint('No data fetched: ${response.body}');
        debugPrint('HTTP Request failed with status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        setState(() {
          if (mounted) {
            isLoading = false;
            apiData = []; // Clear existing data or update with new data
          }
        });
      }
    } catch (error) {
      debugPrint('Error fetching data: $error');
      setState(() {
        if (mounted) {
          isLoading = false;
          apiData = []; // Clear existing data or update with new data
        }
      });
    }
  }

  void _initializeData() {
    fetchData(currentPage, int.parse(_selectedItem), '');
    currentPage = 0;
    fetchDistinct();
  }

  void onPageSizeChange(int selectedItem) {
    setState(() {
      _selectedItem = selectedItem.toString();
      _initializeData();
    });
  }

  ///GENERATED ROW FOR FREEZE PANES : ACTION AND CLIENT CLASSIFICATION
  List<DataRow> getFreezeActionRow() {
    return List<DataRow>.generate(apiData.length, (index) {
      final rowData = apiData[index];
      final color = index % 2 == 0 ? Colors.transparent : Colors.white;

      return DataRow(
        color: MaterialStateProperty.all(color),
        cells: [
          DataCell(
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (rowData.isEditing)
                    if (hasChanges)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.save,
                              color: AppColors.green3,
                              size: 20,
                            ),
                            onPressed: () {
                              final cid = rowData.data['cid'];
                              debugPrint('Save button clicked for row $index');
                              _showConfirmUpdateAlertDialog(context, cid, index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.maroon4,
                              size: 20,
                            ),
                            onPressed: () {
                              debugPrint('Cancel button clicked for row $index');
                              setState(() {
                                rowData.data = Map.from(rowData.originalData);
                                for (var key in rowData.data.keys) {
                                  rowData.controllers[key]?.text = rowData.originalData[key]?.toString() ?? '';
                                }
                                rowData.isEditing = false;
                                hasChanges = false;
                              });
                            },
                          ),
                        ],
                      )
                    else
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.maroon4,
                        ),
                        onPressed: () {
                          debugPrint('Cancel button clicked for row $index');
                          setState(() {
                            rowData.isEditing = false;
                            hasChanges = false;
                          });
                        },
                      )
                  else
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: AppColors.infoColor,
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          rowData.originalData = Map.from(rowData.data);
                          rowData.isEditing = true;
                          hasChanges = false;
                        });
                      },
                    ),
                  if (userRole == 'Checker')
                    IconButton(
                      icon: const Icon(
                        Icons.delete_sweep_outlined,
                        color: AppColors.maroon4,
                        size: 20,
                      ),
                      onPressed: () {
                        final cid = rowData.data['cid'];
                        _showDelistAlertDialog(context, cid, index);
                        debugPrint(cid);
                        debugPrint('Delete button clicked for row $index');
                      },
                    ),
                ],
              ),
            ),
          ),
          DataCell(
            Center(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 150,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _getClientClassificationColor(rowData.data['memberClassification']).withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: _getClientClassificationColor(rowData.data['memberClassification']).withOpacity(0.2),
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
                        rowData.data['memberClassification']?.toUpperCase() ?? '',
                        style: TextStyle(
                          color: _getClientClassificationColor(rowData.data['memberClassification']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (rowData.isEditing)
                    Tooltip(
                      message: rowData.data['memberClassification'] == 'Agent' ? 'Revert back to Client' : 'Promote to Agent',
                      child: IconButton(
                        icon: Icon(
                          rowData.data['memberClassification'] == 'Agent' ? Icons.move_down : Icons.move_up,
                          color: AppColors.maroon2,
                        ),
                        onPressed: () {
                          setState(() {
                            rowData.data['memberClassification'] = rowData.data['memberClassification'] == 'Agent' ? 'Client' : 'Agent';
                            hasChanges = true;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          // DataCell(
          //   Center(
          //     child: Container(
          //       margin: const EdgeInsets.only(right: 20),
          //       width: 150,
          //       height: 30,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(20),
          //         color: _getWatchlistClassificationColor(watchlistedType).withOpacity(0.2),
          //         boxShadow: [
          //           BoxShadow(
          //             color: _getWatchlistClassificationColor(watchlistedType).withOpacity(0.2),
          //             spreadRadius: 2,
          //             blurRadius: 5,
          //             offset: const Offset(3, 3),
          //           ),
          //           const BoxShadow(
          //             color: Colors.white,
          //             spreadRadius: 2,
          //             blurRadius: 5,
          //             offset: Offset(-3, -3),
          //           ),
          //         ],
          //       ),
          //       child: Center(
          //         child: Text(
          //           watchlistedType?.toUpperCase() ?? '',
          //           style: TextStyle(
          //             color: _getWatchlistClassificationColor(watchlistedType), // Text color to match the background
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      );
    });
  }

  ///GENERATED ROW FOR OTHER CLIENT INFO
  List<DataRow> getPaginatedRows() {
    const textStyle = TextStyles.dataTextStyle;

    //BUILD EDITABLE DATA CELL USING TEXTFORMFIELD
    DataCell buildDataCell(String key, RowData rowData, {Alignment alignment = Alignment.centerLeft}) {
      return DataCell(
        Align(
          alignment: alignment,
          child: rowData.isEditing && editableFields.contains(key)
              ? key == 'birthday'
                  ? GestureDetector(
                      onTap: () {
                        showModalDatePicker(context, rowData.controllers[key]!, initialDate, 'Select Birthdate', false, () {});
                        // setState(() {
                        //   rowData.data[key] = value;
                        //   hasChanges = true;
                        // });
                      },
                      child: AbsorbPointer(
                        // Prevents keyboard from appearing
                        child: TextFormField(
                          controller: rowData.controllers[key],
                          style: textStyle,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            setState(() {
                              rowData.data[key] = value;
                              hasChanges = true;
                            });
                          },
                        ),
                      ),
                    )
                  : TextFormField(
                      controller: rowData.controllers[key],
                      style: textStyle,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        setState(() {
                          rowData.data[key] = value;
                          hasChanges = true;
                        });
                      },
                    )
              : SelectableText(
                  rowData.data[key] ?? '',
                  style: textStyle,
                ),
        ),
      );
    }

    //GENERATE THE ROW DATA FROM THE API
    return List<DataRow>.generate(apiData.length, (index) {
      final rowData = apiData[index];
      final color = index % 2 == 0 ? Colors.transparent : Colors.white;

      return DataRow(
        color: MaterialStateProperty.all(color),
        cells: [
          buildDataCell('watchlistedType', rowData),
          buildDataCell('cid', rowData),
          buildDataCell('firstName', rowData),
          buildDataCell('middleName', rowData),
          buildDataCell('lastName', rowData),
          buildDataCell('maidenFName', rowData),
          buildDataCell('maidenMName', rowData),
          buildDataCell('maidenLName', rowData),
          buildDataCell('mobileNumber', rowData),
          buildDataCell('birthday', rowData),
          buildDataCell('placeOfBirth', rowData),
          buildDataCell('religion', rowData),
          buildDataCell('gender', rowData),
          buildDataCell('civilStatus', rowData),
          buildDataCell('citizenship', rowData),
          buildDataCell('presentAddress', rowData),
          buildDataCell('permanentAddress', rowData),
          buildDataCell('city', rowData),
          buildDataCell('province', rowData),
          buildDataCell('postalCode', rowData),
          buildDataCell('memberMaidenFName', rowData),
          buildDataCell('memberMaidenMName', rowData),
          buildDataCell('memberMaidenLName', rowData),
          buildDataCell('email', rowData),
          buildDataCell('institutionCode', rowData),
          buildDataCell('unitCode', rowData),
          buildDataCell('centerCode', rowData),
          buildDataCell('branchCode', rowData),
          buildDataCell('sourceOfFund', rowData),
          buildDataCell('employerOrBusinessName', rowData),
          buildDataCell('employerOrBusinessAddress', rowData),
          buildDataCell('status', rowData),
          buildDataCell('createdAt', rowData),
          buildDataCell('updatedAt', rowData),
        ],
      );
    });
  }

  //========Create templated data cell for PAGINATED COLUMNS=============//
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
      // buildDataColumn('CID', onTap: () => _sortData(0, !_sortAscending)),
      buildDataColumn('Watchlist Type'),
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
      buildDataColumn('Source of Fund'),
      buildDataColumn('Employer/Business Name'),
      buildDataColumn('Employer/Business Address'),
      buildDataColumn('Status'),
      buildDataColumn('Created Date'),
      buildDataColumn('Updated Date'),
    ];
  }

  void nextPage() {
    if (currentPage + 1 < totalPages) {
      setState(() {
        currentPage++; // Update currentPage
      });
      fetchData(currentPage + 1, int.parse(_selectedItem), batchUploadIDController.text); // Fetch the next page of data
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--; // Update currentPage
      });
      fetchData(currentPage + 1, int.parse(_selectedItem), batchUploadIDController.text); // Fetch the previous page of data
    }
  }

  void _onPageSelected(int page) {
    setState(() {
      currentPage = page;
    });
  }

  ///SEARCH FUNCTION FOR ALL CLIENT DATA
  void _onFetchDataSearchChanged() {
    final query = searchController.text;
    debugPrint('Fetch Data Search query: $query');
    Provider.of<MFIClientProvider>(context, listen: false).searchClient(query);
  }

  ///SEARCH FUNCTION FOR DISTINCT FILE
  void _onFetchDistinctSearchChanged() {
    final query = searchController.text;
    debugPrint('Fetch Data Search query: $query');
    // Assuming you have a method in the provider to handle searches within distinct data.
    Provider.of<MFIClientProvider>(context, listen: false).searchClient(query);
  }

  @override
  Widget build(BuildContext context) {
    int displayPage = (totalRecords == 0) ? 0 : (currentPage + 1);
    return Container(
      padding: const EdgeInsets.only(left: 90),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const HeaderBar(screenText: 'APPROVED CLIENTS'),
            Container(
              padding: const EdgeInsets.only(
                right: 10,
                top: 5,
              ),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //rows&clock

                  ///SHOW LIST FILTER
                  ShowListWidget(rowsPerPageController: _rowsPerPageController, rowsPerPage: _selectedItem, onPageSizeChange: onPageSizeChange),
                  // Container(
                  //   padding: const EdgeInsets.only(
                  //     left: 3,
                  //     right: 10,
                  //     top: 5,
                  //     bottom: 5,
                  //   ),
                  //   decoration: const BoxDecoration(
                  //     color: Colors.transparent,
                  //   ),
                  //   height: 40,
                  //   width: 200,
                  //   child: Row(
                  //     children: [
                  //       const Text(
                  //         'Show',
                  //         style: TextStyles.dataTextStyle,
                  //       ),
                  //       const SizedBox(
                  //         width: 5,
                  //       ),
                  //       SizedBox(
                  //         width: 35,
                  //         height: 35,
                  //         child: TextField(
                  //           controller: _rowsPerPageController,
                  //           textAlignVertical: TextAlignVertical.top,
                  //           cursorColor: AppColors.maroon2,
                  //           cursorWidth: 1,
                  //           cursorRadius: const Radius.circular(5),
                  //           decoration: InputDecoration(
                  //             contentPadding: const EdgeInsets.only(top: -20, left: 10),
                  //             filled: true,
                  //             fillColor: Colors.transparent,
                  //             focusedBorder: const OutlineInputBorder(
                  //               borderSide: BorderSide(
                  //                 color: AppColors.maroon2,
                  //                 width: 0.5,
                  //               ),
                  //               borderRadius: BorderRadius.only(
                  //                 topLeft: Radius.circular(5),
                  //                 bottomLeft: Radius.circular(5),
                  //                 topRight: Radius.circular(0),
                  //                 bottomRight: Radius.circular(0),
                  //               ),
                  //             ),
                  //             enabledBorder: const OutlineInputBorder(
                  //               borderSide: BorderSide(
                  //                 color: AppColors.maroon2,
                  //                 width: 0.5,
                  //               ),
                  //               borderRadius: BorderRadius.only(
                  //                 topLeft: Radius.circular(5),
                  //                 bottomLeft: Radius.circular(5),
                  //                 topRight: Radius.circular(0),
                  //                 bottomRight: Radius.circular(0),
                  //               ),
                  //             ),
                  //             border: const OutlineInputBorder(
                  //               borderSide: BorderSide(
                  //                 style: BorderStyle.solid,
                  //                 color: AppColors.maroon2,
                  //                 width: 0.5,
                  //               ),
                  //               borderRadius: BorderRadius.only(
                  //                 topLeft: Radius.circular(5),
                  //                 bottomLeft: Radius.circular(5),
                  //                 topRight: Radius.circular(0),
                  //                 bottomRight: Radius.circular(0),
                  //               ),
                  //             ),
                  //             hintText: _selectedItem,
                  //             hintStyle: const TextStyle(fontSize: 11, color: Colors.black54),
                  //           ),
                  //           readOnly: true,
                  //         ),
                  //       ),
                  //       Container(
                  //         height: 40,
                  //         decoration: const BoxDecoration(
                  //           border: Border(
                  //             top: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
                  //             right: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
                  //             bottom: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
                  //             // left: BorderSide(color: Color(0xff1E5128), width: 0, style: BorderStyle.solid),
                  //           ),
                  //           borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                  //           // color: Colors.black26,
                  //           color: AppColors.maroon2,
                  //         ),
                  //         child: PopupMenuButton<String>(
                  //           splashRadius: 20,
                  //           icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.white),
                  //           onSelected: (String selectedItem) {
                  //             setState(() {
                  //               _selectedItem = selectedItem;
                  //               _initializeData();
                  //             });
                  //           },
                  //           itemBuilder: (BuildContext context) {
                  //             return _displayPages.map((String type) {
                  //               return PopupMenuItem<String>(
                  //                 height: 20,
                  //                 value: type,
                  //                 child: Center(
                  //                   child: Text(type, style: TextStyles.dataTextStyle),
                  //                 ),
                  //               );
                  //             }).toList();
                  //           },
                  //           elevation: 8,
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         width: 5,
                  //       ),
                  //       const Text(
                  //         'List',
                  //         style: TextStyles.dataTextStyle,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const Spacer(),
                  const Responsive(desktop: Clock(), mobile: Spacer()),
                ],
              ),
            ),
            const SizedBox(height: 5),

            //FILE TEXT FIELD AND OTHER CTAs
            Row(
              children: [
                //file textfield
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
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
                        suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                fileNameController.clear();
                                selectedFileName = '';
                                batchUploadIDController.clear();
                                fetchDistinct();
                                fetchData(currentPage, int.parse(_selectedItem), batchUploadIDController.text);
                              });
                            },
                            child: const Icon(Icons.close, size: 20)),
                        hintText: selectedFileName.isEmpty ? 'Select a file' : selectedFileName,
                        hintStyle: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
                Container(
                  height: 35,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
                      right: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
                      bottom: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
                    ),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                    color: AppColors.maroon2,
                  ),
                  child: PopupMenuButton<String>(
                    splashRadius: 20,
                    icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.white),
                    onSelected: (String selectedItem) {
                      setState(() {
                        selectedFileName = selectedItem;
                        debugPrint('File Selected: $selectedFileName');
                        // Get the batch upload ID based on the selected file name
                        String? fetchedBatchUploadID = fileBatchUploadMap[selectedFileName];
                        fetchDistinct();
                        fetchData(currentPage, int.parse(_selectedItem), fetchedBatchUploadID);
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      if (displayFileName.isEmpty) {
                        return [
                          const PopupMenuItem<String>(
                            height: 20,
                            value: null,
                            child: Text(
                              'You have no approved file yet',
                              style: TextStyles.dataTextStyle,
                            ),
                          ),
                        ];
                      } else {
                        return displayFileName.map((String type) {
                          return PopupMenuItem<String>(
                            height: 20,
                            value: type,
                            child: Text(
                              type,
                              style: TextStyles.dataTextStyle,
                            ),
                          );
                        }).toList();
                      }
                    },
                    elevation: 8,
                  ),
                ),
                const Spacer(),
                // DynamicSearchBar(
                //   searchWidth: 400,
                //   searchHeight: 35,
                //   radius: 5.0,
                //   hintText: 'Search',
                //   color: Colors.transparent,
                //   controller: searchController,
                //   onChanged: (value) {
                //     _onFetchDataSearchChanged();
                //     _onFetchDistinctSearchChanged();
                //   },
                // ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
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
                        ? const Center(
                            child: NoRecordsFound(),
                          )
                        : SingleChildScrollView(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DataTableTheme(
                                  data: const DataTableThemeData(
                                    dividerThickness: 0.1,
                                  ),
                                  child: DataTable(
                                    sortColumnIndex: _sortColumnIndex,
                                    sortAscending: _sortAscending,
                                    border: TableBorder.all(width: 0.1, color: Colors.black54.withOpacity(0.5)),
                                    headingRowColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.black12,
                                    ),
                                    headingRowHeight: 50,
                                    columns: [
                                      DataColumn(
                                          label: Text('Actions',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black.withOpacity(0.6),
                                                letterSpacing: .5,
                                                fontWeight: FontWeight.bold,
                                              ))),
                                      DataColumn(
                                          label: Text('Client Classification',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black.withOpacity(0.6),
                                                letterSpacing: .5,
                                                fontWeight: FontWeight.bold,
                                              ))),
                                    ],
                                    rows: getFreezeActionRow(),
                                  ),
                                ),
                                Expanded(
                                  child: ScrollBarWidget(
                                    child: DataTableTheme(
                                      data: const DataTableThemeData(
                                        dividerThickness: 0.1,
                                      ),
                                      child: DataTable(
                                        sortColumnIndex: _sortColumnIndex,
                                        sortAscending: _sortAscending,
                                        border: TableBorder.all(width: 0.1, color: Colors.black54.withOpacity(0.5)),
                                        headingRowColor: MaterialStateColor.resolveWith(
                                          (states) => Colors.black12,
                                        ),
                                        headingRowHeight: 50,
                                        columns: buildDataColumns(),
                                        rows: getPaginatedRows(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
            ),
            const SizedBox(height: 10),

            //PAGINATION BUTTON CODE
            PaginationControls(currentPage: displayPage, totalPages: totalPages, totalRecords: totalRecords, onPreviousPage: previousPage, onNextPage: nextPage, title: 'Clients'),
          ],
        ),
      ),
    );
  }

  ///SUBMIT UPDATED CLIENT DATA
  void submitUpdateClientForm(RowData rowData, int index) async {
    // Create a ClientDataModel instance using the data from TextEditingController
    ClientDataModel clientData = ClientDataModel(
      cid: rowData.data['cid'],
      firstName: rowData.controllers['firstName']?.text,
      middleName: rowData.controllers['middleName']?.text,
      lastName: rowData.controllers['lastName']?.text,
      maidenFName: rowData.controllers['maidenFName']?.text,
      maidenMName: rowData.controllers['maidenMName']?.text,
      maidenLName: rowData.controllers['maidenLName']?.text,
      mobileNumber: rowData.controllers['mobileNumber']?.text,
      birthday: rowData.controllers['birthday']?.text,
      placeOfBirth: rowData.controllers['placeOfBirth']?.text,
      religion: rowData.controllers['religion']?.text,
      civilStatus: rowData.controllers['civilStatus']?.text,
      citizenship: rowData.controllers['citizenship']?.text,
      presentAddress: rowData.controllers['presentAddress']?.text,
      permanentAddress: rowData.controllers['permanentAddress']?.text,
      city: rowData.controllers['city']?.text,
      province: rowData.controllers['province']?.text,
      postalCode: rowData.controllers['postalCode']?.text,
      memberMaidenFName: rowData.controllers['memberMaidenFName']?.text,
      memberMaidenMName: rowData.controllers['memberMaidenMName']?.text,
      memberMaidenLName: rowData.controllers['memberMaidenLName']?.text,
      email: rowData.controllers['email']?.text,
      memberClassification: rowData.data['memberClassification'],
      sourceOfFund: rowData.controllers['sourceOfFund']?.text,
      employerOrBusinessName: rowData.controllers['employerOrBusinessName']?.text,
      employerOrBusinessAddress: rowData.controllers['employerOrBusinessAddress']?.text,
      clientClassification: rowData.data['clientClassification'],
    );

    // Show a temporary message to simulate API response
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 350,
          height: 100,
          decoration: const BoxDecoration(
            color: AppColors.dialogColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingCircle(color: AppColors.maroon2),
              SizedBox(width: 10),
              Text('Saving in progress...'),
            ],
          ),
        ),
      ),
    );

    // Call the API
    final response = await UpdateApprovedClientInfoAPI().updateApprovedClient(clientData);
    Navigator.pop(navigatorKey.currentContext!); // Dismiss the loading dialog

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['retCode'] == '200') {
        showSuccessAlertDialog(navigatorKey.currentContext!, "The client's updated info was saved successfully.", onPositiveButtonPressed: () {
          _initializeData();
        });
        // Reset the editing state and change the icon back to edit
        setState(() {
          apiData[index].isEditing = false;
          hasChanges = false;
        });
      } else {
        String errorMessage = jsonDecode(response.body)['message'];
        showGeneralErrorAlertDialog(navigatorKey.currentContext!, errorMessage);
      }
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      showGeneralErrorAlertDialog(navigatorKey.currentContext!, errorMessage);
    }
  }

  ///DELIST A CLIENT
  void submitDelistClient(String cid, int index) async {
    // Show a temporary message to simulate API response
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 350,
          height: 100,
          decoration: const BoxDecoration(
            color: AppColors.dialogColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingCircle(color: AppColors.maroon2),
              SizedBox(width: 10),
              Text('Delist in progress...'),
            ],
          ),
        ),
      ),
    );

    // Call the API
    final response = await DelistApprovedClientAPI().delistApprovedClient(cid);
    Navigator.pop(navigatorKey.currentContext!); // Dismiss the loading dialog

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['retCode'] == '200') {
        showSuccessAlertDialog(navigatorKey.currentContext!, "A client was delisted from the records.", onPositiveButtonPressed: () {
          _initializeData();
        });
      } else {
        String errorMessage = jsonDecode(response.body)['message'];
        showGeneralErrorAlertDialog(navigatorKey.currentContext!, errorMessage);
      }
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      showGeneralErrorAlertDialog(navigatorKey.currentContext!, errorMessage);
    }
  }

  ///DELIST DIALOG
  void _showDelistAlertDialog(BuildContext context, String cid, int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialogWidget(
        titleText: "Confirmation",
        contentText: "You will be de-listing a client. Proceed with caution.",
        positiveButtonText: "Delist Client",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          Navigator.of(context).pop();
          submitDelistClient(cid, index);
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  ///CONFIRM UPDATE
  void _showConfirmUpdateAlertDialog(BuildContext context, dynamic cid, int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialogWidget(
        titleText: "Confirmation",
        contentText: "You will be updating a client's info. Proceed with caution.",
        positiveButtonText: "Update Info",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          Navigator.of(context).pop(); // Close dialog
          debugPrint('Confirm Update for cid: $cid');
          final rowData = apiData[index]; // Obtain the rowData instance for the row being edited
          submitUpdateClientForm(rowData, index);
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  ///SUCCESSFUL
  Color _getClientClassificationColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'AGENT':
        return AppColors.maroon5; // Yellow color for Pending status
      case 'CLIENT':
        return AppColors.mlniColor; // Green color for Approved status
      default:
        return Colors.transparent; // Default color (you can change this as per your design)
    }
  }

  Color _getWatchlistClassificationColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'HIGH RISK':
        return Colors.orangeAccent; // Yellow color for Pending status
      case 'BLACKLISTED':
        return Colors.red.shade600; // Green color for Approved status
      default:
        return Colors.transparent; // Default color (you can change this as per your design)
    }
  }
}
