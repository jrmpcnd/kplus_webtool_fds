import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/header/header.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/clock/clock.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/utils/utils_responsive.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/toast.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/fields/simplified_widget.dart';

import '../../../../../core/models/mfi_whitelist_admin_portal/whitelistModel.dart';
import '../../../../../main.dart';
import '../../../core/models/AMLA/registeredClientMonitoringModel.dart';
import '../../../core/models/AMLA/volumeModel.dart';

class AMLARegistereClientMonitoring extends StatefulWidget {
  const AMLARegistereClientMonitoring({Key? key}) : super(key: key);

  @override
  State<AMLARegistereClientMonitoring> createState() => _AMLARegistereClientMonitoringState();
}

class _AMLARegistereClientMonitoringState extends State<AMLARegistereClientMonitoring> {
  final token = getToken();
  late RowData rowData;

  final TextEditingController _rowsPerPageController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController batchUploadIDController = TextEditingController();
  TextEditingController transactTypeController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  final TextEditingController dateFromController = TextEditingController();

  // List<RowData> apiData = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  int totalRecords = 0;
  int totalPages = 1;
  String selectedFileName = '';
  String selectedUnit = '';
  String selectedCenter = '';
  String selectedFrom = '';
  String selectedTo = '';

  final int _sortColumnIndex = 0;

  List<String> displayFileName = [];
  List<String> _displayPages = [];
  String _selectedItem = '10';

  ///BOOLEAN VALUES
  final bool _sortAscending = true;
  bool isLoading = false; // Add this variable to track loading state
  bool isEditing = false;
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    //fetchData(1, int.parse(_selectedItem));
    // fetchVolumeETransData();
    updateUrl('/AMLA/Registered_Client_Monitoring');
    getToken();
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

