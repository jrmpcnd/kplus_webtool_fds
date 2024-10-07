import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/buttons/button.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/container.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/dialog.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/fields/show_list.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/pagination/pagination_button.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/scrollable/scrollable_widget.dart';

import '../../../../core/mfi_whitelist_api/clients/clients_api.dart';
import '../../../../main.dart';
import '../../../shared/clock/clock.dart';
import '../../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../../shared/utils/utils_responsive.dart';
import '../../../shared/values/colors.dart';
import '../../../shared/widget/containers/toast.dart';
import '../../user_management/ui/screen_bases/header/header.dart';
import '../../user_management/ui/screen_bases/header/header_CTA.dart';

typedef VoidCallback = void Function();

class BatchUpload extends StatefulWidget {
  const BatchUpload({Key? key}) : super(key: key);

  @override
  State<BatchUpload> createState() => _BatchUploadState();
}

class _BatchUploadState extends State<BatchUpload> {
  String? uploadStatus = '';
  String FileName = '';
  String TimeStamp = '';
  String FirstName = '';
  String LastName = '';
  int total = 0;
  String selectedFileName = '';
  Blob? selectedFile;
  int duplicatecount = 0;
  List<String> duplicates = [];
  List<String> pepsFound = [];
  String existingCIDs = '';

  //get the specific message to parameterize the UI
  String parameterMessage = '';
  String dataMessage = '';
  Color uploadStatusColor = Colors.transparent;

  TextEditingController rowPerPageController = TextEditingController();
  List<Map<String, dynamic>> apiData = [];
  List<String> pepListData = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isLoading = true; // Add this variable to track loading state
  bool hasPepList = false;
  int totalRecords = 0;
  int totalPages = 1;
  String _selectedItem = '10';

  @override
  void initState() {
    super.initState();
    updateUrl('/Access/Batch_Upload/Batch_Insert');
  }

