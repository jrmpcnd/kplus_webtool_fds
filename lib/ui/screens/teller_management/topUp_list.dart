import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/fields/show_list.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/pagination/pagination_button.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/scrollable/scrollable_widget.dart';

import '../../../../../main.dart';
import '../../shared/clock/clock.dart';
import '../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import '../../shared/utils/utils_responsive.dart';
import '../../shared/values/colors.dart';
import '../../shared/values/styles.dart';
import '../../shared/widget/containers/container.dart';
import '../user_management/ui/screen_bases/header/header.dart';

class TopUpClients extends StatefulWidget {
  const TopUpClients({Key? key}) : super(key: key);

  @override
  State<TopUpClients> createState() => _TopUpClientsState();
}

class _TopUpClientsState extends State<TopUpClients> {
  final fname = getFname();
  final lname = getLname();
  final urole = getUrole();
  final insti = getInstitution();
  final token = getToken();

  TextEditingController _rowsperpagecontroller = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController batchUploadIDController = TextEditingController();

  List<Map<String, dynamic>> apiData = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isLoading = true; // Add this variable to track loading state
  int totalRecords = 0;
  int totalPages = 0;
  String selectedFileName = '';

  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  List<String> displayFileName = [];
  List<String> _displayPages = [];
  String _selectedItem = '10';