  ///FETCH DATA FROM API USING DATE SELECTION
  // Future<void> _selectDate(BuildContext context, bool isStart) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //
  //   if (picked != null && picked != (isStart ? _startDate : _endDate)) {
  //     setState(() {
  //       if (isStart) {
  //         _startDate = picked;
  //         dateFromController.text = _startDate.toString();
  //       } else {
  //         _endDate = picked;
  //         dateToController.text = _endDate.toString();
  //       }
  //     });
  //
  //     // Trigger API call if both dates are selected
  //     if (_startDate != null && _endDate != null) {
  //       fetchVolumeETransData();
  //     }
  //   }
  // }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          dateFromController.text = DateFormat('yyyy-MM-dd').format(_startDate!); // Format the date
          fetchRCMData();
        } else {
          _endDate = picked;
          dateToController.text = DateFormat('yyyy-MM-dd').format(_endDate!); // Format the date
          fetchRCMData();
        }
      });

      // Trigger API call if both dates are selected
      if (_startDate != null && _endDate != null) {
        fetchRCMData();
      }
    }
  }

  Future<void> fetchRCMData() async {
    final volumetoken = getToken(); // Retrieve the token
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      final url = 'https://dev-api-janus.fortress-asya.com:18021/api/public/v1/amla/test/client/ewallet/registered'; // Replace with your actual API URL
      // final VolumeRequestModel requestModel = VolumeRequestModel(
      //   startDate: _startDate?.toString(),
      //   endDate: _endDate?.toString(),
      //   trnType: transactTypeController.text, // Use the selected transaction type
      // );
      final AMLARCMReqModel requestModel = AMLARCMReqModel(
        startDate: _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : null,
        endDate: _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : null,
      );

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $volumetoken', // Use the token
        },
        body: jsonEncode(requestModel.toJson()), // Send request model
      );

      // Print the body of the requestModel
      debugPrint('Request Body: ${jsonEncode(requestModel.toJson())}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final rcmModel = AMLARCMResModel.fromJson(responseData);

        setState(() {
          apiData = rcmModel.response ?? []; // Update API data
          isLoading = false; // Stop loading indicator
        });
        debugPrint('Response ETrans: ${response.statusCode}');
        debugPrint('Response ETrans: ${response.body}');
      } else {
        setState(() {
          isLoading = false; // Stop loading indicator
        });
        debugPrint('Response ETrans: ${response.statusCode}');
        debugPrint('Response ETrans: ${response.body}');
        print('Failed to load data'); // Handle failure
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
      print('An error occurred: $e'); // Handle error
    }
  }

  void _onFiltersChanged(TextEditingController controller) {
    if (controller == dateFromController) {
      setState(() {
        dateFromController.clear();
        dateToController.clear();
        transactTypeController.clear();
        _startDate == null;
        apiData = [];
      });
    } else {
      setState(() {
        dateToController.clear();
        apiData = [];
        fetchRCMData();
      });
    }
  }

  DateTime? _startDate;
  DateTime? _endDate;
  List<RCMResponse> apiData = [];
  //date edited | setp 5
  // List<DataRow> getPaginatedRows() {
  //   DataCell buildDataCell(String? text) {
  //     return DataCell(Center(
  //       child: SelectableText(
  //         text ?? '',
  //       ),
  //     ));
  //   }
  //
  //   return List<DataRow>.generate(apiData.length, (index) {
  //     final rowData = apiData[index];
  //     final color = index % 2 == 0 ? Colors.transparent : Colors.white;
  //
  //     return DataRow(
  //       color: MaterialStateProperty.all(color),
  //       cells: [
  //         buildDataCell(rowData.clientType),
  //         buildDataCell(rowData.date),
  //         buildDataCell(rowData.findings),
  //         buildDataCell(rowData.name),
  //         buildDataCell(rowData.sourceOfIncome),
  //         buildDataCell(rowData.status),
  //         buildDataCell(rowData.transactionAmount.toString()),
  //         buildDataCell(rowData.transactionCount.toString()),
  //         buildDataCell(rowData.transactionType),
  //       ],
  //     );
  //   });
  // }

  // List<DataRow> getPaginatedRows() {
  //   DataCell buildDataCell(String? text, {bool isBold = false}) {
  //     return DataCell(Center(
  //       child: SelectableText(
  //         text ?? '',
  //         style: isBold ? TextStyle(fontWeight: FontWeight.bold) : null,
  //         textAlign: TextAlign.center, // Ensure text is centered
  //       ),
  //     ));
  //   }
  //
  //   // Calculate the total of the transactionAmount field
  //   //double totalTransactionAmount = apiData.fold(0, (sum, item) => sum + (item.transactionAmount ?? 0));
  //
  //   // Generate the data rows
  //   List<DataRow> rows = List<DataRow>.generate(apiData.length, (index) {
  //     final rowData = apiData[index];
  //     final color = index % 2 == 0 ? Colors.transparent : Colors.white;
  //
  //     return DataRow(
  //       color: MaterialStateProperty.all(color),
  //       cells: [
  //         buildDataCell(rowData.status),
  //         buildDataCell(rowData.address),
  //         buildDataCell(rowData.birthDate),
  //         buildDataCell(rowData.cid),
  //         buildDataCell(rowData.clientType),
  //         buildDataCell(rowData.email),
  //         buildDataCell(rowData.firstName),
  //         buildDataCell(rowData.fullName),
  //         buildDataCell(rowData.institutionCode.toString()),
  //         buildDataCell(rowData.lastName),
  //         buildDataCell(rowData.middleName),
  //         buildDataCell(rowData.mobileNumber),
  //         buildDataCell(rowData.registeredDate),
  //         buildDataCell(rowData.sourceOfIncome),
  //
  //       ],
  //     );
  //   });
  //
  //   // Add a final row for the total transactionAmount
  //
  //   return rows;
  // }

  ///
  // List<DataRow> getPaginatedRows() {
  //   DataCell buildDataCell(String? text, {bool isBold = false, Color? textColor}) {
  //     return DataCell(Center(
  //       child: SelectableText(
  //         text ?? '',
  //         style: TextStyle(
  //           fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
  //           color: textColor ?? Colors.black, // Set the default text color
  //         ),
  //         textAlign: TextAlign.center, // Ensure text is centered
  //       ),
  //     ));
  //   }
  //
  //   // Generate the data rows
  //   List<DataRow> rows = List<DataRow>.generate(apiData.length, (index) {
  //     final rowData = apiData[index];
  //     final color = index % 2 == 0 ? Colors.transparent : Colors.white;
  //
  //     // Define custom text color based on status value
  //     Color statusColor;
  //     if (rowData.status == 'Blacklisted') {
  //       statusColor = Colors.red; // Green for 'Active'
  //     } else if (rowData.status == 'Low') {
  //       statusColor = Colors.amber; // Red for 'Inactive'
  //     } else if(rowData.status == 'High'){
  //       statusColor = Colors.orange; // Default color for other statuses
  //     }else{
  //       statusColor = Colors.black;
  //     }
  //
  //     return DataRow(
  //       color: MaterialStateProperty.all(color),
  //       cells: [
  //         buildDataCell(rowData.status, textColor: statusColor), // Apply custom color to status cell
  //         buildDataCell(rowData.address),
  //         buildDataCell(rowData.birthDate),
  //         buildDataCell(rowData.cid),
  //         buildDataCell(rowData.clientType),
  //         buildDataCell(rowData.email),
  //         buildDataCell(rowData.firstName),
  //         buildDataCell(rowData.fullName),
  //         buildDataCell(rowData.institutionCode.toString()),
  //         buildDataCell(rowData.lastName),
  //         buildDataCell(rowData.middleName),
  //         buildDataCell(rowData.mobileNumber),
  //         buildDataCell(rowData.registeredDate),
  //         buildDataCell(rowData.sourceOfIncome),
  //       ],
  //     );
  //   });
  //
  //   return rows;
  // }
