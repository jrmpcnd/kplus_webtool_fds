import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/allFilesModel.dart';
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/clientModel.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';

import '../../service/url_getter_setter.dart';

class FetchClientListAPI {
  static final token = getToken();
  //FETCH ALL UPLOADED FILES
  static Future<List<AllUploadedFileData>> fetchAllUploadedFiles() async {
    final response = await http.get(
      Uri.parse('${UrlGetter.getURL()}/files/test/get/all/uploaded'),
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
        return jsonData.map((json) => AllUploadedFileData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load files');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  //SEARCH ON UPLOADED FILES
  static Future<List<AllUploadedFileData>> searchAllUploadedFiles(String filename) async {
    final response = await http.get(
      Uri.parse('${UrlGetter.getURL()}/files/test/get/all/uploaded?file_name=$filename'),
      headers: {'Authorization': 'Bearer $token'},
    );

    try {
      if (response.statusCode == 200) {
        // debugPrint(response.body);
        final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes))['data'];
        return jsonData.map((json) => AllUploadedFileData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  //DELETE A LIST
  static FutureOr<http.Response> deleteClientList(int idInput) async {
    try {
      final response = await http.post(
        Uri.parse('${UrlGetter.getURL()}/clients/test/delete-client'),
        headers: {'Authorization': 'Bearer $token'},
        body: jsonEncode({'upload_id_input': idInput}),
      );

      debugPrint('API response: ${response.body}');
      debugPrint('API response: ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('An error occurred during deleting the clients: $e');
      rethrow;
    }
  }
}

class FetchClientDataApiService {
  final String baseUrl;

  FetchClientDataApiService(this.baseUrl);

  Future<Map<String, dynamic>> fetchData({
    required String endpoint,
    Map<String, String>? queryParams,
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint').replace(queryParameters: queryParams);
    debugPrint('Fetching data from: $uri');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}

class ClientService {
  static Future<List<ClientDataModel>> fetchClients() async {
    final url = '${UrlGetter.getURL()}/clients/test/preview';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> clientData = data['data'] ?? [];
      return clientData.map((json) => ClientDataModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load clients');
    }
  }
}
