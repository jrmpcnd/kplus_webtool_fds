import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../../../../core/service/url_getter_setter.dart';
import '../../../../main.dart';
import '../../../shared/clock/clock.dart';
import '../../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../../shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import '../../../shared/values/colors.dart';
import '../../../shared/widget/containers/dialog.dart';
import '../../user_management/ui/screen_bases/header/header.dart';

class BatchDelist extends StatefulWidget {
  const BatchDelist({Key? key}) : super(key: key);

  @override
  State<BatchDelist> createState() => _BatchDelistState();
}

class _BatchDelistState extends State<BatchDelist> {
  final fname = getFname();
  final lname = getLname();
  final urole = getUrole();
  String uploadStatus = '';
  String FileName = '';
  String TimeStamp = '';
  String FirstName = '';
  String LastName = '';
  Blob? selectedFile;
  int total = 0;
  List<String> duplicates = [];
  String selectedFileName = '';
  Map<String, dynamic>? responseJson;
  bool isLoading = true;
  int duplicatecount = 0;

  List<String> column = [];

  // final TextEditingController _rowsperpagecontroller = TextEditingController();
  // final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchColumns();
    updateUrl('/Access/Batch_Upload/Batch_Delist');
  }

  void fetchColumns() async {
    try {
      final response = await http.get(
        Uri.parse('https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/ngo/test/get/all/headers'),
        headers: {
          'Accept-Charset': 'UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // final jsonData = json.decode(utf8.decode(response.bodyBytes));
        final Map<String, dynamic> jsonResponse = json.decode((utf8.decode(response.bodyBytes)));
        // Extracting the 'data' field from the JSON response
        final List<dynamic> data = jsonResponse['data'];
        // Extracting column names from the 'data' list
        final List<String> columns = data.map((dynamic item) => item['column'].toString()).toList();
        // Printing the extracted column names
        print(columns);
        // Assigning the extracted columns to the class variable
        column = columns;
      } else {
        throw Exception('Failed to load columns');
      }
    } catch (error) {
      print('Error fetching data: $error');
      // Handle the error, e.g., show a message to the user or log it
    }
  }

  TextEditingController NewCidcontroller = TextEditingController();
  bool SearchButtonEnabled = false;
  String selectedColumn = '';

  void openFileUploadDialog() {
    InputElement input = (FileUploadInputElement()..accept = 'text/csv') as InputElement;
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

      // Assuming the first row is the header
      if (rows.isNotEmpty) {
        List<String> header = rows.first.split(',');

        // Find the index of each column in the header
        int newCidIndex = header.indexOf('NewCid');
        int areaIndex = header.indexOf('Area');
        int newBranchCodeIndex = header.indexOf('NewBranchCode');
        int unitIndex = header.indexOf('Unit');
        int centerNameIndex = header.indexOf('CenterName');
        int eSystemCidIndex = header.indexOf('ESystemCid');
        int contactIndex = header.indexOf('Contact');
        int lastNameIndex = header.indexOf('LastName');
        int firstNameIndex = header.indexOf('FirstName');
        int middleNameIndex = header.indexOf('MiddleName');
        int birthdayIndex = header.indexOf('Birthday');
        int recognizedDateIndex = header.indexOf('RecognizedDate');

        // Check if all columns are found in the header
        if (newCidIndex >= 0 && areaIndex >= 0 && newBranchCodeIndex >= 0 && unitIndex >= 0 && centerNameIndex >= 0 && eSystemCidIndex >= 0 && contactIndex >= 0 && lastNameIndex >= 0 && firstNameIndex >= 0 && middleNameIndex >= 0 && birthdayIndex >= 0 && recognizedDateIndex >= 0) {
          // Iterate through the remaining rows with data
          for (int i = 1; i < rows.length; i++) {
            List<String> values = rows[i].split(',');

            // Access each column value based on its index
            String newCid = values[newCidIndex].trim();
            String area = values[areaIndex].trim();
            String newBranchCode = values[newBranchCodeIndex].trim();
            String unit = values[unitIndex].trim();
            String centerName = values[centerNameIndex].trim();
            String eSystemCid = values[eSystemCidIndex].trim();
            String contact = values[contactIndex].trim();
            String lastName = values[lastNameIndex].trim();
            String firstName = values[firstNameIndex].trim();
            String middleName = values[middleNameIndex].trim();
            String birthday = values[birthdayIndex].trim();
            String recognizedDate = values[recognizedDateIndex].trim();

            // Construct a map representing the row and add it to the processedData list
            processedData.add({
              'NewCid': newCid,
              'Area': area,
              'NewBranchCode': newBranchCode,
              'Unit': unit,
              'CenterName': centerName,
              'ESystemCid': eSystemCid,
              'Contact': contact,
              'LastName': lastName,
              'FirstName': firstName,
              'MiddleName': middleName,
              'Birthday': birthday,
              'RecognizedDate': recognizedDate,
            });
            print(processedData);
          }
        } else {
          // Handle case where any of the columns are not found in the header
          print('One or more columns are missing in the CSV header');
        }
      }
    } catch (error) {
      // Handle error
      print('Error processing CSV content: $error');
      print('pd:$processedData');
    }

    return processedData;
  }

  List<DataRow> getPaginatedRows(List<Map<String, dynamic>> processedData) {
    return processedData.map<DataRow>((rowData) {
      final color = processedData.indexOf(rowData) % 2 == 0 ? Colors.white : Colors.white;
      return DataRow(
        color: MaterialStateProperty.all(color),
        cells: [
          DataCell(Center(
            child: SelectableText(
              rowData['newcid'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'RobotoThin',
              ),
            ),
          )),
          DataCell(Center(
            child: SelectableText(
              rowData['area'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'RobotoThin',
              ),
            ),
          )),
          DataCell(Center(
            child: SelectableText(
              rowData['newbranchcode'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'RobotoThin',
              ),
            ),
          )),
          DataCell(Center(
            child: SelectableText(
              rowData['unit'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'RobotoThin',
              ),
            ),
          )),
          DataCell(Center(
            child: SelectableText(
              rowData['centername'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'RobotoThin',
              ),
            ),
          )),
          DataCell(Center(
            child: SelectableText(
              rowData['esystemcid'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'RobotoThin',
              ),
            ),
          )),
          DataCell(Center(
            child: SelectableText(
              rowData['contact'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'RobotoThin',
              ),
            ),
          )),
          DataCell(Center(
            child: SelectableText(
              rowData['lastname'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'RobotoThin',
              ),
            ),
          )),
          DataCell(Center(
            child: SelectableText(
              rowData['firstname'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'RobotoThin',
              ),
            ),
          )),
          DataCell(Center(
            child: SelectableText(
              rowData['middlename'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'RobotoThin',
              ),
            ),
          )),
          DataCell(Center(
            child: SelectableText(
              rowData['birthday'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'RobotoThin',
              ),
            ),
          )),
          DataCell(Center(
            child: SelectableText(
              rowData['recognizeddate'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'RobotoThin',
              ),
            ),
          )),
        ],
      );
    }).toList();
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
      print('Uploading file');
      uploadStatus = 'Uploading file...';
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
          decoration: const BoxDecoration(color: AppColors.dialogColor, borderRadius: BorderRadius.all(Radius.circular(5))),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [SpinKitFadingCircle(color: AppColors.maroon2), SizedBox(width: 10), Text('Uploading in progress...')],
          ),
        ),
      ),
    );

    final reader = FileReader();

    reader.onLoad.listen((event) async {
      final List<int> bytes = reader.result as List<int>;

      try {
        final request = http.MultipartRequest('POST', Uri.parse('${UrlGetter.getURL()}/clients/test/batch/upload'));

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
        final responseStatusCode = response.statusCode;

        final responseData = utf8.decode(responseStream);
        final jsonData = json.decode(responseData);
        final responseMessage = jsonData['message'] ?? 'Unknown error occurred';

        Navigator.pop(context); // Close the loading dialog

        if (response.statusCode == 200) {
          showUploadFileAlertDialog(isSuccess: true, message: 'You uploaded a file successfully.');
          // Widget confirmButton = TextButton(
          //   child: const Text("Okay", style: TextStyle(fontFamily: 'RobotoThin', color: Colors.black54, fontSize: 12)),
          //   onPressed: () {
          //     setState(() {});
          //     Navigator.pop(context);
          //   },
          // );
          //
          // AlertDialog alert = AlertDialog(
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(5),
          //   ),
          //   title: Container(
          //     padding: const EdgeInsets.all(20),
          //     decoration: const BoxDecoration(
          //       color: AppColors.sidePanel1,
          //       borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(5.0),
          //         topRight: Radius.circular(5.0),
          //       ),
          //     ),
          //     child: const Row(
          //       children: [
          //         Icon(
          //           Icons.check,
          //           color: Colors.white,
          //           size: 17,
          //         ),
          //         SizedBox(width: 10),
          //         Text(
          //           "File Uploaded Successfully",
          //           style: TextStyle(
          //             fontFamily: 'RobotoThin',
          //             color: Colors.white,
          //             fontSize: 12,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          //   titlePadding: const EdgeInsets.all(0),
          //   content: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         "File Uploaded Successfully",
          //         style: TextStyle(
          //           fontFamily: 'RobotoThin',
          //           color: Colors.black,
          //           fontSize: 12,
          //         ),
          //       ),
          //     ],
          //   ),
          //   actions: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [confirmButton],
          //     ),
          //   ],
          // );
          //
          // showDialog(
          //   barrierDismissible: false,
          //   context: context,
          //   builder: (BuildContext context) {
          //     return alert;
          //   },
          // );
          if (jsonData['message'] == 'File Uploaded Successfully' && jsonData['retCode'] == '200') {
            setState(() {
              uploadStatus = 'File uploaded successfully';
              FileName = jsonData['data']['FileName'];
              FirstName = jsonData['data']['FirstName'];
              LastName = jsonData['data']['LastName'];
              TimeStamp = jsonData['data']['Timestamp'];
              total = jsonData['data']['TotalRecords'];
            });
            print("FILENAME:$FileName");
            print("TIMESTAMP:$TimeStamp");
            print("TOTAL:$total");
            print("RESPONSE:$responseData");
          } else {
            setState(() {
              uploadStatus = 'File uploaded successfully';
            });
          }
        } else {
          // Widget confirmButton = TextButton(
          //   child: const Text("Okay", style: TextStyle(fontFamily: 'RobotoThin', color: Colors.black54, fontSize: 12)),
          //   onPressed: () {
          //     setState(() {});
          //     Navigator.pop(context);
          //   },
          // );
          //
          // AlertDialog alert = AlertDialog(
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(5),
          //   ),
          //   title: Container(
          //     padding: const EdgeInsets.all(20),
          //     decoration: const BoxDecoration(
          //       color: AppColors.sidePanel1,
          //       borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(5.0),
          //         topRight: Radius.circular(5.0),
          //       ),
          //     ),
          //     child: const Row(
          //       children: [
          //         Icon(
          //           Icons.warning_amber_outlined,
          //           color: Colors.white,
          //           size: 17,
          //         ),
          //         SizedBox(width: 10),
          //         Text(
          //           "File Upload Failed",
          //           style: TextStyle(
          //             fontFamily: 'RobotoThin',
          //             color: Colors.white,
          //             fontSize: 12,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          //   titlePadding: const EdgeInsets.all(0),
          //   content: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         responseMessage,
          //         style: TextStyle(
          //           fontFamily: 'RobotoThin',
          //           color: Colors.black,
          //           fontSize: 12,
          //         ),
          //       ),
          //     ],
          //   ),
          //   actions: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [confirmButton],
          //     ),
          //   ],
          // );
          //
          // showDialog(
          //   barrierDismissible: false,
          //   context: context,
          //   builder: (BuildContext context) {
          //     return alert;
          //   },
          // );
          showUploadFileAlertDialog(isSuccess: false, message: responseMessage);

          // Ensure the data is correctly cast and assigned
          final List<dynamic> rawDuplicates = jsonData['data']['DuplicateNewCIDs'] ?? [];
          final List<String> duplicateNewCIDs = rawDuplicates.map((e) => e.toString()).toList();

          setState(() {
            uploadStatus = 'File upload failed';
            FileName = jsonData['data']['FileName'];
            FirstName = jsonData['data']['FirstName'];
            LastName = jsonData['data']['LastName'];
            TimeStamp = jsonData['data']['Timestamp'];
            total = jsonData['data']['TotalRecords'];
            duplicatecount = jsonData['data']['DuplicateCount'];
            duplicates = duplicateNewCIDs; // Assign the correctly cast list here
          });
          print('File upload failed');
          print('Response body: ${String.fromCharCodes(responseStream)}');
        }
      } catch (e) {
        Navigator.pop(context); // Close the loading dialog in case of error
        print('Error: $e');
        setState(() {
          uploadStatus = 'Error uploading file: $e';
          isLoading = false;
        });
      }
    });

    reader.readAsArrayBuffer(file);
  }

  List<Map<String, dynamic>> apiData = [];

  @override
  Widget build(BuildContext context) {
    // Determine if the buttons should be enabled
    bool areButtonsEnabled = selectedFileName.isNotEmpty;

    return Container(
      padding: const EdgeInsets.only(left: 90),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const HeaderBar(screenText: 'BATCH DELIST'),
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.sidePanel3.withOpacity(0.9), AppColors.sidePanel4, AppColors.sidePanel5, AppColors.sidePanel6], // Gradient colors
                    begin: Alignment.topCenter, // Alignment for the start of the gradient
                    end: Alignment.bottomCenter, // Alignment for the end of the gradient
                  ),
                  // color:  const Color(0xff941c1b),
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
                child: Row(
                  children: [
                    const Expanded(
                        flex: 4,
                        child: Opacity(
                          opacity: 0.8,
                          child: Image(
                            image: AssetImage('/images/ngobg.png'),
                            fit: BoxFit.fill,
                            // height: 700,
                            width: 400,
                          ),
                        )
                        // Container(
                        //   child: Opacity(
                        //     opacity: 0.2,
                        //     child: Image(
                        //       image: AssetImage('/images/cii.png'),
                        //       fit: BoxFit.fill,
                        //     ),
                        //   ),
                        // ),
                        ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: const EdgeInsets.only(left: 40, top: 40, bottom: 40, right: 40),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.sidePanel1, style: BorderStyle.solid, width: 0.1)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                              child: Row(
                                children: [
                                  // Image(
                                  //   image: AssetImage('/images/cgby.png'),
                                  //   height: 30,
                                  //   width: 30,
                                  // ),
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  // Image(
                                  //   image: AssetImage('/images/mfi_whitelist_logo.png'),
                                  //   height: 80,
                                  //   width: 100,
                                  // ),
                                ],
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'WHITELIST',
                                  style: TextStyle(color: AppColors.sidePanel1, fontSize: 40, fontFamily: 'RobotoThin', fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'MANAGEMENT SYSTEM',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: 'RobotoThin',
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline_outlined,
                                      color: AppColors.sidePanel1,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'BATCH DELIST',
                                      style: TextStyle(
                                        color: AppColors.sidePanel1,
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
                            Row(
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: 400,
                                  child: TextField(
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                    onTap: () {
                                      openFileUploadDialog();
                                    },
                                    textAlignVertical: TextAlignVertical.center,
                                    cursorColor: AppColors.sidePanel1,
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
                                          });
                                        },
                                        child: const Icon(
                                          Icons.clear,
                                          color: Color(0xff1E5128),
                                          size: 17,
                                        ),
                                      ),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      areButtonsEnabled ? showBatchUploadConfirmAlertDialog(context) : null;
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
                                      side: const BorderSide(color: AppColors.sidePanel1, width: 0.5),
                                      backgroundColor: (areButtonsEnabled ? AppColors.maroon2 : Colors.grey),
                                    ),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.drive_folder_upload_sharp,
                                            size: 17,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Upload File',
                                            style: TextStyle(fontFamily: 'RobotoThin', color: Colors.white, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'BATCH DELISTING SUMMARY',
                              style: TextStyle(
                                color: AppColors.sidePanel1,
                                fontFamily: 'RobotoThin',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                            // const Divider(
                            //   color: Colors.black54,
                            //   thickness: 0.5,
                            // ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'File name',
                                    style: TextStyle(
                                        fontFamily: 'RobotoThin',
                                        fontSize: 12,
                                        color: Colors.black54,
                                        // color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 35,
                                    width: 300,
                                    child: TextField(
                                      textAlignVertical: TextAlignVertical.center,
                                      cursorColor: AppColors.sidePanel1,
                                      cursorWidth: 1,
                                      // cursorHeight: 12,
                                      cursorRadius: const Radius.circular(5),
                                      // obscureText: _obscureText,
                                      decoration: InputDecoration(
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            // color: Color(0xff941c1b),
                                            width: 0.5,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white10,
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.sidePanel1,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.sidePanel1,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),
                                        hintText: selectedFileName,
                                        hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 12),
                                      ),
                                      readOnly: true,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Uploader',
                                              style: TextStyle(
                                                  fontFamily: 'RobotoThin',
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                  // color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 35,
                                              // width: 300,
                                              child: TextField(
                                                textAlignVertical: TextAlignVertical.center,
                                                cursorColor: AppColors.sidePanel1,
                                                cursorWidth: 1,
                                                // cursorHeight: 12,
                                                cursorRadius: const Radius.circular(5),
                                                // obscureText: _obscureText,
                                                decoration: InputDecoration(
                                                  enabledBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      // color: Color(0xff941c1b),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white10,
                                                  focusedBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.sidePanel1,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  ),
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.sidePanel1,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  ),
                                                  hintText: '$FirstName $LastName',
                                                  hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 12),
                                                ),
                                                readOnly: true,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              'Date and Time:',
                                              style: TextStyle(
                                                  fontFamily: 'RobotoThin',
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                  // color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 35,
                                              // width: 300,
                                              child: TextField(
                                                textAlignVertical: TextAlignVertical.center,
                                                cursorColor: AppColors.sidePanel1,
                                                cursorWidth: 1,
                                                // cursorHeight: 12,
                                                cursorRadius: const Radius.circular(5),
                                                // obscureText: _obscureText,
                                                decoration: InputDecoration(
                                                  enabledBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      // color: Color(0xff941c1b),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white10,
                                                  focusedBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.sidePanel1,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  ),
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.sidePanel1,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  ),
                                                  hintText: TimeStamp,
                                                  hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 12),
                                                ),
                                                readOnly: true,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            // const SizedBox(height: 5,),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Duplicate Count',
                                              style: TextStyle(
                                                  fontFamily: 'RobotoThin',
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                  // color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 35,
                                              // width: 300,
                                              child: TextField(
                                                textAlignVertical: TextAlignVertical.center,
                                                cursorColor: AppColors.sidePanel1,
                                                cursorWidth: 1,
                                                // cursorHeight: 12,
                                                cursorRadius: const Radius.circular(5),
                                                // obscureText: _obscureText,
                                                decoration: InputDecoration(
                                                  enabledBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      // color: Color(0xff941c1b),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white10,
                                                  focusedBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.sidePanel1,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  ),
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.sidePanel1,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  ),
                                                  hintText: '$duplicatecount',
                                                  hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 12),
                                                ),
                                                readOnly: true,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              'No. of Clients Uploaded',
                                              style: TextStyle(
                                                  fontFamily: 'RobotoThin',
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                  // color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 35,
                                              // width: 300,
                                              child: TextField(
                                                textAlignVertical: TextAlignVertical.center,
                                                cursorColor: AppColors.sidePanel1,
                                                cursorWidth: 1,
                                                // cursorHeight: 12,
                                                cursorRadius: const Radius.circular(5),
                                                // obscureText: _obscureText,
                                                decoration: InputDecoration(
                                                  enabledBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      // color: Color(0xff941c1b),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white10,
                                                  focusedBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.sidePanel1,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  ),
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.sidePanel1,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  ),
                                                  hintText: '$total',
                                                  hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 12),
                                                ),
                                                readOnly: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Duplicate CID',
                                        style: TextStyle(
                                            fontFamily: 'RobotoThin',
                                            fontSize: 12,
                                            // color: Color(0xff941c1b),
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      // height: 35,
                                      // width: 300,
                                      child: TextField(
                                        maxLines: 5,
                                        textAlignVertical: TextAlignVertical.center,
                                        cursorColor: AppColors.sidePanel1,
                                        cursorWidth: 1,
                                        // cursorHeight: 12,
                                        cursorRadius: const Radius.circular(5),
                                        // obscureText: _obscureText,
                                        decoration: InputDecoration(
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              // color: Color(0xff941c1b),
                                              width: 0.5,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white10,
                                          focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.sidePanel1,
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                          ),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.sidePanel1,
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                          ),
                                          hintText: '$duplicates',
                                          hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 12),
                                        ),
                                        readOnly: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const Divider(
            //   thickness: 0.5,
            // ),
            // const SizedBox(
            //   height: 5,
            // ),
            // Expanded(
            //   child: Container(
            //     // padding: const EdgeInsets.all(10),
            //     decoration: const BoxDecoration(
            //         // gradient: LinearGradient(colors: [const Color(0xffE0F1E6),const Color(0xffE0F1E6).withOpacity(0.6), Colors.white.withOpacity(0.2)]),
            //       borderRadius:  BorderRadius.all(Radius.circular(5))
            //         ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         // const Divider(
            //         //   thickness: 0.5,
            //         // ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             Container(
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 border: Border.all(
            //                   color: const Color(0xff1E5128),
            //                   width: 2, // Set the width of the border
            //                 ),
            //               ),
            //               child: const CircleAvatar(
            //                 backgroundImage: AssetImage('images/uploads.png'),
            //                 maxRadius: 20,
            //               ),
            //             ),
            //             const SizedBox(
            //               width: 10,
            //             ),
            //             const Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                  Text(
            //                   'DELISTING PREVIEW',
            //                   style: TextStyle(
            //                       fontFamily: 'RobotoThin',
            //                       fontSize: 15,
            //                       color: Color(0xff1E5128),
            //                       fontWeight: FontWeight.bold),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //         const SizedBox(height: 5,),
            //         const Divider(
            //           thickness: 0.5,
            //         ),
            //         const SizedBox(height: 5,),
            //         Row(
            //           children: [
            //             Column(
            //               children: [
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     const Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           'File Name :',
            //                           style: TextStyle(
            //                             fontFamily: 'RobotoThin',
            //                             fontSize: 15,
            //                             color: Color(0xff1E5128),
            //                           ),
            //                         ),
            //                         SizedBox(height: 30,),
            //                         Text(
            //                           'Uploader:',
            //                           style: TextStyle(
            //                             fontFamily: 'RobotoThin',
            //                             fontSize: 15,
            //                             color: Color(0xff1E5128),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     const SizedBox(width: 15,),
            //                     Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       children: [
            //                         SizedBox(
            //                           height: 40,
            //                           width: 300,
            //                           child: TextField(
            //                             textAlignVertical: TextAlignVertical.center,
            //                             cursorColor: const Color(0xff009150),
            //                             cursorWidth: 1,
            //                             // cursorHeight: 12,
            //                             cursorRadius: const Radius.circular(5),
            //                             // obscureText: _obscureText,
            //                             decoration: InputDecoration(
            //                               filled: true,
            //                               fillColor: Colors.white10,
            //                               focusedBorder:  const OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0xff009150),
            //                                 ),
            //                                 borderRadius:
            //                                 BorderRadius.all(Radius.circular(5)),
            //                               ),
            //                               border:  const OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0xff009150),
            //                                 ),
            //                                 borderRadius:
            //                                 BorderRadius.all(Radius.circular(5)),
            //                               ),
            //                               hintText: selectedFileName,
            //                               hintStyle: const TextStyle(
            //                                   fontFamily: 'RobotoThin', fontSize: 12),
            //                             ),
            //                             readOnly: true,
            //                           ),
            //                         ),
            //                         const SizedBox(height: 10,),
            //                         SizedBox(
            //                           height: 40,
            //                           width: 300,
            //                           child: TextField(
            //                             textAlignVertical: TextAlignVertical.center,
            //                             cursorColor: const Color(0xff009150),
            //                             cursorWidth: 1,
            //                             // cursorHeight: 12,
            //                             cursorRadius: const Radius.circular(5),
            //                             // obscureText: _obscureText,
            //                             decoration: InputDecoration(
            //                               filled: true,
            //                               fillColor: Colors.white10,
            //                               focusedBorder: const OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0xff009150),
            //                                 ),
            //                                 borderRadius:
            //                                 BorderRadius.all(Radius.circular(5)),
            //                               ),
            //                               border: const OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0xff009150),
            //                                 ),
            //                                 borderRadius:
            //                                 BorderRadius.all(Radius.circular(5)),
            //                               ),
            //                               hintText: '$FirstName $LastName',
            //                               hintStyle: const TextStyle(
            //                                   fontFamily: 'RobotoThin', fontSize: 12),
            //                             ),
            //                             readOnly: true,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     const Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           'Date and Time:',
            //                           style: TextStyle(
            //                             fontFamily: 'RobotoThin',
            //                             fontSize: 15,
            //                             color: Color(0xff1E5128),
            //                           ),
            //                         ),
            //                         SizedBox(height: 30,),
            //                         Text(
            //                           'No. of Clients Uploaded:',
            //                           style: TextStyle(
            //                             fontFamily: 'RobotoThin',
            //                             fontSize: 15,
            //                             color: Color(0xff1E5128),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     const SizedBox(width: 15,),
            //                     Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       children: [
            //                         SizedBox(
            //                           height: 40,
            //                           width: 300,
            //                           child: TextField(
            //                             textAlignVertical: TextAlignVertical.center,
            //                             cursorColor: const Color(0xff009150),
            //                             cursorWidth: 1,
            //                             // cursorHeight: 12,
            //                             cursorRadius: const Radius.circular(5),
            //                             // obscureText: _obscureText,
            //                             decoration: InputDecoration(
            //                               filled: true,
            //                               fillColor: Colors.white10,
            //                               focusedBorder: const OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0xff009150),
            //                                 ),
            //                                 borderRadius:
            //                                 BorderRadius.all(Radius.circular(5)),
            //                               ),
            //                               border: const OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0xff009150),
            //                                 ),
            //                                 borderRadius:
            //                                 BorderRadius.all(Radius.circular(5)),
            //                               ),
            //                               hintText: TimeStamp,
            //                               hintStyle: const TextStyle(
            //                                   fontFamily: 'RobotoThin', fontSize: 12),
            //                             ),
            //                             readOnly: true,
            //                           ),
            //                         ),
            //                         const SizedBox(height: 10,),
            //                         SizedBox(
            //                           height: 40,
            //                           width: 300,
            //                           child: TextField(
            //                             textAlignVertical: TextAlignVertical.center,
            //                             cursorColor: const Color(0xff009150),
            //                             cursorWidth: 1,
            //                             // cursorHeight: 12,
            //                             cursorRadius: const Radius.circular(5),
            //                             // obscureText: _obscureText,
            //                             decoration: InputDecoration(
            //                               filled: true,
            //                               fillColor: Colors.white10,
            //                               focusedBorder: const OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0xff009150),
            //                                 ),
            //                                 borderRadius:
            //                                 BorderRadius.all(Radius.circular(5)),
            //                               ),
            //                               border: const OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0xff009150),
            //                                 ),
            //                                 borderRadius:
            //                                 BorderRadius.all(Radius.circular(5)),
            //                               ),
            //                               hintText: '$total',
            //                               hintStyle: const TextStyle(
            //                                   fontFamily: 'RobotoThin', fontSize: 12),
            //                             ),
            //                             readOnly: true,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     const Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           'Duplicate CID:',
            //                           style: TextStyle(
            //                             fontFamily: 'RobotoThin',
            //                             fontSize: 15,
            //                             color: Color(0xff1E5128),
            //                           ),
            //                         ),
            //                         SizedBox(height: 30,),
            //                         Text(
            //                           'Duplicate Count:',
            //                           style: TextStyle(
            //                             fontFamily: 'RobotoThin',
            //                             fontSize: 15,
            //                             color: Color(0xff1E5128),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     const SizedBox(width: 15,),
            //                     Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       children: [
            //                         SizedBox(
            //                           height: 40,
            //                           width: 300,
            //                           child: TextField(
            //                             textAlignVertical: TextAlignVertical.center,
            //                             cursorColor: const Color(0xff009150),
            //                             cursorWidth: 1,
            //                             // cursorHeight: 12,
            //                             cursorRadius: const Radius.circular(5),
            //                             // obscureText: _obscureText,
            //                             decoration: InputDecoration(
            //                               filled: true,
            //                               fillColor: Colors.white10,
            //                               focusedBorder: const OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0xff009150),
            //                                 ),
            //                                 borderRadius:
            //                                 BorderRadius.all(Radius.circular(5)),
            //                               ),
            //                               border: const OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0xff009150),
            //                                 ),
            //                                 borderRadius:
            //                                 BorderRadius.all(Radius.circular(5)),
            //                               ),
            //                               hintText: TimeStamp,
            //                               hintStyle: const TextStyle(
            //                                   fontFamily: 'RobotoThin', fontSize: 12),
            //                             ),
            //                             readOnly: true,
            //                           ),
            //                         ),
            //                         const SizedBox(height: 10,),
            //                         SizedBox(
            //                           height: 40,
            //                           width: 300,
            //                           child: TextField(
            //                             textAlignVertical: TextAlignVertical.center,
            //                             cursorColor: const Color(0xff009150),
            //                             cursorWidth: 1,
            //                             // cursorHeight: 12,
            //                             cursorRadius: const Radius.circular(5),
            //                             // obscureText: _obscureText,
            //                             decoration: InputDecoration(
            //                               filled: true,
            //                               fillColor: Colors.white10,
            //                               focusedBorder: const OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0xff009150),
            //                                 ),
            //                                 borderRadius:
            //                                 BorderRadius.all(Radius.circular(5)),
            //                               ),
            //                               border: const OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0xff009150),
            //                                 ),
            //                                 borderRadius:
            //                                 BorderRadius.all(Radius.circular(5)),
            //                               ),
            //                               hintText: '$total',
            //                               hintStyle: const TextStyle(
            //                                   fontFamily: 'RobotoThin', fontSize: 12),
            //                             ),
            //                             readOnly: true,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             )
            //           ],
            //         ),
            //         const SizedBox(height: 5,),
            //         const Divider(
            //           thickness: 0.5,
            //         ),
            //         const SizedBox(height: 5,),
            //         Expanded(
            //           child: Container(
            //             decoration: const BoxDecoration(
            //               // color: Colors.grey,
            //               border: Border(
            //                 top: BorderSide(
            //                   color: Color(0xff1E5128),
            //                   width: 0.5,
            //                   style: BorderStyle.solid,
            //                 ),
            //                 bottom: BorderSide(
            //                   color: Color(0xff1E5128),
            //                   width: 0.5,
            //                   style: BorderStyle.solid,
            //                 ),
            //                 left: BorderSide(
            //                   color: Color(0xff1E5128),
            //                   width: 0.5,
            //                   style: BorderStyle.solid,
            //                 ),
            //                 right: BorderSide(
            //                   color: Color(0xff1E5128),
            //                   style: BorderStyle.solid,
            //                   width: 0.5,
            //                 ),
            //               ),
            //             ),
            //             child: Scrollbar(
            //               // thickness: 15,
            //               radius: const Radius.circular(3),
            //               thumbVisibility: true,
            //               scrollbarOrientation: ScrollbarOrientation.bottom,
            //               controller: controllerOne,
            //               child: SingleChildScrollView(
            //                 controller: controllerOne,
            //                 scrollDirection: Axis.horizontal,
            //                 child: Scrollbar(
            //                   radius: const Radius.circular(3),
            //                   thumbVisibility: true,
            //                   scrollbarOrientation: ScrollbarOrientation.right,
            //                   controller: controllerTwo,
            //                   child: SingleChildScrollView(
            //                     controller: controllerTwo,
            //                     scrollDirection: Axis.vertical,
            //                     child: DataTable(
            //                       border: TableBorder.all(width: 0.2),
            //                       headingRowColor: MaterialStateColor.resolveWith(
            //                             (states) =>
            //                             const Color(0xff009150).withOpacity(0.1),
            //                       ),
            //                       //COLUMN HEADERS
            //                       columns:  [
            //                         DataColumn(
            //                           label: Expanded(
            //                             child: GestureDetector(
            //                               onTap: () {
            //                                 // _sortData(0, !_sortAscending);
            //                               },
            //                               child: const Row(
            //                                 mainAxisAlignment: MainAxisAlignment.center,
            //                                 children: [
            //                                   Text(
            //                                     'New CID',
            //                                     style: TextStyle(
            //                                       fontFamily: 'RobotoThin',
            //                                       fontSize: 15,
            //                                       color: Color(0xff1E5128),
            //                                       fontWeight: FontWeight.bold,
            //                                     ),
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                         const DataColumn(
            //                           label: Expanded(
            //                             child: Row(
            //                               mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                               children: [
            //                                 Text(
            //                                   'Area',
            //                                   style: TextStyle(
            //                                       fontFamily: 'RobotoThin',
            //                                       // fontWeight: FontWeight.bold,
            //                                       fontSize: 15,
            //                                       color: Color(0xff1E5128),
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                         const DataColumn(
            //                           label: Expanded(
            //                             child: Row(
            //                               mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                               children: [
            //                                 Text(
            //                                   'New Branch Code',
            //                                   style: TextStyle(
            //                                       fontFamily: 'RobotoThin',
            //                                       // fontWeight: FontWeight.bold,
            //                                       fontSize: 15,
            //                                       color: Color(0xff1E5128),
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                         const DataColumn(
            //                           label: Expanded(
            //                             child: Row(
            //                               mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                               children: [
            //                                 Text(
            //                                   'Unit',
            //                                   style: TextStyle(
            //                                       fontFamily: 'RobotoThin',
            //                                       // fontWeight: FontWeight.bold,
            //                                       fontSize: 15,
            //                                       color: Color(0xff1E5128),
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                         const DataColumn(
            //                           label: Expanded(
            //                             child: Row(
            //                               mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                               children: [
            //                                 Text(
            //                                   'Center Name',
            //                                   style: TextStyle(
            //                                       fontFamily: 'RobotoThin',
            //                                       // fontWeight: FontWeight.bold,
            //                                       fontSize: 15,
            //                                       color: Color(0xff1E5128),
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                         const DataColumn(
            //                           label: Expanded(
            //                             child: Row(
            //                               mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                               children: [
            //                                 Text(
            //                                   'Esystem CID',
            //                                   style: TextStyle(
            //                                       fontFamily: 'RobotoThin',
            //                                       // fontWeight: FontWeight.bold,
            //                                       fontSize: 15,
            //                                       color: Color(0xff1E5128),
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                         const DataColumn(
            //                           label: Expanded(
            //                             child: Row(
            //                               mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                               children: [
            //                                 Text(
            //                                   'Contact',
            //                                   style: TextStyle(
            //                                       fontFamily: 'RobotoThin',
            //                                       // fontWeight: FontWeight.bold,
            //                                       fontSize: 15,
            //                                       color: Color(0xff1E5128),
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                         const DataColumn(
            //                           label: Expanded(
            //                             child: Row(
            //                               mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                               children: [
            //                                 Text(
            //                                   'Last Name',
            //                                   style: TextStyle(
            //                                       fontFamily: 'RobotoThin',
            //                                       // fontWeight: FontWeight.bold,
            //                                       fontSize: 15,
            //                                       color: Color(0xff1E5128),
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                         const DataColumn(
            //                           label: Expanded(
            //                             child: Row(
            //                               mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                               children: [
            //                                 Text(
            //                                   'First Name',
            //                                   style: TextStyle(
            //                                       fontFamily: 'RobotoThin',
            //                                       // fontWeight: FontWeight.bold,
            //                                       fontSize: 15,
            //                                       color: Color(0xff1E5128),
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                         const DataColumn(
            //                           label: Expanded(
            //                             child: Row(
            //                               mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                               children: [
            //                                 Text(
            //                                   'Middle Name',
            //                                   style: TextStyle(
            //                                       fontFamily: 'RobotoThin',
            //                                       // fontWeight: FontWeight.bold,
            //                                       fontSize: 15,
            //                                       color: Color(0xff1E5128),
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                         const DataColumn(
            //                           label: Expanded(
            //                             child: Row(
            //                               mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                               children: [
            //                                 Text(
            //                                   'Birthday',
            //                                   style: TextStyle(
            //                                       fontFamily: 'RobotoThin',
            //                                       // fontWeight: FontWeight.bold,
            //                                       fontSize: 15,
            //                                       color: Color(0xff1E5128),
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                         const DataColumn(
            //                           label: Expanded(
            //                             child: Row(
            //                               mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                               children: [
            //                                 Text(
            //                                   'Recognized Date',
            //                                   style: TextStyle(
            //                                       fontFamily: 'RobotoThin',
            //                                       // fontWeight: FontWeight.bold,
            //                                       fontSize: 15,
            //                                       color: Color(0xff1E5128),
            //                                       fontWeight: FontWeight.bold),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ),
            //                       ],
            //                       rows: getPaginatedRows([]),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  void showBatchUploadConfirmAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Batch Delisting Confirmation",
        contentText: "Are you sure you want to delist $selectedFileName ?",
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
        titleColor: AppColors.maroon2,
        iconColor: Colors.white,
      ),
    );
  }

  void showUploadFileAlertDialog({required bool isSuccess, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        titleText: isSuccess ? 'File Uploaded Successfully' : 'File Upload Failed',
        contentText: message,
        positiveButtonText: isSuccess ? "Done" : "Retry",
        positiveOnPressed: () async {
          Navigator.of(context).pop();
        },
        iconData: isSuccess ? Icons.check_circle_outline : Icons.error_outline,
        titleColor: AppColors.maroon2,
        iconColor: Colors.white,
      ),
    );
  }
}
