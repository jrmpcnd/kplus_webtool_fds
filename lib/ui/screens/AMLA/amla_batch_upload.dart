import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/header/header.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/header/header_CTA.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/clock/clock.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/dialog.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/toast.dart';

import '../../../core/mfi_whitelist_api/clients/clients_api.dart';
import '../../../main.dart';
import '../../shared/utils/utils_responsive.dart';

class AMLABatchUpload extends StatefulWidget {
  const AMLABatchUpload({Key? key}) : super(key: key);

  @override
  State<AMLABatchUpload> createState() => _AMLABatchUploadState();
}

class _AMLABatchUploadState extends State<AMLABatchUpload> {
  String? uploadStatus = '';
  String FileName = '';
  String TimeStamp = '';
  String FirstName = '';
  String LastName = '';
  int total = 0;
  String selectedFileName = '';
  Blob? selectedFile;
  Map<String, dynamic>? responseJson;
  int duplicatecount = 0;
  List<String> duplicates = [];
  List<String> pepsFound = [];
  String existingCIDs = '';

  //get the specific message to parameterize the UI
  String parameterMessage = '';
  String dataMessage = '';
  Color uploadStatusColor = Colors.transparent;

  List<String> column = [];
  final ScrollController controllerOne = ScrollController();
  final ScrollController controllerTwo = ScrollController();
  List<Map<String, dynamic>> apiData = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isLoading = true; // Add this variable to track loading state
  int totalRecords = 0;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    updateUrl('/AMLA/Batch_Upload');
  }

  TextEditingController NewCidcontroller = TextEditingController();
  bool SearchButtonEnabled = false;
  String selectedColumn = '';

  void openFileUploadDialog() {
    //InputElement input = (FileUploadInputElement()..accept = 'text/csv') as InputElement;
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
        readCSVFile(file);
      }
    });
  }

  Future<void> readCSVFile(File file) async {
    try {
      final reader = FileReader();
      reader.readAsText(file);

      // Wait for the reader to load
      await reader.onLoad.first;

      // Access the content of the CSV file
      final String csvContent = reader.result as String;

      // Process the CSV content as needed
      processCSVContent(csvContent);
    } catch (error) {
      print('Error reading CSV file: $error');
    }
  }

  List<Map<String, dynamic>> processCSVContent(String csvContent) {
    List<Map<String, dynamic>> processedData = [];

    try {
      List<String> rows = LineSplitter.split(csvContent).toList();

      if (rows.isNotEmpty) {
        List<String> header = rows.first.split(',');

        Map<String, int> columnIndices = {
          'Cid': header.indexOf('Cid'),
          'FirstName': header.indexOf('FirstName'),
          'LastName': header.indexOf('LastName'),
          'MiddleName': header.indexOf('MiddleName'),
          'SpouseMaidenFName': header.indexOf('SpouseMaidenFName'),
          'SpouseMaidenMName': header.indexOf('SpouseMaidenMName'),
          'SpouseMaidenLName': header.indexOf('SpouseMaidenLName'),
          'MobileNumber': header.indexOf('MobileNumber'),
          'Birthday': header.indexOf('Birthday'),
          'PlaceOfBirth': header.indexOf('PlaceOfBirth'),
          'Religion': header.indexOf('Religion'),
          'Gender': header.indexOf('Gender'),
          'CivilStatus': header.indexOf('CivilStatus'),
          'Citizenship': header.indexOf('Citizenship'),
          'PresentAddress': header.indexOf('PresentAddress'),
          'PermanentAddress': header.indexOf('PermanentAddress'),
          'PresentCity': header.indexOf('PresentCity'),
          'PresentProvince': header.indexOf('PresentProvince'),
          'PresentPostalCode': header.indexOf('PresentPostalCode'),
          'ClientMaidenFName': header.indexOf('ClientMaidenFName'),
          'ClientMaidenMName': header.indexOf('ClientMaidenMName'),
          'ClientMaidenLName': header.indexOf('ClientMaidenLName'),
          'Email': header.indexOf('Email'),
          'InstitutionName': header.indexOf('InstitutionName'),
          'UnitName': header.indexOf('UnitName'),
          'CenterName': header.indexOf('CenterName'),
          'BranchName': header.indexOf('BranchName'),
          'ClientClassification': header.indexOf('ClientClassification'),
          'SourceOfFund': header.indexOf('SourceOfFund'),
          'EmployerOrBusinessName': header.indexOf('EmployerOrBusinessName'),
          'EmployerOrBusinessAddress': header.indexOf('EmployerOrBusinessAddress'),
          'WatchlistType': header.indexOf('WatchlistType')
        };

        // Check if all required columns are present
        bool allColumnsPresent = columnIndices.values.every((index) => index >= 0);
        if (!allColumnsPresent) {
          debugPrint('One or more columns are missing in the CSV header');
          return processedData; // Or handle the missing columns as needed
        }

        // Process rows and populate processedData
        for (int i = 1; i < rows.length; i++) {
          List<String> values = rows[i].split(',');

          Map<String, dynamic> rowMap = {};
          columnIndices.forEach((key, index) {
            rowMap[key] = values[index].trim();
          });

          processedData.add(rowMap);
        }
      }
    } catch (error) {
      debugPrint('Error processing CSV content: $error');
    }

    return processedData;
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'UPLOADING':
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

  void uploadFile(Blob? file) async {
    if (file == null) {
      setState(() {
        print('No file selected');
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
          Uri.parse('${UrlGetter.getURL()}/amla/test/batch/upload'),
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

        print('Response Body: ${String.fromCharCodes(responseStream)}');
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
        } else if (responseMessage == 'Delisted AMLA Watchlist Names Found' && jsonData['retCode'] == '200' && response.statusCode == 400) {
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

  void updateApiData(List<dynamic> newData) {
    apiData.clear(); // Clear existing data
    apiData.addAll(newData.cast<Map<String, dynamic>>()); // Cast and add new data
  }

  void updateTableData(List<dynamic> newData) {
    setState(() {
      // Update the apiData with the new data
      updateApiData(newData);
    });
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

    final response = await DownloadAMLAAPI.downloadAMLAFile();

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
        print('No file selected');
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

        print('Response Body: ${String.fromCharCodes(responseStream)}');
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
        } else if (responseMessage == 'Delisted AMLA Watchlist Names Found' && jsonData['retCode'] == '200' && response.statusCode == 400) {
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
            const HeaderBar(screenText: 'AMLA WATCHLIST UPLOADING'),
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
                    children: [
                      // imageAMLABatchUpload(),
                      bodyAMLABatchUpload(
                        areButtonsEnabled,
                      )
                    ],
                  ),
                  mobile: Column(
                    children: [
                      bodyAMLABatchUpload(areButtonsEnabled),
                    ],
                  ),
                  tablet: Column(
                    children: [
                      bodyAMLABatchUpload(areButtonsEnabled),
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

  Widget bodyAMLABatchUpload(bool areButtonsEnabled) {
    double fontSize = (MediaQuery.sizeOf(context).width / 30);
    return Expanded(
      flex: 6,
      child: Container(
        padding: const EdgeInsets.all(30),
        // color: Colors.amber,
        // decoration: BoxDecoration(color: Colors.amber, border: Border.all(color: AppColors.sidePanel1, style: BorderStyle.solid, width: 0.1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AMLA',
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
                      'WATCHLIST BATCH INSERT',
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
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 10,
              children: [
                Container(
                  height: 35,
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4),
                  child: chooseFileAndUploadButton(areButtonsEnabled),
                ),
                downloadFileButton(),
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
                  // fontWeight: FontWeight.bold
                ),
              ),
            ),

            /// RESULT FIELDS
            Expanded(
              // width: MediaQuery.of(context).size.width * 0.9,
              // color: Colors.pink,
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
                              // _buildReadOnlyTextField(uploadStatus),
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
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: SingleChildScrollView(
                        child: decideTextFieldWidget(
                            parameterMessage,
                            parameterMessage == 'Existing CIDs'
                                ? existingCIDs
                                : parameterMessage == 'Duplicate CIDs'
                                    ? duplicates
                                    : parameterMessage == 'Delisted AMLA Watchlist Names Found'
                                        ? pepsFound
                                        : parameterMessage),
                      ),
                    ),
                    // if (parameterMessage == 'PEP List Found')
                    //   Align(
                    //     alignment: Alignment.centerRight,
                    //     child: Container(
                    //       margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         children: [
                    //           CustomColoredButton.secondaryButtonWithText(context, 5, () => cancelUpload(), Colors.white, "CANCEL"),
                    //           CustomColoredButton.primaryButtonWithText(context, 5, () => showProceedAMLABatchUploadConfirmAlertDialog(context), AppColors.maroon2, "PROCEED UPLOAD"),
                    //         ],
                    //       ),
                    //     ),
                    //   )
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
            areButtonsEnabled ? showAMLABatchUploadConfirmAlertDialog(context) : CustomToast.show(context, 'Please select a file first.');
          },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
            side: const BorderSide(color: AppColors.maroon2, width: 0.5),
            backgroundColor: (areButtonsEnabled ? AppColors.maroon2 : Colors.grey),
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

  Widget imageAMLABatchUpload() {
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
              image: AssetImage('/images/mwap_batch_upload.png'),
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
              style: TextStyle(
                fontSize: 12,
                // color: uploadStatusColor,
              ),
            ),
          ),
        ));
  }

  Widget decideTextFieldWidget(String responseMessage, dynamic data) {
    if (responseMessage == 'Existing CIDs' && data is String) {
      return _buildReadOnlyTextField(data);
    } else if (responseMessage == 'Delisted AMLA Watchlist Names Found' && data is List<String>) {
      return _buildPEPTextField(data.join('\n'));
    } else if (responseMessage != 'Existing CIDs' && data is List<String>) {
      return _buildReadOnlyTextField(data.join(', ')); // Join list into a comma-separated string
    } else {
      return _buildReadOnlyTextField(data);
    }
  }

  String getLabelForDuplicateCount(String message) {
    if (message == 'Existing CIDs') {
      return 'Existing CID Count';
    } else if (message == 'Duplicate CIDs') {
      return 'Duplicate CID Count';
    } else {
      return 'Count';
    }
  }

  String getLabelForDuplicateCID(String message) {
    if (message == 'Existing CIDs') {
      return 'Existing CIDs';
    } else if (message == 'Duplicate CIDs') {
      return 'Duplicate CIDs';
    } else if (message == 'Delisted AMLA Watchlist Names Found') {
      return 'Watchlist';
    } else {
      return 'Remarks';
    }
  }

  void showProceedAMLABatchUploadConfirmAlertDialog(BuildContext context) {
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
          Navigator.of(context).pop();
          proceedUploadFile(selectedFile);
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  void showAMLABatchUploadConfirmAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Batch Upload Confirmation",
        contentText: "Are you sure you want to upload $selectedFileName ?",
        positiveButtonText: "Proceed",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
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