  ///OPEN PREVIEW
  void openFileUploadDialog() {
    InputElement input = (FileUploadInputElement()..accept = 'xlsm') as InputElement;
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        setState(() {
          selectedFile = file;
          selectedFileName = file.name;
        });

        // Call the API here
        previewFile(file);
      }
    });
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'UPLOADING' || 'PREVIEWED':
        return Colors.amber.shade600;
      case 'SUCCESS':
        return Colors.green.shade600; // Green color for Approved status
      case 'FAILED':
        return Colors.red.shade600; // Red color for Disapproved status
      case 'WATCHLIST':
        return Colors.orangeAccent; // Red color for Disapproved status
      default:
        return Colors.transparent; // Default color (you can change this as per your design)
    }
  }

  void changePagePreviewFile(Blob? file, int page) async {
    debugPrint('Before Request URL Change Preview $page');
    setState(() {
      isLoading = true;
    });

    // Show loading dialog
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => const Center(
          child: CircularProgressIndicator(
        color: AppColors.maroon2,
      )),
    );

    final reader = FileReader();
    reader.onLoad.listen((event) async {
      final List<int> bytes = reader.result as List<int>;
      final url = Uri.parse('${UrlGetter.getURL()}/clients/test/preview?page=$page&perPage=$_selectedItem');
      debugPrint('Request URL batch upload $url');

      try {
        final request = http.MultipartRequest('POST', url)
          ..headers['Authorization'] = 'Bearer ${getToken()}'
          ..headers['Content-type'] = 'application/json'
          ..files.add(http.MultipartFile.fromBytes('file', bytes, filename: selectedFileName));

        final response = await request.send();
        final responseStream = await response.stream.toBytes();
        final responseData = utf8.decode(responseStream);

        final jsonData = json.decode(responseData);
        final dataList = jsonData['data'] as List<dynamic>? ?? [];
        final List<Map<String, dynamic>> data = dataList.map((e) {
          if (e is Map<String, dynamic>) {
            return e;
          } else {
            return <String, dynamic>{}; // Handle unexpected item type
          }
        }).toList();

        setState(() {
          apiData = data;
          totalRecords = jsonData['totalRecords'];
          totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
          isLoading = false;
          // print('apidata: $apiData');
        });
        Navigator.pop(context);
        Navigator.pop(context);
        showPreviewDialog(context);
      } catch (e) {
        debugPrint('Error fetching page: $e');
        setState(() {
          isLoading = false;
        });
      }
    });

    reader.readAsArrayBuffer(selectedFile!);
  }

  Future<void> previewFile(Blob? file) async {
    if (file == null) {
      setState(() {
        uploadStatus = 'No file selected';
      });
      return;
    }

    // Show loading dialog
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
              Text('Data rendering...'),
            ],
          ),
        ),
      ),
    );

    final reader = FileReader();

    reader.onLoad.listen((event) async {
      final List<int> bytes = reader.result as List<int>;
      final url = Uri.parse('${UrlGetter.getURL()}/clients/test/preview?page=${currentPage + 1}&perPage=$_selectedItem');
      debugPrint('First Preview Request URL $url');

      try {
        final request = http.MultipartRequest(
          'POST',
          url,
        );

        final token = getToken();
        request.headers['Authorization'] = 'Bearer $token';
        request.headers['Content-type'] = 'application/json';
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: selectedFileName,
          ),
        );

        final response = await request.send();
        final responseStream = await response.stream.toBytes();

        final responseData = utf8.decode(responseStream);
        final jsonData = json.decode(responseData);

        setState(() {
          parameterMessage = jsonData['message'] ?? 'Unknown error occurred';
          hasPepList = jsonData['pepList'] != null && (jsonData['pepList'] as List<dynamic>).isNotEmpty;
        });

        if (response.statusCode == 200) {
          final dataList = jsonData['data'] as List<dynamic>? ?? [];

          // Check if dataList is of type List<Map<String, dynamic>> if needed
          final List<Map<String, dynamic>> data = dataList.map((e) {
            if (e is Map<String, dynamic>) {
              return e;
            } else {
              // Handle unexpected item type or log an error
              return <String, dynamic>{}; // Return an empty map or handle accordingly
            }
          }).toList();

          if (parameterMessage == 'Preview with PEP List') {
            setState(() {
              uploadStatus = 'WATCHLIST';
              uploadStatusColor = _getStatusColor('WATCHLIST');
              apiData = data;
              totalRecords = jsonData['totalRecords'];
              totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
              parameterMessage = jsonData['message'];
              duplicatecount = countPepList(jsonData);
              FileName = selectedFileName;
              pepsFound = hasPepList ? (jsonData['pepList'] as List<dynamic>).map((item) => item as String).toList() : [];
              isLoading = false;
            });
          } else {
            setState(() {
              uploadStatus = 'PREVIEWED';
              uploadStatusColor = _getStatusColor('PREVIEWED');
              apiData = data;
              totalRecords = jsonData['totalRecords'];
              totalPages = jsonData['totalPages'];
              parameterMessage = jsonData['message'];
              duplicatecount = countPepList(jsonData);
              FileName = selectedFileName;
              pepsFound = hasPepList ? (jsonData['pepList'] as List<dynamic>).map((item) => item as String).toList() : [];
              isLoading = false;
            });
          }

          Navigator.pop(context);
          Future.delayed(const Duration(seconds: 2));
          showPreviewDialog(context);
        } else {
          showUploadFileAlertDialog(
            isSuccess: false,
            titleMessage: 'Failed to Upload',
            contentMessage: 'Sorry, we are unable to process your request. See remarks for info.',
          );

          setState(() {
            uploadStatus = 'FAILED';
            uploadStatusColor = _getStatusColor('FAILED');
            isLoading = false;
          });
        }
      } catch (e) {
        debugPrint('Error here: $e');
        setState(() {
          uploadStatus = 'FAILED';
          uploadStatusColor = _getStatusColor('FAILED');
          isLoading = false;
        });
      }
    });

    reader.readAsArrayBuffer(file);
  }

  int countPepList(Map<String, dynamic> jsonData) {
    // Check if 'pepList' exists and is a List
    if (jsonData.containsKey('pepList') && jsonData['pepList'] is List) {
      // Cast the list and return its length
      List<dynamic> pepList = jsonData['pepList'];
      return pepList.length;
    } else {
      // If 'pepList' doesn't exist or isn't a list, return 0
      return 0;
    }
  }

  ///ORIGINAL VALUE
  void uploadFile(Blob? file) async {
    if (file == null) {
      setState(() {
        uploadStatus = 'No file selected';
      });
      return;
    }

    setState(() {
      uploadStatus = 'UPLOADING';
      isLoading = true;
    });

    // Show loading dialog
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
              Text('Uploading in progress...'),
            ],
          ),
        ),
      ),
    );

    final reader = FileReader();

    reader.onLoad.listen((event) async {
      final List<int> bytes = reader.result as List<int>;

      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('${UrlGetter.getURL()}/clients/test/batch/upload'),
        );

        final token = getToken();
        request.headers['Authorization'] = 'Bearer $token';
        request.headers['Content-type'] = 'application/json';
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: selectedFileName,
          ),
        );

        final response = await request.send();
        final responseStream = await response.stream.toBytes();

        final responseData = utf8.decode(responseStream);
        final jsonData = json.decode(responseData);
        final responseMessage = jsonData['message'] ?? 'Unknown error occurred';
        final responseDataMap = jsonData['data'] ?? {};

        Navigator.pop(context); // Close the loading dialog

        setState(() {
          parameterMessage = responseMessage;
          dataMessage = responseDataMap.toString(); // Example: Convert responseDataMap to String
        });

        // print('Response Body: ${String.fromCharCodes(responseStream)}');
        if (response.statusCode == 200) {
          if (jsonData['message'] == 'File Uploaded Successfully') {
            showUploadFileAlertDialog(
              isSuccess: true,
              titleMessage: 'File Uploaded Successfully',
              contentMessage: 'You uploaded a file successfully.',
            );
            setState(() {
              uploadStatus = 'SUCCESS';
              uploadStatusColor = _getStatusColor(uploadStatus);
              FileName = responseDataMap['FileName'] ?? '';
              FirstName = responseDataMap['FirstName'] ?? '';
              LastName = responseDataMap['LastName'] ?? '';
              TimeStamp = responseDataMap['Timestamp'] ?? '';
              total = responseDataMap['TotalRecords'] ?? 0;
              duplicatecount = responseDataMap['DuplicateCount'] ?? 0;
            });
          } else if (jsonData['message'] == 'File size exceeds the 24 MB limit' && jsonData['retCode'] == '400') {
            showUploadFileAlertDialog(
              isSuccess: false,
              titleMessage: 'Failed to Upload',
              contentMessage: parameterMessage,
            );

            setState(() {
              uploadStatus = 'FAILED';
              uploadStatusColor = _getStatusColor('FAILED');
            });
          } else if (responseMessage == 'CSV file exceeds the maximum row limit of 1000' && jsonData['retCode'] == '400') {
            showUploadFileAlertDialog(
              isSuccess: false,
              titleMessage: 'Failed to Upload',
              contentMessage: parameterMessage,
            );

            setState(() {
              uploadStatus = 'FAILED';
              uploadStatusColor = _getStatusColor('FAILED');
            });
          } else if (responseMessage == 'Error opening uploaded file' && jsonData['retCode'] == '500') {
            showUploadFileAlertDialog(
              isSuccess: false,
              titleMessage: 'Failed to Upload',
              contentMessage: parameterMessage,
            );

            setState(() {
              uploadStatus = 'FAILED';
              uploadStatusColor = _getStatusColor('FAILED');
            });
          } else if (responseMessage == 'File name already exists and already checked by checker' && jsonData['retCode'] == '500') {
            showUploadFileAlertDialog(
              isSuccess: false,
              titleMessage: 'Failed to Upload',
              contentMessage: parameterMessage,
            );

            setState(() {
              uploadStatus = 'FAILED';
              uploadStatusColor = _getStatusColor('FAILED');
            });
          } else if (jsonData['data'] == 'Error in bulk inserting' && jsonData['retCode'] == '500') {
            showUploadFileAlertDialog(
              isSuccess: false,
              titleMessage: responseDataMap.toString(),
              contentMessage: jsonData['data'],
            );

            setState(() {
              uploadStatus = 'FAILED';
              uploadStatusColor = _getStatusColor('FAILED');
            });
          } else {
            showUploadFileAlertDialog(
              isSuccess: false,
              titleMessage: 'Failed to Upload',
              contentMessage: responseMessage,
            );

            // Ensure the data is correctly cast and assigned
            final List<dynamic> rawDuplicates = responseDataMap['DuplicateNewCIDs'] ?? [];
            final List<String> duplicateNewCIDs = rawDuplicates.map((e) => e.toString()).toList();

            setState(() {
              uploadStatus = 'FAILED';
              uploadStatusColor = _getStatusColor('FAILED');
              FileName = responseDataMap['FileName'] ?? '';
              FirstName = responseDataMap['FirstName'] ?? '';
              LastName = responseDataMap['LastName'] ?? '';
              TimeStamp = responseDataMap['Timestamp'] ?? '';
              total = responseDataMap['TotalRecords'] ?? 0;
              duplicatecount = responseDataMap['DuplicateCount'] ?? 0;
              duplicates = duplicateNewCIDs; // Assign the correctly cast list here
            });
          }
        } else if (responseMessage == 'PEP List Found' && jsonData['retCode'] == '200' && response.statusCode == 400) {
          showUploadFileAlertDialog(
            isSuccess: false,
            titleMessage: 'Failed to Upload',
            contentMessage: 'Sorry, we are unable to process your request. See remarks for info.',
          );

          // Ensure the data is correctly cast and assigned
          final List<dynamic> rawDuplicates = responseDataMap['DuplicateNewCIDs'] ?? [];
          final List<String> duplicateNewCIDs = rawDuplicates.map((e) => e.toString()).toList();

          setState(() {
            uploadStatus = 'WATCHLIST';
            uploadStatusColor = _getStatusColor('WATCHLIST');
            FileName = responseDataMap['FileName'] ?? '';
            FirstName = responseDataMap['FirstName'] ?? '';
            LastName = responseDataMap['LastName'] ?? '';
            TimeStamp = responseDataMap['Timestamp'] ?? '';
            total = responseDataMap['TotalRecords'] ?? 0;
            duplicatecount = responseDataMap['DuplicateCount'] ?? 0;
            pepsFound = duplicateNewCIDs; // Assign the correctly cast list here
          });
        } else if (responseMessage == 'Existing CIDs' && jsonData['retCode'] == '200' && response.statusCode == 400) {
          showUploadFileAlertDialog(
            isSuccess: false,
            titleMessage: 'Failed to Upload',
            contentMessage: responseMessage,
          );

          setState(() {
            uploadStatus = 'FAILED';
            uploadStatusColor = _getStatusColor('FAILED');
            FileName = responseDataMap['FileName'] ?? '';
            FirstName = responseDataMap['FirstName'] ?? '';
            LastName = responseDataMap['LastName'] ?? '';
            TimeStamp = responseDataMap['Timestamp'] ?? '';
            total = responseDataMap['TotalRecords'] ?? 0;
            duplicatecount = int.parse(responseDataMap['DuplicateCount'].toString());
            existingCIDs = responseDataMap['DuplicateNewCIDs'].toString(); // Assign the correctly cast string here
          });
        } else {
          showUploadFileAlertDialog(
            isSuccess: false,
            titleMessage: 'Failed to Upload',
            contentMessage: 'Sorry, we are unable to process your request. See remarks for info.',
          );

          // Ensure the data is correctly cast and assigned
          final List<dynamic> rawDuplicates = responseDataMap['DuplicateNewCIDs'] ?? [];
          final List<String> duplicateNewCIDs = rawDuplicates.map((e) => e.toString()).toList();

          setState(() {
            uploadStatus = 'FAILED';
            uploadStatusColor = _getStatusColor('FAILED');
            FileName = responseDataMap['FileName'] ?? '';
            FirstName = responseDataMap['FirstName'] ?? '';
            LastName = responseDataMap['LastName'] ?? '';
            TimeStamp = responseDataMap['Timestamp'] ?? '';
            total = responseDataMap['TotalRecords'] ?? 0;
            duplicatecount = responseDataMap['DuplicateCount'] ?? 0;
            duplicates = duplicateNewCIDs; // Assign the correctly cast list here
          });
        }
      } catch (e) {
        debugPrint('Error uploading: $e');
        setState(() {
          uploadStatus = 'FAILED';
          uploadStatusColor = _getStatusColor('FAILED');
          isLoading = false;
        });
      }
    });

    reader.readAsArrayBuffer(file);
  }

  void _downloadFile() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 350,
          height: 100,
          decoration: const BoxDecoration(color: AppColors.dialogColor, borderRadius: BorderRadius.all(Radius.circular(5))),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [SpinKitFadingCircle(color: AppColors.maroon2), SizedBox(width: 10), Text('Downloading in progress...')],
          ),
        ),
      ),
    );

    final response = await DownloadAPI.downloadFile();

    Navigator.pop(context);
    if (response.statusCode == 200) {
      showUploadFileAlertDialog(isSuccess: true, titleMessage: 'File Downloaded Successfully', contentMessage: 'You have successfully downloaded the file template');
    } else {
      showUploadFileAlertDialog(isSuccess: false, titleMessage: 'Failed to Download', contentMessage: 'File not downloaded.');
    }
  }

  void proceedUploadFile(Blob? file) async {
    if (file == null) {
      setState(() {
        // print('No file selected');
        uploadStatus = 'No file selected';
      });
      return;
    }

    setState(() {
      uploadStatus = 'UPLOADING';
      isLoading = true;
    });

    // Show loading dialog
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
              Text('Uploading in progress...'),
            ],
          ),
        ),
      ),
    );

    final reader = FileReader();

    reader.onLoad.listen((event) async {
      final List<int> bytes = reader.result as List<int>;

      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('${UrlGetter.getURL()}/clients/test/batch/upload/proceed'),
        );

        final token = getToken();
        request.headers['Authorization'] = 'Bearer $token';
        request.headers['Content-type'] = 'application/json';
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: selectedFileName,
          ),
        );

        final response = await request.send();
        final responseStream = await response.stream.toBytes();

        final responseData = utf8.decode(responseStream);
        final jsonData = json.decode(responseData);
        final responseMessage = jsonData['message'] ?? 'Unknown error occurred';
        final responseDataMap = jsonData['data'] ?? {};

        Navigator.pop(context); // Close the loading dialog

        setState(() {
          parameterMessage = responseMessage;
          dataMessage = responseDataMap.toString(); // Example: Convert responseDataMap to String
        });

        // print('Response Body: ${String.fromCharCodes(responseStream)}');
        if (response.statusCode == 200) {
          if (jsonData['message'] == 'File Uploaded Successfully') {
            showUploadFileAlertDialog(
              isSuccess: true,
              titleMessage: 'File Uploaded Successfully',
              contentMessage: 'You uploaded a file successfully.',
            );
            setState(() {
              uploadStatus = 'SUCCESS';
              uploadStatusColor = _getStatusColor(uploadStatus);
              FileName = responseDataMap['FileName'] ?? '';
              FirstName = responseDataMap['FirstName'] ?? '';
              LastName = responseDataMap['LastName'] ?? '';
              TimeStamp = responseDataMap['Timestamp'] ?? '';
              total = responseDataMap['TotalRecords'] ?? 0;
              duplicatecount = responseDataMap['DuplicateCount'] ?? 0;
            });
          } else if (jsonData['message'] == 'File size exceeds the 24 MB limit' && jsonData['retCode'] == '400') {
            showUploadFileAlertDialog(
              isSuccess: false,
              titleMessage: 'Failed to Upload',
              contentMessage: responseMessage,
            );

            setState(() {
              uploadStatus = 'FAILED';
              uploadStatusColor = _getStatusColor('FAILED');
            });
          } else if (responseMessage == 'CSV file exceeds the maximum row limit of 1000' && jsonData['retCode'] == '400') {
            showUploadFileAlertDialog(
              isSuccess: false,
              titleMessage: 'Failed to Upload',
              contentMessage: responseMessage,
            );

            setState(() {
              uploadStatus = 'FAILED';
              uploadStatusColor = _getStatusColor('FAILED');
            });
          } else if (responseMessage == 'Error opening uploaded file' && jsonData['retCode'] == '500') {
            showUploadFileAlertDialog(
              isSuccess: false,
              titleMessage: 'Failed to Upload',
              contentMessage: responseMessage,
            );

            setState(() {
              uploadStatus = 'FAILED';
              uploadStatusColor = _getStatusColor('FAILED');
            });
          } else if (responseMessage == 'File name already exists and already checked by checker' && jsonData['retCode'] == '500') {
            showUploadFileAlertDialog(
              isSuccess: false,
              titleMessage: 'Failed to Upload',
              contentMessage: responseMessage,
            );

            setState(() {
              uploadStatus = 'FAILED';
              uploadStatusColor = _getStatusColor('FAILED');
            });
          } else if (jsonData['data'] == 'Error in bulk inserting' && jsonData['retCode'] == '500') {
            showUploadFileAlertDialog(
              isSuccess: false,
              titleMessage: responseDataMap.toString(),
              contentMessage: jsonData['data'],
            );

            setState(() {
              uploadStatus = 'FAILED';
              uploadStatusColor = _getStatusColor('FAILED');
            });
          } else {
            showUploadFileAlertDialog(
              isSuccess: false,
              titleMessage: 'Failed to Upload',
              contentMessage: responseMessage,
            );

            // Ensure the data is correctly cast and assigned
            final List<dynamic> rawDuplicates = responseDataMap['DuplicateNewCIDs'] ?? [];
            final List<String> duplicateNewCIDs = rawDuplicates.map((e) => e.toString()).toList();

            setState(() {
              uploadStatus = 'FAILED';
              uploadStatusColor = _getStatusColor('FAILED');
              FileName = responseDataMap['FileName'] ?? '';
              FirstName = responseDataMap['FirstName'] ?? '';
              LastName = responseDataMap['LastName'] ?? '';
              TimeStamp = responseDataMap['Timestamp'] ?? '';
              total = responseDataMap['TotalRecords'] ?? 0;
              duplicatecount = responseDataMap['DuplicateCount'] ?? 0;
              duplicates = duplicateNewCIDs; // Assign the correctly cast list here
            });
          }
        } else if (responseMessage == 'Existing CIDs' && jsonData['retCode'] == '200' && response.statusCode == 400) {
          showUploadFileAlertDialog(
            isSuccess: false,
            titleMessage: 'Failed to Upload',
            contentMessage: responseMessage,
          );

          setState(() {
            uploadStatus = 'FAILED';
            uploadStatusColor = _getStatusColor('FAILED');
            FileName = responseDataMap['FileName'] ?? '';
            FirstName = responseDataMap['FirstName'] ?? '';
            LastName = responseDataMap['LastName'] ?? '';
            TimeStamp = responseDataMap['Timestamp'] ?? '';
            total = responseDataMap['TotalRecords'] ?? 0;
            duplicatecount = int.parse(responseDataMap['DuplicateCount'].toString());
            existingCIDs = responseDataMap['DuplicateNewCIDs'].toString(); // Assign the correctly cast string here
          });
        } else if (responseMessage == 'PEP List Found' && jsonData['retCode'] == '200' && response.statusCode == 400) {
          showUploadFileAlertDialog(
            isSuccess: false,
            titleMessage: 'Failed to Upload',
            contentMessage: 'Sorry, we are unable to process your request. See remarks for info.',
          );

          // Ensure the data is correctly cast and assigned
          final List<dynamic> rawDuplicates = responseDataMap['DuplicateNewCIDs'] ?? [];
          final List<String> duplicateNewCIDs = rawDuplicates.map((e) => e.toString()).toList();

          setState(() {
            uploadStatus = 'FAILED';
            uploadStatusColor = _getStatusColor('FAILED');
            FileName = responseDataMap['FileName'] ?? '';
            FirstName = responseDataMap['FirstName'] ?? '';
            LastName = responseDataMap['LastName'] ?? '';
            TimeStamp = responseDataMap['Timestamp'] ?? '';
            total = responseDataMap['TotalRecords'] ?? 0;
            duplicatecount = responseDataMap['DuplicateCount'] ?? 0;
            pepsFound = duplicateNewCIDs; // Assign the correctly cast list here
          });
        } else {
          showUploadFileAlertDialog(
            isSuccess: false,
            titleMessage: 'Failed to Upload',
            contentMessage: 'Sorry, we are unable to process your request. See remarks for info.',
          );

          // Ensure the data is correctly cast and assigned
          final List<dynamic> rawDuplicates = responseDataMap['DuplicateNewCIDs'] ?? [];
          final List<String> duplicateNewCIDs = rawDuplicates.map((e) => e.toString()).toList();

          setState(() {
            uploadStatus = 'FAILED';
            uploadStatusColor = _getStatusColor('FAILED');
            FileName = responseDataMap['FileName'] ?? '';
            FirstName = responseDataMap['FirstName'] ?? '';
            LastName = responseDataMap['LastName'] ?? '';
            TimeStamp = responseDataMap['Timestamp'] ?? '';
            total = responseDataMap['TotalRecords'] ?? 0;
            duplicatecount = responseDataMap['DuplicateCount'] ?? 0;
            duplicates = duplicateNewCIDs; // Assign the correctly cast list here
          });
        }
      } catch (e) {
        debugPrint('Error here: $e');
        setState(() {
          uploadStatus = 'FAILED';
          uploadStatusColor = _getStatusColor('FAILED');
          isLoading = false;
        });
      }
    });

    reader.readAsArrayBuffer(file);
  }

  void cancelUpload() {
    setState(() {
      selectedFileName = '';
      FirstName = '';
      LastName = '';
      TimeStamp = '';
      duplicatecount = 0;
      total = 0;
      duplicates = [];
      existingCIDs = '';
      parameterMessage = '';
      uploadStatus = '';
      uploadStatusColor = Colors.transparent;
      dataMessage = '';
    });
  }

  void showPreviewDialog(BuildContext context) {
    showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => AlertDialog(
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
              Text('Preview Selected File: $selectedFileName', style: TextStyles.bold18White),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //rows&clock
                    ShowListWidget(rowsPerPageController: rowPerPageController, rowsPerPage: _selectedItem, onPageSizeChange: onPageSizeChange),
                    const Spacer(),
                    if (uploadStatus != 'SUCCESS')
                      MyButton.buttonWithLabel(
                        context,
                        () => parameterMessage == 'Preview with PEP List'
                            ? showProceedBatchUploadConfirmAlertDialog(context, closeDialog: () {
                                Navigator.of(context).pop();
                              })
                            : showBatchUploadConfirmAlertDialog(context, closeDialog: () {
                                Navigator.of(context).pop();
                              }),
                        'Upload File',
                        Icons.file_upload,
                        AppColors.maroon2,
                      ),
                  ],
                ),
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
                              ? const Center(child: NoRecordsFound())
                              : ScrollBarWidget(
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
                                      rows: getPaginatedRows(),
                                    ),
                                  ),
                                )
                      // : const NoClientsFound()),
                      )),
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
              //   currentPage: (totalRecords == 0) ? 0 : (currentPage + 1),
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
      ),
      barrierDismissible: false,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // ========Create templated data cell for PAGINATED ROWS=============//
  List<DataRow> getPaginatedRows() {
    const textStyle = TextStyles.dataTextStyle;

    DataCell buildDataCell(String? text, {bool isWatchlisted = false}) {
      return DataCell(
        Center(
          child: isWatchlisted
              ? Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: 150,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.highlightDash.withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.highlightDash.withOpacity(0.4),
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
                      text?.toUpperCase() ?? '',
                      style: const TextStyle(
                        color: AppColors.highlightDash, // Text color to match the background
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
      final isPep = rowData['is_pep'] == true;

      final cells = <DataCell>[
        buildDataCell(rowData['Cid']),
        buildDataCell(rowData['FirstName']),
        buildDataCell(rowData['MiddleName']),
        buildDataCell(rowData['LastName']),
        buildDataCell(rowData['SpouseMaidenFName']),
        buildDataCell(rowData['SpouseMaidenMName']),
        buildDataCell(rowData['SpouseMaidenLName']),
        buildDataCell(rowData['MobileNumber']),
        buildDataCell(rowData['Birthday']),
        buildDataCell(rowData['PlaceOfBirth']),
        buildDataCell(rowData['Religion']),
        buildDataCell(rowData['Gender']),
        buildDataCell(rowData['CivilStatus']),
        buildDataCell(rowData['Citizenship']),
        buildDataCell(rowData['PresentAddress']),
        buildDataCell(rowData['PermanentAddress']),
        buildDataCell(rowData['PresentCity']),
        buildDataCell(rowData['PresentProvince']),
        buildDataCell(rowData['PresentPostalCode']),
        buildDataCell(rowData['ClientMaidenFName']),
        buildDataCell(rowData['ClientMaidenMName']),
        buildDataCell(rowData['ClientMaidenLName']),
        buildDataCell(rowData['Email']),
        buildDataCell(rowData['InstitutionName']),
        buildDataCell(rowData['UnitName']),
        buildDataCell(rowData['CenterName']),
        buildDataCell(rowData['BranchName']),
        buildDataCell(rowData['ClientClassification']),
        buildDataCell(rowData['SourceOfFund']),
        buildDataCell(rowData['EmployerOrBusinessName']),
        buildDataCell(rowData['EmployerOrBusinessAddress']),
      ];

      if (hasPepList) {
        cells.insert(0, buildDataCell(isPep ? 'Watchlist' : '', isWatchlisted: isPep));
      }

      return DataRow(
        color: MaterialStateProperty.all<Color>(color),
        cells: cells,
      );
    });
  }

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

    final columns = <DataColumn>[
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
    ];

    if (hasPepList) {
      columns.insert(0, buildDataColumn('Watchlist'));
    }

    return columns;
  }

  void onPageSizeChange(int newPageSize) {
    setState(() {
      _selectedItem = newPageSize.toString();
      currentPage = 0; // Reset to first page
    });
    changePagePreviewFile(selectedFile, currentPage); // Refetch the file with new page size
  }

  void nextPage() {
    if (currentPage < totalPages - 1) {
      setState(() {
        currentPage += 1;
      });
      changePagePreviewFile(selectedFile, currentPage);
      // previewFile(selectedFile); // Fetch data for the next page
      debugPrint('next page $currentPage');
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage -= 1;
      });
      changePagePreviewFile(selectedFile, currentPage);
      // previewFile(selectedFile); // Fetch data for the previous page

      debugPrint('previous page $currentPage');
    }
  }

  // Function to handle go-to-page input
  void _onGoToPage(String value) {
    final int? page = int.tryParse(value);
    if (page != null && page > 0 && page <= totalPages) {
      setState(() {
        currentPage = page;
      });
      changePagePreviewFile(selectedFile, currentPage);
    }
  }

  void _onPageSelected(int page) {
    print('Page passed : $page');
    setState(() {
      currentPage = page;
      print('Current page selected : $currentPage');
      changePagePreviewFile(selectedFile, currentPage);
    });
  }

  void showConfirmDialog() {
    if (parameterMessage == 'Preview with PEP List') {
      showProceedBatchUploadConfirmAlertDialog(context);
    } else {
      showBatchUploadConfirmAlertDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool areButtonsEnabled = selectedFileName.isNotEmpty && (selectedFileName.endsWith('.xlsm'));

    return Container(
      padding: const EdgeInsets.only(left: 90),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const HeaderBar(screenText: 'BATCH UPLOADING'),
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
                    children: [imageBatchUpload(), bodyBatchUpload(areButtonsEnabled)],
                  ),
                  mobile: Column(
                    children: [
                      bodyBatchUpload(areButtonsEnabled),
                    ],
                  ),
                  tablet: Column(
                    children: [
                      bodyBatchUpload(areButtonsEnabled),
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

  Widget bodyBatchUpload(bool areButtonsEnabled) {
    double fontSize = (MediaQuery.sizeOf(context).width / 30);
    return Expanded(
      flex: 6,
      child: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WHITELIST',
                  style: TextStyle(color: AppColors.maroon2, fontSize: fontSize.clamp(25, 40), fontWeight: FontWeight.bold),
                ),
                const Text(
                  'MANAGEMENT SYSTEM',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.add_circle_outline_outlined,
                      color: AppColors.maroon2,
                      size: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'BATCH INSERT/UPDATE',
                      style: TextStyle(
                        color: AppColors.maroon2,
                        fontSize: 10,
                        // fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),

            /// CHOOSE FILE, UPLOAD BUTTON, AND DOWNLOAD BUTTON
            Wrap(
              // alignment: WrapAlignment.spaceBetween,
              runSpacing: 10,
              spacing: 20,
              children: [
                Container(
                  height: 35,
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4),
                  child: chooseFileAndUploadButton(areButtonsEnabled),
                ),
                downloadFileButton(),
                if (selectedFileName.isNotEmpty || (uploadStatus != '' && uploadStatus != 'SUCCESS')) previewFileButton()
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: const Text(
                'BATCH UPLOADING SUMMARY',
                style: TextStyle(
                  color: AppColors.maroon2,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            /// RESULT FIELDS
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Container(
                          // color: Colors.teal,
                          width: 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('File name'),
                              const SizedBox(height: 5),
                              _buildReadOnlyTextField(selectedFileName),
                              const SizedBox(height: 5),
                              _buildLabel('Uploader'),
                              const SizedBox(height: 5),
                              _buildReadOnlyTextField('$FirstName $LastName'),
                              const SizedBox(height: 5),
                              _buildLabel('Date and Time:'),
                              const SizedBox(height: 5),
                              _buildReadOnlyTextField(TimeStamp),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                        Container(
                          // color: Colors.deepPurpleAccent,
                          width: 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Upload Status'),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.all(1.5),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: AppColors.sidePanel1),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white10,
                                ),
                                child: uploadStatus != null
                                    ? Container(
                                        width: 150,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          color: uploadStatusColor.withOpacity(0.2),
                                        ),
                                        child: Center(
                                          child: Text(
                                            (uploadStatus?.toUpperCase() ?? ''), // Ensure text is uppercase
                                            style: TextStyle(
                                              color: uploadStatusColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ),
                              const SizedBox(height: 5),
                              _buildLabel(getLabelForDuplicateCount(parameterMessage)),
                              const SizedBox(height: 5),
                              _buildReadOnlyTextField('$duplicatecount'),
                              const SizedBox(height: 5),
                              _buildLabel('No. of Clients Uploaded'),
                              const SizedBox(height: 5),
                              _buildReadOnlyTextField('$total'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    _buildLabel(getLabelForDuplicateCID(parameterMessage)),
                    const SizedBox(height: 5),
                    Container(
                      // color: Colors.pink,
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: decideTextFieldWidget(
                          parameterMessage,
                          parameterMessage == 'Existing CIDs'
                              ? existingCIDs
                              : parameterMessage == 'Duplicate CIDs'
                                  ? duplicates
                                  // : parameterMessage == 'PEP List Found'
                                  : parameterMessage == 'Preview with PEP List'
                                      ? pepsFound
                                      : parameterMessage == 'Preview without PEP List'
                                          ? 'No clients were detected as being on the watchlist.'
                                          : parameterMessage == 'Existing Data Found'
                                              ? duplicates
                                              : parameterMessage),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chooseFileAndUploadButton(bool areButtonsEnabled) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: TextField(
            style: const TextStyle(
              fontSize: 12,
            ),
            onTap: () {
              openFileUploadDialog();
            },
            textAlignVertical: TextAlignVertical.center,
            cursorColor: AppColors.maroon2,
            cursorWidth: 1,
            cursorRadius: const Radius.circular(5),
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              // labelText: 'New CID',
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              filled: true,
              fillColor: Colors.white10,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.sidePanel1,
                ),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
              ),
              prefixIcon: const Icon(
                Icons.folder_open,
                color: AppColors.sidePanel1,
                size: 17,
              ),
              hintText: selectedFileName.isEmpty ? 'Select file...' : selectedFileName,
              hintStyle: const TextStyle(fontSize: 12, color: Colors.black54),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFileName = '';
                    FirstName = '';
                    LastName = '';
                    TimeStamp = '';
                    duplicatecount = 0;
                    total = 0;
                    duplicates = [];
                    existingCIDs = '';
                    parameterMessage = '';
                    uploadStatus = '';
                    uploadStatusColor = Colors.transparent;
                    dataMessage = '';
                  });
                },
                child: const Icon(
                  Icons.clear,
                  color: AppColors.sidePanel1,
                  size: 17,
                ),
              ),
            ),
            readOnly: true,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            areButtonsEnabled
                ? uploadStatus != 'SUCCESS'
                    ? showConfirmDialog()
                    : CustomToast.show(context, 'File was already uploaded.')
                : CustomToast.show(context, 'Please select a file first.');
          },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
            side: const BorderSide(color: AppColors.maroon2, width: 0.5),
            backgroundColor: (areButtonsEnabled
                ? uploadStatus != 'SUCCESS'
                    ? AppColors.maroon2
                    : Colors.grey
                : Colors.grey),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.drive_folder_upload_sharp,
                  size: 17,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Upload File',
                  style: TextStyle(color: Colors.white, fontSize: (MediaQuery.sizeOf(context).width / 40).clamp(9, 12)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget downloadFileButton() {
    return SizedBox(
      height: 35,
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          showDownloadTemplateConfirmAlertDialog(context);
        },
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          backgroundColor: (AppColors.maroon2),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.file_download,
                size: 17,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Download Template',
                maxLines: 2,
                style: TextStyle(color: Colors.white, fontSize: (MediaQuery.sizeOf(context).width / 40).clamp(9, 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget previewFileButton() {
    return SizedBox(
      height: 35,
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          showPreviewDialog(context);
        },
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          backgroundColor: (AppColors.maroon2),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.remove_red_eye,
                size: 17,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Preview File',
                maxLines: 2,
                style: TextStyle(color: Colors.white, fontSize: (MediaQuery.sizeOf(context).width / 40).clamp(9, 12)),
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
              colors: [AppColors.maroon1.withOpacity(0.9), AppColors.maroon2, AppColors.maroon3, AppColors.maroon4], // Gradient colors
              begin: Alignment.topCenter, // Alignment for the start of the gradient
              end: Alignment.bottomCenter, // Alignment for the end of the gradient
            ),
            // color:  const Color(0xff941c1b),
            borderRadius: const BorderRadius.all(Radius.zero),
            image: const DecorationImage(
              image: AssetImage('/images/kplus_webtool.png'),
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

  Widget _buildReadOnlyTextField(String hintText, {double width = double.infinity}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: AppColors.sidePanel1),
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white10,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Text(
          hintText,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildPEPTextField(String hintText, {double width = double.infinity}) {
    return Container(
        width: width,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: AppColors.sidePanel1),
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white10,
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: uploadStatusColor.withOpacity(0.2),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(
              hintText,
              style: const TextStyle(
                fontSize: 12,
                // color: uploadStatusColor,
              ),
            ),
          ),
        ));
  }

  Widget decideTextFieldWidget(String responseMessage, dynamic data) {
    // } else if (responseMessage == 'PEP List Found' && data is List<String>) {
    if (responseMessage == 'Preview with PEP List' && data is List<String>) {
      return _buildPEPTextField(data.join('\n'));
    } else if (responseMessage == 'Existing Data Found' && data is List<String>) {
      return _buildReadOnlyTextField(data.join(', \n'));
    } else if (responseMessage == 'Existing CIDs' && data is String) {
      return _buildReadOnlyTextField(data);
    } else if (responseMessage != 'Existing CIDs' && data is List<String>) {
      return _buildReadOnlyTextField(data.join(', ')); // Join list into a comma-separated string
    } else {
      return _buildReadOnlyTextField(data);
    }
  }

  String getLabelForDuplicateCount(String message) {
    // } else if (message == 'PEP List Found') {
    if (message == 'Preview with PEP List') {
      return 'PEPs Count';
    } else if (message == 'Existing CIDs') {
      return 'Existing CID Count';
    } else if (message == 'Duplicate CIDs') {
      return 'Duplicate CID Count';
    } else {
      return 'Count';
    }
  }

  String getLabelForDuplicateCID(String message) {
    // } else if (message == 'PEP List Found') {
    if (message == 'Preview with PEP List') {
      return 'Watchlist';
    } else if (message == 'Existing CIDs') {
      return 'Existing CIDs';
    } else if (message == 'Duplicate CIDs') {
      return 'Duplicate CIDs';
    } else {
      return 'Remarks';
    }
  }

  void showProceedBatchUploadConfirmAlertDialog(BuildContext context, {VoidCallback? closeDialog}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Batch Upload Confirmation",
        contentText: "You will be uploading $selectedFileName with clients listed as PEP. Proceed with caution.",
        positiveButtonText: "Proceed",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          // Call closeDialog if it's provided
          if (closeDialog != null) {
            closeDialog();
          }
          Navigator.of(context).pop();
          proceedUploadFile(selectedFile);
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  void showBatchUploadConfirmAlertDialog(BuildContext context, {VoidCallback? closeDialog}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Batch Upload Confirmation",
        contentText: "Are you sure you want to upload $selectedFileName?",
        positiveButtonText: "Proceed",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          // Call closeDialog if it's provided
          if (closeDialog != null) {
            closeDialog();
          }
          Navigator.of(context).pop();
          uploadFile(selectedFile);
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  void showDownloadTemplateConfirmAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Download Confirmation",
        contentText: "Are you sure you want to download the file template?",
        positiveButtonText: "Proceed",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          Navigator.of(context).pop();
          _downloadFile();
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  void showUploadFileAlertDialog({required bool isSuccess, required String titleMessage, required String contentMessage}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        titleText: titleMessage,
        contentText: contentMessage,
        positiveButtonText: isSuccess ? "Done" : "Okay",
        positiveOnPressed: () async {
          Navigator.of(context).pop();
        },
        iconData: isSuccess ? Icons.check_circle_outline : Icons.error_outline,
        titleColor: isSuccess ? AppColors.ngoColor : AppColors.maroon2,
        iconColor: Colors.white,
      ),
    );
  }
}
