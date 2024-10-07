// // import 'dart:convert';
// // import 'dart:core';
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_spinkit/flutter_spinkit.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:iconsax_flutter/iconsax_flutter.dart';
// <<<<<<< Updated upstream
// // //import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/civilStatusModel.dart';
// =======
// // import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/civilStatusModel.dart';
// // import 'package:mfi_whitelist_admin_portal/core/provider/mfi/mfi_client_all_provider.dart';
// >>>>>>> Stashed changes
// // import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
// // import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/header/header.dart';
// // import 'package:mfi_whitelist_admin_portal/ui/shared/clock/clock.dart';
// // import 'package:mfi_whitelist_admin_portal/ui/shared/formatters/formatter.dart';
// // import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/getuserinfo/getuserinfo.dart';
// // import 'package:mfi_whitelist_admin_portal/ui/shared/utils/utils_responsive.dart';
// // import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
// // import 'package:mfi_whitelist_admin_portal/ui/shared/widget/buttons/button.dart';
// // import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/container.dart';
// // import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/dialog.dart';
// // import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/pop_container.dart';
// // import 'package:mfi_whitelist_admin_portal/ui/shared/widget/fields/file_selector.dart';
// // import 'package:mfi_whitelist_admin_portal/ui/shared/widget/fields/simplified_widget.dart';
// // import 'package:mfi_whitelist_admin_portal/ui/shared/widget/pagination/pagination_button.dart';
// <<<<<<< Updated upstream
// //
// // import '../../../../../core/mfi_whitelist_api/clients/update_client.dart';
// // import '../../../../../core/models/mfi_whitelist_admin_portal/civilStatusModel.dart';
// =======
// // import 'package:provider/provider.dart';
// //
// // import '../../../../../core/mfi_whitelist_api/clients/update_client.dart';
// >>>>>>> Stashed changes
// // import '../../../../../core/models/mfi_whitelist_admin_portal/clientModel.dart';
// // import '../../../../../core/models/mfi_whitelist_admin_portal/whitelistModel.dart';
// // import '../../../../../main.dart';
// // import '../../../../shared/sessionmanagement/gettoken/gettoken.dart';
// // import '../../../../shared/values/styles.dart';
// // import '../../../../shared/widget/alert_dialog/alert_dialogs.dart';
// //
// // class ApprovedClients extends StatefulWidget {
// //   const ApprovedClients({Key? key}) : super(key: key);
// //
// //   @override
// //   State<ApprovedClients> createState() => _ApprovedClientsState();
// // }
// //
// // class _ApprovedClientsState extends State<ApprovedClients> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeData();
// //     updateUrl('/Access/Client_List/Approved_Clients');
// //     rowData = RowData(data: {}, isEditing: false);
// //   }
// //
// //   @override
// //   void dispose() {
// //     _verticalScrollController1.dispose();
// //     _verticalScrollController2.dispose();
// //     super.dispose();
// //   }
// //
// //   ///Continue to call setState as usual in your code.
// //   ///The overridden method ensures that setState is only called when the widget is mounted.
// //   @override
// //   void setState(fn) {
// //     if (mounted) {
// //       super.setState(fn);
// //     }
// //   }
// //
// //   final token = getToken();
// //   final userRole = getUrole();
// //   late RowData rowData;
// //
// //   ScrollController _verticalScrollController1 = ScrollController();
// //   ScrollController _verticalScrollController2 = ScrollController();
// //   final TextEditingController _rowsPerPageController = TextEditingController();
// //   TextEditingController fileNameController = TextEditingController();
// //   TextEditingController batchUploadIDController = TextEditingController();
// //   TextEditingController searchController = TextEditingController();
// //
// //   List<RowData> apiData = [];
// //   List<RowData> _allData = [];
// //   int currentPage = 0;
// //   int itemsPerPage = 10;
// //   int totalRecords = 0;
// //   int totalPages = 0;
// //   String selectedFileName = '';
// //   String selectedUnit = '';
// //   String selectedCenter = '';
// //   String selectedFrom = '';
// //   String selectedTo = '';
// //   DateTime initialDate = DateTime.now();
// //   String? _selectedClassification;
// //   String getCID = '';
// <<<<<<< Updated upstream
// =======
// //   String getFullName = '';
// >>>>>>> Stashed changes
// //
// //   List<String> displayFileName = [];
// //   String _selectedItem = '10';
// //   int? activeRowIndex;
// //   // Create a global list to store selected rows' cids
// //   List<String> selectedRowsCids = [];
// //
// //   ///BOOLEAN VALUES
// //   bool isEditing = false;
// //   bool hasChanges = false;
// //   final bool _sortAscending = true;
// //   bool isLoading = true; // Add this variable to track loading state
// //   bool isClosed = false;
// //   bool isMinimize = false;
// <<<<<<< Updated upstream
// //   bool showEditInfo = false;
// //   bool isSelected = false;
// //   bool categoryOnPressed = false;
// =======
// //   bool showEditInfo = false; //Opens the pop up panel for edit info
// //   bool showTopUpInfo = false; //Opens the pop up panel for top up info
// //   bool isSelected = false;
// //   bool categoryOnPressed = false;
// //   bool isSelectAllChecked = false;
// //
// //   // Define your classifications
// //   final List<String> classifications = ['All', 'Client', 'Agent'];
// >>>>>>> Stashed changes
// //
// //   final List<String> editableFields = [
// //     'firstName',
// //     'middleName',
// //     'lastName',
// //     'maidenFName',
// //     'maidenMName',
// //     'maidenLName',
// //     'mobileNumber',
// //     'birthday',
// //     'placeOfBirth',
// //     'religion',
// //     'civilStatus',
// //     'citizenship',
// //     'presentAddress',
// //     'permanentAddress',
// //     'city',
// //     'province',
// //     'postalCode',
// //     'memberMaidenFName',
// //     'memberMaidenMName',
// //     'memberMaidenLName',
// //     'email',
// //     'sourceOfFund',
// //     'employerOrBusinessName',
// //     'employerOrBusinessAddress',
// //   ];
// //
// //   ///FETCH DATA FROM API
// //   Map<String, String> fileBatchUploadMap = {};
// //
// //   ///STORES THE UPLOAD IDS OF THE FETCHED FILES
// //   Future<void> fetchDistinct() async {
// //     try {
// //       final token = getToken();
// //       final response = await http.get(
// //         Uri.parse('${UrlGetter.getURL()}/filters/test/get/all/distinct/approved'),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //         },
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final responseData = json.decode(response.body);
// //         debugPrint('Distinct ${responseData.toString()}');
// //
// //         if (responseData['distinctData'] != null) {
// //           fileBatchUploadMap.clear(); // Clear the previous mapping if any
// //           for (var item in responseData['distinctData']) {
// //             if (item['fileName'] != null && item['batchUploadId'] != null) {
// //               fileBatchUploadMap[item['fileName']] = item['batchUploadId'].toString();
// //             }
// //           }
// //         }
// //
// //         // Print the map contents
// //         debugPrint('File Batch Upload Map: $fileBatchUploadMap');
// //
// //         setState(() {
// //           displayFileName = fileBatchUploadMap.keys.toList(); // Update the display file names
// //         });
// //       } else {
// //         debugPrint('FAILED');
// //         debugPrint(response.body);
// //         throw Exception('Failed to load menu data: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       debugPrint('Exception occurred: $e');
// //     }
// //   }
// //
// //   void fetchData(int page, int perPage, String? batchUploadID) async {
// //     print('call api: $page');
// //     setState(() {
// //       isLoading = true;
// //     });
// //     String? fetchedBatchUploadID = fileBatchUploadMap[selectedFileName];
// //
// //     if (fetchedBatchUploadID != null) {
// //       batchUploadIDController.text = fetchedBatchUploadID;
// //     }
// //
// //     try {
// //       final token = getToken();
// //       final url = Uri.parse('${UrlGetter.getURL()}/clients/test/get/all/approved?page=$page&perPage=$perPage&batch_upload_id=${batchUploadID ?? ''}');
// //       fileNameController.text = selectedFileName;
// //
// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //         },
// //       );
// //
// //       debugPrint('Requested URL APPROVED CLIENTS: $url');
// //
// //       if (response.statusCode == 200) {
// //         final jsonData = json.decode(utf8.decode(response.bodyBytes));
// //         if (jsonData['retCode'] == '200') {
// //           final data = jsonData['data'];
// //
// //           if (data is List) {
// //             setState(() {
// //               // apiData = List<RowData>.from(data.map((item) => RowData(
// //               //       isEditing: false,
// //               //       data: Map<String, dynamic>.from(item),
// //               //     )));
// //               // Store all data before applying classification filter
// //               _allData = List<RowData>.from(data.map((item) => RowData(
// //                     isEditing: false,
// //                     data: Map<String, dynamic>.from(item),
// //                   )));
// //               applyClassificationFilter();
// //               totalRecords = jsonData['totalRecords'];
// //               totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
// //               isLoading = false;
// //             });
// //           } else {
// //             debugPrint('JSON data is not in the expected format');
// //             setState(() {
// //               if (mounted) {
// //                 isLoading = false;
// //                 apiData = []; // Clear existing data or update with new data
// //               }
// //             });
// //           }
// //         } else if (jsonData['data'] == null) {
// //           totalRecords = 0;
// //           setState(() {
// //             if (mounted) {
// //               isLoading = false;
// //               apiData = []; // Clear existing data or update with new data
// //             }
// //           });
// //         } else {
// //           debugPrint('NO DATA AVAILABLE');
// //           setState(() {
// //             if (mounted) {
// //               isLoading = false;
// //               apiData = []; // Clear existing data or update with new data
// //             }
// //           });
// //         }
// //       } else {
// //         debugPrint('No data fetched: ${response.body}');
// //         debugPrint('HTTP Request failed with status code: ${response.statusCode}');
// //         debugPrint('Response body: ${response.body}');
// //         setState(() {
// //           if (mounted) {
// //             isLoading = false;
// //             apiData = []; // Clear existing data or update with new data
// //           }
// //         });
// //       }
// //     } catch (error) {
// //       debugPrint('Error fetching data: $error');
// //       setState(() {
// //         if (mounted) {
// //           isLoading = false;
// //           apiData = []; // Clear existing data or update with new data
// //         }
// //       });
// //     }
// //   }
// //
// //   ///RESETS THE DATA AND VARIABLES
// //   void _initializeData() {
// //     fetchData(currentPage, int.parse(_selectedItem), '');
// //     currentPage = 0;
// //     fetchDistinct();
// //   }
// //
// //   // Getter for displayPage
// //   int get displayPage => (totalRecords == 0) ? 0 : (currentPage + 1);
// //
// //   //SETTER FOR THE SELECTED ROWS
// //   final Set<int> _hoveredRows = {}; // Keep track of hovered row indices
// //   final Set<int> _selectedRows = {}; // Keep track of selected rows
// //
// //   //FUNCTION FOR CHECKBOX
// //   void _handleCheckboxChange(int index, bool? value) {
// //     setState(() {
// //       if (value == true) {
// //         _selectedRows.add(index);
// //       } else {
// //         _selectedRows.remove(index);
// //       }
// //     });
// //   }
// //
// //   void nextPage() {
// //     if (currentPage + 1 < totalPages) {
// //       setState(() {
// //         currentPage++; // Update currentPage
// //       });
// //       fetchData(currentPage + 1, int.parse(_selectedItem), batchUploadIDController.text); // Fetch the next page of data
// //     }
// //   }
// //
// //   void previousPage() {
// //     if (currentPage > 0) {
// //       setState(() {
// //         currentPage--; // Update currentPage
// //       });
// //       fetchData(currentPage + 1, int.parse(_selectedItem), batchUploadIDController.text); // Fetch the previous page of data
// //     }
// //   }
// //
// //   void onPageSizeChange(int selectedItem) {
// //     setState(() {
// //       _selectedItem = selectedItem.toString();
// //       fetchData(currentPage + 1, int.parse(_selectedItem), batchUploadIDController.text);
// //     });
// //   }
// //
// //   void _onPageSelected(int page) {
// //     setState(() {
// //       currentPage = page;
// //     });
// //   }
// //
// //   // Function to handle go-to-page input
// //   void _onGoToPage(String value) {
// //     final int? page = int.tryParse(value);
// //     debugPrint('GOTO PG: $page');
// //     if (page != null && page > 0 && page <= totalPages) {
// //       setState(() {
// //         currentPage = page - 1; // To match the pagination 1-indexed
// //       });
// //     }
// //
// //     fetchData(currentPage + 1, int.parse(_selectedItem), batchUploadIDController.text);
// //   }
// //
// //   void applyClassificationFilter() {
// //     List<RowData> filteredData;
// //
// //     if (_selectedClassification == null || _selectedClassification == 'All') {
// //       filteredData = _allData; // No filter or 'All' selected
// //     } else {
// //       filteredData = _allData.where((rowData) {
// //         final classification = rowData.data['memberClassification'];
// //         return classification == _selectedClassification;
// //       }).toList();
// //     }
// //
// //     // Calculate the new total records based on the filtered data
// //     int newTotalRecords = filteredData.length;
// //
// //     // Calculate the new total pages based on the records per page
// //     int newTotalPages = (newTotalRecords / int.parse(_selectedItem)).ceil();
// //
// //     setState(() {
// //       apiData = filteredData; // Update state with filtered data
// //       totalRecords = newTotalRecords; // Update total records
// //       totalPages = newTotalPages; // Update total pages
// //     });
// //   }
// //
// //   ///WIDGET DESIGN OF THE TABLE CONTENT
// //   ///WITH COLUMN WIDTH
// //   List<double> getColumnWidths(List<String> headers, List<Map<String, dynamic>> data) {
// //     final List<double> widths = List.filled(headers.length, 0.0);
// //
// //     // Set a fixed width for the checkbox column with padding of 30
// //     const double checkboxColumnWidth = 90.0;
// //     widths[0] = checkboxColumnWidth;
// //
// //     for (int i = 1; i < headers.length; i++) {
// //       final TextPainter painter = TextPainter(
// //         text: TextSpan(
// //           text: headers[i],
// //           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
// //         ),
// //         textDirection: TextDirection.ltr,
// //       )..layout();
// //       widths[i] = painter.size.width;
// //     }
// //
// //     for (var row in data) {
// //       final values = [
// //         row['watchlistedType'],
// //         row['cid'],
// //         row['firstName'],
// //         row['middleName'],
// //         row['lastName'],
// //         row['mobileNumber'],
// //         row['institutionCode'],
// //         row['createdAt'],
// //         row['updatedAt'],
// //       ];
// //
// //       for (int i = 1; i < values.length; i++) {
// //         final TextPainter painter = TextPainter(
// //           text: TextSpan(
// //             text: values[i]?.toString() ?? '',
// //             style: TextStyles.dataTextStyle,
// //           ),
// //           textDirection: TextDirection.ltr,
// //         )..layout();
// //         widths[i] = widths[i] > painter.size.width ? widths[i] : painter.size.width;
// //       }
// //     }
// //
// //     const double padding = 100.0; // Adjust padding based on your layout needs
// //     for (int i = 1; i < widths.length; i++) {
// //       widths[i] += padding;
// //     }
// //
// //     return widths;
// //   }
// //
// //   //HEADERS
// //   List<Widget> buildHeaderCells(List<String> headers, List<double> columnWidths) {
// //     return headers.asMap().entries.map((entry) {
// //       final index = entry.key;
// //       final header = entry.value;
// //
// //       return Container(
// //         width: columnWidths[index],
// //         padding: const EdgeInsets.all(8),
// //         child: Text(
// //           header,
// //           style: TextStyle(
// //             fontSize: 14,
// //             color: Colors.black.withOpacity(0.6),
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //       );
// //     }).toList();
// //   }
// //
// //   // List<Widget> getPaginatedRows(List<double> columnWidths) {
// //   //   return apiData.asMap().entries.map<Widget>((entry) {
// //   //     final index = entry.key;
// //   //     final rowData = entry.value;
// //   //     final isSelected = rowData.isEditing; // Use isEditing to determine if the row is selected
// //   //     final isHovered = rowData.isHovered || isSelected;
// //   //
// //   //     // Define the background color based on hover and selection
// //   //     final color = isSelected
// //   //         ? Colors.indigo.shade50 // Highlight color for selected row
// //   //         : isHovered
// //   //             ? Colors.grey.withOpacity(0.1) // Hover color for all rows
// //   //             : index % 2 == 0
// //   //                 ? Colors.transparent
// //   //                 : Colors.white;
// //   //
// //   //     return GestureDetector(
// //   //       onTap: () {
// //   //         setState(() {
// //   //           rowData.isEditing = !rowData.isEditing; // Toggle checkbox state
// //   //         });
// //   //       },
// //   //       child: MouseRegion(
// //   //         onEnter: (_) {
// //   //           setState(() {
// //   //             rowData.isHovered = true;
// //   //           });
// //   //         },
// //   //         onExit: (_) {
// //   //           setState(() {
// //   //             rowData.isHovered = false;
// //   //           });
// //   //         },
// //   //         child: Stack(
// //   //           children: [
// //   //             Container(
// //   //               decoration: BoxDecoration(
// //   //                 color: color,
// //   //                 border: isSelected
// //   //                     ? const Border(
// //   //                         left: BorderSide(width: 0.5, color: Colors.black12),
// //   //                         right: BorderSide(width: 0.5, color: Colors.black12),
// //   //                       )
// //   //                     : Border(
// //   //                         top: isHovered ? const BorderSide(width: 0.2, color: Colors.black12) : BorderSide.none,
// //   //                         bottom: isHovered ? const BorderSide(width: 2, color: Colors.black12) : const BorderSide(width: 0.5, color: Colors.black12),
// //   //                         left: const BorderSide(width: 0.5, color: Colors.black12),
// //   //                         right: const BorderSide(width: 0.5, color: Colors.black12),
// //   //                       ),
// //   //               ),
// //   //               child: Row(
// //   //                 children: [
// //   //                   buildDataCell(
// //   //                     Row(
// //   //                       children: [
// //   //                         _popupMenuButton(
// //   //                           context,
// //   //                           index,
// //   //                           isHovered || isSelected ? Colors.grey.shade900 : Colors.grey.shade400,
// //   //                         ),
// //   //                         Container(
// //   //                           margin: const EdgeInsets.only(left: 5),
// //   //                           width: 10,
// //   //                           child: Checkbox(
// //   //                             value: rowData.isEditing,
// //   //                             onChanged: isHovered
// //   //                                 ? (value) {
// //   //                                     setState(() {
// //   //                                       rowData.isEditing = value ?? false; // Update state
// //   //                                     });
// //   //                                   }
// //   //                                 : null, // Disable if not hovered
// //   //                             activeColor: isHovered ? AppColors.maroon2 : Colors.grey,
// //   //                             checkColor: Colors.white,
// //   //                             side: BorderSide(color: isHovered ? Colors.grey.shade900 : Colors.grey.shade400),
// //   //                           ),
// //   //                         ),
// //   //                       ],
// //   //                     ),
// //   //                     columnWidths[0],
// //   //                     padding: const EdgeInsets.all(0.0),
// //   //                   ),
// //   //                   buildDataCell(
// //   //                     Container(
// //   //                       margin: const EdgeInsets.only(left: 10),
// //   //                       child: Row(
// //   //                         children: [
// //   //                           Container(
// //   //                             width: 130,
// //   //                             height: 30,
// //   //                             decoration: BoxDecoration(
// //   //                               borderRadius: BorderRadius.circular(20),
// //   //                               color: _getClientClassificationColor(rowData.data['memberClassification']).withOpacity(0.2),
// //   //                               boxShadow: [
// //   //                                 BoxShadow(
// //   //                                   color: _getClientClassificationColor(rowData.data['memberClassification']).withOpacity(0.2),
// //   //                                   spreadRadius: 2,
// //   //                                   blurRadius: 5,
// //   //                                   offset: const Offset(3, 3),
// //   //                                 ),
// //   //                                 BoxShadow(
// //   //                                   color: Colors.white,
// //   //                                   spreadRadius: isSelected ? 0 : 2,
// //   //                                   blurRadius: isSelected ? 0 : 5,
// //   //                                   offset: isSelected ? const Offset(0, 0) : const Offset(-3, -3),
// //   //                                 ),
// //   //                               ],
// //   //                             ),
// //   //                             child: Center(
// //   //                               child: Text(
// //   //                                 rowData.data['memberClassification']?.toUpperCase() ?? '',
// //   //                                 style: TextStyle(
// //   //                                   color: _getClientClassificationColor(rowData.data['memberClassification']),
// //   //                                   fontWeight: FontWeight.bold,
// //   //                                 ),
// //   //                               ),
// //   //                             ),
// //   //                           ),
// //   //                           if (rowData.isEditing)
// //   //                             Tooltip(
// //   //                               message: rowData.data['memberClassification'] == 'Agent' ? 'Revert back to Client' : 'Promote to Agent',
// //   //                               child: IconButton(
// //   //                                 icon: Icon(
// //   //                                   rowData.data['memberClassification'] == 'Agent' ? Icons.move_down : Icons.move_up,
// //   //                                   color: AppColors.maroon2,
// //   //                                 ),
// //   //                                 onPressed: () {
// //   //                                   print('original: ${rowData.data['memberClassification']}');
// //   //                                   setState(() {
// //   //                                     final cid = rowData.data['cid'];
// //   //                                     rowData.controllers['memberClassification']?.text = rowData.data['memberClassification'] == 'Agent' ? 'Client' : 'Agent';
// //   //                                     print('controller: ${rowData.controllers['memberClassification']?.text}');
// //   //                                     _showConfirmUpdateAlertDialog(context, cid, index);
// //   //                                     // hasChanges = true;
// //   //                                   });
// //   //                                 },
// //   //                               ),
// //   //                             ),
// //   //                         ],
// //   //                       ),
// //   //                     ),
// //   //                     columnWidths[1],
// //   //                     padding: EdgeInsets.zero,
// //   //                   ),
// //   //                   buildDataCell(Text(rowData.data['watchlistedType'] ?? ''), columnWidths[2]),
// //   //                   buildDataCell(Text(rowData.data['cid'] ?? ''), columnWidths[3]),
// //   //                   buildDataCell(Text(rowData.data['firstName'] ?? ''), columnWidths[4]),
// //   //                   buildDataCell(Text(rowData.data['middleName'] ?? ''), columnWidths[5]),
// //   //                   buildDataCell(Text(rowData.data['lastName'] ?? ''), columnWidths[6]),
// //   //                   buildDataCell(Text(rowData.data['mobileNumber'] ?? ''), columnWidths[7]),
// //   //                   buildDataCell(Text(rowData.data['institutionCode'] ?? ''), columnWidths[8]),
// //   //                   buildDataCell(Text(rowData.data['createdAt'] ?? ''), columnWidths[9]),
// //   //                   buildDataCell(Text(rowData.data['updatedAt'] ?? ''), columnWidths[10]),
// //   //                 ],
// //   //               ),
// //   //             ),
// //   //             // if (activeRowIndex == index && categoryOnPressed) _popupMenuButton(context, index),
// //   //           ],
// //   //         ),
// //   //       ),
// //   //     );
// //   //   }).toList();
// //   // }
// //
// //   Widget buildDataCell(Widget widget, double width, {EdgeInsetsGeometry? padding}) {
// //     return Container(
// //       margin: const EdgeInsets.only(top: 10, bottom: 10),
// //       width: width,
// //       height: 40,
// //       padding: padding ?? const EdgeInsets.all(10),
// //       child: widget,
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     List<String> fixedHeaders = ['', 'Client Classification'];
// //     List<String> headers = ['', 'Client Classification', 'Watchlist Type', 'CID', 'First Name', 'Middle Name', 'Last Name', 'Mobile Number', 'Institution Name', 'Created Date', 'Updated Date'];
// //     // Convert apiData (List<RowData>) into List<Map<String, dynamic>> before passing it to getColumnWidths
// //     List<double> columnWidths = getColumnWidths(headers, apiData.map((row) => row.data).toList());
// //
// //     return Stack(
// //       children: [
// //         Container(
// //           padding: const EdgeInsets.only(left: 90),
// //           child: Container(
// //             padding: const EdgeInsets.all(10),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.start,
// //               crossAxisAlignment: CrossAxisAlignment.end,
// //               children: [
// //                 const HeaderBar(screenText: 'APPROVED CLIENTS'),
// //                 Container(
// //                   padding: const EdgeInsets.only(
// //                     right: 10,
// //                     top: 5,
// //                   ),
// //                   decoration: const BoxDecoration(
// //                     color: Colors.transparent,
// //                     borderRadius: BorderRadius.all(
// //                       Radius.circular(5),
// //                     ),
// //                   ),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       //rows&clock
// //
// //                       ///SHOW LIST FILTER
// //                       //FILE TEXT FIELD AND OTHER CTAs
// //                       Row(
// //                         children: [
// //                           ///Choice Chips
// //                           // buildChoiceChips(),
// //
// //                           ///file textfield
// //                           FileSelector(
// //                             fileNameController: fileNameController,
// //                             selectedFileName: selectedFileName,
// //                             displayFileName: displayFileName,
// //                             fileBatchUploadMap: fileBatchUploadMap,
// //                             iconColor: Colors.grey,
// //                             onFileSelected: (String selectedItem) {
// //                               setState(() {
// //                                 selectedFileName = selectedItem;
// //                                 // debugPrint('File Selected: $selectedFileName');
// //                                 String? fetchedBatchUploadID = fileBatchUploadMap[selectedFileName];
// //                                 fetchDistinct();
// //                                 fetchData(currentPage, int.parse(_selectedItem), fetchedBatchUploadID);
// //                               });
// //                             },
// //                             onClear: () {
// //                               setState(() {
// //                                 fileNameController.clear();
// //                                 selectedFileName = '';
// //                                 batchUploadIDController.clear();
// //                                 fetchDistinct();
// //                                 fetchData(currentPage, int.parse(_selectedItem), batchUploadIDController.text);
// //                               });
// //                             },
// //                           )
// //                         ],
// //                       ),
// //                       const Spacer(),
// //                       const Responsive(desktop: Clock(), mobile: Spacer()),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //
// //                 ///Table Body
// //                 Expanded(
// //                   child: Stack(
// //                     alignment: AlignmentDirectional.center,
// //                     children: [
// //                       Row(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           // Frozen Header and Body for columns 0 and 1
// //                           Column(
// //                             children: [
// //                               // Frozen Header for columns 0 and 1
// <<<<<<< Updated upstream
// =======
// //                               // Frozen Header for columns 0 and 1
// >>>>>>> Stashed changes
// //                               Container(
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.black12,
// //                                   border: Border.all(width: 0.5, color: Colors.black12),
// //                                 ),
// //                                 height: 50,
// //                                 child: Row(
// <<<<<<< Updated upstream
// //                                   children: buildHeaderCells(fixedHeaders, columnWidths.sublist(0, 2)), // Only columns 0 and 1 headers
// //                                 ),
// //                               ),
// =======
// //                                   children: [
// //                                     buildDataCell(
// //                                       Row(
// //                                         children: [
// //                                           Checkbox(
// //                                             value: isSelectAllChecked,
// //                                             onChanged: (value) {
// //                                               setState(() {
// //                                                 isSelectAllChecked = value ?? false;
// //                                                 // Update all rows' checkboxes
// //                                                 for (var rowData in apiData) {
// //                                                   rowData.isEditing = isSelectAllChecked;
// //                                                 }
// //                                               });
// //                                             },
// //                                             activeColor: AppColors.maroon2,
// //                                             checkColor: Colors.white,
// //                                           ),
// //                                         ],
// //                                       ),
// //                                       columnWidths[0],
// //                                       padding: const EdgeInsets.only(left: 35.0),
// //                                     ),
// //                                     ...buildHeaderCells(fixedHeaders.sublist(1), columnWidths.sublist(1, 2)), // Only columns 1 header
// //                                   ],
// //                                 ),
// //                               ),
// //
// //                               // Container(
// //                               //   decoration: BoxDecoration(
// //                               //     color: Colors.black12,
// //                               //     border: Border.all(width: 0.5, color: Colors.black12),
// //                               //   ),
// //                               //   height: 50,
// //                               //   child: Row(
// //                               //     children: buildHeaderCells(fixedHeaders, columnWidths.sublist(0, 2)), // Only columns 0 and 1 headers
// //                               //   ),
// //                               // ),
// >>>>>>> Stashed changes
// //                               // Scrollable Body for columns 0 and 1
// //                               if (apiData.isNotEmpty)
// //                                 Expanded(
// //                                   child: NotificationListener<ScrollNotification>(
// //                                     onNotification: (ScrollNotification notification) {
// //                                       if (_verticalScrollController1.hasClients && _verticalScrollController2.hasClients) {
// //                                         if (notification is ScrollUpdateNotification) {
// //                                           // Sync both scroll controllers
// //                                           _verticalScrollController2.jumpTo(_verticalScrollController1.offset);
// //                                         }
// //                                       }
// //                                       return true;
// //                                     },
// //                                     child: ScrollConfiguration(
// //                                       behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
// //                                       child: SingleChildScrollView(
// //                                         controller: _verticalScrollController1,
// //                                         scrollDirection: Axis.vertical,
// //                                         child: Column(
// //                                           children: apiData.asMap().entries.map((entry) {
// //                                             final index = entry.key;
// //                                             final rowData = entry.value;
// //                                             final isSelected = rowData.isEditing; // Use isEditing to determine if the row is selected
// //                                             final isHovered = rowData.isHovered || isSelected;
// //
// //                                             // Define the background color based on hover and selection
// //                                             final color = isSelected
// //                                                 ? Colors.indigo.shade50 // Highlight color for selected row
// //                                                 : isHovered
// //                                                     ? Colors.grey.withOpacity(0.1) // Hover color for all rows
// //                                                     : index % 2 == 0
// //                                                         ? Colors.transparent
// //                                                         : Colors.white;
// //
// //                                             return GestureDetector(
// //                                               onTap: () {
// //                                                 setState(() {
// //                                                   rowData.isEditing = !rowData.isEditing; // Toggle checkbox state
// //                                                 });
// //                                               },
// //                                               child: MouseRegion(
// //                                                 onEnter: (_) {
// //                                                   setState(() {
// //                                                     rowData.isHovered = true;
// //                                                     getCID = rowData.data['cid'];
// <<<<<<< Updated upstream
// =======
// //                                                     getFullName = rowData.data['firstName'] + ' ' + rowData.data['lastName'];
// >>>>>>> Stashed changes
// //                                                   });
// //                                                 },
// //                                                 onExit: (_) {
// //                                                   setState(() {
// //                                                     rowData.isHovered = false;
// //                                                   });
// //                                                 },
// //                                                 child: Stack(
// //                                                   alignment: AlignmentDirectional.centerStart,
// //                                                   children: [
// //                                                     Container(
// //                                                       decoration: BoxDecoration(
// //                                                         color: color,
// //                                                         border: isSelected
// //                                                             ? const Border(
// //                                                                 left: BorderSide(width: 0.5, color: Colors.black12),
// //                                                                 right: BorderSide(width: 0.5, color: Colors.black12),
// //                                                               )
// //                                                             : Border(
// //                                                                 top: isHovered ? const BorderSide(width: 0.2, color: Colors.black12) : BorderSide.none,
// //                                                                 bottom: isHovered ? const BorderSide(width: 2, color: Colors.black12) : const BorderSide(width: 0.5, color: Colors.black12),
// //                                                                 left: const BorderSide(width: 0.5, color: Colors.black12),
// //                                                                 right: const BorderSide(width: 0.5, color: Colors.black12),
// //                                                               ),
// //                                                       ),
// //                                                       child: Row(
// //                                                         children: [
// //                                                           buildDataCell(
// //                                                             Row(
// //                                                               children: [
// //                                                                 _popupMenuButton(
// //                                                                   context,
// //                                                                   index,
// //                                                                   isHovered || isSelected ? Colors.grey.shade900 : Colors.grey.shade400,
// //                                                                 ),
// //                                                                 Container(
// //                                                                   margin: const EdgeInsets.only(left: 5),
// //                                                                   width: 10,
// //                                                                   child: Checkbox(
// //                                                                     value: rowData.isEditing,
// //                                                                     onChanged: isHovered
// //                                                                         ? (value) {
// //                                                                             setState(() {
// <<<<<<< Updated upstream
// //                                                                               rowData.isEditing = value ?? false; // Update state
// =======
// //                                                                               rowData.isEditing = value ?? false;
// //                                                                               // If any row is unchecked, uncheck the "Select All" checkbox
// //                                                                               if (!rowData.isEditing) {
// //                                                                                 isSelectAllChecked = false;
// //                                                                               } else {
// //                                                                                 // If all rows are checked, check the "Select All" checkbox
// //                                                                                 isSelectAllChecked = apiData.every((row) => row.isEditing);
// //                                                                               }
// >>>>>>> Stashed changes
// //                                                                             });
// //                                                                           }
// //                                                                         : null, // Disable if not hovered
// //                                                                     activeColor: isHovered ? AppColors.maroon2 : Colors.grey,
// //                                                                     checkColor: Colors.white,
// //                                                                     side: BorderSide(color: isHovered ? Colors.grey.shade900 : Colors.grey.shade400),
// //                                                                   ),
// //                                                                 ),
// <<<<<<< Updated upstream
// =======
// //
// //                                                                 // Container(
// //                                                                 //   margin: const EdgeInsets.only(left: 5),
// //                                                                 //   width: 10,
// //                                                                 //   child: Checkbox(
// //                                                                 //     value: rowData.isEditing,
// //                                                                 //     onChanged: isHovered
// //                                                                 //         ? (value) {
// //                                                                 //             setState(() {
// //                                                                 //               rowData.isEditing = value ?? false; // Update state
// //                                                                 //             });
// //                                                                 //           }
// //                                                                 //         : null, // Disable if not hovered
// //                                                                 //     activeColor: isHovered ? AppColors.maroon2 : Colors.grey,
// //                                                                 //     checkColor: Colors.white,
// //                                                                 //     side: BorderSide(color: isHovered ? Colors.grey.shade900 : Colors.grey.shade400),
// //                                                                 //   ),
// //                                                                 // ),
// >>>>>>> Stashed changes
// //                                                               ],
// //                                                             ),
// //                                                             columnWidths[0],
// //                                                             padding: const EdgeInsets.all(0.0),
// //                                                           ),
// //                                                           buildDataCell(
// //                                                             Row(
// //                                                               children: [
// //                                                                 Container(
// //                                                                   width: 150,
// //                                                                   height: 40,
// //                                                                   decoration: BoxDecoration(
// //                                                                     borderRadius: BorderRadius.circular(20),
// //                                                                     color: _getClientClassificationColor(rowData.data['memberClassification']).withOpacity(0.2),
// //                                                                     boxShadow: [
// //                                                                       BoxShadow(
// //                                                                         color: _getClientClassificationColor(rowData.data['memberClassification']).withOpacity(0.2),
// //                                                                         spreadRadius: 2,
// //                                                                         blurRadius: 5,
// //                                                                         offset: const Offset(3, 3),
// //                                                                       ),
// //                                                                       BoxShadow(
// //                                                                         color: Colors.white,
// //                                                                         spreadRadius: isSelected ? 0 : 2,
// //                                                                         blurRadius: isSelected ? 0 : 5,
// //                                                                         offset: isSelected ? const Offset(0, 0) : const Offset(-3, -3),
// //                                                                       ),
// //                                                                     ],
// //                                                                   ),
// //                                                                   child: Center(
// //                                                                     child: Text(
// //                                                                       rowData.data['memberClassification'] ?? '',
// //                                                                       style: TextStyle(
// //                                                                         color: _getClientClassificationColor(rowData.data['memberClassification']),
// //                                                                         fontWeight: FontWeight.bold,
// //                                                                       ),
// //                                                                     ),
// //                                                                   ),
// //                                                                 ),
// //                                                                 if (rowData.isEditing)
// //                                                                   Tooltip(
// //                                                                     message: rowData.data['memberClassification'] == 'Agent' ? 'Revert back to Client' : 'Promote to Agent',
// //                                                                     child: IconButton(
// //                                                                       icon: Icon(
// //                                                                         rowData.data['memberClassification'] == 'Agent' ? Icons.move_down : Icons.move_up,
// //                                                                         color: AppColors.maroon2,
// //                                                                       ),
// //                                                                       onPressed: () {
// //                                                                         print('original: ${rowData.data['memberClassification']}');
// //                                                                         setState(() {
// //                                                                           final cid = rowData.data['cid'];
// //                                                                           rowData.controllers['memberClassification']?.text = rowData.data['memberClassification'] == 'Agent' ? 'Client' : 'Agent';
// //                                                                           print('controller: ${rowData.controllers['memberClassification']?.text}');
// //                                                                           _showConfirmUpdateAlertDialog(context, cid, index);
// //                                                                           // hasChanges = true;
// //                                                                         });
// //                                                                       },
// //                                                                     ),
// //                                                                   ),
// //                                                               ],
// //                                                             ),
// //                                                             columnWidths[1],
// <<<<<<< Updated upstream
// //                                                             padding: EdgeInsets.only(left: 10),
// =======
// //                                                             padding: const EdgeInsets.only(left: 10),
// >>>>>>> Stashed changes
// //                                                           ),
// //                                                         ],
// //                                                       ),
// //                                                     ),
// //                                                     if (isSelected)
// //                                                       Container(
// //                                                         width: 5,
// //                                                         height: 40,
// //                                                         color: AppColors.infoColor,
// //                                                       ),
// //                                                   ],
// //                                                 ),
// //                                               ),
// //                                             );
// //                                           }).toList(),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                             ],
// //                           ),
// //                           // Scrollable Header and Body for remaining columns (index 2 and beyond)
// //                           Expanded(
// //                             child: SingleChildScrollView(
// //                               scrollDirection: Axis.horizontal,
// //                               child: Column(
// //                                 children: [
// //                                   // Scrollable Header for remaining columns (index 2 and beyond)
// //                                   Container(
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.black12,
// //                                       border: Border.all(width: 0.5, color: Colors.black12),
// //                                     ),
// //                                     height: 50,
// //                                     child: Row(
// //                                       children: buildHeaderCells(headers.sublist(2), columnWidths.sublist(2)), // Headers from column 2 onward
// //                                     ),
// //                                   ),
// //                                   // Scrollable Body for remaining columns
// //                                   if (apiData.isNotEmpty)
// //                                     Expanded(
// //                                       child: NotificationListener<ScrollNotification>(
// //                                         onNotification: (ScrollNotification notification) {
// //                                           if (_verticalScrollController1.hasClients && _verticalScrollController2.hasClients) {
// //                                             if (notification is ScrollUpdateNotification) {
// //                                               // Sync both scroll controllers
// //                                               _verticalScrollController1.jumpTo(_verticalScrollController2.offset);
// //                                             }
// //                                           }
// //                                           return true;
// //                                         },
// //                                         child: SingleChildScrollView(
// //                                           controller: _verticalScrollController2,
// //                                           scrollDirection: Axis.vertical,
// //                                           child: Column(
// //                                             children: apiData.asMap().entries.map((entry) {
// //                                               final index = entry.key;
// //                                               final rowData = entry.value;
// //                                               final isSelected = rowData.isEditing;
// //                                               final isHovered = rowData.isHovered || isSelected;
// //
// //                                               final color = isSelected
// //                                                   ? Colors.indigo.shade50
// //                                                   : isHovered
// //                                                       ? Colors.grey.withOpacity(0.1)
// //                                                       : index % 2 == 0
// //                                                           ? Colors.transparent
// //                                                           : Colors.white;
// //
// //                                               return GestureDetector(
// //                                                 onTap: () {
// //                                                   setState(() {
// //                                                     rowData.isEditing = !rowData.isEditing; // Toggle checkbox state
// //                                                   });
// //                                                 },
// //                                                 child: MouseRegion(
// //                                                   onEnter: (_) {
// //                                                     setState(() {
// //                                                       rowData.isHovered = true;
// //                                                     });
// //                                                   },
// //                                                   onExit: (_) {
// //                                                     setState(() {
// //                                                       rowData.isHovered = false;
// //                                                     });
// //                                                   },
// //                                                   child: Container(
// //                                                     decoration: BoxDecoration(
// //                                                       color: color,
// //                                                       border: isSelected
// //                                                           ? const Border(
// //                                                               left: BorderSide(width: 0.5, color: Colors.black12),
// //                                                               right: BorderSide(width: 0.5, color: Colors.black12),
// //                                                             )
// //                                                           : Border(
// //                                                               top: isHovered ? const BorderSide(width: 0.2, color: Colors.black12) : BorderSide.none,
// //                                                               bottom: isHovered ? const BorderSide(width: 2, color: Colors.black12) : const BorderSide(width: 0.5, color: Colors.black12),
// //                                                               left: const BorderSide(width: 0.5, color: Colors.black12),
// //                                                               right: const BorderSide(width: 0.5, color: Colors.black12),
// //                                                             ),
// //                                                     ),
// //                                                     child: Row(
// //                                                       children: [
// //                                                         // buildDataCell(Text(rowData.data['watchlistedType'] ?? ''), columnWidths[2]),
// //                                                         buildDataCell(
// //                                                           Container(
// //                                                             decoration: BoxDecoration(
// //                                                               borderRadius: BorderRadius.circular(5),
// //                                                               color: rowData.data['watchlistedType'] != '' ? _getWatchlistClassificationColor(rowData.data['watchlistedType']).withOpacity(0.2) : Colors.transparent,
// //                                                             ),
// //                                                             child: Center(
// //                                                               child: Text(
// //                                                                 rowData.data['watchlistedType'] ?? '',
// //                                                                 style: TextStyle(
// //                                                                   color: _getWatchlistClassificationColor(rowData.data['watchlistedType']),
// //                                                                   fontWeight: FontWeight.bold,
// //                                                                 ),
// //                                                               ),
// //                                                             ),
// //                                                           ),
// //                                                           columnWidths[2],
// <<<<<<< Updated upstream
// //                                                           padding: EdgeInsets.symmetric(horizontal: 10),
// =======
// //                                                           padding: const EdgeInsets.symmetric(horizontal: 10),
// >>>>>>> Stashed changes
// //                                                         ),
// //                                                         buildDataCell(Text(rowData.data['cid'] ?? ''), columnWidths[3]),
// //                                                         buildDataCell(Text(rowData.data['firstName'] ?? ''), columnWidths[4]),
// //                                                         buildDataCell(Text(rowData.data['middleName'] ?? ''), columnWidths[5]),
// //                                                         buildDataCell(Text(rowData.data['lastName'] ?? ''), columnWidths[6]),
// //                                                         buildDataCell(Text(rowData.data['mobileNumber'] ?? ''), columnWidths[7]),
// //                                                         buildDataCell(Text(rowData.data['institutionCode'] ?? ''), columnWidths[8]),
// //                                                         buildDataCell(Text(rowData.data['createdAt'] ?? ''), columnWidths[9]),
// //                                                         buildDataCell(Text(rowData.data['updatedAt'] ?? ''), columnWidths[10]),
// //                                                       ],
// //                                                     ),
// //                                                   ),
// //                                                 ),
// //                                               );
// //                                             }).toList(),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       if (isLoading)
// //                         const CircularProgressIndicator(
// //                           color: AppColors.maroon2,
// //                         )
// //                       else if (apiData.isEmpty)
// //                         const NoRecordsFound(),
// <<<<<<< Updated upstream
// //                       if (showEditInfo) getEditInfoPopModal()
// =======
// //                       if (showEditInfo) getEditInfoPopModal(),
// //                       if (showTopUpInfo) getTopUpPopModal()
// >>>>>>> Stashed changes
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 10),
// //
// //                 //PAGINATION BUTTON CODE
// <<<<<<< Updated upstream
// //                 PaginationControls(
// //                   currentPage: displayPage,
// //                   totalPages: totalPages,
// //                   totalRecords: totalRecords,
// //                   rowsPerPage: int.parse(_selectedItem),
// //                   onPreviousPage: previousPage,
// //                   onNextPage: nextPage,
// //                   onPageSelected: _onPageSelected,
// //                   onRowsPerPageChanged: onPageSizeChange,
// //                   onGoToPage: _onGoToPage,
// //                   title: 'Logs',
// //                 ),
// //                 // PaginationControls(currentPage: displayPage, totalPages: totalPages, totalRecords: totalRecords, onPreviousPage: previousPage, onNextPage: nextPage, onPageSelected: _onPageSelected, title: 'Clients'),
// =======
// //                 // PaginationControls(
// //                 //   currentPage: displayPage,
// //                 //   totalPages: totalPages,
// //                 //   totalRecords: totalRecords,
// //                 //   rowsPerPage: int.parse(_selectedItem),
// //                 //   onPreviousPage: previousPage,
// //                 //   onNextPage: nextPage,
// //                 //   onPageSelected: _onPageSelected,
// //                 //   onRowsPerPageChanged: onPageSizeChange,
// //                 //   onGoToPage: _onGoToPage,
// //                 //   title: 'Logs',
// //                 // ),
// //                 PaginationControls(currentPage: displayPage, totalPages: totalPages, totalRecords: totalRecords, onPreviousPage: previousPage, onNextPage: nextPage, title: 'Clients'),
// >>>>>>> Stashed changes
// //               ],
// //             ),
// //           ),
// //         ),
// //         // if (showEditInfo) getEditInfoPopModal() // Open a modal for edit info
// //       ],
// //     );
// //   }
// //
// <<<<<<< Updated upstream
// //   // Define your classifications
// //   final List<String> classifications = ['All', 'Client', 'Agent'];
// //
// =======
// >>>>>>> Stashed changes
// //   // Create a widget for each classification
// //   Widget buildChoiceChips() {
// //     return Row(
// //       children: classifications.map((classification) {
// //         return Row(
// //           children: [
// //             ChoiceChip(
// <<<<<<< Updated upstream
// //               label: Text(classification),
// //               selected: _selectedClassification == classification,
// //               selectedColor: classification == 'All' ? AppColors.maroon2.withOpacity(0.8) : null,
// =======
// //               label: Text(
// //                 classification,
// //                 style: TextStyle(color: _selectedClassification == classification ? Colors.white : Colors.grey),
// //               ),
// //               selected: _selectedClassification == classification,
// //               selectedColor: classification == 'All' ? AppColors.maroon2 : AppColors.maroon2,
// >>>>>>> Stashed changes
// //               pressElevation: 5,
// //               checkmarkColor: Colors.white,
// //               onSelected: (selected) {
// //                 setState(() {
// //                   _selectedClassification = selected ? classification : null;
// //                   fetchData(displayPage, 50, batchUploadIDController.text);
// //                 });
// //               },
// //             ),
// //             const SizedBox(width: 8), // Spacing between chips
// //           ],
// //         );
// //       }).toList(),
// //     );
// //   }
// //
// //   Widget getEditInfoPopModal() {
// //     double fieldWidth = 500;
// <<<<<<< Updated upstream
// //     return PopContainer(
// =======
// //
// //     return PopContainer(
// //       popUpWidth: 500,
// >>>>>>> Stashed changes
// //       title: 'Edit Info',
// //       isMinimize: isMinimize,
// //       onMinimizeToggle: (minimized) {
// //         setState(() {
// //           isMinimize = minimized;
// //         });
// //       },
// //       onClose: () {
// //         setState(() {
// //           isClosed = true;
// //           showEditInfo = false; // Hide the container when closed
// //         });
// //       },
// <<<<<<< Updated upstream
// //       rowChildren: [CustomColoredButton.secondaryButtonWithText(context, 5, () => null, Colors.white, 'Cancel'), CustomColoredButton.primaryButtonWithText(context, 5, () => null, AppColors.maroon2, 'Update')],
// //       children: [
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Spouse First Name',
// //           controller: rowData.controllers['maidenFName'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Spouse Middle Name',
// //           controller: rowData.controllers['maidenMName'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Spouse Last Name',
// //           controller: rowData.controllers['maidenLName'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //             width: fieldWidth,
// //             title: 'Birthday',
// //             controller: rowData.controllers['birthday'] ?? TextEditingController(), // Fallback controller
// //             inputFormatters: [BirthdayInputFormatter()]),
// =======
// //       rowChildren: [
// //         CustomColoredButton.secondaryButtonWithText(
// //           context,
// //           5,
// //           () => setState(() {
// //             isClosed = true;
// //             showEditInfo = false; // Hide the container when closed
// //           }),
// //           Colors.white,
// //           'Cancel',
// //         ),
// //         CustomColoredButton.primaryButtonWithText(
// //           context,
// //           5,
// //           () => null,
// //           AppColors.maroon2,
// //           'Update',
// //         ),
// //       ],
// //       children: [
// //         // Show loading indicator if fetching data
// //         if (isLoading)
// //           const Center(
// //             child: CircularProgressIndicator(
// //               color: Colors.tealAccent,
// //             ),
// //           )
// //         else
// //           Column(
// //             children: [
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Spouse First Name',
// //                 controller: rowData.controllers['maidenFName'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Spouse Middle Name',
// //                 controller: rowData.controllers['maidenMName'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Spouse Last Name',
// //                 controller: rowData.controllers['maidenLName'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                   width: fieldWidth,
// //                   title: 'Birthday',
// //                   controller: rowData.controllers['birthday'] ?? TextEditingController(), // Fallback controller
// //                   inputFormatters: [BirthdayInputFormatter()]),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Place of Birth',
// //                 controller: rowData.controllers['placeOfBirth'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Religion',
// //                 controller: rowData.controllers['religion'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildDropDownField(
// //                 width: fieldWidth,
// //                 title: 'Gender',
// //                 hintText: rowData.controllers['gender']?.text,
// //                 controller: rowData.controllers['gender'] ?? TextEditingController(),
// //                 onChanged: (String? newValue) {
// //                   setState(() {
// //                     if (newValue != null) {
// //                       rowData.controllers['gender']?.text = newValue;
// //                     }
// //                   });
// //                 },
// //                 items: ['Male', 'Female'],
// //               ),
// //               buildDropDownField(
// //                 width: fieldWidth,
// //                 title: 'Civil Status',
// //                 hintText: rowData.controllers['civilStatus']?.text,
// //                 controller: rowData.controllers['civilStatus'] ?? TextEditingController(),
// //                 onChanged: (String? newValue) {
// //                   setState(() {
// //                     CivilStatusData? selectedCivilStatus;
// //                     try {
// //                       selectedCivilStatus = titles.firstWhere(
// //                         (civilStatus) => civilStatus.title == newValue,
// //                       );
// //                     } catch (e) {
// //                       rethrow;
// //                     }
// //                     if (selectedCivilStatus != null) {
// //                       rowData.controllers['civilStatus']?.text = newValue!;
// //                     }
// //                   });
// //                 },
// //                 items: titles.map((civilStatus) => civilStatus.title).toList(),
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Citizenship',
// //                 controller: rowData.data['citizenship'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Present Address',
// //                 controller: rowData.data['presentAddress'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Permanent Address',
// //                 controller: rowData.data['permanentAddress'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'City',
// //                 controller: rowData.controllers['city'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Province',
// //                 controller: rowData.controllers['province'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Postal Code',
// //                 controller: rowData.controllers['postalCode'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Client Maiden First Name',
// //                 controller: rowData.controllers['memberMaidenFName'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Client Maiden Middle Name',
// //                 controller: rowData.controllers['memberMaidenMName'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Client Maiden Last Name',
// //                 controller: rowData.controllers['memberMaidenLName'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Email',
// //                 controller: rowData.controllers['email'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Source of Fund',
// //                 controller: rowData.controllers['sourceOfFund'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Employer Or Business Name',
// //                 controller: rowData.controllers['employerOrBusinessName'] ?? TextEditingController(), // Fallback controller
// //               ),
// //               buildTextFormField(
// //                 width: fieldWidth,
// //                 title: 'Employer Or Business Address',
// //                 controller: rowData.controllers['employerOrBusinessAddress'] ?? TextEditingController(), // Fallback controller
// //               ),
// //             ],
// //           ),
// //       ],
// //     );
// //   }
// //
// //   // Widget getEditInfoPopModal() {
// //   //   double fieldWidth = 500;
// //   //   return PopContainer(
// //   //     popUpWidth: 500,
// //   //     title: 'Edit Info',
// //   //     isMinimize: isMinimize,
// //   //     onMinimizeToggle: (minimized) {
// //   //       setState(() {
// //   //         isMinimize = minimized;
// //   //       });
// //   //     },
// //   //     onClose: () {
// //   //       setState(() {
// //   //         isClosed = true;
// //   //         showEditInfo = false; // Hide the container when closed
// //   //       });
// //   //     },
// //   //     rowChildren: [
// //   //       CustomColoredButton.secondaryButtonWithText(
// //   //           context,
// //   //           5,
// //   //           () => setState(() {
// //   //                 isClosed = true;
// //   //                 showEditInfo = false; // Hide the container when closed
// //   //               }),
// //   //           Colors.white,
// //   //           'Cancel'),
// //   //       CustomColoredButton.primaryButtonWithText(context, 5, () => null, AppColors.maroon2, 'Update')
// //   //     ],
// //   //     children: [
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Spouse First Name',
// //   //         controller: rowData.controllers['maidenFName'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Spouse Middle Name',
// //   //         controller: rowData.controllers['maidenMName'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Spouse Last Name',
// //   //         controller: rowData.controllers['maidenLName'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //           width: fieldWidth,
// //   //           title: 'Birthday',
// //   //           controller: rowData.controllers['birthday'] ?? TextEditingController(), // Fallback controller
// //   //           inputFormatters: [BirthdayInputFormatter()]),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Place of Birth',
// //   //         controller: rowData.controllers['placeOfBirth'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Religion',
// //   //         controller: rowData.controllers['religion'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildDropDownField(
// //   //         width: fieldWidth,
// //   //         title: 'Gender',
// //   //         hintText: rowData.controllers['gender']?.text,
// //   //         controller: rowData.controllers['gender'] ?? TextEditingController(),
// //   //         onChanged: (String? newValue) {
// //   //           setState(() {
// //   //             if (newValue != null) {
// //   //               rowData.controllers['gender']?.text = newValue;
// //   //             }
// //   //           });
// //   //         },
// //   //         items: ['Male', 'Female'],
// //   //       ),
// //   //       buildDropDownField(
// //   //         width: fieldWidth,
// //   //         title: 'Civil Status',
// //   //         hintText: rowData.controllers['civilStatus']?.text,
// //   //         controller: rowData.controllers['civilStatus'] ?? TextEditingController(),
// //   //         onChanged: (String? newValue) {
// //   //           setState(() {
// //   //             CivilStatusData? selectedCivilStatus;
// //   //             try {
// //   //               selectedCivilStatus = titles.firstWhere(
// //   //                 (civilStatus) => civilStatus.title == newValue,
// //   //               );
// //   //             } catch (e) {
// //   //               rethrow;
// //   //             }
// //   //             if (selectedCivilStatus != null) {
// //   //               rowData.controllers['civilStatus']?.text = newValue!;
// //   //             }
// //   //           });
// //   //         },
// //   //         items: titles.map((civilStatus) => civilStatus.title).toList(),
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Citizenship',
// //   //         controller: rowData.data['citizenship'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Present Address',
// //   //         controller: rowData.data['presentAddress'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Permanent Address',
// //   //         controller: rowData.data['permanentAddress'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'City',
// //   //         controller: rowData.controllers['city'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Province',
// //   //         controller: rowData.controllers['province'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Postal Code',
// //   //         controller: rowData.controllers['postalCode'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Client Maiden First Name',
// //   //         controller: rowData.controllers['memberMaidenFName'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Client Maiden Middle Name',
// //   //         controller: rowData.controllers['memberMaidenMName'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Client Maiden Last Name',
// //   //         controller: rowData.controllers['memberMaidenLName'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Email',
// //   //         controller: rowData.controllers['email'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Source of Fund',
// //   //         controller: rowData.controllers['sourceOfFund'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Employer Or Business Name',
// //   //         controller: rowData.controllers['employerOrBusinessName'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //       buildTextFormField(
// //   //         width: fieldWidth,
// //   //         title: 'Employer Or Business Address',
// //   //         controller: rowData.controllers['employerOrBusinessAddress'] ?? TextEditingController(), // Fallback controller
// //   //       ),
// //   //     ],
// //   //   );
// //   // }
// //
// //   Widget getTopUpPopModal() {
// //     final cid = getCID;
// //     final fullName = getFullName;
// //     double fieldWidth = 500;
// //     return PopContainer(
// //       popUpWidth: 700,
// //       title: 'Top Up Agent',
// //       isMinimize: isMinimize,
// //       onMinimizeToggle: (minimized) {
// //         setState(() {
// //           isMinimize = minimized;
// //         });
// //       },
// //       onClose: () {
// //         setState(() {
// //           isClosed = true;
// //           showTopUpInfo = false; // Hide the container when closed
// //         });
// //       },
// //       rowChildren: [
// //         CustomColoredButton.secondaryButtonWithText(
// //             context,
// //             5,
// //             () => setState(() {
// //                   isClosed = true;
// //                   showTopUpInfo = false; // Hide the container when closed
// //                 }),
// //             Colors.white,
// //             'Cancel'),
// //         CustomColoredButton.primaryButtonWithText(context, 5, () => _showTopUpAlertDialog(context, cid, fullName), AppColors.maroon2, 'Top Up')
// //       ],
// //       children: [
// >>>>>>> Stashed changes
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Place of Birth',
// //           controller: rowData.controllers['placeOfBirth'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Religion',
// //           controller: rowData.controllers['religion'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildDropDownField(
// //           width: fieldWidth,
// //           title: 'Gender',
// //           hintText: rowData.controllers['gender']?.text,
// //           controller: rowData.controllers['gender'] ?? TextEditingController(),
// //           onChanged: (String? newValue) {
// //             setState(() {
// //               if (newValue != null) {
// //                 rowData.controllers['gender']?.text = newValue;
// //               }
// //             });
// //           },
// //           items: ['Male', 'Female'],
// //         ),
// <<<<<<< Updated upstream
// //         buildDropDownField(
// //           width: fieldWidth,
// //           title: 'Civil Status',
// //           hintText: rowData.controllers['civilStatus']?.text,
// //           controller: rowData.controllers['civilStatus'] ?? TextEditingController(),
// //           onChanged: (String? newValue) {
// //             setState(() {
// //               CivilStatusData? selectedCivilStatus;
// //               try {
// //                 selectedCivilStatus = titles.firstWhere(
// //                   (civilStatus) => civilStatus.title == newValue,
// //                 );
// //               } catch (e) {
// //                 rethrow;
// //               }
// //               if (selectedCivilStatus != null) {
// //                 rowData.controllers['civilStatus']?.text = newValue!;
// //               }
// //             });
// //           },
// //           items: titles.map((civilStatus) => civilStatus.title).toList(),
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Citizenship',
// //           controller: rowData.data['citizenship'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Present Address',
// //           controller: rowData.data['presentAddress'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Permanent Address',
// //           controller: rowData.data['permanentAddress'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'City',
// //           controller: rowData.controllers['city'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Province',
// //           controller: rowData.controllers['province'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Postal Code',
// //           controller: rowData.controllers['postalCode'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Client Maiden First Name',
// //           controller: rowData.controllers['memberMaidenFName'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Client Maiden Middle Name',
// //           controller: rowData.controllers['memberMaidenMName'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Client Maiden Last Name',
// //           controller: rowData.controllers['memberMaidenLName'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Email',
// //           controller: rowData.controllers['email'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Source of Fund',
// //           controller: rowData.controllers['sourceOfFund'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Employer Or Business Name',
// //           controller: rowData.controllers['employerOrBusinessName'] ?? TextEditingController(), // Fallback controller
// //         ),
// //         buildTextFormField(
// //           width: fieldWidth,
// //           title: 'Employer Or Business Address',
// //           controller: rowData.controllers['employerOrBusinessAddress'] ?? TextEditingController(), // Fallback controller
// //         ),
// =======
// >>>>>>> Stashed changes
// //       ],
// //     );
// //   }
// //
// <<<<<<< Updated upstream
// //   // Widget _buildHoverIcons(BuildContext context, index) {
// //   //   return Row(
// //   //     children: [
// //   //       if (rowData.isEditing)
// //   //         if (hasChanges)
// //   //           IconButton(
// //   //             icon: const Icon(
// //   //               Icons.save,
// //   //               color: AppColors.green3,
// //   //               size: 20,
// //   //             ),
// //   //             onPressed: () {
// //   //               final cid = rowData.data['cid'];
// //   //               _showConfirmUpdateAlertDialog(context, cid, index);
// //   //             },
// //   //           )
// //   //         else
// //   //           IconButton(
// //   //             icon: const Icon(
// //   //               Icons.close,
// //   //               color: AppColors.maroon4,
// //   //               size: 20,
// //   //             ),
// //   //             onPressed: () {
// //   //               setState(() {
// //   //                 rowData.isEditing = false;
// //   //                 hasChanges = false;
// //   //                 showEditInfo = false;
// //   //                 categoryOnPressed = false;
// //   //               });
// //   //             },
// //   //           ),
// //   //       if (!rowData.isEditing)
// //   //         IconButton(
// //   //           icon: const Icon(
// //   //             Icons.edit,
// //   //             color: AppColors.infoColor,
// //   //             size: 18,
// //   //           ),
// //   //           onPressed: () {
// //   //             setState(() {
// //   //               rowData.originalData = Map.from(rowData.data);
// //   //               rowData.isEditing = true;
// //   //               showEditInfo = true;
// //   //               hasChanges = false;
// //   //             });
// //   //           },
// //   //         ),
// //   //       if (userRole == 'Checker')
// //   //         IconButton(
// //   //           icon: const Icon(
// //   //             Icons.delete_sweep_outlined,
// //   //             color: AppColors.maroon4,
// //   //             size: 20,
// //   //           ),
// //   //           onPressed: () {
// //   //             final cid = rowData.data['cid'];
// //   //             _showDelistAlertDialog(context, cid);
// //   //             debugPrint(cid);
// //   //           },
// //   //         ),
// //   //     ],
// //   //   );
// //   // }
// //
// //   Widget _popupMenuButton(BuildContext context, index, Color colors) {
// //     return Container(
// //       decoration: const BoxDecoration(
// //         borderRadius: BorderRadius.all(Radius.circular(5)),
// //       ),
// //       child: PopupMenuButton<String>(
// //         padding: EdgeInsets.zero,
// //         icon: Icon(
// //           Iconsax.category_2_copy,
// //           size: 15,
// //           color: colors,
// //         ),
// //         onSelected: (String value) {
// //           if (value == 'edit_info') {
// //             setState(() {
// //               showEditInfo = true;
// //             });
// //           } else if (value == 'delist') {
// //             setState(() {
// //               // final cid = rowData.data['cid'];
// //               final cid = getCID;
// //               // print('Delist CID: $cid');
// //               _showDelistAlertDialog(context, cid);
// //             });
// //           }
// //         },
// //         itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
// //            PopupMenuItem<String>(
// //             padding: EdgeInsets.only(left: 20, right: 20),
// //             value: 'edit_info',
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.start,
// //               children: [
// //                 Icon(
// //                   Iconsax.edit_2_copy,
// //                   color: Colors.black54,
// //                   size: 20,
// //                 ),
// //                 SizedBox(
// //                   width: 10,
// //                 ),
// //                 Text(
// //                   'Edit Info',
// //                   style: TextStyles.dataTextStyle,
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const PopupMenuItem<String>(
// //             padding: EdgeInsets.only(left: 20, right: 20),
// //             value: 'delist',
// //             child: Row(
// //               children: [
// //                 Icon(
// //                   Iconsax.profile_delete_copy,
// //                   color: Colors.black54,
// //                   size: 19,
// //                 ),
// //                 SizedBox(
// //                   width: 10,
// //                 ),
// //                 Text(
// //                   'Delist',
// //                   style: TextStyles.dataTextStyle,
// //                 )
// //               ],
// //             ),
// //           ),
// //         ],
// //         offset: const Offset(0, 40), // Adjust the offset as needed
// //         elevation: 8,
// =======
// //   Widget _popupMenuButton(BuildContext context, int index, Color color) {
// //     return PopupMenuButton<String>(
// //       padding: EdgeInsets.zero,
// //       icon: Icon(Iconsax.category_2_copy, size: 15, color: color),
// //       onSelected: (value) async {
// //         final cid = getCID;
// //         switch (value) {
// //           case 'edit_info':
// //             setState(() => showEditInfo = true);
// //             // Call the provider's method to fetch the client data
// //             await _fetchClientData(int.parse(cid));
// //             break;
// //           case 'delist':
// //             _showDelistAlertDialog(context, cid);
// //             break;
// //           case 'topUp':
// //             setState(() => showTopUpInfo = true);
// //             break;
// //         }
// //       },
// //       itemBuilder: (context) => [
// //         _buildPopupMenuItem('Edit Info', Iconsax.edit_2_copy, 'edit_info'),
// //         if (userRole == 'Checker') _buildPopupMenuItem('Delist', Iconsax.profile_delete_copy, 'delist'),
// //         if (userRole == 'Teller') _buildPopupMenuItem('Top Up', Iconsax.wallet_money_copy, 'topUp'),
// //         // if (rowData.data['memberClassification'] == 'Agent') _buildPopupMenuItem('Top Up', Iconsax.profile_delete_copy, 'topUp'),
// //       ],
// //       offset: const Offset(0, 40),
// //       elevation: 8,
// //     );
// //   }
// //
// //   PopupMenuItem<String> _buildPopupMenuItem(String text, IconData icon, String value) {
// //     return PopupMenuItem<String>(
// //       value: value,
// //       child: Row(
// //         children: [
// //           Icon(icon, color: Colors.black54, size: 19),
// //           const SizedBox(width: 10),
// //           Text(text, style: TextStyles.dataTextStyle),
// //         ],
// >>>>>>> Stashed changes
// //       ),
// //     );
// //   }
// //
// <<<<<<< Updated upstream
// =======
// //   ///GET SINGLE CLIENT DATA
// //   Future<void> _fetchClientData(int cid) async {
// //     setState(() {
// //       isLoading = true; // Show loading spinner
// //     });
// //
// //     print('get single client from ui : $cid');
// //
// //     try {
// //       await Provider.of<MFIClientProvider>(context, listen: false).getClientData(cid);
// //     } catch (e) {
// //       // Handle any error or show a message to the user
// //       debugPrint("Error fetching client data: $e");
// //     }
// //
// //     setState(() {
// //       isLoading = false; // Hide loading spinner
// //     });
// //   }
// //
// >>>>>>> Stashed changes
// //   ///SUBMIT UPDATED CLIENT DATA
// //   void submitUpdateClientForm(RowData rowData, int index) async {
// //     // Create a ClientDataModel instance using the data from TextEditingController
// //     ClientDataModel clientData = ClientDataModel(
// //       cid: rowData.data['cid'],
// //       firstName: rowData.controllers['firstName']?.text,
// //       middleName: rowData.controllers['middleName']?.text,
// //       lastName: rowData.controllers['lastName']?.text,
// //       maidenFName: rowData.controllers['maidenFName']?.text,
// //       maidenMName: rowData.controllers['maidenMName']?.text,
// //       maidenLName: rowData.controllers['maidenLName']?.text,
// //       mobileNumber: rowData.controllers['mobileNumber']?.text,
// //       birthday: rowData.controllers['birthday']?.text,
// //       placeOfBirth: rowData.controllers['placeOfBirth']?.text,
// //       religion: rowData.controllers['religion']?.text,
// //       civilStatus: rowData.controllers['civilStatus']?.text,
// //       citizenship: rowData.controllers['citizenship']?.text,
// //       presentAddress: rowData.controllers['presentAddress']?.text,
// //       permanentAddress: rowData.controllers['permanentAddress']?.text,
// //       city: rowData.controllers['city']?.text,
// //       province: rowData.controllers['province']?.text,
// //       postalCode: rowData.controllers['postalCode']?.text,
// //       memberMaidenFName: rowData.controllers['memberMaidenFName']?.text,
// //       memberMaidenMName: rowData.controllers['memberMaidenMName']?.text,
// //       memberMaidenLName: rowData.controllers['memberMaidenLName']?.text,
// //       email: rowData.controllers['email']?.text,
// //       memberClassification: rowData.controllers['memberClassification']?.text,
// //       sourceOfFund: rowData.controllers['sourceOfFund']?.text,
// //       employerOrBusinessName: rowData.controllers['employerOrBusinessName']?.text,
// //       employerOrBusinessAddress: rowData.controllers['employerOrBusinessAddress']?.text,
// //       clientClassification: rowData.data['clientClassification'],
// //     );
// //
// //     debugPrint('Client Classification : ${rowData.controllers['memberClassification']?.text}');
// //
// //     // Show a temporary message to simulate API response
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (context) => Center(
// //         child: Container(
// //           width: 350,
// //           height: 100,
// //           decoration: const BoxDecoration(
// //             color: AppColors.dialogColor,
// //             borderRadius: BorderRadius.all(Radius.circular(5)),
// //           ),
// //           child: const Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               SpinKitFadingCircle(color: AppColors.maroon2),
// //               SizedBox(width: 10),
// //               Text('Saving in progress...'),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //
// //     // Call the API
// //     final response = await UpdateApprovedClientInfoAPI().updateApprovedClient(clientData);
// //     Navigator.pop(navigatorKey.currentContext!); // Dismiss the loading dialog
// //
// //     if (response.statusCode == 200) {
// //       if (jsonDecode(response.body)['retCode'] == '200') {
// //         showSuccessAlertDialog(navigatorKey.currentContext!, "The client's updated info was saved successfully.", onPositiveButtonPressed: () {
// //           // Reset the editing state and change the icon back to edit
// //           setState(() {
// //             apiData[index].data['memberClassification'] = clientData.memberClassification;
// //             apiData[index].isEditing = false;
// //             hasChanges = false;
// //             _initializeData();
// //           });
// //         });
// //       } else {
// //         String errorMessage = jsonDecode(response.body)['message'];
// //         showGeneralErrorAlertDialog(navigatorKey.currentContext!, errorMessage);
// //       }
// //     } else {
// //       String errorMessage = jsonDecode(response.body)['message'];
// //       showGeneralErrorAlertDialog(navigatorKey.currentContext!, errorMessage);
// //     }
// //   }
// //
// //   ///DELIST A CLIENT
// //   void submitDelistClient(String cid) async {
// //     // Show a temporary message to simulate API response
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (context) => Center(
// //         child: Container(
// //           width: 350,
// //           height: 100,
// //           decoration: const BoxDecoration(
// //             color: AppColors.dialogColor,
// //             borderRadius: BorderRadius.all(Radius.circular(5)),
// //           ),
// //           child: const Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               SpinKitFadingCircle(color: AppColors.maroon2),
// //               SizedBox(width: 10),
// //               Text('Delist in progress...'),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //
// //     // Call the API
// //     final response = await DelistApprovedClientAPI().delistApprovedClient(cid);
// //     Navigator.pop(navigatorKey.currentContext!); // Dismiss the loading dialog
// //
// //     if (response.statusCode == 200) {
// //       if (jsonDecode(response.body)['retCode'] == '200') {
// //         showSuccessAlertDialog(navigatorKey.currentContext!, "A client was delisted from the records.", onPositiveButtonPressed: () {
// //           _initializeData();
// //         });
// //       } else {
// //         String errorMessage = jsonDecode(response.body)['message'];
// //         showGeneralErrorAlertDialog(navigatorKey.currentContext!, errorMessage);
// //       }
// //     } else {
// //       String errorMessage = jsonDecode(response.body)['message'];
// //       showGeneralErrorAlertDialog(navigatorKey.currentContext!, errorMessage);
// //     }
// //   }
// //
// //   ///DELIST DIALOG
// //   void _showDelistAlertDialog(BuildContext context, String cid) {
// //     showDialog(
// //       barrierDismissible: false,
// //       context: context,
// //       builder: (context) => AlertDialogWidget(
// //         titleText: "Confirmation",
// //         contentText: "You will be de-listing a client. Proceed with caution.",
// //         positiveButtonText: "Delist Client",
// //         negativeButtonText: "Cancel",
// //         negativeOnPressed: () {
// //           Navigator.of(context).pop();
// //         },
// //         positiveOnPressed: () async {
// //           Navigator.of(context).pop();
// //           submitDelistClient(cid);
// //         },
// //         iconData: Icons.info_outline,
// //         titleColor: AppColors.infoColor,
// //         iconColor: Colors.white,
// //       ),
// //     );
// //   }
// //
// <<<<<<< Updated upstream
// =======
// //   ///TOP UP DIALOG
// //   void _showTopUpAlertDialog(BuildContext context, String cid, String agentName) {
// //     showDialog(
// //       barrierDismissible: false,
// //       context: context,
// //       builder: (context) => AlertDialogWidget(
// //         titleText: "Confirmation",
// //         contentText: "You are about to top up the account for Agent $agentName. Please confirm to proceed.",
// //         positiveButtonText: "Proceed Top Up",
// //         negativeButtonText: "Cancel",
// //         negativeOnPressed: () {
// //           Navigator.of(context).pop();
// //         },
// //         positiveOnPressed: () async {
// //           Navigator.of(context).pop();
// //           // submitDelistClient(cid);
// //         },
// //         iconData: Icons.info_outline,
// //         titleColor: AppColors.infoColor,
// //         iconColor: Colors.white,
// //       ),
// //     );
// //   }
// //
// >>>>>>> Stashed changes
// //   ///CONFIRM UPDATE
// //   void _showConfirmUpdateAlertDialog(BuildContext context, dynamic cid, int index) {
// //     showDialog(
// //       barrierDismissible: false,
// //       context: context,
// //       builder: (context) => AlertDialogWidget(
// //         titleText: "Confirmation",
// //         contentText: "You will be updating a client's info. Proceed with caution.",
// //         positiveButtonText: "Update Info",
// //         negativeButtonText: "Cancel",
// //         negativeOnPressed: () {
// //           Navigator.of(context).pop();
// //         },
// //         positiveOnPressed: () async {
// //           Navigator.of(context).pop(); // Close dialog
// //           debugPrint('Confirm Update for cid: $cid');
// //           final rowData = apiData[index]; // Obtain the rowData instance for the row being edited
// //           submitUpdateClientForm(rowData, index);
// //         },
// //         iconData: Icons.info_outline,
// //         titleColor: AppColors.infoColor,
// //         iconColor: Colors.white,
// //       ),
// //     );
// //   }
// //
// //   ///SUCCESSFUL
// //   Color _getClientClassificationColor(String? status) {
// //     switch (status?.toUpperCase()) {
// //       case 'AGENT':
// //         return AppColors.maroon5; // Yellow color for Pending status
// //       case 'CLIENT':
// //         return AppColors.mlniColor; // Green color for Approved status
// //       default:
// //         return Colors.transparent; // Default color (you can change this as per your design)
// //     }
// //   }
// //
// //   Color _getWatchlistClassificationColor(String? status) {
// //     switch (status?.toUpperCase()) {
// //       case 'HIGH RISK':
// //         return Colors.orangeAccent.shade700; // Yellow color for Pending status
// //       case 'BLACKLISTED':
// //         return Colors.red.shade900; // Green color for Approved status
// //       case 'WATCHLISTED':
// //         return Colors.yellow.shade500; // Green color for Approved status
// //       case '':
// //         return Colors.transparent; // Green color for Approved status
// //       default:
// //         return Colors.transparent; // Default color (you can change this as per your design)
// //     }
// //   }
// // }
// //
// // class DataRowWidget extends StatefulWidget {
// //   final Map<String, dynamic> rowData;
// //   final int index;
// //   final bool isEditing;
// //   final bool hasChanges;
// //   final Function(bool?)? onCheckboxChanged;
// //   final Function() onEdit;
// //   final Function() onSave;
// //   final Function() onCancel;
// //   final Function() onDelete;
// //
// //   DataRowWidget({
// //     required this.rowData,
// //     required this.index,
// //     required this.isEditing,
// //     required this.hasChanges,
// //     required this.onCheckboxChanged,
// //     required this.onEdit,
// //     required this.onSave,
// //     required this.onCancel,
// //     required this.onDelete,
// //   });
// //
// //   @override
// //   _DataRowWidgetState createState() => _DataRowWidgetState();
// // }
// //
// // class _DataRowWidgetState extends State<DataRowWidget> {
// //   bool isHovered = false;
// //   bool isSelected = false;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MouseRegion(
// //       onEnter: (_) => setState(() => isHovered = true),
// //       onExit: (_) => setState(() => isHovered = false),
// //       child: Container(
// //         color: isSelected ? Colors.blueGrey.withOpacity(0.2) : Colors.transparent,
// //         padding: const EdgeInsets.all(8.0),
// //         child: Row(
// //           children: [
// //             Checkbox(
// //               value: isSelected,
// //               onChanged: isHovered ? widget.onCheckboxChanged : null,
// //             ),
// //             Expanded(child: Text(widget.rowData['data'] ?? '')),
// //             if (isHovered || widget.isEditing) ...[
// //               if (widget.isEditing) ...[
// //                 if (widget.hasChanges) ...[
// //                   IconButton(
// //                     icon: const Icon(Icons.save, color: Colors.green, size: 20),
// //                     onPressed: widget.onSave,
// //                   ),
// //                   IconButton(
// //                     icon: const Icon(Icons.close, color: Colors.red, size: 20),
// //                     onPressed: widget.onCancel,
// //                   ),
// //                 ] else ...[
// //                   IconButton(
// //                     icon: const Icon(Icons.close, color: Colors.red),
// //                     onPressed: widget.onCancel,
// //                   ),
// //                 ],
// //               ] else ...[
// //                 IconButton(
// //                   icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
// //                   onPressed: widget.onEdit,
// //                 ),
// //               ],
// //               IconButton(
// //                 icon: const Icon(Icons.delete, color: Colors.red, size: 20),
// //                 onPressed: widget.onDelete,
// //               ),
// //             ],
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
