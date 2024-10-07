import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';

import '../models/user_management/code_model.dart';

class BranchCodeAPI {
  static String baseURL = UrlGetter.getURL();

  //GET ALL BRANCH
  static Future<List<BranchCodeData>> getAllBranches() async {
    final response = await http.get(Uri.parse('$baseURL/all/branch'));
    try {
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body)['data'];
        return jsonData.map((json) => BranchCodeData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load branches');
      }
    } catch (e) {
      throw Exception('Failed to parse API response: $e');
    }
  }
}

//GET ALL UNITS
// class UnitCodeAPI {
//   static String baseURL = UrlGetter.getURL();
//
//   static Future<List<Mfiinsti>> getAllUnits() async {
//     final response = await http.get(Uri.parse('$baseURL/role/test/fetch/all'));
//     try {
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = jsonDecode(response.body)['data'];
//         return jsonData.map((json) => Mfiinsti.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load branches');
//       }
//     } catch (e) {
//       throw Exception('Failed to parse API response: $e');
//     }
//   }
// }

//GET ALL CENTERS
// class CenterCodeAPI {
//   static String baseURL = UrlGetter.getURL();
//
//   static Future<List<CenterCodeData>> getAllCenters() async {
//     final response = await http.get(Uri.parse('$baseURL/all/center'));
//     try {
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = jsonDecode(response.body)['data'];
//         return jsonData.map((json) => CenterCodeData.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load branches');
//       }
//     } catch (e) {
//       throw Exception('Failed to parse API response: $e');
//     }
//   }
// }

//GET ALL ROLE
class RoleAPI {
  static String baseURL = UrlGetter.getURL();
  static final token = getToken();

  static Future<List<Mfiinsti>> getAllRole() async {
    final response = await http.get(Uri.parse('$baseURL/role/test/fetch/all'), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token', 'Accept-Charset': 'UTF-8'});

    try {
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body)['data'];
        return jsonData.map((json) => Mfiinsti.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load branches');
      }
    } catch (e) {
      throw Exception('Failed to parse API response: $e');
    }
  }
}

//GET ALL INSTITUTION
class InstitutionAPI {
  static String baseURL = UrlGetter.getURL();
  static final token = getToken();

  static Future<List<InstitutionData>> getAllInstitution() async {
    final response = await http.get(
      Uri.parse('$baseURL/user/test/get/all/distinct/institutions'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print(jsonDecode(response.body));
    try {
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body)['data'];
        return jsonData.map((json) => InstitutionData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load branches');
      }
    } catch (e) {
      throw Exception('Failed to parse API response: $e');
    }
  }
}
