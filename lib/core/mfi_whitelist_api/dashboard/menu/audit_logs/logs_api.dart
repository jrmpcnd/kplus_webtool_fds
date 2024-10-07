import 'dart:convert';
import 'dart:html' as html;

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';

class GetLogsAPI {
  Future<Map<String, dynamic>> fetchData({
    int? page,
    int? perPage,
    String? username,
    String? dateFrom,
    String? dateTo,
    String? orderBy,
    required String token,
  }) async {
    final url = Uri.parse('${UrlGetter.getURL()}/audit/test/get/all/logs'
        '?username=${username ?? ''}'
        '&page=${page ?? ''}'
        '&perPage=${perPage ?? ''}'
        '&date_from=${dateFrom ?? ''}'
        '&date_to=${dateTo ?? ''}'
        '&order_by=${orderBy ?? ''}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }
}

class AuditLogService {
  final String baseUrl = 'https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/audit/test/download/audit/logs';

  static Future<http.Response> downloadAuditLogs({
    required String fileType,
    String? username,
    int? page,
    int? perPage,
    String? dateFrom,
    String? dateTo,
    String? orderBy,
  }) async {
    // Construct the query parameters
    String queryParams = '?file_type=$fileType';
    if (username != null) queryParams += '&username=$username';
    if (page != null) queryParams += '&page=$page';
    if (perPage != null) queryParams += '&perPage=$perPage';
    if (dateFrom != null) queryParams += '&date_from=$dateFrom';
    if (dateTo != null) queryParams += '&date_to=$dateTo';
    if (orderBy != null) queryParams += '&order_by=$orderBy';

    final url = Uri.parse('${UrlGetter.getURL()}/audit/test/download/audit/logs$queryParams');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${getToken()}', // Ensure you have the correct token setup
    });

    if (response.statusCode == 200) {
      // Get current date and time
      final DateTime now = DateTime.now();
      final String formattedDate = DateFormat('MM-dd-yyyy_HH:mm').format(now);

      final blob = html.Blob([response.bodyBytes], 'application/octet-stream');
      final downloadUrl = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: downloadUrl)
        ..setAttribute("download", 'MFI Audit Logs $formattedDate.$fileType')
        ..click();

      html.Url.revokeObjectUrl(downloadUrl);
      return response;
    } else {
      print(response.body);
      throw 'Failed to download file';
    }
  }
}
