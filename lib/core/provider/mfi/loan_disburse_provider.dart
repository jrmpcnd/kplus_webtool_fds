import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/core/mfi_whitelist_api/loan_disburse_api.dart';
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/disburse_model.dart';

class LoanDisbursementProvider extends ChangeNotifier {
  List<UploadedLoanDisburseFile> _allFiles = [];
  List<UploadedLoanDisburseFile> _currentUsers = [];
  List<UploadedLoanDisburseFile> _filteredFiles = [];
  String? _allFilesRole;

  int _currentPage = 0;
  int _totalPages = 0;
  int _totalRecords = 0;
  int pageSize = 10;

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalRecords => _totalRecords;
  List<UploadedLoanDisburseFile> get allFiles => _allFiles;
  List<UploadedLoanDisburseFile> get currentUsers => _currentUsers;
  String? get userRole => _allFilesRole;

  Future<void> fetchAllFiles() async {
    try {
      List<UploadedLoanDisburseFile> allUploadedFiles = await LoanDisbursementAPIs.fetchAllUploadedDisburseFiles();
      // Sort users by ID in descending order
      allUploadedFiles.sort((a, b) => b.batchLoanDisbursementFileId!.compareTo(a.batchLoanDisbursementFileId!));
      _allFiles = allUploadedFiles;
      _filteredFiles = allUploadedFiles;
      _totalRecords = _filteredFiles.length;
      _totalPages = (_totalRecords / pageSize).ceil(); // Calculate total pages based on pageSize
      _updateCurrentUsers();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void updatePageSize(int value) {
    pageSize = value;
    _currentPage = 0; // Reset to first page
    _totalPages = (_totalRecords / pageSize).ceil();
    _updateCurrentUsers();
    notifyListeners();
  }

  void _updateCurrentUsers() {
    final startIndex = currentPage * pageSize;
    final endIndex = startIndex + pageSize;
    _currentUsers = _filteredFiles.sublist(
      startIndex,
      endIndex > _filteredFiles.length ? _filteredFiles.length : endIndex,
    );
    notifyListeners();
  }

  void nextPage() {
    if ((_currentPage + 1) * pageSize < _allFiles.length) {
      _currentPage++;
      _updateCurrentUsers();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _updateCurrentUsers();
    }
  }

//SEARCH FOR FILES
  Future<void> searchFiles({String searchQuery = ''}) async {
    try {
      List<UploadedLoanDisburseFile> allUploadedFiles = await LoanDisbursementAPIs.searchAllUploadedDisburseFiles(searchQuery);
      // Sort users by ID in descending order
      allUploadedFiles.sort((a, b) => b.batchLoanDisbursementFileId!.compareTo(a.batchLoanDisbursementFileId!));
      _allFiles = allUploadedFiles;
      _filteredFiles = allUploadedFiles;
      _totalRecords = _filteredFiles.length;
      _totalPages = (_totalRecords / pageSize).ceil(); // Calculate total pages based on pageSize
      _updateCurrentUsers();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void searchFromFile(String query) {
    if (query.isEmpty) {
      _filteredFiles = _allFiles;
    } else {
      _filteredFiles = _allFiles.where((file) {
        return file.fileName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    _totalRecords = _filteredFiles.length;
    _totalPages = (_totalRecords / pageSize).ceil();
    _currentPage = 0; // Reset to first page after search
    _updateCurrentUsers();
    notifyListeners();
  }
}
