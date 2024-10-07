// import 'dart:async';
// import 'dart:convert';
// import 'dart:html';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:http/http.dart' as http;
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
// import 'package:mfi_whitelist_admin_portal/ui/screens/clientmanagement/batch_upload/batch_disbursement.dart';
// import 'package:mfi_whitelist_admin_portal/ui/screens/clientmanagement/batch_upload/batch_topup.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/widget/buttons/button.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/container.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/dialog.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/widget/fields/show_list.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/widget/scrollable/scrollable_widget.dart';
//
// import '../../../../core/mfi_whitelist_api/clients/clients_api.dart';
// import '../../../../main.dart';
// import '../../../shared/clock/clock.dart';
// import '../../../shared/sessionmanagement/gettoken/gettoken.dart';
// import '../../../shared/utils/utils_responsive.dart';
// import '../../../shared/values/colors.dart';
// import '../../../shared/widget/containers/toast.dart';
// import '../../user_management/ui/screen_bases/header/header.dart';
// import '../../user_management/ui/screen_bases/header/header_CTA.dart';
//
// typedef VoidCallback = void Function();
//
// class BatchUpload extends StatefulWidget {
//   const BatchUpload({Key? key}) : super(key: key);
//
//   @override
//   State<BatchUpload> createState() => _BatchUploadState();
// }
//
// class _BatchUploadState extends State<BatchUpload> with SingleTickerProviderStateMixin {
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
//
//     _tabController = TabController(length: 3, vsync: this);
//     _tabController.addListener(() {
//       // Reset values when the tab changes
//       if (_tabController.indexIsChanging) {
//         resetFileUploadState();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   void resetFileUploadState() {
//     setState(() {
//       selectedFileName = '';
//       firstName = '';
//       lastName = '';
//       timeStamp = '';
//       duplicateCount = 0;
//       total = 0;
//       duplicates = [];
//       existingCIDs = '';
//       parameterMessage = '';
//       uploadStatus = '';
//       uploadStatusColor = Colors.transparent;
//       dataMessage = '';
//     });
//   }
//
//   ///OPEN PREVIEW
//   // void openFileUploadDialog() {
//   //   InputElement input = (FileUploadInputElement()..accept = 'xlsm') as InputElement;
//   //   input.click();
//   //
//   //   input.onChange.listen((e) {
//   //     final files = input.files;
//   //     if (files != null && files.isNotEmpty) {
//   //       final file = files[0];
//   //       setState(() {
//   //         selectedFile = file;
//   //         selectedFileName = file.name;
//   //       });
//   //
//   //       // Call the API here
//   //       previewFile(file);
//   //     }
//   //   });
//   // }
//   void openFileUploadDialog() {
//     InputElement input = (FileUploadInputElement()..accept = 'xlsm') as InputElement;
//     input.click();
//
//     input.onChange.listen((e) {
//       final files = input.files;
//       if (files != null && files.isNotEmpty) {
//         final file = files[0];
//         setState(() {
//           selectedFile = file;
//           selectedFileName = file.name;
//         });
//
//         // Determine the API call based on the active tab
//         switch (_tabController.index) {
//           case 0: // Onboarding
//             previewFile(file); // Call the onboarding API
//             break;
//           case 1: // Disbursement
//             disbursement(file); // Call the disbursement API
//             break;
//           case 2: // Top Up
//             topUp(file); // Call the top-up API
//             break;
//           default:
//             previewFile(file); // Default action if no tab is selected (optional)
//         }
//       }
//     });
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
//   void changePagePreviewFile(Blob? file, int page) async {
//     debugPrint('Before Request URL Change Preview $page');
//     setState(() {
//       isLoading = true;
//     });
//
//     // Show loading dialog
//     showDialog(
//       context: context,
//       barrierColor: Colors.transparent,
//       builder: (context) => const Center(
//           child: CircularProgressIndicator(
//         color: AppColors.maroon2,
//       )),
//     );
//
//     final reader = FileReader();
//     reader.onLoad.listen((event) async {
//       final List<int> bytes = reader.result as List<int>;
//       final url = Uri.parse('${UrlGetter.getURL()}/clients/test/preview?page=$page&perPage=$_selectedItem');
//       debugPrint('Request URL batch upload $url');
//
//       try {
//         final request = http.MultipartRequest('POST', url)
//           ..headers['Authorization'] = 'Bearer ${getToken()}'
//           ..headers['Content-type'] = 'application/json'
//           ..files.add(http.MultipartFile.fromBytes('file', bytes, filename: selectedFileName));
//
//         final response = await request.send();
//         final responseStream = await response.stream.toBytes();
//         final responseData = utf8.decode(responseStream);
//
//         final jsonData = json.decode(responseData);
//         final dataList = jsonData['data'] as List<dynamic>? ?? [];
//         final List<Map<String, dynamic>> data = dataList.map((e) {
//           if (e is Map<String, dynamic>) {
//             return e;
//           } else {
//             return <String, dynamic>{}; // Handle unexpected item type
//           }
//         }).toList();
//
//         setState(() {
//           apiData = data;
//           totalRecords = jsonData['totalRecords'];
//           totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
//           isLoading = false;
//           // debugPrint('apidata: $apiData');
//         });
//         Navigator.pop(context);
//         Navigator.pop(context);
//         showPreviewDialog(context);
//       } catch (e) {
//         debugPrint('Error fetching page: $e');
//         setState(() {
//           isLoading = false;
//         });
//       }
//     });
//
//     reader.readAsArrayBuffer(selectedFile!);
//   }
//
//   Future<void> previewFile(Blob? file) async {
//     if (file == null) {
//       setState(() {
//         uploadStatus = 'No file selected';
//       });
//       return;
//     }
//
//     // Show loading dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(
//         child: Container(
//           width: 350,
//           height: 100,
//           decoration: const BoxDecoration(
//             color: AppColors.dialogColor,
//             borderRadius: BorderRadius.all(Radius.circular(5)),
//           ),
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SpinKitFadingCircle(color: AppColors.maroon2),
//               SizedBox(width: 10),
//               Text('Data rendering...'),
//             ],
//           ),
//         ),
//       ),
//     );
//
//     final reader = FileReader();
//
//     reader.onLoad.listen((event) async {
//       final List<int> bytes = reader.result as List<int>;
//       final url = Uri.parse('${UrlGetter.getURL()}/clients/test/preview?page=${currentPage + 1}&perPage=$_selectedItem');
//       debugPrint('First Preview Request URL $url');
//
//       try {
//         final request = http.MultipartRequest(
//           'POST',
//           url,
//         );
//
//         final token = getToken();
//         request.headers['Authorization'] = 'Bearer $token';
//         request.headers['Content-type'] = 'application/json';
//         request.files.add(
//           http.MultipartFile.fromBytes(
//             'file',
//             bytes,
//             filename: selectedFileName,
//           ),
//         );
//
//         final response = await request.send();
//         final responseStream = await response.stream.toBytes();
//
//         final responseData = utf8.decode(responseStream);
//         final jsonData = json.decode(responseData);
//
//         setState(() {
//           parameterMessage = jsonData['message'] ?? 'Unknown error occurred';
//           hasPepList = jsonData['pepList'] != null && (jsonData['pepList'] as List<dynamic>).isNotEmpty;
//         });
//
//         if (response.statusCode == 200) {
//           final dataList = jsonData['data'] as List<dynamic>? ?? [];
//
//           // Check if dataList is of type List<Map<String, dynamic>> if needed
//           final List<Map<String, dynamic>> data = dataList.map((e) {
//             if (e is Map<String, dynamic>) {
//               return e;
//             } else {
//               // Handle unexpected item type or log an error
//               return <String, dynamic>{}; // Return an empty map or handle accordingly
//             }
//           }).toList();
//
//           if (parameterMessage == 'Preview with PEP List') {
//             setState(() {
//               uploadStatus = 'WATCHLIST';
//               uploadStatusColor = _getStatusColor('WATCHLIST');
//               apiData = data;
//               totalRecords = jsonData['totalRecords'];
//               totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
//               parameterMessage = jsonData['message'];
//               duplicateCount = countPepList(jsonData);
//               fileName = selectedFileName;
//               pepsFound = hasPepList ? (jsonData['pepList'] as List<dynamic>).map((item) => item as String).toList() : [];
//               isLoading = false;
//             });
//           } else {
//             setState(() {
//               uploadStatus = 'PREVIEWED';
//               uploadStatusColor = _getStatusColor('PREVIEWED');
//               apiData = data;
//               totalRecords = jsonData['totalRecords'];
//               totalPages = jsonData['totalPages'];
//               parameterMessage = jsonData['message'];
//               duplicateCount = countPepList(jsonData);
//               fileName = selectedFileName;
//               pepsFound = hasPepList ? (jsonData['pepList'] as List<dynamic>).map((item) => item as String).toList() : [];
//               isLoading = false;
//             });
//           }
//
//           Navigator.pop(context);
//           Future.delayed(const Duration(seconds: 2));
//           showPreviewDialog(context);
//         } else {
//           showUploadFileAlertDialog(
//             isSuccess: false,
//             titleMessage: 'Failed to Upload',
//             contentMessage: 'Sorry, we are unable to process your request. See remarks for info.',
//           );
//
//           setState(() {
//             uploadStatus = 'FAILED';
//             uploadStatusColor = _getStatusColor('FAILED');
//             isLoading = false;
//           });
//         }
//       } catch (e) {
//         debugPrint('Error here: $e');
//         setState(() {
//           uploadStatus = 'FAILED';
//           uploadStatusColor = _getStatusColor('FAILED');
//           isLoading = false;
//         });
//       }
//     });
//
//     reader.readAsArrayBuffer(file);
//   }
//
//   Future<void> disbursement(Blob? file) async {
//     if (file == null) {
//       setState(() {
//         uploadStatus = 'No file selected';
//       });
//       return;
//     }
//
//     // Show loading dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(
//         child: Container(
//           width: 350,
//           height: 100,
//           decoration: const BoxDecoration(
//             color: AppColors.dialogColor,
//             borderRadius: BorderRadius.all(Radius.circular(5)),
//           ),
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SpinKitFadingCircle(color: AppColors.maroon2),
//               SizedBox(width: 10),
//               Text('Data rendering...'),
//             ],
//           ),
//         ),
//       ),
//     );
//
//     final reader = FileReader();
//
//     reader.onLoad.listen((event) async {
//       final List<int> bytes = reader.result as List<int>;
//       final url = Uri.parse('${UrlGetter.getURL()}/clients/test/preview?page=${currentPage + 1}&perPage=$_selectedItem');
//       debugPrint('First Preview Request URL $url');
//
//       try {
//         final request = http.MultipartRequest(
//           'POST',
//           url,
//         );
//
//         final token = getToken();
//         request.headers['Authorization'] = 'Bearer $token';
//         request.headers['Content-type'] = 'application/json';
//         request.files.add(
//           http.MultipartFile.fromBytes(
//             'file',
//             bytes,
//             filename: selectedFileName,
//           ),
//         );
//
//         final response = await request.send();
//         final responseStream = await response.stream.toBytes();
//
//         final responseData = utf8.decode(responseStream);
//         final jsonData = json.decode(responseData);
//
//         setState(() {
//           parameterMessage = jsonData['message'] ?? 'Unknown error occurred';
//           hasPepList = jsonData['pepList'] != null && (jsonData['pepList'] as List<dynamic>).isNotEmpty;
//         });
//
//         if (response.statusCode == 200) {
//           final dataList = jsonData['data'] as List<dynamic>? ?? [];
//
//           // Check if dataList is of type List<Map<String, dynamic>> if needed
//           final List<Map<String, dynamic>> data = dataList.map((e) {
//             if (e is Map<String, dynamic>) {
//               return e;
//             } else {
//               // Handle unexpected item type or log an error
//               return <String, dynamic>{}; // Return an empty map or handle accordingly
//             }
//           }).toList();
//
//           if (parameterMessage == 'Preview with PEP List') {
//             setState(() {
//               uploadStatus = 'WATCHLIST';
//               uploadStatusColor = _getStatusColor('WATCHLIST');
//               apiData = data;
//               totalRecords = jsonData['totalRecords'];
//               totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
//               parameterMessage = jsonData['message'];
//               duplicateCount = countPepList(jsonData);
//               fileName = selectedFileName;
//               pepsFound = hasPepList ? (jsonData['pepList'] as List<dynamic>).map((item) => item as String).toList() : [];
//               isLoading = false;
//             });
//           } else {
//             setState(() {
//               uploadStatus = 'PREVIEWED';
//               uploadStatusColor = _getStatusColor('PREVIEWED');
//               apiData = data;
//               totalRecords = jsonData['totalRecords'];
//               totalPages = jsonData['totalPages'];
//               parameterMessage = jsonData['message'];
//               duplicateCount = countPepList(jsonData);
//               fileName = selectedFileName;
//               pepsFound = hasPepList ? (jsonData['pepList'] as List<dynamic>).map((item) => item as String).toList() : [];
//               isLoading = false;
//             });
//           }
//
//           Navigator.pop(context);
//           Future.delayed(const Duration(seconds: 2));
//           showPreviewDialog(context);
//         } else {
//           showUploadFileAlertDialog(
//             isSuccess: false,
//             titleMessage: 'Failed to Upload',
//             contentMessage: 'Sorry, we are unable to process your request. See remarks for info.',
//           );
//
//           setState(() {
//             uploadStatus = 'FAILED';
//             uploadStatusColor = _getStatusColor('FAILED');
//             isLoading = false;
//           });
//         }
//       } catch (e) {
//         debugPrint('Error here: $e');
//         setState(() {
//           uploadStatus = 'FAILED';
//           uploadStatusColor = _getStatusColor('FAILED');
//           isLoading = false;
//         });
//       }
//     });
//
//     reader.readAsArrayBuffer(file);
//   }
//
//   Future<void> topUp(Blob? file) async {
//     if (file == null) {
//       setState(() {
//         uploadStatus = 'No file selected';
//       });
//       return;
//     }
//
//     // Show loading dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(
//         child: Container(
//           width: 350,
//           height: 100,
//           decoration: const BoxDecoration(
//             color: AppColors.dialogColor,
//             borderRadius: BorderRadius.all(Radius.circular(5)),
//           ),
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SpinKitFadingCircle(color: AppColors.maroon2),
//               SizedBox(width: 10),
//               Text('Data rendering...'),
//             ],
//           ),
//         ),
//       ),
//     );
//
//     final reader = FileReader();
//
//     reader.onLoad.listen((event) async {
//       final List<int> bytes = reader.result as List<int>;
//       final url = Uri.parse('${UrlGetter.getURL()}/clients/test/preview?page=${currentPage + 1}&perPage=$_selectedItem');
//       debugPrint('First Preview Request URL $url');
//
//       try {
//         final request = http.MultipartRequest(
//           'POST',
//           url,
//         );
//
//         final token = getToken();
//         request.headers['Authorization'] = 'Bearer $token';
//         request.headers['Content-type'] = 'application/json';
//         request.files.add(
//           http.MultipartFile.fromBytes(
//             'file',
//             bytes,
//             filename: selectedFileName,
//           ),
//         );
//
//         final response = await request.send();
//         final responseStream = await response.stream.toBytes();
//
//         final responseData = utf8.decode(responseStream);
//         final jsonData = json.decode(responseData);
//
//         setState(() {
//           parameterMessage = jsonData['message'] ?? 'Unknown error occurred';
//           hasPepList = jsonData['pepList'] != null && (jsonData['pepList'] as List<dynamic>).isNotEmpty;
//         });
//
//         if (response.statusCode == 200) {
//           final dataList = jsonData['data'] as List<dynamic>? ?? [];
//
//           // Check if dataList is of type List<Map<String, dynamic>> if needed
//           final List<Map<String, dynamic>> data = dataList.map((e) {
//             if (e is Map<String, dynamic>) {
//               return e;
//             } else {
//               // Handle unexpected item type or log an error
//               return <String, dynamic>{}; // Return an empty map or handle accordingly
//             }
//           }).toList();
//
//           if (parameterMessage == 'Preview with PEP List') {
//             setState(() {
//               uploadStatus = 'WATCHLIST';
//               uploadStatusColor = _getStatusColor('WATCHLIST');
//               apiData = data;
//               totalRecords = jsonData['totalRecords'];
//               totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
//               parameterMessage = jsonData['message'];
//               duplicateCount = countPepList(jsonData);
//               fileName = selectedFileName;
//               pepsFound = hasPepList ? (jsonData['pepList'] as List<dynamic>).map((item) => item as String).toList() : [];
//               isLoading = false;
//             });
//           } else {
//             setState(() {
//               uploadStatus = 'PREVIEWED';
//               uploadStatusColor = _getStatusColor('PREVIEWED');
//               apiData = data;
//               totalRecords = jsonData['totalRecords'];
//               totalPages = jsonData['totalPages'];
//               parameterMessage = jsonData['message'];
//               duplicateCount = countPepList(jsonData);
//               fileName = selectedFileName;
//               pepsFound = hasPepList ? (jsonData['pepList'] as List<dynamic>).map((item) => item as String).toList() : [];
//               isLoading = false;
//             });
//           }
//
//           Navigator.pop(context);
//           Future.delayed(const Duration(seconds: 2));
//           showPreviewDialog(context);
//         } else {
//           showUploadFileAlertDialog(
//             isSuccess: false,
//             titleMessage: 'Failed to Upload',
//             contentMessage: 'Sorry, we are unable to process your request. See remarks for info.',
//           );
//
//           setState(() {
//             uploadStatus = 'FAILED';
//             uploadStatusColor = _getStatusColor('FAILED');
//             isLoading = false;
//           });
//         }
//       } catch (e) {
//         debugPrint('Error here: $e');
//         setState(() {
//           uploadStatus = 'FAILED';
//           uploadStatusColor = _getStatusColor('FAILED');
//           isLoading = false;
//         });
//       }
//     });
//
//     reader.readAsArrayBuffer(file);
//   }
//
//   int countPepList(Map<String, dynamic> jsonData) {
//     // Check if 'pepList' exists and is a List
//     if (jsonData.containsKey('pepList') && jsonData['pepList'] is List) {
//       // Cast the list and return its length
//       List<dynamic> pepList = jsonData['pepList'];
//       return pepList.length;
//     } else {
//       // If 'pepList' doesn't exist or isn't a list, return 0
//       return 0;
//     }
//   }
//
//   ///ORIGINAL VALUE
//   void uploadFile(Blob? file) async {
//     if (file == null) {
//       setState(() {
//         uploadStatus = 'No file selected';
//       });
//       return;
//     }
//
//     setState(() {
//       uploadStatus = 'UPLOADING';
//       isLoading = true;
//     });
//
//     // Show loading dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(
//         child: Container(
//           width: 350,
//           height: 100,
//           decoration: const BoxDecoration(
//             color: AppColors.dialogColor,
//             borderRadius: BorderRadius.all(Radius.circular(5)),
//           ),
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SpinKitFadingCircle(color: AppColors.maroon2),
//               SizedBox(width: 10),
//               Text('Uploading in progress...'),
//             ],
//           ),
//         ),
//       ),
//     );
//
//     final reader = FileReader();
//
//     reader.onLoad.listen((event) async {
//       final List<int> bytes = reader.result as List<int>;
//
//       try {
//         final request = http.MultipartRequest(
//           'POST',
//           Uri.parse('${UrlGetter.getURL()}/clients/test/batch/upload'),
//         );
//
//         final token = getToken();
//         request.headers['Authorization'] = 'Bearer $token';
//         request.headers['Content-type'] = 'application/json';
//         request.files.add(
//           http.MultipartFile.fromBytes(
//             'file',
//             bytes,
//             filename: selectedFileName,
//           ),
//         );
//
//         final response = await request.send();
//         final responseStream = await response.stream.toBytes();
//
//         final responseData = utf8.decode(responseStream);
//         final jsonData = json.decode(responseData);
//         final responseMessage = jsonData['message'] ?? 'Unknown error occurred';
//         final responseDataMap = jsonData['data'] ?? {};
//
//         Navigator.pop(context); // Close the loading dialog
//
//         setState(() {
//           parameterMessage = responseMessage;
//           dataMessage = responseDataMap.toString(); // Example: Convert responseDataMap to String
//         });
//
//         // debugPrint('Response Body: ${String.fromCharCodes(responseStream)}');
//         if (response.statusCode == 200) {
//           if (jsonData['message'] == 'File Uploaded Successfully') {
//             showUploadFileAlertDialog(
//               isSuccess: true,
//               titleMessage: 'File Uploaded Successfully',
//               contentMessage: 'You uploaded a file successfully.',
//             );
//             setState(() {
//               uploadStatus = 'SUCCESS';
//               uploadStatusColor = _getStatusColor(uploadStatus);
//               fileName = responseDataMap['FileName'] ?? '';
//               firstName = responseDataMap['FirstName'] ?? '';
//               lastName = responseDataMap['LastName'] ?? '';
//               timeStamp = responseDataMap['Timestamp'] ?? '';
//               total = responseDataMap['TotalRecords'] ?? 0;
//               duplicateCount = responseDataMap['DuplicateCount'] ?? 0;
//             });
//           } else if (jsonData['message'] == 'File size exceeds the 24 MB limit' && jsonData['retCode'] == '400') {
//             showUploadFileAlertDialog(
//               isSuccess: false,
//               titleMessage: 'Failed to Upload',
//               contentMessage: parameterMessage,
//             );
//
//             setState(() {
//               uploadStatus = 'FAILED';
//               uploadStatusColor = _getStatusColor('FAILED');
//             });
//           } else if (responseMessage == 'CSV file exceeds the maximum row limit of 1000' && jsonData['retCode'] == '400') {
//             showUploadFileAlertDialog(
//               isSuccess: false,
//               titleMessage: 'Failed to Upload',
//               contentMessage: parameterMessage,
//             );
//
//             setState(() {
//               uploadStatus = 'FAILED';
//               uploadStatusColor = _getStatusColor('FAILED');
//             });
//           } else if (responseMessage == 'Error opening uploaded file' && jsonData['retCode'] == '500') {
//             showUploadFileAlertDialog(
//               isSuccess: false,
//               titleMessage: 'Failed to Upload',
//               contentMessage: parameterMessage,
//             );
//
//             setState(() {
//               uploadStatus = 'FAILED';
//               uploadStatusColor = _getStatusColor('FAILED');
//             });
//           } else if (responseMessage == 'File name already exists and already checked by checker' && jsonData['retCode'] == '500') {
//             showUploadFileAlertDialog(
//               isSuccess: false,
//               titleMessage: 'Failed to Upload',
//               contentMessage: parameterMessage,
//             );
//
//             setState(() {
//               uploadStatus = 'FAILED';
//               uploadStatusColor = _getStatusColor('FAILED');
//             });
//           } else if (jsonData['data'] == 'Error in bulk inserting' && jsonData['retCode'] == '500') {
//             showUploadFileAlertDialog(
//               isSuccess: false,
//               titleMessage: responseDataMap.toString(),
//               contentMessage: jsonData['data'],
//             );
//
//             setState(() {
//               uploadStatus = 'FAILED';
//               uploadStatusColor = _getStatusColor('FAILED');
//             });
//           } else {
//             showUploadFileAlertDialog(
//               isSuccess: false,
//               titleMessage: 'Failed to Upload',
//               contentMessage: responseMessage,
//             );
//
//             // Ensure the data is correctly cast and assigned
//             final List<dynamic> rawDuplicates = responseDataMap['DuplicateNewCIDs'] ?? [];
//             final List<String> duplicateNewCIDs = rawDuplicates.map((e) => e.toString()).toList();
//
//             setState(() {
//               uploadStatus = 'FAILED';
//               uploadStatusColor = _getStatusColor('FAILED');
//               fileName = responseDataMap['FileName'] ?? '';
//               firstName = responseDataMap['FirstName'] ?? '';
//               lastName = responseDataMap['LastName'] ?? '';
//               timeStamp = responseDataMap['Timestamp'] ?? '';
//               total = responseDataMap['TotalRecords'] ?? 0;
//               duplicateCount = responseDataMap['DuplicateCount'] ?? 0;
//               duplicates = duplicateNewCIDs; // Assign the correctly cast list here
//             });
//           }
//         } else if (responseMessage == 'PEP List Found' && jsonData['retCode'] == '200' && response.statusCode == 400) {
//           showUploadFileAlertDialog(
//             isSuccess: false,
//             titleMessage: 'Failed to Upload',
//             contentMessage: 'Sorry, we are unable to process your request. See remarks for info.',
//           );
//
//           // Ensure the data is correctly cast and assigned
//           final List<dynamic> rawDuplicates = responseDataMap['DuplicateNewCIDs'] ?? [];
//           final List<String> duplicateNewCIDs = rawDuplicates.map((e) => e.toString()).toList();
//
//           setState(() {
//             uploadStatus = 'WATCHLIST';
//             uploadStatusColor = _getStatusColor('WATCHLIST');
//             fileName = responseDataMap['FileName'] ?? '';
//             firstName = responseDataMap['FirstName'] ?? '';
//             lastName = responseDataMap['LastName'] ?? '';
//             timeStamp = responseDataMap['Timestamp'] ?? '';
//             total = responseDataMap['TotalRecords'] ?? 0;
//             duplicateCount = responseDataMap['DuplicateCount'] ?? 0;
//             pepsFound = duplicateNewCIDs; // Assign the correctly cast list here
//           });
//         } else if (responseMessage == 'Existing CIDs' && jsonData['retCode'] == '200' && response.statusCode == 400) {
//           showUploadFileAlertDialog(
//             isSuccess: false,
//             titleMessage: 'Failed to Upload',
//             contentMessage: responseMessage,
//           );
//
//           setState(() {
//             uploadStatus = 'FAILED';
//             uploadStatusColor = _getStatusColor('FAILED');
//             fileName = responseDataMap['FileName'] ?? '';
//             firstName = responseDataMap['FirstName'] ?? '';
//             lastName = responseDataMap['LastName'] ?? '';
//             timeStamp = responseDataMap['Timestamp'] ?? '';
//             total = responseDataMap['TotalRecords'] ?? 0;
//             duplicateCount = int.parse(responseDataMap['DuplicateCount'].toString());
//             existingCIDs = responseDataMap['DuplicateNewCIDs'].toString(); // Assign the correctly cast string here
//           });
//         } else {
//           showUploadFileAlertDialog(
//             isSuccess: false,
//             titleMessage: 'Failed to Upload',
//             contentMessage: 'Sorry, we are unable to process your request. See remarks for info.',
//           );
//
//           // Ensure the data is correctly cast and assigned
//           final List<dynamic> rawDuplicates = responseDataMap['DuplicateNewCIDs'] ?? [];
//           final List<String> duplicateNewCIDs = rawDuplicates.map((e) => e.toString()).toList();
//
//           setState(() {
//             uploadStatus = 'FAILED';
//             uploadStatusColor = _getStatusColor('FAILED');
//             fileName = responseDataMap['FileName'] ?? '';
//             firstName = responseDataMap['FirstName'] ?? '';
//             lastName = responseDataMap['LastName'] ?? '';
//             timeStamp = responseDataMap['Timestamp'] ?? '';
//             total = responseDataMap['TotalRecords'] ?? 0;
//             duplicateCount = responseDataMap['DuplicateCount'] ?? 0;
//             duplicates = duplicateNewCIDs; // Assign the correctly cast list here
//           });
//         }
//       } catch (e) {
//         debugPrint('Error uploading: $e');
//         setState(() {
//           uploadStatus = 'FAILED';
//           uploadStatusColor = _getStatusColor('FAILED');
//           isLoading = false;
//         });
//       }
//     });
//
//     reader.readAsArrayBuffer(file);
//   }
//
//   void proceedUploadFile(Blob? file) async {
//     if (file == null) {
//       setState(() {
//         // debugPrint('No file selected');
//         uploadStatus = 'No file selected';
//       });
//       return;
//     }
//
//     setState(() {
//       uploadStatus = 'UPLOADING';
//       isLoading = true;
//     });
//
//     // Show loading dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(
//         child: Container(
//           width: 350,
//           height: 100,
//           decoration: const BoxDecoration(
//             color: AppColors.dialogColor,
//             borderRadius: BorderRadius.all(Radius.circular(5)),
//           ),
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SpinKitFadingCircle(color: AppColors.maroon2),
//               SizedBox(width: 10),
//               Text('Uploading in progress...'),
//             ],
//           ),
//         ),
//       ),
//     );
//
//     final reader = FileReader();
//
//     reader.onLoad.listen((event) async {
//       final List<int> bytes = reader.result as List<int>;
//
//       try {
//         final request = http.MultipartRequest(
//           'POST',
//           Uri.parse('${UrlGetter.getURL()}/clients/test/batch/upload/proceed'),
//         );
//
//         final token = getToken();
//         request.headers['Authorization'] = 'Bearer $token';
//         request.headers['Content-type'] = 'application/json';
//         request.files.add(
//           http.MultipartFile.fromBytes(
//             'file',
//             bytes,
//             filename: selectedFileName,
//           ),
//         );
//
//         final response = await request.send();
//         final responseStream = await response.stream.toBytes();
//
//         final responseData = utf8.decode(responseStream);
//         final jsonData = json.decode(responseData);
//         final responseMessage = jsonData['message'] ?? 'Unknown error occurred';
//         final responseDataMap = jsonData['data'] ?? {};
//
//         Navigator.pop(context); // Close the loading dialog
//
//         setState(() {
//           parameterMessage = responseMessage;
//           dataMessage = responseDataMap.toString(); // Example: Convert responseDataMap to String
//         });
//
//         // debugPrint('Response Body: ${String.fromCharCodes(responseStream)}');
//         if (response.statusCode == 200) {
//           if (jsonData['message'] == 'File Uploaded Successfully') {
//             showUploadFileAlertDialog(
//               isSuccess: true,
//               titleMessage: 'File Uploaded Successfully',
//               contentMessage: 'You uploaded a file successfully.',
//             );
//             setState(() {
//               uploadStatus = 'SUCCESS';
//               uploadStatusColor = _getStatusColor(uploadStatus);
//               fileName = responseDataMap['FileName'] ?? '';
//               firstName = responseDataMap['FirstName'] ?? '';
//               lastName = responseDataMap['LastName'] ?? '';
//               timeStamp = responseDataMap['Timestamp'] ?? '';
//               total = responseDataMap['TotalRecords'] ?? 0;
//               duplicateCount = responseDataMap['DuplicateCount'] ?? 0;
//             });
//           } else if (jsonData['message'] == 'File size exceeds the 24 MB limit' && jsonData['retCode'] == '400') {
//             showUploadFileAlertDialog(
//               isSuccess: false,
//               titleMessage: 'Failed to Upload',
//               contentMessage: responseMessage,
//             );
//
//             setState(() {
//               uploadStatus = 'FAILED';
//               uploadStatusColor = _getStatusColor('FAILED');
//             });
//           } else if (responseMessage == 'CSV file exceeds the maximum row limit of 1000' && jsonData['retCode'] == '400') {
//             showUploadFileAlertDialog(
//               isSuccess: false,
//               titleMessage: 'Failed to Upload',
//               contentMessage: responseMessage,
//             );
//
//             setState(() {
//               uploadStatus = 'FAILED';
//               uploadStatusColor = _getStatusColor('FAILED');
//             });
//           } else if (responseMessage == 'Error opening uploaded file' && jsonData['retCode'] == '500') {
//             showUploadFileAlertDialog(
//               isSuccess: false,
//               titleMessage: 'Failed to Upload',
//               contentMessage: responseMessage,
//             );
//
//             setState(() {
//               uploadStatus = 'FAILED';
//               uploadStatusColor = _getStatusColor('FAILED');
//             });
//           } else if (responseMessage == 'File name already exists and already checked by checker' && jsonData['retCode'] == '500') {
//             showUploadFileAlertDialog(
//               isSuccess: false,
//               titleMessage: 'Failed to Upload',
//               contentMessage: responseMessage,
//             );
//
//             setState(() {
//               uploadStatus = 'FAILED';
//               uploadStatusColor = _getStatusColor('FAILED');
//             });
//           } else if (jsonData['data'] == 'Error in bulk inserting' && jsonData['retCode'] == '500') {
//             showUploadFileAlertDialog(
//               isSuccess: false,
//               titleMessage: responseDataMap.toString(),
//               contentMessage: jsonData['data'],
//             );
//
//             setState(() {
//               uploadStatus = 'FAILED';
//               uploadStatusColor = _getStatusColor('FAILED');
//             });
//           } else {
//             showUploadFileAlertDialog(
//               isSuccess: false,
//               titleMessage: 'Failed to Upload',
//               contentMessage: responseMessage,
//             );
//
//             // Ensure the data is correctly cast and assigned
//             final List<dynamic> rawDuplicates = responseDataMap['DuplicateNewCIDs'] ?? [];
//             final List<String> duplicateNewCIDs = rawDuplicates.map((e) => e.toString()).toList();
//
//             setState(() {
//               uploadStatus = 'FAILED';
//               uploadStatusColor = _getStatusColor('FAILED');
//               fileName = responseDataMap['FileName'] ?? '';
//               firstName = responseDataMap['FirstName'] ?? '';
//               lastName = responseDataMap['LastName'] ?? '';
//               timeStamp = responseDataMap['Timestamp'] ?? '';
//               total = responseDataMap['TotalRecords'] ?? 0;
//               duplicateCount = responseDataMap['DuplicateCount'] ?? 0;
//               duplicates = duplicateNewCIDs; // Assign the correctly cast list here
//             });
//           }
//         } else if (responseMessage == 'Existing CIDs' && jsonData['retCode'] == '200' && response.statusCode == 400) {
//           showUploadFileAlertDialog(
//             isSuccess: false,
//             titleMessage: 'Failed to Upload',
//             contentMessage: responseMessage,
//           );
//
//           setState(() {
//             uploadStatus = 'FAILED';
//             uploadStatusColor = _getStatusColor('FAILED');
//             fileName = responseDataMap['FileName'] ?? '';
//             firstName = responseDataMap['FirstName'] ?? '';
//             lastName = responseDataMap['LastName'] ?? '';
//             timeStamp = responseDataMap['Timestamp'] ?? '';
//             total = responseDataMap['TotalRecords'] ?? 0;
//             duplicateCount = int.parse(responseDataMap['DuplicateCount'].toString());
//             existingCIDs = responseDataMap['DuplicateNewCIDs'].toString(); // Assign the correctly cast string here
//           });
//         } else if (responseMessage == 'PEP List Found' && jsonData['retCode'] == '200' && response.statusCode == 400) {
//           showUploadFileAlertDialog(
//             isSuccess: false,
//             titleMessage: 'Failed to Upload',
//             contentMessage: 'Sorry, we are unable to process your request. See remarks for info.',
//           );
//
//           // Ensure the data is correctly cast and assigned
//           final List<dynamic> rawDuplicates = responseDataMap['DuplicateNewCIDs'] ?? [];
//           final List<String> duplicateNewCIDs = rawDuplicates.map((e) => e.toString()).toList();
//
//           setState(() {
//             uploadStatus = 'FAILED';
//             uploadStatusColor = _getStatusColor('FAILED');
//             fileName = responseDataMap['FileName'] ?? '';
//             firstName = responseDataMap['FirstName'] ?? '';
//             lastName = responseDataMap['LastName'] ?? '';
//             timeStamp = responseDataMap['Timestamp'] ?? '';
//             total = responseDataMap['TotalRecords'] ?? 0;
//             duplicateCount = responseDataMap['DuplicateCount'] ?? 0;
//             pepsFound = duplicateNewCIDs; // Assign the correctly cast list here
//           });
//         } else {
//           showUploadFileAlertDialog(
//             isSuccess: false,
//             titleMessage: 'Failed to Upload',
//             contentMessage: 'Sorry, we are unable to process your request. See remarks for info.',
//           );
//
//           // Ensure the data is correctly cast and assigned
//           final List<dynamic> rawDuplicates = responseDataMap['DuplicateNewCIDs'] ?? [];
//           final List<String> duplicateNewCIDs = rawDuplicates.map((e) => e.toString()).toList();
//
//           setState(() {
//             uploadStatus = 'FAILED';
//             uploadStatusColor = _getStatusColor('FAILED');
//             fileName = responseDataMap['FileName'] ?? '';
//             firstName = responseDataMap['FirstName'] ?? '';
//             lastName = responseDataMap['LastName'] ?? '';
//             timeStamp = responseDataMap['Timestamp'] ?? '';
//             total = responseDataMap['TotalRecords'] ?? 0;
//             duplicateCount = responseDataMap['DuplicateCount'] ?? 0;
//             duplicates = duplicateNewCIDs; // Assign the correctly cast list here
//           });
//         }
//       } catch (e) {
//         debugPrint('Error here: $e');
//         setState(() {
//           uploadStatus = 'FAILED';
//           uploadStatusColor = _getStatusColor('FAILED');
//           isLoading = false;
//         });
//       }
//     });
//
//     reader.readAsArrayBuffer(file);
//   }
//
//   void _downloadFile() async {
//     // Show loading dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(
//         child: Container(
//           width: 350,
//           height: 100,
//           decoration: const BoxDecoration(color: AppColors.dialogColor, borderRadius: BorderRadius.all(Radius.circular(5))),
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [SpinKitFadingCircle(color: AppColors.maroon2), SizedBox(width: 10), Text('Downloading in progress...')],
//           ),
//         ),
//       ),
//     );
//
//     final response = await DownloadAPI.downloadFile();
//
//     Navigator.pop(context);
//     if (response.statusCode == 200) {
//       showUploadFileAlertDialog(isSuccess: true, titleMessage: 'File Downloaded Successfully', contentMessage: 'You have successfully downloaded the file template');
//     } else {
//       showUploadFileAlertDialog(isSuccess: false, titleMessage: 'Failed to Download', contentMessage: 'File not downloaded.');
//     }
//   }
//
//   void cancelUpload() {
//     setState(() {
//       selectedFileName = '';
//       firstName = '';
//       lastName = '';
//       timeStamp = '';
//       duplicateCount = 0;
//       total = 0;
//       duplicates = [];
//       existingCIDs = '';
//       parameterMessage = '';
//       uploadStatus = '';
//       uploadStatusColor = Colors.transparent;
//       dataMessage = '';
//     });
//   }
//
//   // ========Create templated data cell for PAGINATED ROWS=============//
//   List<DataRow> getPaginatedRows() {
//     const textStyle = TextStyles.dataTextStyle;
//
//     DataCell buildDataCell(String? text, {bool isWatchlisted = false}) {
//       return DataCell(
//         Center(
//           child: isWatchlisted
//               ? Container(
//                   margin: const EdgeInsets.only(right: 20),
//                   width: 150,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: AppColors.highlightDash.withOpacity(0.2),
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColors.highlightDash.withOpacity(0.4),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: const Offset(3, 3),
//                       ),
//                       const BoxShadow(
//                         color: Colors.white,
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: Offset(-3, -3),
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Text(
//                       text?.toUpperCase() ?? '',
//                       style: const TextStyle(
//                         color: AppColors.highlightDash, // Text color to match the background
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 )
//               : SelectableText(
//                   text ?? '',
//                   style: textStyle,
//                 ),
//         ),
//       );
//     }
//
//     return List<DataRow>.generate(apiData.length, (index) {
//       final rowData = apiData[index];
//       final color = index % 2 == 0 ? Colors.transparent : Colors.white;
//       final isPep = rowData['is_pep'] == true;
//
//       final cells = <DataCell>[
//         buildDataCell(rowData['Cid']),
//         buildDataCell(rowData['FirstName']),
//         buildDataCell(rowData['MiddleName']),
//         buildDataCell(rowData['LastName']),
//         buildDataCell(rowData['SpouseMaidenFName']),
//         buildDataCell(rowData['SpouseMaidenMName']),
//         buildDataCell(rowData['SpouseMaidenLName']),
//         buildDataCell(rowData['MobileNumber']),
//         buildDataCell(rowData['Birthday']),
//         buildDataCell(rowData['PlaceOfBirth']),
//         buildDataCell(rowData['Religion']),
//         buildDataCell(rowData['Gender']),
//         buildDataCell(rowData['CivilStatus']),
//         buildDataCell(rowData['Citizenship']),
//         buildDataCell(rowData['PresentAddress']),
//         buildDataCell(rowData['PermanentAddress']),
//         buildDataCell(rowData['PresentCity']),
//         buildDataCell(rowData['PresentProvince']),
//         buildDataCell(rowData['PresentPostalCode']),
//         buildDataCell(rowData['ClientMaidenFName']),
//         buildDataCell(rowData['ClientMaidenMName']),
//         buildDataCell(rowData['ClientMaidenLName']),
//         buildDataCell(rowData['Email']),
//         buildDataCell(rowData['InstitutionName']),
//         buildDataCell(rowData['UnitName']),
//         buildDataCell(rowData['CenterName']),
//         buildDataCell(rowData['BranchName']),
//         buildDataCell(rowData['ClientClassification']),
//         buildDataCell(rowData['SourceOfFund']),
//         buildDataCell(rowData['EmployerOrBusinessName']),
//         buildDataCell(rowData['EmployerOrBusinessAddress']),
//       ];
//
//       if (hasPepList) {
//         cells.insert(0, buildDataCell(isPep ? 'Watchlist' : '', isWatchlisted: isPep));
//       }
//
//       return DataRow(
//         color: MaterialStateProperty.all<Color>(color),
//         cells: cells,
//       );
//     });
//   }
//
//   List<DataColumn> buildDataColumns() {
//     final textStyle = TextStyle(
//       fontSize: 14,
//       color: Colors.black.withOpacity(0.6),
//       letterSpacing: .5,
//       fontWeight: FontWeight.bold,
//     );
//
//     DataColumn buildDataColumn(String label, {void Function()? onTap}) {
//       return DataColumn(
//         label: Expanded(
//           child: GestureDetector(
//             onTap: onTap,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(label, style: textStyle),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//
//     final columns = <DataColumn>[
//       buildDataColumn('CID'),
//       buildDataColumn('First Name'),
//       buildDataColumn('Middle Name'),
//       buildDataColumn('Last Name'),
//       buildDataColumn('Spouse First Name'),
//       buildDataColumn('Spouse Middle Name'),
//       buildDataColumn('Spouse Last Name'),
//       buildDataColumn('Mobile Number'),
//       buildDataColumn('Birthday'),
//       buildDataColumn('Place of Birth'),
//       buildDataColumn('Religion'),
//       buildDataColumn('Gender'),
//       buildDataColumn('Civil Status'),
//       buildDataColumn('Citizenship'),
//       buildDataColumn('Present Address'),
//       buildDataColumn('Permanent Address'),
//       buildDataColumn('Present City'),
//       buildDataColumn('Present Province'),
//       buildDataColumn('Present Postal Code'),
//       buildDataColumn('Client Maiden First Name'),
//       buildDataColumn('Client Maiden Middle Name'),
//       buildDataColumn('Client Maiden Last Name'),
//       buildDataColumn('Email'),
//       buildDataColumn('Institution Name'),
//       buildDataColumn('Unit Name'),
//       buildDataColumn('Center Name'),
//       buildDataColumn('Branch Name'),
//       buildDataColumn('Client Classification'),
//       buildDataColumn('Source of Fund'),
//       buildDataColumn('Employer/Business Name'),
//       buildDataColumn('Employer/Business Address'),
//     ];
//
//     if (hasPepList) {
//       columns.insert(0, buildDataColumn('Watchlist'));
//     }
//
//     return columns;
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
//
//   void onPageSizeChange(int newPageSize) {
//     setState(() {
//       _selectedItem = newPageSize.toString();
//       currentPage = 0; // Reset to first page
//     });
//     changePagePreviewFile(selectedFile, currentPage); // Refetch the file with new page size
//   }
//
//   void nextPage() {
//     if (currentPage < totalPages - 1) {
//       setState(() {
//         currentPage += 1;
//       });
//       changePagePreviewFile(selectedFile, currentPage);
//       // previewFile(selectedFile); // Fetch data for the next page
//       debugPrint('next page $currentPage');
//     }
//   }
//
//   void previousPage() {
//     if (currentPage > 0) {
//       setState(() {
//         currentPage -= 1;
//       });
//       changePagePreviewFile(selectedFile, currentPage);
//       // previewFile(selectedFile); // Fetch data for the previous page
//
//       debugPrint('previous page $currentPage');
//     }
//   }
//
//   // Function to handle go-to-page input
//   void _onGoToPage(String value) {
//     final int? page = int.tryParse(value);
//     if (page != null && page > 0 && page <= totalPages) {
//       setState(() {
//         currentPage = page;
//       });
//       changePagePreviewFile(selectedFile, currentPage);
//     }
//   }
//
//   void _onPageSelected(int page) {
//     debugPrint('Page passed : $page');
//     setState(() {
//       currentPage = page;
//       debugPrint('Current page selected : $currentPage');
//       changePagePreviewFile(selectedFile, currentPage);
//     });
//   }
//
//   void showTopUpConfirmDialog() {}
//
//   void showDisbursementConfirmDialog() {}
//
//   void showOnboardingConfirmDialog() {
//     if (parameterMessage == 'Preview with PEP List') {
//       showProceedBatchUploadConfirmAlertDialog(context);
//     } else {
//       showBatchUploadConfirmAlertDialog(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool areButtonsEnabled = selectedFileName.isNotEmpty && (selectedFileName.endsWith('.xlsm'));
//
//     return Container(
//       padding: const EdgeInsets.only(left: 90),
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const HeaderBar(screenText: 'BATCH UPLOADING'),
//             const HeaderCTA(children: [
//               Spacer(),
//               Responsive(desktop: Clock(), mobile: Spacer()),
//             ]),
//             const SizedBox(
//               height: 15,
//             ),
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.all(20),
//                 // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9, maxHeight: MediaQuery.of(context).size.height * 0.),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(6.0),
//                   color: Colors.grey.shade50,
//                   shape: BoxShape.rectangle,
//                   boxShadow: [
//                     BoxShadow(color: Colors.grey.shade200, spreadRadius: 0.0, blurRadius: 3, offset: const Offset(3.0, 3.0)),
//                     BoxShadow(color: Colors.grey.shade300, spreadRadius: 0.0, blurRadius: 3 / 2.0, offset: const Offset(3.0, 3.0)),
//                     const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3, offset: Offset(-3.0, -3.0)),
//                     const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3 / 2, offset: Offset(-3.0, -3.0)),
//                   ],
//                 ),
//                 child: Responsive(
//                   desktop: Row(
//                     children: [imageBatchUpload(), bodyBatchUpload(areButtonsEnabled)],
//                   ),
//                   mobile: Column(
//                     children: [
//                       bodyBatchUpload(areButtonsEnabled),
//                     ],
//                   ),
//                   tablet: Column(
//                     children: [
//                       bodyBatchUpload(areButtonsEnabled),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget bodyBatchUpload(bool areButtonsEnabled) {
//     double fontSize = (MediaQuery.sizeOf(context).width / 30);
//     return Expanded(
//       flex: 6,
//       child: Container(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'WHITELIST',
//                   style: TextStyle(color: AppColors.maroon2, fontSize: fontSize.clamp(25, 40), fontWeight: FontWeight.bold),
//                 ),
//                 const Text(
//                   'MANAGEMENT SYSTEM',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 10,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TabBar(
//                   controller: _tabController,
//                   labelColor: AppColors.maroon3,
//                   dividerColor: Colors.transparent,
//                   indicator: BoxDecoration(
//                     border: const Border(top: BorderSide(color: AppColors.maroon2, width: 3)),
//                     shape: BoxShape.rectangle,
//                     gradient: LinearGradient(
//                       colors: [Colors.red.withOpacity(0.1), AppColors.maroon5.withOpacity(0.01)], // Gradient colors
//                       begin: Alignment.topCenter, // Alignment for the start of the gradient
//                       end: Alignment.bottomCenter, // Alignment for the end of the gradient
//                     ),
//                   ),
//                   unselectedLabelColor: Colors.black54, // Color for unselected tab text
//                   tabs: [
//                     _buildTab("Onboarding", Iconsax.people),
//                     _buildTab("Disbursement", Iconsax.money_send_copy),
//                     _buildTab("Top Up", Iconsax.wallet_money_copy),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             Expanded(
//               child: TabBarView(
//                 physics: NeverScrollableScrollPhysics(),
//                 controller: _tabController,
//                 children: [
//                   _onboardingTab(areButtonsEnabled), // Content for "Onboarding" tab
//                   BatchDisbursement(), // Content for "Disbursement" tab
//                   BatchTopUp(), // Content for "Top Up" tab
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _onboardingTab(bool areButtonsEnabled) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// CHOOSE FILE, UPLOAD BUTTON, AND DOWNLOAD BUTTON
//         Wrap(
//           // alignment: WrapAlignment.spaceBetween,
//           runSpacing: 10,
//           spacing: 20,
//           children: [
//             Container(
//               height: 35,
//               constraints: const BoxConstraints(maxWidth: 350),
//               child: chooseFileAndUploadButton(areButtonsEnabled),
//             ),
//             downloadFileButton(),
//             if (selectedFileName.isNotEmpty || (uploadStatus != '' && uploadStatus != 'SUCCESS')) previewFileButton()
//           ],
//         ),
//         Container(
//           margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
//           child: const Text(
//             'CLIENT ONBOARDING SUMMARY',
//             style: TextStyle(
//               color: AppColors.maroon2,
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//             ),
//           ),
//         ),
//
//         /// RESULT FIELDS
//         Expanded(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Wrap(
//                   alignment: WrapAlignment.spaceBetween,
//                   spacing: 10,
//                   runSpacing: 10,
//                   children: [
//                     Container(
//                       // color: Colors.teal,
//                       width: 400,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildLabel('File name'),
//                           const SizedBox(height: 5),
//                           _buildReadOnlyTextField(selectedFileName),
//                           const SizedBox(height: 5),
//                           _buildLabel('Uploader'),
//                           const SizedBox(height: 5),
//                           _buildReadOnlyTextField('$firstName $lastName'),
//                           const SizedBox(height: 5),
//                           _buildLabel('Date and Time:'),
//                           const SizedBox(height: 5),
//                           _buildReadOnlyTextField(timeStamp),
//                           const SizedBox(height: 5),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       // color: Colors.deepPurpleAccent,
//                       width: 400,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildLabel('Upload Status'),
//                           const SizedBox(height: 5),
//                           Container(
//                             padding: const EdgeInsets.all(1.5),
//                             decoration: BoxDecoration(
//                               border: Border.all(width: 0.5, color: AppColors.sidePanel1),
//                               borderRadius: BorderRadius.circular(5.0),
//                               color: Colors.white10,
//                             ),
//                             child: uploadStatus != null
//                                 ? Container(
//                                     width: 150,
//                                     height: 30,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(3),
//                                       color: uploadStatusColor.withOpacity(0.2),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         (uploadStatus?.toUpperCase() ?? ''), // Ensure text is uppercase
//                                         style: TextStyle(
//                                           color: uploadStatusColor,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 : Container(),
//                           ),
//                           const SizedBox(height: 5),
//                           _buildLabel(getLabelForDuplicateCount(parameterMessage)),
//                           const SizedBox(height: 5),
//                           _buildReadOnlyTextField('$duplicateCount'),
//                           const SizedBox(height: 5),
//                           _buildLabel('No. of Clients Uploaded'),
//                           const SizedBox(height: 5),
//                           _buildReadOnlyTextField('$total'),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 _buildLabel(getLabelForDuplicateCID(parameterMessage)),
//                 const SizedBox(height: 5),
//                 Container(
//                   // color: Colors.pink,
//                   constraints: const BoxConstraints(maxHeight: 150),
//                   child: decideTextFieldWidget(
//                       parameterMessage,
//                       parameterMessage == 'Existing CIDs'
//                           ? existingCIDs
//                           : parameterMessage == 'Duplicate CIDs'
//                               ? duplicates
//                               // : parameterMessage == 'PEP List Found'
//                               : parameterMessage == 'Preview with PEP List'
//                                   ? pepsFound
//                                   : parameterMessage == 'Preview without PEP List'
//                                       ? 'No clients were detected as being on the watchlist.'
//                                       : parameterMessage == 'Existing Data Found'
//                                           ? duplicates
//                                           : parameterMessage),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTab(String title, IconData icon) {
//     return Tab(
//       child: Container(
//         alignment: Alignment.center,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 20), // Icon with specified size
//             const SizedBox(width: 8), // Add space between icon and text
//             Responsive(
//               mobile: const SizedBox.shrink(),
//               desktop: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget chooseFileAndUploadButton(bool areButtonsEnabled) {
//     return Row(
//       children: [
//         SizedBox(
//           width: 200,
//           child: TextField(
//             style: const TextStyle(
//               fontSize: 12,
//             ),
//             onTap: () {
//               openFileUploadDialog();
//             },
//             textAlignVertical: TextAlignVertical.center,
//             cursorColor: AppColors.maroon2,
//             cursorWidth: 1,
//             cursorRadius: const Radius.circular(5),
//             decoration: InputDecoration(
//               enabledBorder: const OutlineInputBorder(
//                 borderSide: BorderSide(
//                   width: 0.5,
//                 ),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(5),
//                   bottomLeft: Radius.circular(5),
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
//               filled: true,
//               fillColor: Colors.white10,
//               focusedBorder: const OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: AppColors.sidePanel1,
//                 ),
//                 borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
//               ),
//               prefixIcon: const Icon(
//                 Icons.folder_open,
//                 color: AppColors.sidePanel1,
//                 size: 17,
//               ),
//               hintText: selectedFileName.isEmpty ? 'Select file...' : selectedFileName,
//               hintStyle: const TextStyle(fontSize: 12, color: Colors.black54),
//               suffixIcon: GestureDetector(
//                 onTap: resetFileUploadState, // Use the reset method here
//                 child: const Icon(
//                   Icons.clear,
//                   color: AppColors.sidePanel1,
//                   size: 17,
//                 ),
//               ),
//             ),
//             readOnly: true,
//           ),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             areButtonsEnabled
//                 ? uploadStatus != 'SUCCESS'
//                     ? showOnboardingConfirmDialog()
//                     : CustomToast.show(context, 'File was already uploaded.')
//                 : CustomToast.show(context, 'Please select a file first.');
//           },
//           style: ElevatedButton.styleFrom(
//             shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
//             side: const BorderSide(color: AppColors.maroon2, width: 0.5),
//             backgroundColor: (areButtonsEnabled
//                 ? uploadStatus != 'SUCCESS'
//                     ? AppColors.maroon2
//                     : Colors.grey
//                 : Colors.grey),
//           ),
//           child: Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(
//                   Icons.drive_folder_upload_sharp,
//                   size: 17,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   'Upload File',
//                   style: TextStyle(color: Colors.white, fontSize: (MediaQuery.sizeOf(context).width / 40).clamp(9, 12)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
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
//   //             // labelText: 'New CID',
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
//   //               onTap: () {
//   //                 setState(() {
//   //                   selectedFileName = '';
//   //                   firstName = '';
//   //                   lastName = '';
//   //                   timeStamp = '';
//   //                   duplicateCount = 0;
//   //                   total = 0;
//   //                   duplicates = [];
//   //                   existingCIDs = '';
//   //                   parameterMessage = '';
//   //                   uploadStatus = '';
//   //                   uploadStatusColor = Colors.transparent;
//   //                   dataMessage = '';
//   //                 });
//   //               },
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
//   //                   ? showOnboardingConfirmDialog()
//   //                   : CustomToast.show(context, 'File was already uploaded.')
//   //               : CustomToast.show(context, 'Please select a file first.');
//   //         },
//   //         style: ElevatedButton.styleFrom(
//   //           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
//   //           side: const BorderSide(color: AppColors.maroon2, width: 0.5),
//   //           backgroundColor: (areButtonsEnabled
//   //               ? uploadStatus != 'SUCCESS'
//   //                   ? AppColors.maroon2
//   //                   : Colors.grey
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
//               showPreviewDialog(context);
//               break;
//             case 1: // Disbursement
//               showDisbursementPreviewDialog(context);
//               break;
//             case 2: // Top Up
//               showTopUpPreviewDialog(context);
//               break;
//             default:
//               showPreviewDialog(context);
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
//   Widget imageBatchUpload() {
//     return Expanded(
//       flex: 3,
//       child: Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.maroon1.withOpacity(0.9), AppColors.maroon2, AppColors.maroon3, AppColors.maroon4], // Gradient colors
//               begin: Alignment.topCenter, // Alignment for the start of the gradient
//               end: Alignment.bottomCenter, // Alignment for the end of the gradient
//             ),
//             // color:  const Color(0xff941c1b),
//             borderRadius: const BorderRadius.all(Radius.zero),
//             image: const DecorationImage(
//               image: AssetImage('/images/mwap_batch_upload.png'),
//               fit: BoxFit.cover,
//             )),
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
//   Widget topUpTable() {
//     final headers = ['Account No', 'Amount', 'Customer Name'];
//     final keys = ['AccountNumber', 'E-WalletType', 'FirstName'];
//     final columnWidths = getColumnWidths(headers, apiData);
//
//     return buildTable(
//       headers: headers,
//       keys: keys,
//       columnWidths: columnWidths,
//     );
//   }
//
//   Widget topUpTotalAmount() {
//     return summaryWidget('Top Up Amount', 'PHP 0.00');
//   }
//
//   Widget topUpTotalAgents() {
//     return summaryWidget('Number of Agents', '50');
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
//   ///ONBOARDING WIDGETS
//   void showProceedBatchUploadConfirmAlertDialog(BuildContext context, {VoidCallback? closeDialog}) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialogWidget(
//         titleText: "Batch Upload Confirmation",
//         contentText: "You will be uploading $selectedFileName with clients listed as PEP. Proceed with caution.",
//         positiveButtonText: "Proceed",
//         negativeButtonText: "Cancel",
//         negativeOnPressed: () {
//           Navigator.of(context).pop();
//         },
//         positiveOnPressed: () async {
//           // Call closeDialog if it's provided
//           if (closeDialog != null) {
//             closeDialog();
//           }
//           Navigator.of(context).pop();
//           proceedUploadFile(selectedFile);
//         },
//         iconData: Icons.info_outline,
//         titleColor: AppColors.infoColor,
//         iconColor: Colors.white,
//       ),
//     );
//   }
//
//   void showBatchUploadConfirmAlertDialog(BuildContext context, {VoidCallback? closeDialog}) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialogWidget(
//         titleText: "Batch Upload Confirmation",
//         contentText: "Are you sure you want to upload $selectedFileName?",
//         positiveButtonText: "Proceed",
//         negativeButtonText: "Cancel",
//         negativeOnPressed: () {
//           Navigator.of(context).pop();
//         },
//         positiveOnPressed: () async {
//           // Call closeDialog if it's provided
//           if (closeDialog != null) {
//             closeDialog();
//           }
//           Navigator.of(context).pop();
//           uploadFile(selectedFile);
//         },
//         iconData: Icons.info_outline,
//         titleColor: AppColors.infoColor,
//         iconColor: Colors.white,
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
//           _downloadFile();
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
//   void showPreviewDialog(BuildContext context) {
//     showGeneralDialog(
//       context: navigatorKey.currentContext!,
//       barrierColor: Colors.black54,
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, animation, secondaryAnimation) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         elevation: 3,
//         surfaceTintColor: Colors.white,
//         titlePadding: const EdgeInsets.all(0),
//         title: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: const BoxDecoration(
//             image: DecorationImage(image: AssetImage('/images/mwap_header.png'), fit: BoxFit.cover, opacity: 0.5),
//             color: AppColors.maroon2,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(5.0),
//               topRight: Radius.circular(5.0),
//             ),
//           ),
//           child: Row(
//             children: [
//               Text('Preview Selected File: $selectedFileName', style: TextStyles.bold18White),
//               const Spacer(),
//               Container(
//                   padding: const EdgeInsets.all(10),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Icon(
//                       Icons.cancel_presentation,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   )),
//             ],
//           ),
//         ),
//         content: Container(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(
//                   right: 10,
//                   top: 5,
//                 ),
//                 decoration: const BoxDecoration(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(5),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     //rows&clock
//                     ShowListWidget(rowsPerPageController: rowPerPageController, rowsPerPage: _selectedItem, onPageSizeChange: onPageSizeChange),
//                     const Spacer(),
//                     if (uploadStatus != 'SUCCESS')
//                       MyButton.buttonWithLabel(
//                         context,
//                         () => parameterMessage == 'Preview with PEP List'
//                             ? showProceedBatchUploadConfirmAlertDialog(context, closeDialog: () {
//                                 Navigator.of(context).pop();
//                               })
//                             : showBatchUploadConfirmAlertDialog(context, closeDialog: () {
//                                 Navigator.of(context).pop();
//                               }),
//                         'Upload File',
//                         Icons.file_upload,
//                         AppColors.maroon2,
//                       ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                   child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: Colors.black54,
//                           width: 0.1,
//                           style: BorderStyle.solid,
//                         ),
//                       ),
//                       height: MediaQuery.of(context).size.height,
//                       width: MediaQuery.of(context).size.width,
//                       child: isLoading
//                           ? const Center(
//                               child: CircularProgressIndicator(
//                                 color: AppColors.maroon2,
//                               ),
//                             )
//                           : apiData.isEmpty
//                               ? const Center(child: NoRecordsFound())
//                               : ScrollBarWidget(
//                                   child: DataTableTheme(
//                                     data: const DataTableThemeData(
//                                       dividerThickness: 0.1,
//                                     ),
//                                     child: DataTable(
//                                       border: TableBorder.all(width: 0.1, color: Colors.black54.withOpacity(0.5)),
//                                       headingRowColor: MaterialStateColor.resolveWith(
//                                         (states) => Colors.black54.withOpacity(0.2),
//                                       ),
//                                       headingRowHeight: 50,
//                                       columns: buildDataColumns(),
//                                       rows: getPaginatedRows(),
//                                     ),
//                                   ),
//                                 )
//                       // : const NoClientsFound()),
//                       )),
//               const SizedBox(height: 10),
//
//               //PAGINATION BUTTON CODE
//               // PaginationControls(
//               //   currentPage: (totalRecords == 0) ? 0 : (currentPage + 1),
//               //   totalPages: totalPages,
//               //   totalRecords: totalRecords,
//               //   rowsPerPage: int.parse(_selectedItem),
//               //   onPreviousPage: previousPage,
//               //   onNextPage: nextPage,
//               //   onPageSelected: _onPageSelected,
//               //   onRowsPerPageChanged: onPageSizeChange,
//               //   onGoToPage: _onGoToPage,
//               //   title: 'Clients',
//               // ),
//             ],
//           ),
//         ),
//       ),
//       barrierDismissible: false,
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return FadeTransition(
//           opacity: animation,
//           child: child,
//         );
//       },
//     );
//   }
//
//   ///REUSABLE preview panel
//   void showPreviewPanelDialog({
//     required BuildContext context,
//     required String title,
//     required List<Widget> totalsWidgets,
//     required Widget tableWidget,
//     required String uploadStatus,
//     required String parameterMessage,
//     required VoidCallback onUpload,
//   }) {
//     showGeneralDialog(
//       context: navigatorKey.currentContext!,
//       barrierColor: Colors.black54,
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, animation, secondaryAnimation) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         elevation: 3,
//         surfaceTintColor: Colors.white,
//         titlePadding: const EdgeInsets.all(0),
//         title: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: const BoxDecoration(
//             image: DecorationImage(image: AssetImage('/images/mwap_header.png'), fit: BoxFit.cover, opacity: 0.5),
//             color: AppColors.maroon2,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(5.0),
//               topRight: Radius.circular(5.0),
//             ),
//           ),
//           child: Row(
//             children: [
//               Text(title, style: TextStyles.bold18White),
//               const Spacer(),
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Icon(
//                     Icons.cancel_presentation,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         content: Container(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(right: 10, top: 5),
//                 decoration: const BoxDecoration(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.all(Radius.circular(5)),
//                 ),
//                 child: Row(
//                   children: [
//                     const Spacer(),
//                     if (uploadStatus != 'SUCCESS')
//                       MyButton.buttonWithLabel(
//                         context,
//                         onUpload,
//                         'Upload File',
//                         Icons.file_upload,
//                         AppColors.maroon2,
//                       ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Responsive(
//                 mobile: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: totalsWidgets,
//                 ),
//                 tablet: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(children: totalsWidgets),
//                 ),
//                 desktop: const SizedBox.shrink(),
//               ),
//               Expanded(
//                 child: Center(
//                   child: Responsive(
//                     mobile: tableWidget,
//                     desktop: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Column(children: totalsWidgets),
//                         Expanded(child: tableWidget),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//       barrierDismissible: false,
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return FadeTransition(
//           opacity: animation,
//           child: child,
//         );
//       },
//     );
//   }
//
//   ///DISBURSEMENT FUNCTIONS
//   void showDisbursementPreviewDialog(BuildContext context) {
//     showPreviewPanelDialog(
//       context: context,
//       title: 'Preview Loan Disbursement: $selectedFileName',
//       totalsWidgets: [disbursementTotalAmount(), disbursementTotalCustomers()],
//       tableWidget: disbursementTable(),
//       uploadStatus: uploadStatus ?? '',
//       parameterMessage: parameterMessage,
//       onUpload: () {
//         if (parameterMessage == 'Preview with PEP List') {
//           showProceedBatchUploadConfirmAlertDialog(context, closeDialog: () {
//             Navigator.of(context).pop();
//           });
//         } else {
//           showBatchUploadConfirmAlertDialog(context, closeDialog: () {
//             Navigator.of(context).pop();
//           });
//         }
//       },
//     );
//   }
//
//   ///TOP UP FUNCTIONS
//   void showTopUpPreviewDialog(BuildContext context) {
//     showPreviewPanelDialog(
//       context: context,
//       title: 'Preview Agent Top Up: $selectedFileName',
//       totalsWidgets: [topUpTotalAmount(), topUpTotalAgents()],
//       tableWidget: topUpTable(),
//       uploadStatus: uploadStatus ?? '',
//       parameterMessage: parameterMessage,
//       onUpload: () {
//         if (parameterMessage == 'Preview with PEP List') {
//           showProceedBatchUploadConfirmAlertDialog(context, closeDialog: () {
//             Navigator.of(context).pop();
//           });
//         } else {
//           showBatchUploadConfirmAlertDialog(context, closeDialog: () {
//             Navigator.of(context).pop();
//           });
//         }
//       },
//     );
//   }
// }
