import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mfi_whitelist_admin_portal/core/models/AMLA/summaryResModel.dart';

import '../../../main.dart';
import '../../shared/clock/clock.dart';
import '../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import '../../shared/utils/utils_responsive.dart';
import '../../shared/values/colors.dart';
import '../../shared/widget/containers/toast.dart';
import '../user_management/ui/screen_bases/header/header.dart';
import '../user_management/ui/screen_bases/header/header_CTA.dart';

class SummaryETransaction extends StatefulWidget {
  const SummaryETransaction({Key? key}) : super(key: key);

  @override
  State<SummaryETransaction> createState() => _SummaryETransactionState();
}

class _SummaryETransactionState extends State<SummaryETransaction> {
  final urole = getUrole();
  bool isLoading = false;
  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  TextEditingController transactTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateUrl('/AMLA/SummaryETrans');
  }

  // DateTime? _startDate;
  // DateTime? _endDate;
  // String? _selectedOption;
  //
  //
  //
  // Future<void> _selectDate(BuildContext context, bool isStart) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //
  //   if (picked != null) {
  //     setState(() {
  //       if (isStart) {
  //         _startDate = picked;
  //         dateFromController.text = DateFormat('yyyy-MM-dd').format(_startDate!); // Format the date
  //       } else {
  //         _endDate = picked;
  //         dateToController.text = DateFormat('yyyy-MM-dd').format(_endDate!); // Format the date
  //       }
  //     });
  //
  //     // Trigger API call if both dates are selected
  //     if (_startDate != null && _endDate != null) {
  //       fetchVolumeETransData();
  //     }
  //   }
  // }
  //
  //
  //
  // List<SummaryResponse> apiData = [];
  //
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
  //         buildDataCell(rowData.transactionType),
  //         buildDataCell(rowData.totalAmount.toString()),
  //       ],
  //     );
  //   });
  // }
  //
  // //========Create templated data cell for COLUMNS=============//
  // List<DataColumn> buildDataColumns() {
  //   final textStyle = TextStyle(
  //     fontSize: 14,
  //     color: Colors.black.withOpacity(0.6),
  //     letterSpacing: .5,
  //     fontWeight: FontWeight.bold,
  //   );
  //
  //   DataColumn buildDataColumn(String label, {void Function()? onTap}) {
  //     return DataColumn(
  //       label: Expanded(
  //         child: GestureDetector(
  //           onTap: onTap,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(label, style: textStyle),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //
  //   return [
  //     buildDataColumn('Date'),
  //     buildDataColumn('Name'),
  //
  //   ];
  // }
  // // Sample data for dropdowns
  //
  // String selectedStatus = 'Transaction Type';
  //
  //
  //
  // List<String> statusOptions = ['Transaction Type','Load', 'Cash In - Cash Out', 'Billspayment', 'Fundtransfer'];
  //
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
          fetchVolumeETransData();
        } else {
          _endDate = picked;
          dateToController.text = DateFormat('yyyy-MM-dd').format(_endDate!); // Format the date
          fetchVolumeETransData();
        }
      });

      // Trigger API call if both dates are selected
      if (_startDate != null && _endDate != null) {
        fetchVolumeETransData();
      }
    }
  }

  Future<void> fetchVolumeETransData() async {
    final volumetoken = getToken(); // Retrieve the token
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      final url = 'https://dev-api-janus.fortress-asya.com:18021/api/public/v1/amla/test/summary/ewallet/transaction'; // Replace with your actual API URL
      final SummaryRequestModel requestModel = SummaryRequestModel(
        startDate: _startDate?.toIso8601String(),
        endDate: _endDate?.toIso8601String(),
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
        final volumeModel = SummaryResModel.fromJson(responseData);

        setState(() {
          apiData = volumeModel.response ?? []; // Update API data
          isLoading = false; // Stop loading indicator
        });
        debugPrint('Response SETrans: ${response.statusCode}');
        debugPrint('Response SETrans: ${response.body}');
      } else {
        setState(() {
          isLoading = false; // Stop loading indicator
        });
        debugPrint('Response SETrans: ${response.statusCode}');
        debugPrint('Response SETrans: ${response.body}');
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
        dateFromController.text = '';
        dateToController.text = '';
        _startDate == null;
        apiData = [];
      });
    } else {
      setState(() {
        dateToController.text = '';
        apiData = [];
        fetchVolumeETransData();
      });
    }
  }

  DateTime? _startDate;
  DateTime? _endDate;
  List<SummaryResponse> apiData = [];

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
  //         buildDataCell(rowData.numberOfTransaction.toString()),
  //         buildDataCell(rowData.totalAmount.toString()),
  //         buildDataCell(rowData.transactionType),
  //       ],
  //     );
  //   });
  // }

  List<DataRow> getPaginatedRows() {
    DataCell buildDataCell(String? text) {
      return DataCell(Center(
        child: SelectableText(
          text ?? '',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
    }

    // Calculate the total of the totalAmount field
    double totalAmountSum = apiData.fold(0, (sum, item) => sum + (item.totalAmount ?? 0));

    // Generate the data rows
    List<DataRow> rows = List<DataRow>.generate(apiData.length, (index) {
      final rowData = apiData[index];
      final color = index % 2 == 0 ? Colors.transparent : Colors.white;

      return DataRow(
        color: MaterialStateProperty.all(color),
        cells: [
          buildDataCell(rowData.numberOfTransaction.toString()),
          buildDataCell(rowData.totalAmount.toString()),
          buildDataCell(rowData.transactionType),
        ],
      );
    });

    // Add a final row for the total amount
    rows.add(
      DataRow(
        color: MaterialStateProperty.all(Colors.grey[300]), // Optional: Different color for the total row
        cells: [
          buildDataCell('Total'),
          buildDataCell(totalAmountSum.toStringAsFixed(2)), // Display the total amount
          buildDataCell(''), // Empty cell for the transactionType column
        ],
      ),
    );

    return rows;
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
        label: Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: textStyle),
              ],
            ),
          ),
        ),
      );
    }

    return [
      buildDataColumn('Number of Transaction'),
      buildDataColumn('Transaction Amount'),
      buildDataColumn('Transaction Type'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 90),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const HeaderBar(screenText: 'AMLA WATCHLIST'),
            const HeaderCTA(children: [
              Spacer(),
              Responsive(desktop: Clock(), mobile: Spacer()),
            ]),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9, maxHeight: MediaQuery.of(context).size.height * 0.),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colors.grey.shade50,
                  shape: BoxShape.rectangle,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade200, spreadRadius: 0.0, blurRadius: 3, offset: const Offset(3.0, 3.0)),
                    BoxShadow(color: Colors.grey.shade300, spreadRadius: 0.0, blurRadius: 3 / 2.0, offset: const Offset(3.0, 3.0)),
                    const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3, offset: Offset(-3.0, -3.0)),
                    const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3 / 2, offset: Offset(-3.0, -3.0)),
                  ],
                ),
                child: Responsive(
                  desktop: Row(
                    children: [imageBatchUpload(), bodyBatchUpload()],
                  ),
                  mobile: Column(
                    children: [
                      bodyBatchUpload(),
                    ],
                  ),
                  tablet: Column(
                    children: [
                      bodyBatchUpload(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget bodyBatchUpload() {
  //   double fontSize = (MediaQuery.sizeOf(context).width / 30);
  //   return Expanded(
  //     flex: 6,
  //     child: Container(
  //       padding: const EdgeInsets.all(30),
  //       // color: Colors.amber,
  //       // decoration: BoxDecoration(color: Colors.amber, border: Border.all(color: AppColors.sidePanel1, style: BorderStyle.solid, width: 0.1)),
  //       child: Column(
  //         // mainAxisAlignment: MainAxisAlignment.start,
  //         // crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'SUMMARY E-WALLET TRANSACTION',
  //                 style: TextStyle(color: AppColors.maroon2, fontSize: fontSize.clamp(25, 40), fontWeight: FontWeight.bold),
  //               ),
  //               const Text(
  //                 'WATCHLIST MANAGEMENT SYSTEM',
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 20,
  //                 ),
  //               ),
  //               const Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   // Icon(
  //                   //   Icons.add_circle_outline_outlined,
  //                   //   color: AppColors.maroon2,
  //                   //   size: 15,
  //                   // ),
  //                   SizedBox(
  //                     width: 5,
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           // const SizedBox(
  //           //   height: 40,
  //           // ),
  //
  //
  //           // Row(
  //           //   mainAxisAlignment: MainAxisAlignment.values.first,
  //           //   children: [
  //           //     Row(
  //           //       children: [
  //           //         ElevatedButton(
  //           //           onPressed: () => _selectDate(context, true),
  //           //           child: Text('Select Start Date'),
  //           //         ),
  //           //         SizedBox(width: 5,),
  //           //         Text(_startDate == null
  //           //             ? 'No Start Date'
  //           //             : 'Start: ${_startDate!.toLocal()}'.split(' ')[0]),
  //           //       ],
  //           //     ),
  //           //
  //           //     SizedBox(width: 20,),
  //           //     Row(
  //           //       children: [
  //           //         ElevatedButton(
  //           //           onPressed: () => _selectDate(context, false),
  //           //           child: Text('Select End Date'),
  //           //         ),
  //           //         SizedBox(width: 5,),
  //           //         Text(_endDate == null
  //           //             ? 'No End Date'
  //           //             : 'End: ${_endDate!.toLocal()}'.split(' ')[0]),
  //           //       ],
  //           //     ),
  //           //   ],
  //           // ),
  //           Expanded(
  //             child: Row(
  //               // mainAxisAlignment: MainAxisAlignment.start,
  //               // crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 const SizedBox(
  //                   width: 295,
  //                   height: 100,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     dateField('Select Start Date', dateFromController, () {
  //                       _selectDate(context, true);
  //                     }, 250, 200),
  //                     const SizedBox(
  //                       width: 50,
  //                     ),
  //                     const SizedBox(
  //                       width: 20,
  //                     ),
  //                     dateField('Select End Date', dateToController, () {
  //                       dateFromController.text.isNotEmpty ? _selectDate(context, false) : CustomToast.show(context, 'Set start date first.');
  //                     }, 250, 200),
  //                     const SizedBox(
  //                       width: 50,
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(
  //                   width: 20,
  //                 ),
  //
  //               ],
  //             ),
  //           ),
  //          // SizedBox(height: 20),
  //           // Space between dropdowns and the table
  //           Expanded(
  //             child: Container(
  //               height: MediaQuery.of(context).size.height,
  //               width: MediaQuery.of(context).size.width,
  //               child: SingleChildScrollView(
  //                 child: DataTableTheme(
  //                   data: const DataTableThemeData(
  //                     dividerThickness: 0.1,
  //                   ),
  //                   child: DataTable(
  //                     border: TableBorder.all(width: 0.1, color: Colors.black54.withOpacity(0.5)),
  //                     headingRowColor: MaterialStateColor.resolveWith(
  //                           (states) => Colors.black54.withOpacity(0.2),
  //                     ),
  //                     headingRowHeight: 50,
  //                     columns: buildDataColumns(),
  //                     rows: getPaginatedRows(),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget bodyBatchUpload() {
    double fontSize = (MediaQuery.sizeOf(context).width / 30);
    return Expanded(
      flex: 6,
      child: Container(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SUMMARY E-WALLET TRANSACTION',
                style: TextStyle(
                  color: AppColors.maroon2,
                  fontSize: fontSize.clamp(25, 40),
                  fontWeight: FontWeight.bold,
                ),
              ),
              // const Text(
              //   'WATCHLIST MANAGEMENT SYSTEM',
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: 20,
              //   ),
              // ),
              const SizedBox(height: 20),
              Row(
                children: [
                  dateField('Select Start Date', dateFromController, () {
                    _selectDate(context, true);
                  }, 250, 200),
                  const SizedBox(width: 50),
                  dateField('Select End Date', dateToController, () {
                    dateFromController.text.isNotEmpty ? _selectDate(context, false) : CustomToast.show(context, 'Set start date first.');
                  }, 250, 200),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: DataTableTheme(
                    data: const DataTableThemeData(
                      dividerThickness: 0.1,
                    ),
                    child: DataTable(
                      border: TableBorder.all(
                        width: 0.1,
                        color: Colors.black54.withOpacity(0.5),
                      ),
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black54.withOpacity(0.2),
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
    );
  }

  Widget imageBatchUpload() {
    return Expanded(
      flex: 4,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.maroon1.withOpacity(0.9), AppColors.maroon2, AppColors.maroon3, AppColors.maroon4],
              // Gradient colors
              begin: Alignment.topCenter,
              // Alignment for the start of the gradient
              end: Alignment.bottomCenter, // Alignment for the end of the gradient
            ),
            // color:  const Color(0xff941c1b),
            borderRadius: const BorderRadius.all(Radius.zero),

            ///images/amla_cover.png
            image: DecorationImage(
              image: AssetImage(urole == 'Maker' || urole == 'Checker'
                  ? '/images/mwap_batch_upload.png'
                  : urole == 'AMLA'
                      ? '/images/amla_cover.png'
                      : ''),
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black54,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
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