///

  List<DataRow> getPaginatedRows() {
    DataCell buildDataCell(String? text, {bool isBold = false, Color? textColor}) {
      return DataCell(Center(
        child: SelectableText(
          text ?? '',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor ?? Colors.black, // Set the default text color
          ),
          textAlign: TextAlign.center, // Ensure text is centered
        ),
      ));
    }

    // Generate the data rows
    List<DataRow> rows = List<DataRow>.generate(apiData.length, (index) {
      final rowData = apiData[index];
      final color = index % 2 == 0 ? Colors.transparent : Colors.white;

      // Define custom text color and style based on status value
      final statusColor = _getClientClassificationColor(rowData.status.toString()); // Use a helper function like _getClientClassificationColor for status

      return DataRow(
        color: MaterialStateProperty.all(color),
        cells: [
          DataCell(
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                width: 150,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: statusColor.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.2),
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
                    rowData.status?.toUpperCase() ?? '',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          buildDataCell(rowData.address),
          buildDataCell(rowData.birthDate),
          buildDataCell(rowData.cid),
          buildDataCell(rowData.clientType),
          buildDataCell(rowData.email),
          buildDataCell(rowData.firstName),
          buildDataCell(rowData.fullName),
          buildDataCell(rowData.institutionCode.toString()),
          buildDataCell(rowData.lastName),
          buildDataCell(rowData.middleName),
          buildDataCell(rowData.mobileNumber),
          buildDataCell(rowData.registeredDate),
          buildDataCell(rowData.sourceOfIncome),
        ],
      );
    });

    return rows;
  }

