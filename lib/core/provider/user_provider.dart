import 'dart:async';

import 'package:flutter/material.dart';

import '../models/user_management/user_model.dart';
import '../service/user_api.dart';

class UserProvider extends ChangeNotifier {
  List<AllUserData> _user = [];
  List<AllUserData> _currentUsers = [];
  List<AllUserData> _filteredUsers = [];
  Map<int, bool> switchStates = {};
  Timer? _timer;
  String? _userRole;
  bool isLoggedOut = false;
  bool isTimerStarted = false;

  int _currentPage = 0;
  int _totalPages = 0;
  int _totalRecords = 0;
  int pageSize = 10;

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalRecords => _totalRecords;
  List<AllUserData> get user => _user;
  List<AllUserData> get currentUsers => _currentUsers;
  String? get userRole => _userRole;

  Future<void> fetchAllUsers() async {
    try {
      List<AllUserData> allUsers = await UserAPI.getAllUser();
      // Sort users by ID in descending order
      allUsers.sort((a, b) => b.id!.compareTo(a.id!)); //================Date Added : 6-17 ; Lea===================//

      // Concatenate full names for each user
      // for (var user in allUsers) {
      //   user.fullName = '${user.firstName} ${user.middleName != null ? '${user.middleName?[0]}.' : ''} ${user.lastName}';
      // }
      _user = allUsers;
      _filteredUsers = allUsers;
      _totalRecords = _filteredUsers.length;
      _totalPages = (_totalRecords / pageSize).ceil(); // Calculate total pages based on pageSize
      _updateCurrentUsers();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Set<String> getDistinctUsernames() {
    Set<String> distinctUsernames = {};
    for (var user in _user) {
      if (user.username != null && user.username!.isNotEmpty) {
        distinctUsernames.add(user.username!);
      }
    }
    return distinctUsernames;
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
    _currentUsers = _filteredUsers.sublist(
      startIndex,
      endIndex > _filteredUsers.length ? _filteredUsers.length : endIndex,
    );

    // Update switch states for current users
    switchStates = {for (var user in _currentUsers) user.id!: user.status?.toLowerCase() == 'active'};

    notifyListeners();
  }

  void nextPage() {
    if ((_currentPage + 1) * pageSize < _user.length) {
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

  // void searchUsers(String query) {
  //   print('Search query: $query');
  //
  //   List<AllUserData> filteredUsers = [];
  //
  //   // Filter users whose full name contains the query (case-insensitive)
  //   String queryLowerCase = query.toLowerCase();
  //   filteredUsers.addAll(_user.where((userData) {
  //     bool matches = userData.fullName.toLowerCase().contains(queryLowerCase);
  //     print('Checking user: ${userData.fullName} - Matches: $matches');
  //     return matches;
  //   }));
  //
  //   _filteredUsers = filteredUsers;
  //   _totalRecords = _filteredUsers.length;
  //   _totalPages = (_totalRecords / pageSize).ceil();
  //   _currentPage = 0; // Reset to first page whenever search query changes
  //   _updateCurrentUsers();
  //   notifyListeners();
  // }

  AllUserData? _fetchUser;
  // String get brCode => _fetchUser?.brCode ?? '';
  // String get unitCode => _fetchUser?.unitCode ?? '';
  // String get centerCode => _fetchUser?.centerCode ?? '';
  // String get staffID => _fetchUser?.staffID ?? '';
  // String get cid => _fetchUser?.cid ?? '';
  // String get firstName => _fetchUser?.firstName ?? '';
  // String get middleName => _fetchUser?.middleName ?? '';
  // String get lastName => _fetchUser?.lastName ?? '';
  // String get position => _fetchUser?.position ?? '';
  // String get institution => _fetchUser?.institution ?? '';
  // String get email => _fetchUser?.emailAddress ?? '';
  // String get contact => _fetchUser?.mobileNumber ?? '';
  // String get role => _fetchUser?.userRole ?? '';
  // String get userName => _fetchUser?.username ?? '';

  //mfi_whitelist_admin_portal
  //
  String get mwapinstiID => _fetchUser?.institution ?? '';
  String get mwaphcisID => _fetchUser?.hcisId ?? '';
  String get mwaproleID => _fetchUser?.role ?? '';
  String get mwapfname => _fetchUser?.firstName ?? '';
  String get mwapmname => _fetchUser?.middleName ?? '';
  String get mwaplname => _fetchUser?.lastName ?? '';
  String get mwapposition => _fetchUser?.position ?? '';
  String get mwapemail => _fetchUser?.email ?? '';
  String get mwapusername => _fetchUser?.username ?? '';
  String get mwapbranch => _fetchUser?.branch ?? '';
  String get mwapunit => _fetchUser?.unit ?? '';
  String get mwapcenter => _fetchUser?.centerCode ?? '';
  String get mwapcontact => _fetchUser?.contact ?? '';
  String get mwapbirthday => _fetchUser?.birthday ?? '';

  //

  //FOR EDITING A USER INFO
  Future<AllUserData> fetchSingleUser(int id) async {
    try {
      final userInfoByID = await UserAPI.getUserByID(id);
      if (userInfoByID != null) {
        _fetchUser = userInfoByID;
        notifyListeners();
        return userInfoByID;
      } else {
        notifyListeners();
        throw Exception('No user data available for ID: $id');
      }
    } catch (error) {
      rethrow;
    }
  }

  //FOR DISPLAYING INFO IN USER PROFILE
  Future<AllUserData> displayUserInfoToProfile(String hcis) async {
    try {
      final userInfoByHCIS = await UserAPI.getInfoToProfile(hcis);
      if (userInfoByHCIS != null) {
        _fetchUser = userInfoByHCIS;
        notifyListeners();
        return userInfoByHCIS;
      } else {
        // debugPrint('NO DATA AVAILABLE');
        notifyListeners();
        throw Exception('No user data available for ID: $hcis');
      }
    } catch (error) {
      rethrow;
    }
  }

  // // Get the status of a user by their ID
  //date change june 13, 2024
  String? getUserStatus(int userId) {
    final user = _user.firstWhere((user) => user.id == userId); // Find the user in the list of users
    return user.status;
  }

//SWITCHING USER ACTIVE/DEACTIVATE
  Future<bool> setUserStatus(int userId, String token, bool activate) async {
    try {
      final success = await UserAPI.switchUserStatus(userId, token, activate);
      //date change june 13, 2024
      if (success) {
        final userToUpdate = _user.firstWhere((user) => user.id == userId);
        userToUpdate.status = userToUpdate.status == 'Active' ? 'Inactive' : 'Active';
        notifyListeners();
      } else {
        debugPrint('Failed to update user status via API');
      }
      return success;
    } catch (error) {
      return false;
    }
  }

  // void startUserStatusCheck() {
  //   // Check if the user is logged in by checking the UID
  //   final hcis = getUId();
  //   if (hcis == null) {
  //     debugPrint('User is not logged in, not starting user status check.');
  //     return; // Exit early if the user is not logged in
  //   }
  //
  //   if (!isTimerStarted) {
  //     _timer = Timer.periodic(const Duration(seconds: 45), (Timer t) {
  //       _checkUserStatus();
  //       // debugPrint('_checkUserStatus executed');
  //     });
  //     isTimerStarted = true; // Set the flag to true once timer is started
  //   }
  // }
  //
  // Future<void> _checkUserStatus() async {
  //   try {
  //     // Check if the token is valid
  //     // final tokenService = TokenService();
  //     // final tokenStatus = await tokenService.checkTokenStatus();
  //     // if (tokenStatus != '200') {
  //     //   // Token is not valid, logout and handle accordingly
  //     //
  //     //   // debugPrint('Calling session dialog and logout');
  //     //   // const SessionAlertDialog();
  //     //   // Future.delayed(const Duration(seconds: 3), () {
  //     //   //   logout();
  //     //   // });
  //     //   return;
  //     // }
  //
  //     // Recheck if the user is logged in by checking the UID
  //     final hcis = getUId();
  //     if (hcis == null) return;
  //
  //     final role = getUrole();
  //     final institution = getInstitution();
  //
  //     // Fetch user information from the API
  //     final userInfo = await displayUserInfoToProfile(hcis);
  //     // final String? savedUsername = await getSavedUsername();
  //     // final String? fetchedUsername = userInfo.username;
  //
  //     // debugPrint('Checking current user status');
  //     //date change june 13, 2024
  //     // if (userInfo.status == 'Inactive') {
  //     //   // debugPrint('User is inactive, will logout!');
  //     //   handleUserDeactivationDialog();
  //     //   handleDeactivationAndLogout();
  //     // } else {
  //     //   debugPrint('User is active.');
  //     // }
  //
  //     // debugPrint('Checking current user role');
  //     // Check if the user role has changed
  //     //date change june 13, 2024
  //     // if (userInfo.userRole != role) {
  //     //   // If the role has changed, update local storage and rebuild the UI
  //     //   html.window.localStorage['userrole'] = userInfo.userRole!;
  //     //   // debugPrint('User role has changed to ${userInfo.userRole}');
  //     //   handleChangeInRoleDialog();
  //     // } else {
  //     //   debugPrint('User role has not changed');
  //     // }
  //
  //     // Fetch role information to check its status
  //     final roleProvider = UserRoleProvider();
  //     await roleProvider.fetchRoleInfoByTitle(role!);
  //     final fetchedRole = roleProvider.editUserRole;
  //
  //     if (fetchedRole != null && fetchedRole['status'] == 'Active') {
  //       debugPrint('The $role is active');
  //       // listenToAccessChanges(role);
  //     } else {
  //       // debugPrint('The $role is inactive.');
  //       handleRoleDeactivationDialog();
  //       handleDeactivationAndLogout();
  //     }
  //
  //     // debugPrint('Checking current user institution');
  //     // Check if the user institution has changed
  //     //date change june 13, 2024
  //     // if (userInfo.institution != institution) {
  //     //   // If the institution has changed, update local storage and rebuild the UI
  //     //   html.window.localStorage['insti'] = userInfo.institution!;
  //     //   // debugPrint('User institution has changed to ${userInfo.institution}');
  //     //   handleChangeInstitutionDialog();
  //     // } else {
  //     //   debugPrint('User institution has not changed');
  //     // }
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
  //
  // void handleDeactivationAndLogout() {
  //   _timer?.cancel(); // Stop the timer
  //   isTimerStarted = false;
  //   isLoggedOut = true;
  //   notifyListeners();
  //   Timer(const Duration(seconds: 10), () {
  //     logout();
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   super.dispose();
  // }
}

class UserByStaffIDProvider extends ChangeNotifier {
  GetUserByStaffID? getUserByStaffID;

  // String get cid => getUserByStaffID?.cid ?? '';
  String get fname => getUserByStaffID?.firstName ?? '';
  String get mname => getUserByStaffID?.middleName ?? '';
  String get lname => getUserByStaffID?.lastName ?? '';
  String get contact => getUserByStaffID?.mobileNumber ?? '';
  String get email => getUserByStaffID?.email ?? '';

  // Future<void> fetchUserDataByStaffID(String staffID) async {
  //   try {
  //     getUserByStaffID = await UserAPI.getUserByStaffID(staffID);
  //     notifyListeners();
  //   } catch (e) {
  //     getUserByStaffID = null;
  //     notifyListeners();
  //     rethrow; // rethrow the exception to handle it in the UI
  //   }
  // }
  //
  // Future<bool> fetchUserDataByStaffID(String staffID) async {
  //   try {
  //     getUserByStaffID = await UserAPI.getUserByStaffID(staffID);
  //     notifyListeners();
  //     return getUserByStaffID != null; // Return true if data is not null
  //   } catch (e) {
  //     getUserByStaffID = null;
  //     notifyListeners();
  //     rethrow; // rethrow the exception to handle it in the UI
  //   }
  // }

  void clearAllData() {
    getUserByStaffID = GetUserByStaffID(
      // cid: '',
      // lastName: '', firstName: '', middleName: '', email: '', mobileNumber: ''
      //mfi_whitelist_admin_portal
      mwapinstiID: 0,
      mwapHCISiD: '',
      mwaproleID: 0,
      mwapfname: '',
      mwapmname: '',
      mwaplname: '',
      mwapposition: '',
      mwapemail: '',
      mwapusername: '',
      mwapcontact: '',
      mwapbranch: '',
      mwapunit: '',
      mwapcenter: '',
      mwapbirthday: '',
    );
    notifyListeners();
  }
}
