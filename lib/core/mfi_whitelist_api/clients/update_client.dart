import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/clientModel.dart';

import '../../../../ui/shared/sessionmanagement/gettoken/gettoken.dart';
import '../../service/url_getter_setter.dart';

class UpdateApprovedClientInfoAPI {
  FutureOr<http.Response> updateApprovedClient(ClientDataModel clientData) async {
    // Print the client data to debug
    debugPrint('Client Data: ${clientData.toJson()}');
    try {
      String url = '${UrlGetter.getURL()}/client/test/update';

      final token = getToken();
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(clientData.toJson()),
      );

      debugPrint('API Response: ${response.body}');
      debugPrint('Client data after sending: ${clientData.toJson()}');
      return response;
    } catch (error) {
      debugPrint('Error during update request: $error');
      rethrow;
    }
  }
}

class DelistApprovedClientAPI {
  FutureOr<http.Response> delistApprovedClient(String cid) async {
    try {
      String url = '${UrlGetter.getURL()}/client/test/delist';

      final token = getToken();
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'cid': cid}), // Correctly format the body as a JSON object
      );

      debugPrint('API Response: ${response.body}');
      return response;
    } catch (error) {
      debugPrint('Error during update request: $error');
      rethrow;
    }
  }
}
