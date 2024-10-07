import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/core/mfi_whitelist_api/clients/fetch_client_list_api.dart';
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/allFilesModel.dart';
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/clientModel.dart';
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/whitelistModel.dart';

import '../../../ui/shared/sessionmanagement/gettoken/gettoken.dart';

class MFIClientProvider extends ChangeNotifier {
  late final FetchClientDataApiService apiService;

  ///GET SINGLE CLIENT
  Client? _client;
  final ClientService _clientApi = ClientService();
  Client? get client => _client;

  List<AllUploadedFileData> _allFiles = [];
  List<AllUploadedFileData> _currentUsers = [];
  List<AllUploadedFileData> _filteredFiles = [];
  List<RowData> _allData = []; // Store all fetched data
  List<RowData> _filteredData = []; // Store filtered data for display
  List<RowData> apiData = [];
  List<String> displayFileName = [];
  String? _allFilesRole;
  bool isLoggedOut = false;
  bool isTimerStarted = false;
  bool isLoading = false;
  String? selectedFileName;

  int _currentPage = 0;
  int _totalPages = 0;
  int _totalRecords = 0;
  int pageSize = 10;

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalRecords => _totalRecords;
  List<AllUploadedFileData> get allFiles => _allFiles;
  List<AllUploadedFileData> get currentUsers => _currentUsers;
  String? get userRole => _allFilesRole;

  ///GET ALL THE UPLOADED FILES
  Future<void> fetchAllFiles() async {
    try {
      List<AllUploadedFileData> allUploadedFiles = await FetchClientListAPI.fetchAllUploadedFiles();
      // Sort users by ID in descending order
      allUploadedFiles.sort((a, b) => b.batchUploadId!.compareTo(a.batchUploadId!));
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

  AllUploadedFileData? _fetchFile;
  //mfi_whitelist_admin_portal
  int get mwapBatchUploadID => _fetchFile?.batchUploadId ?? 0;
  String get mwapFileName => _fetchFile?.fileName ?? '';
  String get mwapDateAndTimeUploaded => _fetchFile?.dateAndTimeUploaded ?? '';
  String get mwapMaker => _fetchFile?.maker ?? '';
  String get mwapChecker => _fetchFile?.checker ?? '';
  String get mwapStatus => _fetchFile?.status ?? '';
  String get mwapRemarks => _fetchFile?.remarks ?? '';
  String get mwapDateCreated => _fetchFile?.createdAt ?? '';
  String get mwapDateUpdated => _fetchFile?.updatedAt ?? '';
  String get mwapDateDeleted => _fetchFile?.deletedAt ?? '';

//SEARCH FOR FILES
  Future<void> searchFiles({String searchQuery = ''}) async {
    try {
      List<AllUploadedFileData> allUploadedFiles = await FetchClientListAPI.searchAllUploadedFiles(searchQuery);
      // Sort users by ID in descending order
      allUploadedFiles.sort((a, b) => b.batchUploadId!.compareTo(a.batchUploadId!));
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

  ///New line of code Aug 15
  Future<void> fetchData(int page, String perPage, String selectedFileName) async {
    final token = getToken(); // Implement getToken to get the auth token
    final responseData = await apiService.fetchData(
      endpoint: 'clients/test/get/all/approved',
      queryParams: {
        'page': '$page',
        'perPage': perPage,
        'file_name': selectedFileName,
      },
      token: token!,
    );

    if (responseData['retCode'] == '200') {
      final data = responseData['data'];
      if (data is List) {
        apiData = List<RowData>.from(data.map((item) => RowData(
              isEditing: false,
              data: Map<String, dynamic>.from(item),
            )));
        _totalRecords = responseData['totalRecords'];
        _totalPages = (totalRecords / int.parse(perPage)).ceil();
      } else {
        debugPrint('JSON data is not in the expected format');
        apiData = []; // Clear existing data
      }
    } else {
      debugPrint('No data available');
      apiData = []; // Clear existing data
    }
  }

  Future<void> fetchDistinct() async {
    try {
      final token = getToken(); // Implement getToken to get the auth token
      final responseData = await apiService.fetchData(
        endpoint: 'filters/test/get/all/distinct/approved',
        token: token!,
      );

      List<String> file = [];
      if (responseData['distinctData'] != null) {
        for (var item in responseData['distinctData']) {
          if (item['fileName'] != null) {
            file.add(item['fileName']);
          }
        }
      }

      displayFileName = file;
      notifyListeners();

      debugPrint('Success fetching distinct data');
    } catch (error) {
      debugPrint('Error fetching distinct data: $error');
    }
  }

  Future<void> searchClient(String query) async {
    if (query.isEmpty) {
      _filteredData = _allData;
    } else {
      _filteredData = _allData.where((rowData) {
        // Convert rowData.data to Map<String, dynamic> and check if any value matches the query
        final data = rowData.data;

        // Check if the cid or any other field contains the query
        final cidMatch = (data['cid'] ?? '').toString().contains(query);
        final otherFieldsMatch = data.values.any((value) => value.toString().toLowerCase().contains(query.toLowerCase()));

        return cidMatch || otherFieldsMatch;
      }).toList();
    }

    _totalRecords = _filteredData.length;
    _totalPages = (_totalRecords / pageSize).ceil();
    _currentPage = 0; // Reset to first page after search
    _updateCurrentPageData();
    notifyListeners();
  }

  void _updateCurrentPageData() {
    final startIndex = _currentPage * pageSize;
    final endIndex = startIndex + pageSize;
    apiData = _filteredData.sublist(
      startIndex,
      endIndex > _filteredData.length ? _filteredData.length : endIndex,
    );
  }

  List<String> _selectedRowsCids = [];

  List<String> get selectedRowsCids => _selectedRowsCids;

  void toggleRow(String cid) {
    if (_selectedRowsCids.contains(cid)) {
      _selectedRowsCids.remove(cid);
      print(cid);
    } else {
      _selectedRowsCids.add(cid);
      print(cid);
    }
    notifyListeners(); // Notify all listening widgets to rebuild
  }

  bool isRowSelected(String cid) {
    return _selectedRowsCids.contains(cid);
  }

  void clearSelection() {
    _selectedRowsCids.clear();
    notifyListeners();
  }

  ///GET SINGLE CLIENT FOR APPROVE TABLE
  // Future<void> getClientData(int cid) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     _client = await _clientApi.fetchClientData(cid.toString());
  //   } catch (error) {
  //     debugPrint(error.toString());
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
