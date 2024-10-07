import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';

class BatchUploadMultipleFiles extends StatefulWidget {
  const BatchUploadMultipleFiles({super.key});

  @override
  State<BatchUploadMultipleFiles> createState() => _BatchUploadMultipleFilesState();
}

class _BatchUploadMultipleFilesState extends State<BatchUploadMultipleFiles> {
  List<File> selectedFiles = [];
  List<String> selectedFileNames = [];

  void openFileUploadDialog() {
    InputElement input = (FileUploadInputElement()..accept = '.csv') as InputElement;
    input.multiple = true;
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        setState(() {
          selectedFiles = files;
          selectedFileNames = files.map((file) => file.name).toList();
        });
        for (var file in files) {
          readCSVFile(file);
        }
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
      // processCSVContent(csvContent);
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
        };

        // Check if all required columns are present
        List<String> missingColumns = [];
        columnIndices.forEach((key, index) {
          if (index == -1) {
            missingColumns.add(key);
          }
        });

        if (missingColumns.isNotEmpty) {
          debugPrint('Missing columns: ${missingColumns.join(', ')}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV File Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: openFileUploadDialog,
              child: Text('Select CSV Files'),
            ),
            SizedBox(height: 20),
            selectedFileNames.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: selectedFileNames.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(selectedFileNames[index]),
                        );
                      },
                    ),
                  )
                : Text('No files selected'),
          ],
        ),
      ),
    );
  }
}