// Helper function to get color based on status
  Color _getClientClassificationColor(String status) {
    switch (status) {
      case 'Blacklisted':
        return Colors.red;
      case 'Low':
        return Colors.blueAccent;
      case 'Highrisk':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }



//========Create templated data cell for COLUMNS=============//
  List<DataColumn> buildDataColumns() {
    final textStyle = TextStyle(
      fontSize: 14,
      color: Colors.black.withOpacity(0.6),
      letterSpacing: .5,
      fontWeight: FontWeight.bold,
    );

    DataColumn buildDataColumn(String label, {void Function()? onTap}) {
      return DataColumn(
        label: Center( // Ensure the column header is centered
          child: GestureDetector(
            onTap: onTap,
            child: Text(
              label,
              style: textStyle,
              textAlign: TextAlign.center, // Ensure text is centered
            ),
          ),
        ),
      );
    }

    return [
      buildDataColumn('Status'),
      buildDataColumn('Address'),
      buildDataColumn('BirthDate'),
      buildDataColumn('CID'),
      buildDataColumn('Client Type'),
      buildDataColumn('Email'),
      buildDataColumn('First Name'),
      buildDataColumn('Full Name'),
      buildDataColumn('Institution'),
      buildDataColumn('LastName'),
      buildDataColumn('Middle'),
      buildDataColumn('Mobile Number'),
      buildDataColumn('Registered Date'),
      buildDataColumn('Source Of Income'),
    ];
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
            const HeaderBar(screenText: 'Registered Client Monitoring'),
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Responsive(desktop: Clock(), mobile: Spacer()),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'REGISTERED CLIENT MONITORING',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    if (transactTypeController.text.isNotEmpty)
                      Text(
                        '  :  ${transactTypeController.text}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                  ],
                ),
                // Text('$transactTypeController'),
                // Dropdown menus
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 295,
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        dateField('Select Start Date', dateFromController, () {
                          _selectDate(context, true);
                        }, 250, 200),
                        const SizedBox(
                          width: 50,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        dateField('Select End Date', dateToController, () {
                          dateFromController.text.isNotEmpty ? _selectDate(context, false) : CustomToast.show(context, 'Set start date first.');
                        }, 250, 200),
                        const SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    // Stack(
                    //   children: [
                    //     buildDropDownField(
                    //       title: '',
                    //       width: 250,
                    //       height: 30,
                    //       contentPadding: 7,
                    //       hintText: 'Transaction Type',
                    //       controller: transactTypeController,
                    //       onChanged: (String? newValue) {
                    //         setState(() {
                    //           if (newValue != null) {
                    //             transactTypeController.text = newValue;
                    //             apiData = [];
                    //             fetchVolumeETransData();
                    //           }
                    //         });
                    //       },
                    //       items: dateFromController.text.isEmpty ? [] : ['Purchase Load', 'Cash-in', 'Cash-out', 'Billers Payment', 'Fund Transfer'], // Only "Agent" or "Client" as items
                    //     ),
                    //     if (transactTypeController.text.isNotEmpty)
                    //       Container(
                    //         margin: const EdgeInsets.only(left: 190),
                    //         height: 30,
                    //         child: transactTypeController.text.isNotEmpty
                    //             ? IconButton(
                    //           onPressed: () {
                    //             setState(() {
                    //               transactTypeController.clear();
                    //               apiData = [];
                    //             });
                    //           },
                    //           icon: const Icon(
                    //             Icons.clear,
                    //             color: Colors.black,
                    //             size: 12,
                    //           ),
                    //         )
                    //             : null, // Hide the icon when the text is empty
                    //       ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),

            // Expanded(
            //   child: DataTableTheme(
            //     data: const DataTableThemeData(
            //       dividerThickness: 0.1,
            //     ),
            //     child: DataTable(
            //       border: TableBorder.all(width: 0.1, color: Colors.black54.withOpacity(0.5)),
            //       headingRowColor: MaterialStateColor.resolveWith(
            //             (states) => Colors.black54.withOpacity(0.2),
            //       ),
            //       headingRowHeight: 50,
            //       columns: buildDataColumns(),
            //       rows:[], // Rows with actual data
            //     ),
            //   ),
            // ),

            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black54,
                        width: 0.1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTableTheme(
                          data: const DataTableThemeData(
                            dividerThickness: 0.1,
                          ),
                          child: DataTable(
                            border: TableBorder.all(width: 0.1, color: Colors.black54.withOpacity(0.5)),
                            headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.black54.withOpacity(0.2),
                            ),
                            headingRowHeight: 50,
                            columns: buildDataColumns(),
                            rows: apiData.isEmpty
                                ? [] // No rows if there's no data
                                : getPaginatedRows(), // Rows with actual data
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (apiData.isEmpty && !isLoading)
                    const Center(
                      child: Text(
                        'No records to show yet. Set the start date and transaction type.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (isLoading)
                    Container(
                      color: Colors.transparent, // Optional: Background to make the loading indicator stand out
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.maroon2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dateField(String hintText, TextEditingController controller, VoidCallback onIconPressed, double? containerWidth, double? width) {
    return SizedBox(
      width: containerWidth ?? 200,
      child: Row(
        children: [
          SizedBox(
            width: width ?? 150,
            height: 30,
            child: TextField(
              style: const TextStyle(fontSize: 11),
              controller: controller,
              textAlignVertical: TextAlignVertical.top,
              cursorColor: AppColors.maroon2,
              cursorWidth: 1,
              cursorRadius: const Radius.circular(5),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.maroon2, width: 0.5),
                  borderRadius: BorderRadius.circular(5).copyWith(
                    topRight: const Radius.circular(0),
                    bottomRight: const Radius.circular(0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.maroon2, width: 0.5),
                  borderRadius: BorderRadius.circular(5).copyWith(
                    topRight: const Radius.circular(0),
                    bottomRight: const Radius.circular(0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.maroon2, width: 0.5),
                  borderRadius: BorderRadius.circular(5).copyWith(
                    topRight: const Radius.circular(0),
                    bottomRight: const Radius.circular(0),
                  ),
                ),
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 11, color: Colors.black54),
                suffixIcon: controller.text.isNotEmpty
                    ? InkWell(
                  onTap: () {
                    controller.clear(); // Clear the text using the controller method
                    // Trigger a rebuild to hide the suffix icon
                    (context as Element).markNeedsBuild();
                    _onFiltersChanged(controller);
                  },
                  child: const Icon(
                    Icons.clear,
                    size: 15,
                  ),
                )
                    : null, // Hide the suffix icon when the controller is empty
              ),
              readOnly: true,
            ),
          ),
          Container(
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.maroon2,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: IconButton(
              onPressed: onIconPressed,
              icon: const Icon(
                Icons.calendar_month_outlined,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
