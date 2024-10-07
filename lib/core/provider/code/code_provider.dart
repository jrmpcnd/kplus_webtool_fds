import 'package:flutter/widgets.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';

import '../../models/user_management/code_model.dart';
import '../../service/code_api.dart';

class CodeProvider extends ChangeNotifier {
  //BRANCHES
  List<BranchCodeData> branches = [];
  List<BranchCodeData> filteredBranches = [];

  Future<void> fetchAllBranch() async {
    try {
      List<BranchCodeData> branchData = await BranchCodeAPI.getAllBranches();
      branches = branchData;
      // Initialize filteredBranches with all branches
      filteredBranches = List.from(branches);
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching the list of branches: $error');
    }
  }

  // Method to filter branches based on the provided search query
  void filterBranches(String query) {
    // If the query is empty, show all branches
    if (query.isEmpty) {
      // Restore filteredBranches to contain all branches
      filteredBranches = List.from(branches);
      notifyListeners();
      return;
    }

    // Filter branches based on the description containing the query (case-insensitive)
    filteredBranches = branches.where((branch) {
      return branch.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Notify listeners to update the UI with the filtered branches
    notifyListeners();
  }

  //UNITS
  // List<Mfiinsti> units = [];
  // List<Mfiinsti> filteredUnits = [];
  // Future<void> fetchAllUnit() async {
  //   try {
  //     List<Mfiinsti> unitData = await UnitCodeAPI.getAllUnits();
  //     units = unitData;
  //     // Initialize filteredBranches with all units
  //     filteredUnits = List.from(units);
  //     notifyListeners();
  //   } catch (error) {
  //     debugPrint('Error fetching the list of units: $error');
  //   }
  // }
  //
  // // Method to filter units based on the provided search query
  // void filterUnits(String query) {
  //   // If the query is empty, show all branches
  //   if (query.isEmpty) {
  //     // Restore filteredBranches to contain all branches
  //     filteredUnits = List.from(units);
  //     notifyListeners();
  //     return;
  //   }
  //
  //   // Filter branches based on the description containing the query (case-insensitive)
  //   filteredUnits = units.where((unit) {
  //     return unit.description.toLowerCase().contains(query.toLowerCase());
  //   }).toList();
  //
  //   // Notify listeners to update the UI with the filtered branches
  //   notifyListeners();
  // }

  //CENTERS
  // List<CenterCodeData> centers = [];
  // List<CenterCodeData> filteredCenters = [];
  // Future<void> fetchAllCenter() async {
  //   try {
  //     List<CenterCodeData> centerData = await CenterCodeAPI.getAllCenters();
  //     centers = centerData;
  //     // Initialize filteredBranches with all units
  //     filteredCenters = List.from(centers);
  //     notifyListeners();
  //   } catch (error) {
  //     debugPrint('Error fetching the list of centers: $error');
  //   }
  // }
  //
  // // Method to filter units based on the provided search query
  // void filterCenters(String query) {
  //   // If the query is empty, show all branches
  //   if (query.isEmpty) {
  //     // Restore filteredBranches to contain all branches
  //     filteredCenters = List.from(centers);
  //     notifyListeners();
  //     return;
  //   }
  //
  //   // Filter branches based on the description containing the query (case-insensitive)
  //   filteredCenters = centers.where((unit) {
  //     return unit.description.toLowerCase().contains(query.toLowerCase());
  //   }).toList();
  //
  //   // Notify listeners to update the UI with the filtered branches
  //   notifyListeners();
  // }
  //

  //INSTITUTION
  List<InstitutionData> institution = [];
  Future<void> fetchAllInsti() async {
    try {
      List<InstitutionData> institutionData = await InstitutionAPI.getAllInstitution();
      institution = institutionData;
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching the list of insti: $error');
    }
  }

  //ROLE
  static final token = getToken();
  List<Mfiinsti> roleName = [];
  Future<void> fetchAllRole() async {
    try {
      if (getToken() != null) {
        print('Token not found');
        print(token);
      } else {
        List<Mfiinsti> roleData = await RoleAPI.getAllRole();
        roleName = roleData;
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error fetching the list of insti: $error');
    }
  }

  //POSITION
  // List<PositionData> positions = [];
  // Future<void> fetchAllPosition() async {
  //   try {
  //     // List<PositionData> positionData = await PositionAPI.getAllPosition();
  //     positions = positionData;
  //     notifyListeners();
  //   } catch (error) {
  //     debugPrint('Error fetching the list of insti: $error');
  //   }
  // }
}
