import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/core/mfi_whitelist_api/top_up/top_up_api.dart';
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/top_up_model.dart';

class TopUpProvider with ChangeNotifier {
  final apiService = TopUpApiService();
  ClientRetData? _clientData; // Change type to ClientRetData
  String? _errorMessage;
  String? successfulMessage;
  List<TopUpData> _topUps = [];
  List<TopUpResult> _successList = [];
  List<TopUpResult> _failedList = [];
  int _totalSuccessClients = 0;
  int _totalFailedClients = 0;
  double _totalSuccessAmount = 0;
  double _totalFailedAmount = 0;
  double _totalAmount = 0.0; // Variable to store total amount
  int _totalRecords = 0;
  String _uploadStatus = '';
  Color _uploadStatusColor = Colors.transparent;
  bool _isLoading = false;
  String _message = '';
  String _retCode = '';

  List<TopUpData> get topUps => _topUps;
  ClientRetData? get clientData => _clientData;
  List<TopUpResult> get successList => _successList;
  List<TopUpResult> get failedList => _failedList;

  String get message => _message;
  String get retCode => _retCode;
  String? get errorMessage => _errorMessage;
  String get uploadStatus => _uploadStatus;
  Color get uploadStatusColor => _uploadStatusColor;
  bool get isLoading => _isLoading;

  int get totalRecords => _totalRecords;
  int get totalSuccessClients => _totalSuccessClients;
  int get totalFailedClients => _totalFailedClients;
  int get totalClients => _totalSuccessClients + _totalFailedClients;

  double get totalSuccessAmount => _totalSuccessAmount;
  double get totalFailedAmount => _totalFailedAmount;
  double get totalAmount => _totalAmount;

  Future<void> inquireClientData(int cid) async {
    try {
      _clientData = await apiService.inquireClientData(cid);
      _errorMessage = null; // Clear error message on success
    } catch (e) {
      // Categorize errors
      if (e.toString().contains('No Internet connection')) {
        _errorMessage = 'Please check your internet connection and try again.';
      } else if (e.toString().contains('Error 400')) {
        _errorMessage = 'Client data could not be found. Please verify the CID.';
      } else if (e.toString().contains('Error 500')) {
        _errorMessage = 'Server is currently down. Please try again later.';
      } else {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      }

      _clientData = null; // Clear client data on error
      debugPrint('Provider error: $_errorMessage');
    }

    notifyListeners();
  }

  Future<void> requestTopUp(String accountNumber, double amount) async {
    final apiService = TopUpApiService();

    try {
      final response = await apiService.topUpRequest(accountNumber, amount);
      successfulMessage = response['message']; // "Successful Top Up"

      // Optionally clear error message if successful
      _errorMessage = null;
    } catch (e) {
      // Handle any exceptions that occur during the API call
      _errorMessage = 'Unexpected error: ${e.toString()}';
      debugPrint('Provider request error: $_errorMessage');
      notifyListeners();
    }
  }

  /// Fetches top-ups from the API using multipart file upload.
  Future<void> fetchTopUps(Uint8List fileBytes, String fileName) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Call the API service method and expect a Map<String, dynamic>
      final result = await apiService.fetchTopUps(fileBytes, fileName);

      // Extract top-ups and total amount from the result
      _topUps = result['topUps'] as List<TopUpData>;
      double totalAmount = result['totalAmount'];
      _totalRecords = result['totalRecords'];

