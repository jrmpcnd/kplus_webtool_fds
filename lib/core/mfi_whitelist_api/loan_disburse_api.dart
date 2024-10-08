import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/disburse_model.dart';
import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';

class LoanDisbursementAPIs {
  static final token = getToken();
  //FETCH ALL UPLOADED FILES
  static Future<List<UploadedLoanDisburseFile>> fetchAllUploadedDisburseFiles() async {
    final response = await http.get(
      Uri.parse('${UrlGetter.getURL()}/loan/test/get/all/uploaded?perPage=10000'),
      headers: {'Authorization': 'Bearer $token'},
    );

    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        if (jsonResponse['retCode'] == '404' && jsonResponse['data'] == null) {
          // Return an empty list if no files are found
          return [];
        }

        final List<dynamic> jsonData = jsonResponse['data'];
        return jsonData.map((json) => UploadedLoanDisburseFile.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load files');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  //SEARCH ON UPLOADED FILES
  static Future<List<UploadedLoanDisburseFile>> searchAllUploadedDisburseFiles(String filename) async {
    final response = await http.get(
      Uri.parse('${UrlGetter.getURL()}/loan/test/get/all/uploaded?file_name=$filename'),
      headers: {'Authorization': 'Bearer $token'},
    );

    try {
      if (response.statusCode == 200) {
        // debugPrint(response.body);
        final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes))['data'];
        return jsonData.map((json) => UploadedLoanDisburseFile.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }
}