  @override
  void initState() {
    super.initState();
    fetchRows();
    // fetchDistinct();
    _initializeData();
    updateUrl('/Access/Top_Up/Top_Up_Clients');
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

//for sorting function
  void _sortData(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      apiData.sort((a, b) {
        dynamic aValue = a.values.toList()[columnIndex];
        dynamic bValue = b.values.toList()[columnIndex];

        if (aValue is String && bValue is String) {
          return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        } else if (aValue is int && bValue is int) {
          return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        } else if (aValue is DateTime && bValue is DateTime) {
          return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        } else {
          // Handle other types as needed
          return 0;
        }
      });
    });
  }

  ///ORIGINAL API
  // void fetchData(int page, int perPage) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   try {
  //     final token = getToken();
  //     final url = Uri.parse('${UrlGetter.getURL()}/clients/test/get/all/disapproved?page=$page&perPage=$_selectedItem&file_name=$selectedFileName');
  //     // debugPrint('Request URL: $url');
  //     debugPrint('Value of file name: $selectedFileName');
  //     fileNameController.text = selectedFileName;
  //
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(utf8.decode(response.bodyBytes));
  //       if (jsonData['retCode'] == '200') {
  //         final data = jsonData['data'];
  //
  //         if (data is List) {
  //           setState(() {
  //             apiData = List<Map<String, dynamic>>.from(data);
  //             totalRecords = jsonData['totalRecords'];
  //             totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
  //             isLoading = false;
  //           });
  //         } else {
  //           debugPrint('JSON data is not in the expected format');
  //           setState(() {
  //             if (mounted) {
  //               // Update state variables here
  //               isLoading = false;
  //               apiData = []; // Clear existing data or update with new data
  //             }
  //           });
  //         }
  //       } else {
  //         debugPrint('NO DATA AVAILABLE');
  //         setState(() {
  //           if (mounted) {
  //             // Update state variables here
  //             isLoading = false;
  //             apiData = []; // Clear existing data or update with new data
  //           }
  //         });
  //       }
  //     } else {
  //       debugPrint('No data fetched: ${response.body}');
  //       debugPrint('HTTP Request failed with status code: ${response.statusCode}');
  //       debugPrint('Response body: ${response.body}');
  //       setState(() {
  //         if (mounted) {
  //           // Update state variables here
  //           isLoading = false;
  //           apiData = []; // Clear existing data or update with new data
  //         }
  //       });
  //     }
  //   } catch (error) {
  //     debugPrint('Error fetching data: $error');
  //     setState(() {
  //       if (mounted) {
  //         // Update state variables here
  //         isLoading = false;
  //         apiData = []; // Clear existing data or update with new data
  //       }
  //     });
  //   }
  // }

  // Future<void> fetchDistinct() async {
  //   try {
  //     final token = getToken();
  //     final response = await http.get(
  //       Uri.parse('${UrlGetter.getURL()}/filters/test/get/all/distinct/disapproved'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       debugPrint(responseData.toString());
  //
  //       List<String> file = [];
  //       if (responseData['distinctData'] != null) {
  //         for (var item in responseData['distinctData']) {
  //           if (item['fileName'] != null) {
  //             file.add(item['fileName']);
  //           }
  //         }
  //       }
  //
  //       setState(() {
  //         displayFileName = file;
  //         // _displayUnit = unit;
  //         // _displayCenter = center;
  //       });
  //
  //       debugPrint('SUCCESS');
  //       debugPrint('FILE: $displayFileName');
  //     } else {
  //       debugPrint('FAILED');
  //
  //       debugPrint(response.body);
  //       throw Exception('Failed to load menu data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('Exception occurred: $e');
  //     // Handle exception, maybe show a snackbar or display an error message.
  //   }
  // }

  ///

  /// NEW API
  Map<String, String> fileBatchUploadMap = {};

  // Future<void> fetchDistinct() async {
  //   try {
  //     final token = getToken();
  //     final response = await http.get(
  //       Uri.parse('${UrlGetter.getURL()}/topup/test/get/all/clients?page=1&perPage=10&batch_topup_file_id=1&batch_topup_status=&topup_reference_id='),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       debugPrint('Distinct ${responseData.toString()}');
  //
  //       if (responseData['distinctData'] != null) {
  //         fileBatchUploadMap.clear(); // Clear the previous mapping if any
  //         for (var item in responseData['distinctData']) {
  //           if (item['fileName'] != null && item['batchUploadId'] != null) {
  //             fileBatchUploadMap[item['fileName']] = item['batchUploadId'].toString();
  //           }
  //         }
  //       }
  //
  //       // Print the map contents
  //       debugPrint('File Batch Upload Map: $fileBatchUploadMap');
  //
  //       setState(() {
  //         displayFileName = fileBatchUploadMap.keys.toList(); // Update the display file names
  //       });
  //     } else {
  //       debugPrint('FAILED');
  //       debugPrint(response.body);
  //       throw Exception('Failed to load menu data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('Exception occurred: $e');
  //   }
  // }

  void fetchData(int page, int perPage, String? batchTopupFileId) async {
    print('Call API Pg: $page');
    setState(() {
      isLoading = true;
    });

    try {
      final token = getToken();
      final url = Uri.parse('${UrlGetter.getURL()}/topup/test/get/all/clients?page=$page&perPage=$perPage&batch_topup_file_id=$batchTopupFileId&batch_topup_status=&topup_reference_id=');
      fileNameController.text = selectedFileName!;

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Request url DISAPPROVED: $url');

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        if (jsonData['retCode'] == '200') {
          final data = jsonData['data'];

          if (data is List) {
            setState(() {
              apiData = List<Map<String, dynamic>>.from(data);
              totalRecords = jsonData['totalRecords'];
              totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
              isLoading = false;
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
        debugPrint('HTTP Request failed with status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
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

  // void fetchData(int page, int perPage, String? batchUploadID) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   String? fetchedBatchUploadID = fileBatchUploadMap[selectedFileName];
  //
  //   if (fetchedBatchUploadID != null) {
  //     batchUploadIDController.text = fetchedBatchUploadID;
  //     debugPrint('Fetched batch upload id: $fetchedBatchUploadID');
  //   }
  //
  //   // Print the map contents
  //   debugPrint('File Batch Upload Map: $fileBatchUploadMap');
  //
  //   try {
  //     final token = getToken();
  //     final url = Uri.parse('${UrlGetter.getURL()}/clients/test/get/all/disapproved?page=$page&perPage=$perPage&batch_upload_id=${batchUploadID ?? ''}');
  //     debugPrint('Value of file name: $selectedFileName');
  //     fileNameController.text = selectedFileName!;
  //
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(utf8.decode(response.bodyBytes));
  //       if (jsonData['retCode'] == '200') {
  //         final data = jsonData['data'];
  //
  //         if (data is List) {
  //           setState(() {
  //             apiData = List<RowData>.from(data.map((item) => RowData(
  //                   isEditing: false,
  //                   data: Map<String, dynamic>.from(item),
  //                 )));
  //             totalRecords = jsonData['totalRecords'];
  //             totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
  //             isLoading = false;
  //           });
  //         } else {
  //           debugPrint('JSON data is not in the expected format');
  //           setState(() {
  //             if (mounted) {
  //               isLoading = false;
  //               apiData = []; // Clear existing data or update with new data
  //             }
  //           });
  //         }
  //       } else {
  //         debugPrint('NO DATA AVAILABLE');
  //         setState(() {
  //           if (mounted) {
  //             isLoading = false;
  //             apiData = []; // Clear existing data or update with new data
  //           }
  //         });
  //       }
  //     } else {
  //       debugPrint('No data fetched: ${response.body}');
  //       debugPrint('HTTP Request failed with status code: ${response.statusCode}');
  //       debugPrint('Response body: ${response.body}');
  //       setState(() {
  //         if (mounted) {
  //           isLoading = false;
  //           apiData = []; // Clear existing data or update with new data
  //         }
  //       });
  //     }
  //   } catch (error) {
  //     debugPrint('Error fetching data: $error');
  //     setState(() {
  //       if (mounted) {
  //         isLoading = false;
  //         apiData = []; // Clear existing data or update with new data
  //       }
  //     });
  //   }
  // }

  //for reinitializing
  void _initializeData() {
    fetchData(currentPage, int.parse(_selectedItem), '');
    currentPage = 0;
    // fetchDistinct();
  }

  Future<void> fetchRows() async {
    final response = await http.get(
      Uri.parse('${UrlGetter.getURL()}/topup/test/get/all/clients?page=1&perPage=&batch_topup_file_id=&batch_topup_status=&topup_reference_id='),
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

    DataCell buildDataCell(String? text) {
      return DataCell(Center(
        child: SelectableText(
          text ?? '',
          style: textStyle,
        ),
      ));
    }

    return List<DataRow>.generate(apiData.length, (index) {
      final rowData = apiData[index];
      final color = index % 2 == 0 ? Colors.transparent : Colors.white;

      return DataRow(
        color: MaterialStateProperty.all(color),
        cells: [
          buildDataCell(rowData['file_name']),
          buildDataCell(rowData['cid']),
          buildDataCell(rowData['clientFullName']),
          buildDataCell(rowData['accountNumber']),
          buildDataCell(rowData['amount'].toString()),
          buildDataCell(rowData['tlrUid']),
          buildDataCell(rowData['tgtBranchCode']),
          buildDataCell(rowData['tgtStatus']),
          buildDataCell(rowData['tgtMessage']),
          buildDataCell(rowData['tgtTrxReference']),
          buildDataCell(rowData['tgtCreditCustomerName']),
          buildDataCell(rowData['trxDate']),
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
      buildDataColumn('File Name'),
      buildDataColumn('CID'),
      buildDataColumn('Client Full Name'),
      buildDataColumn('Account Number'),
      buildDataColumn('Amount'),
      buildDataColumn('Teller UID'),
      buildDataColumn('Target Branch Code'),
      buildDataColumn('Target Status'),
      buildDataColumn('Target Message'),
      buildDataColumn('Target Transaction Reference'),
      buildDataColumn('Target Credit Customer Name'),
      buildDataColumn('Transaction Date'),
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

  void onPageSizeChange(int selectedItem) {
    setState(() {
      _selectedItem = selectedItem.toString();
    });
    fetchData(currentPage + 1, int.parse(_selectedItem), batchUploadIDController.text); // Fetch the previous page of data
  }

  void _onPageSelected(int page) {
    setState(() {
      currentPage = page;
    });
  }

  // Function to handle go-to-page input
  void _onGoToPage(String value) {
    final int? page = int.tryParse(value);
    print('GOTO PG: $page');
    if (page != null && page > 0 && page <= totalPages) {
      setState(() {
        currentPage = page - 1; // To match the pagination 1-indexed
      });
    }
    fetchData(currentPage + 1, int.parse(_selectedItem), batchUploadIDController.text);
    print('Current PG: $currentPage');
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const HeaderBar(screenText: 'Top-up Transaction History'),
            // Text(
            //   'Top Up Clients List',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
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
                  ShowListWidget(rowsPerPageController: _rowsperpagecontroller, rowsPerPage: _selectedItem, onPageSizeChange: onPageSizeChange),
                  const Spacer(),
                  const Responsive(desktop: Clock(), mobile: Spacer()),
                ],
              ),
            ),
            const SizedBox(height: 5),

            ///FILE TEXT FIELD AND OTHER CTAs
            // Row(
            //   children: [
            //     //file textfield
            //     ConstrainedBox(
            //       constraints: const BoxConstraints(maxWidth: 300),
            //       child: SizedBox(
            //         width: MediaQuery.of(context).size.width * 0.4,
            //         height: 35,
            //         child: TextField(
            //           style: TextStyles.dataTextStyle,
            //           controller: fileNameController,
            //           textAlignVertical: TextAlignVertical.center,
            //           cursorColor: AppColors.maroon2,
            //           cursorWidth: 1,
            //           cursorRadius: const Radius.circular(5),
            //           decoration: InputDecoration(
            //             contentPadding: const EdgeInsets.all(10),
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
            //             suffixIcon: InkWell(
            //                 onTap: () {
            //                   setState(() {
            //                     fileNameController.clear();
            //                     selectedFileName = '';
            //                     fetchDistinct();
            //                     _initializeData();
            //                   });
            //                 },
            //                 child: const Icon(Icons.close, size: 20)),
            //             hintText: selectedFileName.isEmpty ? 'Select a file' : selectedFileName,
            //             hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 11, color: Colors.black54),
            //           ),
            //           readOnly: true,
            //         ),
            //       ),
            //     ),
            //     Container(
            //       height: 35,
            //       decoration: const BoxDecoration(
            //         border: Border(
            //           top: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
            //           right: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
            //           bottom: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
            //           // left: BorderSide(color: Color(0xff1E5128), width: 0, style: BorderStyle.solid),
            //         ),
            //         borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
            //         color: AppColors.maroon2,
            //       ),
            //       child: PopupMenuButton<String>(
            //         splashRadius: 20,
            //         icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.white),
            //         onSelected: (String selectedItem) {
            //           setState(() {
            //             // _unitcontroller.clear();
            //             // _centercontroller.clear();
            //             // selectedUnit = '';
            //             // selectedCenter = '';
            //             selectedFileName = selectedItem;
            //             debugPrint('File Selected: $selectedFileName');
            //             fetchDistinct();
            //             _initializeData();
            //           });
            //         },
            //         itemBuilder: (BuildContext context) {
            //           if (displayFileName.isEmpty) {
            //             return [
            //               const PopupMenuItem<String>(
            //                 height: 20,
            //                 value: null,
            //                 child: Center(
            //                   child: Text(
            //                     'No File Uploaded Yet',
            //                     style: TextStyle(
            //                       fontFamily: 'RobotoThin',
            //                       color: Colors.black54,
            //                       fontSize: 12,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ];
            //           } else {
            //             return displayFileName.map((String type) {
            //               return PopupMenuItem<String>(
            //                 height: 20,
            //                 value: type,
            //                 child: Center(
            //                   child: Text(
            //                     type,
            //                     style: const TextStyle(
            //                       fontFamily: 'RobotoThin',
            //                       color: Colors.black54,
            //                       fontSize: 12,
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             }).toList();
            //           }
            //         },
            //         elevation: 8,
            //       ),
            //     ),
            //   ],
            // ),
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
                            ? const Center(
                                child: NoRecordsFound(),
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
                              ))),
            const SizedBox(height: 10),

            //PAGINATION BUTTON CODE
            PaginationControls(
              currentPage: (totalRecords == 0) ? 0 : (currentPage + 1),
              totalPages: totalPages,
              totalRecords: totalRecords,
              onPreviousPage: previousPage,
              onNextPage: nextPage,
              title: 'Clients',
            ),
            // PaginationControls(
            //   currentPage: displayPage,
            //   totalPages: totalPages,
            //   totalRecords: totalRecords,
            //   rowsPerPage: int.parse(_selectedItem),
            //   onPreviousPage: previousPage,
            //   onNextPage: nextPage,
            //   onPageSelected: _onPageSelected,
            //   onRowsPerPageChanged: onPageSizeChange,
            //   onGoToPage: _onGoToPage,
            //   title: 'Clients',
            // ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'SUCCESS':
        return Colors.green.shade600; // Green color for Approved status
      case 'FAILED':
        return Colors.red.shade600; // Red color for Disapproved status
      case '':
        return Colors.transparent; // Red color for Disapproved status
      default:
        return Colors.transparent; // Default color (you can change this as per your design)
    }
  }
}