      // Optionally, you can store the total amount in a state variable if needed
      _totalAmount = totalAmount; // Assuming you have a variable for total amount
      _isLoading = false;
    } catch (e) {
      _uploadStatus = 'FAILED';
      _uploadStatusColor = Colors.red.shade600;
      _isLoading = false;
      debugPrint('Error fetching top-ups: $e'); // Optionally log the error
    } finally {
      _isLoading = false; // Ensure loading state is reset
      notifyListeners(); // Notify listeners for final state
    }
  }

  Future<void> fetchBatchTopUpResults(Uint8List fileBytes, String fileName) async {
    _isLoading = true;
    notifyListeners(); // Notify listeners for loading state
    final result = await apiService.fetchBatchTopUpResults(fileBytes, fileName);

    // Extract message and retCode from the result
    _message = result['message'] ?? 'No message provided';
    _retCode = result['retCode'] ?? 'Unknown';

    // Initialize lists to hold messages
    List<String> successMessages = [];
    List<String> failedMessages = [];

    if (_retCode == '200') {
      // Handle successful response
      _successList = result['successList'] as List<TopUpResult>;
      _failedList = result['failedList'] as List<TopUpResult>;
      _totalSuccessClients = result['totalSuccessClients'] as int;
      _totalFailedClients = result['totalFailedClients'] as int;
      _totalSuccessAmount = result['totalSuccessAmount'] as double;
      _totalFailedAmount = result['totalFailedAmount'] as double;

      // Extract messages from success and failed lists
      for (var account in _successList) {
        successMessages.add(account.message); // Assuming TopUpResult has a message field
      }
      for (var account in _failedList) {
        failedMessages.add(account.message); // Assuming TopUpResult has a message field
      }

      _uploadStatus = 'SUCCESS';
      _uploadStatusColor = Colors.green.shade600;
      _isLoading = false;
      notifyListeners();
    } else {
      _uploadStatus = 'FAILED';
      _uploadStatusColor = Colors.red.shade600;
      debugPrint('Error: $_message');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches disburse from the API using multipart file upload.
  Future<void> fetchDisburse(Uint8List fileBytes, String fileName) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Call the API service method and expect a Map<String, dynamic>
      final result = await apiService.fetchDisburse(fileBytes, fileName);

      // Extract top-ups and total amount from the result
      _topUps = result['topUps'] as List<TopUpData>;
      double totalAmount = result['totalAmount'];
      _totalRecords = result['totalRecords'];

      // Optionally, you can store the total amount in a state variable if needed
      _totalAmount = totalAmount; // Assuming you have a variable for total amount
      _isLoading = false;
    } catch (e) {
      _uploadStatus = 'FAILED';
      _uploadStatusColor = Colors.red.shade600;
      _isLoading = false;
      debugPrint('Error fetching top-ups: $e'); // Optionally log the error
    } finally {
      _isLoading = false; // Ensure loading state is reset
      notifyListeners(); // Notify listeners for final state
    }
  }

  Future<void> fetchBatchDisburseResults(Uint8List fileBytes, String fileName) async {
    _isLoading = true;
    notifyListeners(); // Notify listeners for loading state

    try {
      final result = await apiService.fetchBatchDisburseResults(fileBytes, fileName);

      // Extract message and retCode from the result
      _message = result['message'] ?? 'No message provided';
      _retCode = result['retCode'] ?? 'Unknown';

      if (_retCode == '200') {
        // Handle successful response
        _successList = result['successList'] as List<TopUpResult>;
        _failedList = result['failedList'] as List<TopUpResult>;
        _totalSuccessClients = result['totalSuccessClients'] as int;
        _totalFailedClients = result['totalFailedClients'] as int;
        _totalSuccessAmount = result['totalSuccessAmount'] as double;
        _totalFailedAmount = result['totalFailedAmount'] as double;

        _uploadStatus = 'SUCCESS';
        _uploadStatusColor = Colors.green.shade600;
      } else {
        _uploadStatus = 'FAILED';
        _uploadStatusColor = Colors.red.shade600;
        debugPrint('Error: $_message');
      }
    } finally {
      _isLoading = false; // Ensure loading state is reset
      notifyListeners(); // Notify listeners for final state
    }
  }

  Color getUploadStatusColor() {
    switch (_uploadStatus.toUpperCase()) {
      case 'UPLOADING':
      case 'PREVIEWED':
        return Colors.amber.shade600;
      case 'SUCCESS':
        return Colors.green.shade600; // Green color for Approved status
      case 'FAILED':
        return Colors.red.shade600; // Red color for Disapproved status
      default:
        return Colors.transparent; // Default color (you can change this as per your design)
    }
  }
}
