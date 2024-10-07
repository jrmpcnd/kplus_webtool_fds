import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/dialog.dart';

import '../../../../main.dart';
import '../../../shared/clock/clock.dart';
import '../../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../../shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import '../../../shared/utils/utils_responsive.dart';
import '../../../shared/values/colors.dart';
import '../../../shared/widget/containers/toast.dart';
import '../../user_management/ui/screen_bases/header/header.dart';

class MFIBatchDelist extends StatefulWidget {
  const MFIBatchDelist({Key? key}) : super(key: key);

  @override
  State<MFIBatchDelist> createState() => _MFIBatchDelistState();
}

class _MFIBatchDelistState extends State<MFIBatchDelist> {
  final fname = getFname();
  final lname = getLname();
  final urole = getUrole();
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
  String existingCIDs = '';

  //get the specific message to parameterize the UI
  String parameterMessage = '';
  String dataMessage = '';
  Color uploadStatusColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    // updateUrl('/Access/Batch_Upload/Batch_Delist');
    updateUrl('/Access/Client_List/Disapproved_Clients');
  }

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
      debugPrint('Error reading CSV file: $error');
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
      default:
        return Colors.transparent; // Default color (you can change this as per your design)
    }
  }

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

        Navigator.pop(navigatorKey.currentContext!); // Close the loading dialog

        setState(() {
          parameterMessage = responseMessage;
          dataMessage = responseDataMap.toString(); // Convert responseDataMap to String
        });

        debugPrint('Response Body: ${String.fromCharCodes(responseStream)}');
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
          } else if (responseMessage == 'File size exceeds the 24 MB limit' && jsonData['retCode'] == '400') {
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

  List<Map<String, dynamic>> apiData = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isLoading = true; // Add this variable to track loading state
  int totalRecords = 0;
  int totalPages = 1;

  //download file
  // void _downloadFile() async {
  //   // Show loading dialog
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => Center(
  //       child: Container(
  //         width: 350,
  //         height: 100,
  //         decoration: const BoxDecoration(color: AppColors.dialogColor, borderRadius: BorderRadius.all(Radius.circular(5))),
  //         child: const Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [SpinKitFadingCircle(color: AppColors.maroon2), SizedBox(width: 10), Text('Downloading in progress...')],
  //         ),
  //       ),
  //     ),
  //   );
  //
  //   final response = await DownloadAPI.downloadFile();
  //
  //   Navigator.pop(context);
  //   if (response.statusCode == 200) {
  //     showUploadFileAlertDialog(isSuccess: true, titleMessage: 'File Downloaded Successfully', contentMessage: 'You have successfully downloaded the file template');
  //   } else {
  //     showUploadFileAlertDialog(isSuccess: false, titleMessage: 'Failed to Download', contentMessage: 'File not downloaded.');
  //   }
  // }

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
                  //rows&clock
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.only(
                        right: 25,
                      ),
                      child: Clock()),
                ],
              ),
            ),
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
                    children: [imageMFIBatchDelist(), bodyMFIBatchDelist(areButtonsEnabled)],
                  ),
                  mobile: Column(
                    children: [
                      bodyMFIBatchDelist(areButtonsEnabled),
                    ],
                  ),
                  tablet: Column(
                    children: [
                      bodyMFIBatchDelist(areButtonsEnabled),
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

  Widget bodyMFIBatchDelist(bool areButtonsEnabled) {
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
                  'WHITELIST',
                  style: TextStyle(color: AppColors.maroon2, fontSize: fontSize.clamp(25, 40), fontFamily: 'RobotoThin', fontWeight: FontWeight.bold),
                ),
                const Text(
                  'MANAGEMENT SYSTEM',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'RobotoThin',
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
                      'BATCH DELIST',
                      style: TextStyle(
                        color: AppColors.maroon2,
                        fontFamily: 'RobotoThin',
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
                chooseFileAndUploadButton(areButtonsEnabled),
                // downloadFileButton(),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: const Text(
                'BATCH DELIST SUMMARY',
                style: TextStyle(
                  color: AppColors.maroon2,
                  fontFamily: 'RobotoThin',
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
                    _buildLabel(getLabelForDuplicateCID(dataMessage)),
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
                                    : parameterMessage),
                      ),
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
    return Container(
      height: 35,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.35),
      child: Row(
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
                  Icons.file_copy_outlined,
                  color: AppColors.sidePanel1,
                  size: 17,
                ),
                hintText: selectedFileName.isEmpty ? 'Choose file...' : selectedFileName,
                hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 12, color: Colors.black54),
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
              areButtonsEnabled ? showMFIBatchDelistConfirmAlertDialog(context) : CustomToast.show(context, 'Please select a file first.');
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
                    style: TextStyle(fontFamily: 'RobotoThin', color: Colors.white, fontSize: (MediaQuery.sizeOf(context).width / 40).clamp(9, 12)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget downloadFileButton() {
  //   return SizedBox(
  //     height: 35,
  //     width: 200,
  //     child: ElevatedButton(
  //       onPressed: () {
  //         showDownloadTemplateConfirmAlertDialog(context);
  //       },
  //       style: ElevatedButton.styleFrom(
  //         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
  //         backgroundColor: (AppColors.maroon2),
  //       ),
  //       child: Center(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const Icon(
  //               Icons.file_download,
  //               size: 17,
  //               color: Colors.white,
  //             ),
  //             const SizedBox(
  //               width: 5,
  //             ),
  //             Text(
  //               'Download Template',
  //               maxLines: 2,
  //               style: TextStyle(fontFamily: 'RobotoThin', color: Colors.white, fontSize: (MediaQuery.sizeOf(context).width / 40).clamp(9, 12)),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget imageMFIBatchDelist() {
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
        fontFamily: 'RobotoThin',
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
          style: const TextStyle(fontFamily: 'RobotoThin', fontSize: 12),
        ),
      ),
    );
  }

  Widget decideTextFieldWidget(String responseMessage, dynamic data) {
    if (responseMessage == 'Existing CIDs' && data is String) {
      return _buildReadOnlyTextField(data);
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
    } else {
      return 'Remarks';
    }
  }

  void showMFIBatchDelistConfirmAlertDialog(BuildContext context) {
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

  // void showDownloadTemplateConfirmAlertDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => AlertDialogWidget(
  //       titleText: "Download Confirmation",
  //       contentText: "Are you sure you want to download the file template?",
  //       positiveButtonText: "Proceed",
  //       negativeButtonText: "Cancel",
  //       negativeOnPressed: () {
  //         Navigator.of(context).pop();
  //       },
  //       positiveOnPressed: () async {
  //         Navigator.of(context).pop();
  //         _downloadFile();
  //       },
  //       iconData: Icons.info_outline,
  //       titleColor: AppColors.infoColor,
  //       iconColor: Colors.white,
  //     ),
  //   );
  // }

  void showUploadFileAlertDialog({required bool isSuccess, required String titleMessage, required String contentMessage}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        titleText: titleMessage,
        contentText: contentMessage,
        positiveButtonText: isSuccess ? "Done" : "Retry",
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
