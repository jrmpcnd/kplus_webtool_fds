import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/clientModel.dart';
import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';

import '../../../ui/shared/sessionmanagement/gettoken/gettoken.dart';

class UpdateAMLAClientInfoAPI {
  FutureOr<http.Response> updateAMLAClient(ClientDataModel clientData) async {
    try {
      String url = '${UrlGetter.getURL()}/amla/test/update';

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
      rethrow;
    }
  }
}

class DelistAMLAClientAPI {
  FutureOr<http.Response> delistAMLAClient(String cid) async {
    try {
      String url = '${UrlGetter.getURL()}/amla/test/delist';

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
