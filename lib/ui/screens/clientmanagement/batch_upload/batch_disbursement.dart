// import 'dart:convert';
// import 'dart:html';
//
// import 'package:flutter/material.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/values/strings.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/container.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/dialog.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/widget/scrollable/scrollable_widget.dart';
//
// import '../../../../main.dart';
// import '../../../shared/values/colors.dart';
//
// class BatchDisbursement extends StatefulWidget {
//   const BatchDisbursement({Key? key}) : super(key: key);
//
//   @override
//   State<BatchDisbursement> createState() => _BatchDisbursementState();
// }
//
// class _BatchDisbursementState extends State<BatchDisbursement> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String? uploadStatus = '';
//   String fileName = '';
//   String timeStamp = '';
//   String firstName = '';
//   String lastName = '';
//   int total = 0;
//   String selectedFileName = '';
//   Blob? selectedFile;
//   int duplicateCount = 0;
//   List<String> duplicates = [];
//   List<String> pepsFound = [];
//   String existingCIDs = '';
//
//   //get the specific message to parameterize the UI
//   String parameterMessage = '';
//   String dataMessage = '';
//   Color uploadStatusColor = Colors.transparent;
//
//   TextEditingController rowPerPageController = TextEditingController();
//   List<Map<String, dynamic>> apiData = [];
//   List<String> pepListData = [];
//   int currentPage = 0;
//   int itemsPerPage = 10;
//   bool isLoading = true; // Add this variable to track loading state
//   bool hasPepList = false;
//   int totalRecords = 0;
//   int totalPages = 1;
//   String _selectedItem = '10';
//
//   @override
//   void initState() {
//     super.initState();
//     updateUrl('/Access/Batch_Upload/Batch_Insert');
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   Color _getStatusColor(String? status) {
//     switch (status?.toUpperCase()) {
//       case 'UPLOADING' || 'PREVIEWED':
//         return Colors.amber.shade600;
//       case 'SUCCESS':
//         return Colors.green.shade600; // Green color for Approved status
//       case 'FAILED':
//         return Colors.red.shade600; // Red color for Disapproved status
//       case 'WATCHLIST':
//         return Colors.orangeAccent; // Red color for Disapproved status
//       default:
//         return Colors.transparent; // Default color (you can change this as per your design)
//     }
//   }
//
//   ///DISBURSEMENT
//   //Compute maximum width required for each column
//   List<double> getColumnWidths(List<String> headers, List<Map<String, dynamic>> data) {
//     // Create a list to store the width of each column. Initially set all widths to 0.
//     final List<double> widths = List.filled(headers.length, 0.0);
//
//     // Measure the width of each header text.
//     for (int i = 0; i < headers.length; i++) {
//       // Create a TextPainter object to measure the width of the header text.
//       final TextPainter painter = TextPainter(
//         text: TextSpan(
//           text: headers[i], // The text of the header
//           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Style for the header text
//         ),
//         textDirection: TextDirection.ltr, // Text direction for measuring
//       )..layout(); // Layout the text to calculate its size
//       widths[i] = painter.size.width; // Store the width of the header text in the widths list
//     }
//
//     // Measure the width of each row's data.
//     for (var row in data) {
//       // Extract the data for each column from the row and convert it to strings (if necessary).
//       final values = [
//         row['logid'].toString(),
//         row['uid'],
//         row['fname'],
//         row['lname'],
//         row['username'],
//         row['branch'],
//         row['userrole'],
//         row['dateandtime'],
//         row['action'],
//         json.encode(row['original_values']), // JSON encode complex objects like original values
//         json.encode(row['modified_values']),
//       ];
//
//       // Measure the width of each data cell and adjust the width of the corresponding column.
//       for (int i = 0; i < values.length; i++) {
//         // Create a TextPainter to measure the width of the data text in the current column.
//         final TextPainter painter = TextPainter(
//           text: TextSpan(
//             text: values[i], // The text of the data cell
//             style: TextStyles.dataTextStyle, // Style for the data text
//           ),
//           textDirection: TextDirection.ltr, // Text direction for measuring
//         )..layout(); // Layout the text to calculate its size
//         // Update the column width only if the current text is wider than the previously measured width.
//         widths[i] = widths[i] > painter.size.width ? widths[i] : painter.size.width;
//       }
//     }
//
//     // Add padding to each column width to prevent the text from being too close to the edges.
//     const double padding = 200.0; // Padding for each column (can be adjusted)
//     for (int i = 0; i < widths.length; i++) {
//       widths[i] += padding; // Add padding to each column width
//     }
//
//     // Return the calculated widths for all columns.
//     return widths;
//   }
//
//   //HEADERS
//   List<Widget> buildHeaderCells(List<String> headers, List<double> columnWidths) {
//     return headers.asMap().entries.map((entry) {
//       final index = entry.key;
//       final header = entry.value;
//
//       return Container(
//         width: columnWidths[index],
//         padding: const EdgeInsets.all(8),
//         child: Text(
//           header,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.black.withOpacity(0.6),
//             letterSpacing: .5,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       );
//     }).toList();
//   }
//
//   List<Widget> getRows(List<double> columnWidths, List<Widget> Function(dynamic rowData) rowChildrenBuilder) {
//     return apiData.map<Widget>((rowData) {
//       final color = apiData.indexOf(rowData) % 2 == 0 ? Colors.transparent : Colors.white;
//
//       return Container(
//         padding: const EdgeInsets.only(left: 30),
//         decoration: BoxDecoration(
//           color: color,
//           border: const Border(
//             top: BorderSide.none,
//             bottom: BorderSide(width: 0.5, color: Colors.black12),
//             left: BorderSide(width: 0.5, color: Colors.black12),
//             right: BorderSide(width: 0.5, color: Colors.black12),
//           ),
//         ),
//         child: Row(
//           children: rowChildrenBuilder(rowData),
//         ),
//       );
//     }).toList();
//   }
//
//   //ROW DATA CELLS
//   Widget buildDataCell(String? text, double width) {
//     return Container(
//       margin: const EdgeInsets.only(top: 10, bottom: 10),
//       width: width,
//       // color: Colors.amber,
//       height: 40,
//       padding: const EdgeInsets.all(10),
//       child: Text(
//         text ?? '',
//         style: TextStyles.dataTextStyle,
//         textAlign: TextAlign.left,
//       ),
//     );
//   }
//
//   ///DISBURSEMENT
//   void showDisbursementConfirmDialog() {}
//
//   @override
//   Widget build(BuildContext context) {
//     bool areButtonsEnabled = selectedFileName.isNotEmpty && (selectedFileName.endsWith('.xlsm'));
//
//     return const Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Image(
//           image: AssetImage('images/coming_soon.png'),
//           width: 200,
//         ),
//         Text(
//           StringTexts.unavailableScreenTitle,
//           style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.maroon2),
//         ),
//         Text(
//           StringTexts.unavailableScreenSubTitle,
//           style: TextStyles.headingTextStyle,
//         ),
//         SizedBox(height: 50),
//       ],
//     );
//     // return Column(
//     //   mainAxisAlignment: MainAxisAlignment.start,
//     //   crossAxisAlignment: CrossAxisAlignment.start,
//     //   children: [
//     //     /// CHOOSE FILE, UPLOAD BUTTON, AND DOWNLOAD BUTTON
//     //     Wrap(
//     //       // alignment: WrapAlignment.spaceBetween,
//     //       runSpacing: 10,
//     //       spacing: 20,
//     //       children: [
//     //         Container(
//     //           height: 35,
//     //           constraints: const BoxConstraints(maxWidth: 350),
//     //           child: chooseFileAndUploadButton(areButtonsEnabled),
//     //         ),
//     //         downloadFileButton(),
//     //         previewFileButton(),
//     //         if (selectedFileName.isNotEmpty || (uploadStatus != '' && uploadStatus != 'SUCCESS')) previewFileButton()
//     //       ],
//     //     ),
//     //     Container(
//     //       margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
//     //       child: const Text(
//     //         'AGENT TOP UP SUMMARY',
//     //         style: TextStyle(
//     //           color: AppColors.maroon2,
//     //           fontWeight: FontWeight.bold,
//     //           fontSize: 15,
//     //         ),
//     //       ),
//     //     ),
//     //
//     //     /// RESULT FIELDS
//     //     Expanded(
//     //       child: SingleChildScrollView(
//     //         child: Column(
//     //           crossAxisAlignment: CrossAxisAlignment.start,
//     //           children: [
//     //             Wrap(
//     //               alignment: WrapAlignment.spaceBetween,
//     //               spacing: 10,
//     //               runSpacing: 10,
//     //               children: [
//     //                 Container(
//     //                   // color: Colors.teal,
//     //                   width: 400,
//     //                   child: Column(
//     //                     crossAxisAlignment: CrossAxisAlignment.start,
//     //                     children: [
//     //                       _buildLabel('File name'),
//     //                       const SizedBox(height: 5),
//     //                       _buildReadOnlyTextField(selectedFileName),
//     //                       const SizedBox(height: 5),
//     //                       _buildLabel('Uploader'),
//     //                       const SizedBox(height: 5),
//     //                       _buildReadOnlyTextField('$firstName $lastName'),
//     //                       const SizedBox(height: 5),
//     //                       _buildLabel('Date and Time:'),
//     //                       const SizedBox(height: 5),
//     //                       _buildReadOnlyTextField(timeStamp),
//     //                       const SizedBox(height: 5),
//     //                     ],
//     //                   ),
//     //                 ),
//     //                 Container(
//     //                   // color: Colors.deepPurpleAccent,
//     //                   width: 400,
//     //                   child: Column(
//     //                     crossAxisAlignment: CrossAxisAlignment.start,
//     //                     children: [
//     //                       _buildLabel('Upload Status'),
//     //                       const SizedBox(height: 5),
//     //                       Container(
//     //                         padding: const EdgeInsets.all(1.5),
//     //                         decoration: BoxDecoration(
//     //                           border: Border.all(width: 0.5, color: AppColors.sidePanel1),
//     //                           borderRadius: BorderRadius.circular(5.0),
//     //                           color: Colors.white10,
//     //                         ),
//     //                         child: uploadStatus != null
//     //                             ? Container(
//     //                           width: 150,
//     //                           height: 30,
//     //                           decoration: BoxDecoration(
//     //                             borderRadius: BorderRadius.circular(3),
//     //                             color: uploadStatusColor.withOpacity(0.2),
//     //                           ),
//     //                           child: Center(
//     //                             child: Text(
//     //                               (uploadStatus?.toUpperCase() ?? ''), // Ensure text is uppercase
//     //                               style: TextStyle(
//     //                                 color: uploadStatusColor,
//     //                                 fontWeight: FontWeight.bold,
//     //                               ),
//     //                             ),
//     //                           ),
//     //                         )
//     //                             : Container(),
//     //                       ),
//     //                       const SizedBox(height: 5),
//     //                       _buildLabel(getLabelForDuplicateCount(parameterMessage)),
//     //                       const SizedBox(height: 5),
//     //                       _buildReadOnlyTextField('$duplicateCount'),
//     //                       const SizedBox(height: 5),
//     //                       _buildLabel('No. of Clients Uploaded'),
//     //                       const SizedBox(height: 5),
//     //                       _buildReadOnlyTextField('$total'),
//     //                     ],
//     //                   ),
//     //                 ),
//     //               ],
//     //             ),
//     //             const SizedBox(height: 5),
//     //             _buildLabel(getLabelForDuplicateCID(parameterMessage)),
//     //             const SizedBox(height: 5),
//     //             Container(
//     //               // color: Colors.pink,
//     //               constraints: const BoxConstraints(maxHeight: 150),
//     //               child: decideTextFieldWidget(
//     //                   parameterMessage,
//     //                   parameterMessage == 'Existing CIDs'
//     //                       ? existingCIDs
//     //                       : parameterMessage == 'Duplicate CIDs'
//     //                       ? duplicates
//     //                   // : parameterMessage == 'PEP List Found'
//     //                       : parameterMessage == 'Preview with PEP List'
//     //                       ? pepsFound
//     //                       : parameterMessage == 'Preview without PEP List'
//     //                       ? 'No clients were detected as being on the watchlist.'
//     //                       : parameterMessage == 'Existing Data Found'
//     //                       ? duplicates
//     //                       : parameterMessage),
//     //             ),
//     //           ],
//     //         ),
//     //       ),
//     //     ),
//     //   ],
//     // );
//   }
//
//   // Widget chooseFileAndUploadButton(bool areButtonsEnabled) {
//   //   return Row(
//   //     children: [
//   //       SizedBox(
//   //         width: 200,
//   //         child: TextField(
//   //           style: const TextStyle(
//   //             fontSize: 12,
//   //           ),
//   //           onTap: () {
//   //             openFileUploadDialog();
//   //           },
//   //           textAlignVertical: TextAlignVertical.center,
//   //           cursorColor: AppColors.maroon2,
//   //           cursorWidth: 1,
//   //           cursorRadius: const Radius.circular(5),
//   //           decoration: InputDecoration(
//   //             enabledBorder: const OutlineInputBorder(
//   //               borderSide: BorderSide(
//   //                 width: 0.5,
//   //               ),
//   //               borderRadius: BorderRadius.only(
//   //                 topLeft: Radius.circular(5),
//   //                 bottomLeft: Radius.circular(5),
//   //               ),
//   //             ),
//   //             contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
//   //             filled: true,
//   //             fillColor: Colors.white10,
//   //             focusedBorder: const OutlineInputBorder(
//   //               borderSide: BorderSide(
//   //                 color: AppColors.sidePanel1,
//   //               ),
//   //               borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
//   //             ),
//   //             prefixIcon: const Icon(
//   //               Icons.folder_open,
//   //               color: AppColors.sidePanel1,
//   //               size: 17,
//   //             ),
//   //             hintText: selectedFileName.isEmpty ? 'Select file...' : selectedFileName,
//   //             hintStyle: const TextStyle(fontSize: 12, color: Colors.black54),
//   //             suffixIcon: GestureDetector(
//   //               onTap: resetFileUploadState, // Use the reset method here
//   //               child: const Icon(
//   //                 Icons.clear,
//   //                 color: AppColors.sidePanel1,
//   //                 size: 17,
//   //               ),
//   //             ),
//   //           ),
//   //           readOnly: true,
//   //         ),
//   //       ),
//   //       ElevatedButton(
//   //         onPressed: () {
//   //           areButtonsEnabled
//   //               ? uploadStatus != 'SUCCESS'
//   //               ? showOnboardingConfirmDialog()
//   //               : CustomToast.show(context, 'File was already uploaded.')
//   //               : CustomToast.show(context, 'Please select a file first.');
//   //         },
//   //         style: ElevatedButton.styleFrom(
//   //           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
//   //           side: const BorderSide(color: AppColors.maroon2, width: 0.5),
//   //           backgroundColor: (areButtonsEnabled
//   //               ? uploadStatus != 'SUCCESS'
//   //               ? AppColors.maroon2
//   //               : Colors.grey
//   //               : Colors.grey),
//   //         ),
//   //         child: Center(
//   //           child: Row(
//   //             mainAxisAlignment: MainAxisAlignment.center,
//   //             children: [
//   //               const Icon(
//   //                 Icons.drive_folder_upload_sharp,
//   //                 size: 17,
//   //                 color: Colors.white,
//   //               ),
//   //               const SizedBox(
//   //                 width: 5,
//   //               ),
//   //               Text(
//   //                 'Upload File',
//   //                 style: TextStyle(color: Colors.white, fontSize: (MediaQuery.sizeOf(context).width / 40).clamp(9, 12)),
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
//
//   Widget downloadFileButton() {
//     return SizedBox(
//       height: 35,
//       width: 200,
//       child: ElevatedButton(
//         onPressed: () {
//           showDownloadTemplateConfirmAlertDialog(context);
//         },
//         style: ElevatedButton.styleFrom(
//           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
//           backgroundColor: (AppColors.maroon2),
//         ),
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.file_download,
//                 size: 17,
//                 color: Colors.white,
//               ),
//               const SizedBox(
//                 width: 5,
//               ),
//               Text(
//                 'Download Template',
//                 maxLines: 2,
//                 style: TextStyle(color: Colors.white, fontSize: (MediaQuery.sizeOf(context).width / 40).clamp(9, 12)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///MAIN WIDGETS
//
//   Widget previewFileButton() {
//     return SizedBox(
//       height: 35,
//       width: 200,
//       child: ElevatedButton(
//         onPressed: () {
//           switch (_tabController.index) {
//             case 0: // Onboarding
//               // showPreviewDialog(context);
//               break;
//             case 1: // Disbursement
//               // showDisbursementPreviewDialog(context);
//               break;
//             case 2: // Top Up
//               // showTopUpPreviewDialog(context);
//               break;
//             default:
//             // showPreviewDialog(context);
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
//           backgroundColor: AppColors.maroon2,
//         ),
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.remove_red_eye,
//                 size: 17,
//                 color: Colors.white,
//               ),
//               const SizedBox(width: 5),
//               Text(
//                 'Preview File',
//                 maxLines: 2,
//                 style: TextStyle(color: Colors.white, fontSize: (MediaQuery.sizeOf(context).width / 40).clamp(9, 12)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLabel(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 12,
//         color: Colors.black54,
//         fontWeight: FontWeight.bold,
//         fontStyle: FontStyle.italic,
//       ),
//     );
//   }
//
//   Widget _buildReadOnlyTextField(String hintText, {double width = double.infinity}) {
//     return Container(
//       width: width,
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         border: Border.all(width: 0.5, color: AppColors.sidePanel1),
//         borderRadius: BorderRadius.circular(5.0),
//         color: Colors.white10,
//       ),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Text(
//           hintText,
//           style: const TextStyle(fontSize: 12),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPEPTextField(String hintText, {double width = double.infinity}) {
//     return Container(
//         width: width,
//         padding: const EdgeInsets.all(2.0),
//         decoration: BoxDecoration(
//           border: Border.all(width: 0.5, color: AppColors.sidePanel1),
//           borderRadius: BorderRadius.circular(5.0),
//           color: Colors.white10,
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(5),
//           width: width,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(3),
//             color: uploadStatusColor.withOpacity(0.2),
//           ),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: Text(
//               hintText,
//               style: const TextStyle(
//                 fontSize: 12,
//                 // color: uploadStatusColor,
//               ),
//             ),
//           ),
//         ));
//   }
//
//   Widget decideTextFieldWidget(String responseMessage, dynamic data) {
//     // } else if (responseMessage == 'PEP List Found' && data is List<String>) {
//     if (responseMessage == 'Preview with PEP List' && data is List<String>) {
//       return _buildPEPTextField(data.join('\n'));
//     } else if (responseMessage == 'Existing Data Found' && data is List<String>) {
//       return _buildReadOnlyTextField(data.join(', \n'));
//     } else if (responseMessage == 'Existing CIDs' && data is String) {
//       return _buildReadOnlyTextField(data);
//     } else if (responseMessage != 'Existing CIDs' && data is List<String>) {
//       return _buildReadOnlyTextField(data.join(', ')); // Join list into a comma-separated string
//     } else {
//       return _buildReadOnlyTextField(data);
//     }
//   }
//
//   String getLabelForDuplicateCount(String message) {
//     // } else if (message == 'PEP List Found') {
//     if (message == 'Preview with PEP List') {
//       return 'PEPs Count';
//     } else if (message == 'Existing CIDs') {
//       return 'Existing CID Count';
//     } else if (message == 'Duplicate CIDs') {
//       return 'Duplicate CID Count';
//     } else {
//       return 'Count';
//     }
//   }
//
//   String getLabelForDuplicateCID(String message) {
//     // } else if (message == 'PEP List Found') {
//     if (message == 'Preview with PEP List') {
//       return 'Watchlist';
//     } else if (message == 'Existing CIDs') {
//       return 'Existing CIDs';
//     } else if (message == 'Duplicate CIDs') {
//       return 'Duplicate CIDs';
//     } else {
//       return 'Remarks';
//     }
//   }
//
//   ///DISBURSEMENT and TOP UP WIDGETS
//   Widget disbursementTable() {
//     final headers = ['Account No', 'Loan Amount', 'Customer Name'];
//     final keys = ['Cid', 'LoanAmount', 'FirstName'];
//     final columnWidths = getColumnWidths(headers, apiData);
//
//     return buildTable(
//       headers: headers,
//       keys: keys,
//       columnWidths: columnWidths,
//     );
//   }
//
//   Widget disbursementTotalAmount() {
//     return summaryWidget('Disbursed Amount', 'PHP 0.00');
//   }
//
//   Widget disbursementTotalCustomers() {
//     return summaryWidget('Number of Customers', '150');
//   }
//
// // Reusable Widget for Data Tables
//   Widget buildTable({
//     required List<String> headers,
//     required List<String> keys,
//     required List<double> columnWidths,
//   }) {
//     return ScrollBarWidget(
//       child: Container(
//         margin: const EdgeInsets.all(10),
//         width: 900,
//         height: 600,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10.0),
//           color: Colors.grey.shade50,
//           shape: BoxShape.rectangle,
//           boxShadow: [
//             BoxShadow(color: Colors.grey.shade200, spreadRadius: 0.0, blurRadius: 3, offset: const Offset(3.0, 3.0)),
//             BoxShadow(color: Colors.grey.shade300, spreadRadius: 0.0, blurRadius: 3 / 2.0, offset: const Offset(3.0, 3.0)),
//             const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3, offset: Offset(-3.0, -3.0)),
//             const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3 / 2, offset: Offset(-3.0, -3.0)),
//           ],
//         ),
//         child: Stack(
//           alignment: AlignmentDirectional.center,
//           children: [
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Frozen Header
//                   Container(
//                     width: 900,
//                     padding: const EdgeInsets.only(left: 30),
//                     decoration: const BoxDecoration(
//                       color: Colors.black12,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                       ),
//                     ),
//                     height: 50,
//                     child: Row(
//                       children: buildHeaderCells(headers, columnWidths),
//                     ),
//                   ),
//                   // Scrollable Body
//                   if (apiData.isNotEmpty)
//                     Expanded(
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         child: Column(
//                           children: getRows(columnWidths, (rowData) {
//                             return keys.map((key) {
//                               return buildDataCell(rowData[key].toString(), columnWidths[keys.indexOf(key)]);
//                             }).toList();
//                           }),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             if (isLoading)
//               const CircularProgressIndicator(
//                 color: AppColors.maroon2,
//               )
//             else if (apiData.isEmpty)
//               const NoRecordsFound(),
//           ],
//         ),
//       ),
//     );
//   }
//
// // Reusable Widget for Summary Cards
//   Widget summaryWidget(String title, String value) {
//     return Container(
//       margin: const EdgeInsets.all(10),
//       padding: const EdgeInsets.all(20),
//       width: 350,
//       height: 150,
//       decoration: containerBoxDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Text(title, style: TextStyles.heavyBold20Black),
//           Text(value, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.maroon2)),
//         ],
//       ),
//     );
//   }
//
// // Reusable BoxDecoration for containers
//   BoxDecoration containerBoxDecoration() {
//     return BoxDecoration(
//       borderRadius: BorderRadius.circular(10.0),
//       color: Colors.grey.shade50,
//       boxShadow: [
//         BoxShadow(color: Colors.grey.shade200, blurRadius: 3, offset: const Offset(3.0, 3.0)),
//         BoxShadow(color: Colors.grey.shade300, blurRadius: 1.5, offset: const Offset(3.0, 3.0)),
//         const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3, offset: Offset(-3.0, -3.0)),
//       ],
//     );
//   }
//
// // Reusable Header Widget
//   Widget headerWidget(List<String> headers, List<double> columnWidths) {
//     return Container(
//       width: 900,
//       padding: const EdgeInsets.only(left: 30),
//       decoration: const BoxDecoration(
//         color: Colors.black12,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(10),
//           topRight: Radius.circular(10),
//         ),
//       ),
//       height: 50,
//       child: Row(
//         children: buildHeaderCells(headers, columnWidths),
//       ),
//     );
//   }
//
//   void showDownloadTemplateConfirmAlertDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialogWidget(
//         titleText: "Download Confirmation",
//         contentText: "Are you sure you want to download the file template?",
//         positiveButtonText: "Proceed",
//         negativeButtonText: "Cancel",
//         negativeOnPressed: () {
//           Navigator.of(context).pop();
//         },
//         positiveOnPressed: () async {
//           Navigator.of(context).pop();
//           // _downloadFile();
//         },
//         iconData: Icons.info_outline,
//         titleColor: AppColors.infoColor,
//         iconColor: Colors.white,
//       ),
//     );
//   }
//
//   void showUploadFileAlertDialog({required bool isSuccess, required String titleMessage, required String contentMessage}) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialogWidget(
//         titleText: titleMessage,
//         contentText: contentMessage,
//         positiveButtonText: isSuccess ? "Done" : "Okay",
//         positiveOnPressed: () async {
//           Navigator.of(context).pop();
//         },
//         iconData: isSuccess ? Icons.check_circle_outline : Icons.error_outline,
//         titleColor: isSuccess ? AppColors.ngoColor : AppColors.maroon2,
//         iconColor: Colors.white,
//       ),
//     );
//   }
//
//   ///DISBURSEMENT FUNCTIONS
// // void showDisbursementPreviewDialog(BuildContext context) {
// //   showPreviewPanelDialog(
// //     context: context,
// //     title: 'Preview Loan Disbursement: $selectedFileName',
// //     totalsWidgets: [disbursementTotalAmount(), disbursementTotalCustomers()],
// //     tableWidget: disbursementTable(),
// //     uploadStatus: uploadStatus ?? '',
// //     parameterMessage: parameterMessage,
// //     onUpload: () {
// //       if (parameterMessage == 'Preview with PEP List') {
// //         showProceedBatchTopUpConfirmAlertDialog(context, closeDialog: () {
// //           Navigator.of(context).pop();
// //         });
// //       } else {
// //         showBatchTopUpConfirmAlertDialog(context, closeDialog: () {
// //           Navigator.of(context).pop();
// //         });
// //       }
// //     },
// //   );
// // }
// //
// // ///TOP UP FUNCTIONS
// // void showTopUpPreviewDialog(BuildContext context) {
// //   showPreviewPanelDialog(
// //     context: context,
// //     title: 'Preview Agent Top Up: $selectedFileName',
// //     totalsWidgets: [topUpTotalAmount(), topUpTotalAgents()],
// //     tableWidget: topUpTable(),
// //     uploadStatus: uploadStatus ?? '',
// //     parameterMessage: parameterMessage,
// //     onUpload: () {
// //       if (parameterMessage == 'Preview with PEP List') {
// //         showProceedBatchTopUpConfirmAlertDialog(context, closeDialog: () {
// //           Navigator.of(context).pop();
// //         });
// //       } else {
// //         showBatchTopUpConfirmAlertDialog(context, closeDialog: () {
// //           Navigator.of(context).pop();
// //         });
// //       }
// //     },
// //   );
// // }
// }
