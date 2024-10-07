import 'package:flutter/foundation.dart';

import '../models/user_management/roles_model.dart';
import '../service/role_api.dart';

class UserRoleProvider extends ChangeNotifier {
  List<Role> userRoles = [];
  // List<Role> get userRoles => _userRoles;
  Map<int, bool> switchStates = {};

  Future<void> fetchAllRoles() async {
    try {
      List<Role> rolesData = await UserRoleAPI.getAllUserRoleTitlesAndStatus();
      // Sort users by ID in descending order
      // rolesData.sort((a, b) => b.id.compareTo(a.id));
      userRoles = rolesData;
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching the list of roles: $error');
    }
  }

  Map<String, dynamic>? _editUserRole;
  Map<String, dynamic>? get editUserRole => _editUserRole;

  Future<void> fetchRoleInfoByTitle(String roleTitle) async {
    try {
      final Map<String, dynamic> fetchedRole = await UserRoleAPI.getAccessByRole(roleTitle);
      _editUserRole = fetchedRole;
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching the access of role with title $roleTitle: $error');
      _editUserRole = null;
      notifyListeners();
    }
  }

  // Role? _editUserRole;
  // Role? get editUserRole => _editUserRole;
  // Future<Role?> fetchRoleInfoByTitle(String roleTitle) async {
  //   try {
  //     final fetchedRoles = await UserRoleAPI.getAccessByRole(roleTitle);
  //     _editUserRole = fetchedRoles;
  //     notifyListeners();
  //   } catch (error) {
  //     debugPrint('Error fetching the access of role with title $roleTitle: $error');
  //   }
  // }

  String? getRoleStatus(int roleId) {
    // Get the status of a user by their ID
    final role = userRoles.firstWhere((role) => role.id == roleId);
    if (role != null) {
      // debugPrint('(From Provider)Role id: $roleId, Status: ${role.status}'); // If the role is found, print the status and return it
      return role.status;
    } else {
      debugPrint('Role not found with id');
      return null;
    }
  }

//SWITCHING USER ACTIVE/DEACTIVATE
  Future<bool> setRoleStatus(int roleId, String token) async {
    try {
      final success = await UserRoleAPI.switchRoleStatus(roleId, token);
      if (success) {
        // Update the user status locally
        final roleToUpdate = userRoles.firstWhere((role) => role.id == roleId);
        roleToUpdate.status = roleToUpdate.status == 'Active' ? 'Inactive' : 'Active';
        notifyListeners();
      } else {
        debugPrint('Failed to update role status via API');
      }
    } catch (error) {
      debugPrint('An error occurred while updating role status: $error');
    }
    return false;
  }
}

class ScreenRestrictionByRole extends ChangeNotifier {
  List<String> allowedDashboardTitles = [];
  List<String> allowedMenuItems = [];
  List<String> allowedSubmenuItems = [];

  Future<void> fetchRoleAccess(String roleTitle) async {
    try {
      RoleData userRole = (await GetRoleAccess.getAccessByRole(roleTitle));
      for (var access in userRole.data.matrix) {
        // Add dashboard titles to the list
        String? dashboardTitle = access.dashboard;
        allowedDashboardTitles.add(dashboardTitle);

        // Add menu items to the list
        for (var menuItem in access.access!) {
          String? menuTitle = menuItem.menuTitle;
          allowedMenuItems.add(menuTitle!);

          // Add submenu items to the list
          if (menuItem.subMenu != null) {
            for (var submenuItem in menuItem.subMenu!) {
              allowedSubmenuItems.add(submenuItem);
            }
          }
        }
      }

      // debugPrint('Allowed Dashboard Titles: $allowedDashboardTitles');
      // debugPrint('Allowed Menu Items: $allowedMenuItems');
      // debugPrint('Allowed Submenu Items: $allowedSubmenuItems');
    } catch (e) {
      debugPrint('Error fetching role access: $e');
    }
    notifyListeners();
  }
}
