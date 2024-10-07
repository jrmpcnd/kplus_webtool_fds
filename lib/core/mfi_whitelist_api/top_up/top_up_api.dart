import 'dart:convert';
import 'dart:io'; // For SocketException
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/mfi_whitelist_api/api_endpoints.dart';
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/top_up_model.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';

class TopUpApiService {
  final token = getToken();
  Future<ClientRetData> inquireClientData(int cid) async {
    String url = MFIApiEndpoints.mfiInquireClient;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Authorization': '$token'},
        body: jsonEncode({'cid': cid}),
      );

      if (response.statusCode == 200) {
        return ClientRetData.fromJson(json.decode(response.body));
      } else {
        debugPrint('Failed to inquire client: ${json.decode(response.body)}');
        // throw const HttpException('Failed to load data of the inquired CID.');
        throw HttpException('Error ${response.statusCode}: ${json.decode(response.body)['message'] ?? 'Unknown error'}');
      }
    } on SocketException {
      // Handle network-related exceptions (e.g., server down or disconnected)
      throw Exception('No Internet connection. Please check your network.');
    } on HttpException catch (e) {
      // Handle HTTP-related exceptions
      throw Exception(e.message);
    } on FormatException {
      // Handle formatting exceptions (e.g., invalid JSON)
      throw Exception('Server response was not in the expected format.');
    } catch (e) {
      // Handle any other exceptions
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> topUpRequest(String acctNumber, double topUpAmount) async {
    String url = MFIApiEndpoints.mfiTopUpClient;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Authorization': '$token'},
        body: jsonEncode({'accountNumber': acctNumber, 'amount': topUpAmount}),
      );

      if (response.statusCode == 200) {
        print(json.decode(response.body));
        return json.decode(response.body);
      } else {
        print(json.decode(response.body));
        throw HttpException('Failed to load top up data - Status Code: ${response.statusCode}');
      }
    } on SocketException {
      // Handle network-related exceptions (e.g., server down or disconnected)
      throw Exception('No Internet connection. Please check your network.');
    } on HttpException catch (e) {
      // Handle HTTP-related exceptions
      throw Exception(e.message);
    } on FormatException {
      // Handle formatting exceptions (e.g., invalid JSON)
      throw Exception('Server response was not in the expected format.');
    } catch (e) {
      // Handle any other exceptions
      throw Exception('An unexpected error occurred: $e');
    }
  }

  ///BATCH TOP UP
  Future<Map<String, dynamic>> fetchTopUps(Uint8List fileBytes, String fileName) async {
    final url = Uri.parse(MFIApiEndpoints.mfiPreviewBatchTopUp);

    final request = http.MultipartRequest('POST', url);
    final token = getToken();
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseStream = await response.stream.toBytes();
      final responseData = utf8.decode(responseStream);
      final Map<String, dynamic> jsonResponse = json.decode(responseData);
      final List<dynamic> data = jsonResponse['data'];

      // Map JSON data to TopUpData model
      List<TopUpData> topUpList = data.map((item) => TopUpData.fromJson(item)).toList();

      // Calculate the total amount
      double totalAmount = calculateTotalAmount(topUpList);

      // Access the total records from the JSON response
      int totalRecords = jsonResponse['totalRecords'] ?? 0;

      // Return both the top-up data and the total amount
      return {
        'topUps': topUpList,
        'totalAmount': totalAmount,
        'totalRecords': totalRecords,
      };
    } else {
      throw Exception('Failed to load top-ups');
    }
  }

  Future<Map<String, dynamic>> fetchBatchTopUpResults(Uint8List fileBytes, String fileName) async {
    print('Api was called');
    final url = Uri.parse(MFIApiEndpoints.mfiBatchTopUpRequest);

    final request = http.MultipartRequest('POST', url);
    final token = getToken();
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ),
    );

    try {
      final response = await request.send();

      // Log the status code and reason phrase
      print('Response status: ${response.statusCode}');
      print('Response reason: ${response.reasonPhrase}');

      // Read the response body
      final responseStream = await response.stream.toBytes();
      final responseData = utf8.decode(responseStream);

      // Print the response body for debugging
      print('Response body: $responseData');

      // Extract the response status code
      final int statusCode = response.statusCode;

      final Map<String, dynamic> jsonResponse = json.decode(responseData);

      // Extract message and retCode
      final String message = jsonResponse['message'] ?? 'No message provided';
      final String retCode = jsonResponse['retCode'] ?? 'Unknown';

      print('Message: $message');
      print('Return Code: $retCode');

      // Check if 'data' is not null before accessing it
      final data = jsonResponse['data'];
      List<TopUpResult> successList = [];
      List<TopUpResult> failedList = [];

      if (data != null) {
        successList = (data['success'] as List<dynamic>?)?.map((item) => TopUpResult.fromJson(item)).toList() ?? [];

        failedList = (data['failed'] as List<dynamic>?)?.map((item) => TopUpResult.fromJson(item)).toList() ?? [];
      }

      // Compute the totals
      int totalSuccessClients = successList.length;
      int totalFailedClients = failedList.length;

      double totalSuccessAmount = successList.fold(0, (sum, item) => sum + item.amount);
      double totalFailedAmount = failedList.fold(0, (sum, item) => sum + item.amount);

      return {
        'successList': successList,
        'failedList': failedList,
        'totalSuccessClients': totalSuccessClients,
        'totalFailedClients': totalFailedClients,
        'totalSuccessAmount': totalSuccessAmount,
        'totalFailedAmount': totalFailedAmount,
        'message': message, // Add message to return
        'retCode': retCode, // Add retCode to return
        'statusCode': statusCode, // Add statusCode to return
      };
    } catch (e) {
      print('Error occurred: $e');
      throw e; // Rethrow the error for further handling if necessary
    }
  }

  ///BATCH DISBURSE
  Future<Map<String, dynamic>> fetchDisburse(Uint8List fileBytes, String fileName) async {
    final url = Uri.parse(MFIApiEndpoints.mfiPreviewBatchDisburse);

    final request = http.MultipartRequest('POST', url);
    final token = getToken();
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseStream = await response.stream.toBytes();
      final responseData = utf8.decode(responseStream);
      final Map<String, dynamic> jsonResponse = json.decode(responseData);
      final List<dynamic> data = jsonResponse['data'];

      // Map JSON data to TopUpData model
      List<TopUpData> topUpList = data.map((item) => TopUpData.fromJson(item)).toList();

      // Calculate the total amount
      double totalAmount = calculateTotalAmount(topUpList);

      // Access the total records from the JSON response
      int totalRecords = jsonResponse['totalRecords'] ?? 0;

      // Return both the top-up data and the total amount
      return {
        'topUps': topUpList,
        'totalAmount': totalAmount,
        'totalRecords': totalRecords,
      };
    } else {
      throw Exception('Failed to load top-ups');
    }
  }

  Future<Map<String, dynamic>> fetchBatchDisburseResults(Uint8List fileBytes, String fileName) async {
    print('Api was called');
    final url = Uri.parse(MFIApiEndpoints.mfiBatchDisburseRequest);

    final request = http.MultipartRequest('POST', url);
    final token = getToken();
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ),
    );

    try {
      final response = await request.send();

      // Log the status code and reason phrase
      print('Response status: ${response.statusCode}');
      print('Response reason: ${response.reasonPhrase}');

      // Read the response body
      final responseStream = await response.stream.toBytes();
      final responseData = utf8.decode(responseStream);

      // Print the response body for debugging
      print('Response body: $responseData');

      // Extract the response status code
      final int statusCode = response.statusCode;

      final Map<String, dynamic> jsonResponse = json.decode(responseData);

      // Extract message and retCode
      final String message = jsonResponse['message'] ?? 'No message provided';
      final String retCode = jsonResponse['retCode'] ?? 'Unknown';

      print('Message: $message');
      print('Return Code: $retCode');

      // Check if 'data' is not null before accessing it
      final data = jsonResponse['data'];
      List<TopUpResult> successList = [];
      List<TopUpResult> failedList = [];

      if (data != null) {
        successList = (data['success'] as List<dynamic>?)?.map((item) => TopUpResult.fromJson(item)).toList() ?? [];

        failedList = (data['failed'] as List<dynamic>?)?.map((item) => TopUpResult.fromJson(item)).toList() ?? [];
      }

      // Compute the totals
      int totalSuccessClients = successList.length;
      int totalFailedClients = failedList.length;

      double totalSuccessAmount = successList.fold(0, (sum, item) => sum + item.amount);
      double totalFailedAmount = failedList.fold(0, (sum, item) => sum + item.amount);

      return {
        'successList': successList,
        'failedList': failedList,
        'totalSuccessClients': totalSuccessClients,
        'totalFailedClients': totalFailedClients,
        'totalSuccessAmount': totalSuccessAmount,
        'totalFailedAmount': totalFailedAmount,
        'message': message, // Add message to return
        'retCode': retCode, // Add retCode to return
        'statusCode': statusCode, // Add statusCode to return
      };
    } catch (e) {
      print('Error occurred: $e');
      throw e; // Rethrow the error for further handling if necessary
    }
  }

// Helper function to calculate total amount
  double calculateTotalAmount(List<TopUpData> dataList) {
    return dataList.fold(0.0, (sum, item) => sum + item.amount);
  }
}
