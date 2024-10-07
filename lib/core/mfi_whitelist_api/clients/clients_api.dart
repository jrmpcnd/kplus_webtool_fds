import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/clientModel.dart';
import 'package:mfi_whitelist_admin_portal/main.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';

import '../../../ui/shared/widget/alert_dialog/alert_dialogs.dart';
import '../../service/url_getter_setter.dart';
// import 'package:html/html_escape.dart' as html;

class ApproveClientListAPI {
  static final token = getToken();

  FutureOr<http.Response> approveClientList(int idInput) async {
    debugPrint('API fetched id: $idInput');
    try {
      final response = await http.post(
        Uri.parse('${UrlGetter.getURL()}/clients/test/approved-client'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'upload_id_input': idInput}),
      );

      debugPrint('API response: ${response.body}');
      debugPrint('API response: ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('An error occurred during approving the pending clients: $e');

      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      rethrow;
    }
  }
}

class DisapproveClientListAPI {
  static final token = getToken();

  FutureOr<http.Response> disapproveClientList(int idInput, String remarks) async {
    debugPrint('API fetched id: $idInput');
    debugPrint('Remarks received by API: $remarks');
    try {
      final response = await http.post(
        Uri.parse('${UrlGetter.getURL()}/clients/test/disapproved-client'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'remarks_input': remarks, 'upload_id_input': idInput}),
      );

      debugPrint('API response: ${response.body}');
      debugPrint('API response: ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('An error occurred during disapproving the pending clients: $e');

      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      rethrow;
    }
  }
}

class DeleteClientListAPI {
  static final token = getToken();

  FutureOr<http.Response> deleteClientList(int idInput) async {
    debugPrint('API fetched id: $idInput');
    try {
      final response = await http.post(
        Uri.parse('${UrlGetter.getURL()}/clients/test/delete-client'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'batch_upload_id_input': idInput}),
      );

      print(idInput);

      debugPrint('API response: ${response.body}');
      debugPrint('API response: ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('An error occurred during deleting the pending clients: $e');
      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      rethrow;
    }
  }
}

class DownloadClientListAPI {
  static final token = getToken();
  static var dio = Dio();

  static Future<http.Response> downloadClientList(int idInput, String filename) async {
    try {
      final response = await http.post(
        Uri.parse('${UrlGetter.getURL()}/clients/test/download-csv-client'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'upload_id_input': idInput}),
      );

      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes], 'text/csv'); // Explicitly set the MIME type to 'text/csv'
        final url = html.Url.createObjectUrlFromBlob(blob);

        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename.endsWith('.csv') ? filename : '$filename.csv') // Ensure the filename ends with .csv
          ..click();

        // final blob = html.Blob([response.bodyBytes]);
        // final url = html.Url.createObjectUrlFromBlob(blob);
        // final anchor = html.AnchorElement(href: url)
        //   ..setAttribute("download", filename) // Set the filename here
        //   ..click();

        html.Url.revokeObjectUrl(url);

        print(response.body);
        return response;
      } else {
        print(response.body);
        throw 'Failed to download file';
      }
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      rethrow;
    }
  }
}

class DownloadAPI {
  static var dio = Dio();

  static final token = getToken();
  static Future<http.Response> downloadFile() async {
    try {
      final response = await http.get(
        Uri.parse('${UrlGetter.getURL()}/whitelist/test/download-client-template'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "MFI Template.xlsm")
          ..click();

        html.Url.revokeObjectUrl(url);

        return response;
      } else {
        throw 'Failed to download file';
      }
    } catch (e) {
      print('Error downloading file: $e');

      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      rethrow;
    }
  }
}

//top up
class DownloadTopUpAPI {
  static var dio = Dio();

  static final token = getToken();
  static Future<http.Response> downloadTopUpFile() async {
    try {
      final response = await http.get(
        Uri.parse('${UrlGetter.getURL()}/topup/test/download-topup-template'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "Top Up Template.xlsm")
          ..click();

        html.Url.revokeObjectUrl(url);

        return response;
      } else {
        print(response.statusCode);
        print(response.body);
        throw 'Failed to  download file';
      }
    } catch (e) {
      print('Error downloading file: $e');

      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      rethrow;
    }
  }
}

//disburse template
class DownloadDisburseAPI {
  static var dio = Dio();

  static final token = getToken();
  static Future<http.Response> downloadDisburseFile() async {
    final url = Uri.parse('${UrlGetter.getURL()}/loan/test/download-loan-disbursement-template');
    try {
      final response = await http.get(
        Uri.parse('${UrlGetter.getURL()}/loan/test/download-loan-disbursement-template'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print(url);

      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "Disburse Template.xlsm")
          ..click();

        html.Url.revokeObjectUrl(url);

        return response;
      } else {
        print(response.body);
        print(response.statusCode);
        print(url);
        throw 'hjakls,;a.Failed to download file';
      }
    } catch (e) {
      print('Error downloading file: $e');
      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      rethrow;
    }
  }
}

class DownloadAMLAAPI {
  static var dio1 = Dio();

  static final amlatoken = getToken();
  static Future<http.Response> downloadAMLAFile() async {
    try {
      final response = await http.get(
        Uri.parse('${UrlGetter.getURL()}/whitelist/test/download-aml-template'),
        headers: {
          'Authorization': 'Bearer $amlatoken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "AMLA Template.xlsm")
          ..click();

        html.Url.revokeObjectUrl(url);

        return response;
      } else {
        throw 'Failed to download file';
      }
    } catch (e) {
      print('Error downloading file: $e');

      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      rethrow;
    }
  }
}

class CheckExistingClientInfo {
  FutureOr<http.Response> checkingExistingClient(String cid, String mobileNumber, String email) async {
    debugPrint(cid);
    debugPrint(email);
    debugPrint(mobileNumber);
    try {
      String url = '${UrlGetter.getURL()}/client/test/check/info';

      final token = getToken();
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'cid': cid,
          'mobileNumber': mobileNumber,
          'email': email,
        }),
      );

      debugPrint('API Response: ${response.body}');
      return response;
    } catch (error) {
      debugPrint('Error during check request: $error');

      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      rethrow;
    }
  }
}

class InsertSingleClient {
  FutureOr<http.Response> uploadSingleClient(ClientDataModel clientData) async {
    // Print the client data to debug
    debugPrint('Client Data: ${clientData.toJson()}');
    try {
      String url = '${UrlGetter.getURL()}/client/test/create';

      final token = getToken();
      final response = await http.post(
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

      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      rethrow;
    }
  }
}

//top up
class DownloadClientTopUpListAPI {
  static final token = getToken();
  static var dio = Dio();

  static Future<http.Response> downloadClientTopUpList(int idInput, String filename) async {
    try {
      final response = await http.post(
        Uri.parse('${UrlGetter.getURL()}/topup/test/download-topup-file'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'topupFileId': idInput}),
      );

      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes], 'text/csv'); // Explicitly set the MIME type to 'text/csv'
        final url = html.Url.createObjectUrlFromBlob(blob);

        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename.endsWith('.csv') ? filename : '$filename.csv') // Ensure the filename ends with .csv
          ..click();

        // final blob = html.Blob([response.bodyBytes]);
        // final url = html.Url.createObjectUrlFromBlob(blob);
        // final anchor = html.AnchorElement(href: url)
        //   ..setAttribute("download", filename) // Set the filename here
        //   ..click();

        html.Url.revokeObjectUrl(url);

        print(response.body);
        print(idInput);
        return response;
      } else {
        print(response.body);
        throw 'Failed to download file';
      }
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      rethrow;
    }
  }

  //download disburse file
  static Future<http.Response> downloadLoanDisburseFile(int idInput, String filename) async {
    try {
      final response = await http.post(
        Uri.parse('${UrlGetter.getURL()}/loan/test/download-loan-disbursement-file'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'loanDisbursementFileId': idInput}),
      );

      if (response.statusCode == 200) {
        final blob = html.Blob([response.bodyBytes], 'text/csv'); // Explicitly set the MIME type to 'text/csv'
        final url = html.Url.createObjectUrlFromBlob(blob);

        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename.endsWith('.csv') ? filename : '$filename.csv') // Ensure the filename ends with .csv
          ..click();

        // final blob = html.Blob([response.bodyBytes]);
        // final url = html.Url.createObjectUrlFromBlob(blob);
        // final anchor = html.AnchorElement(href: url)
        //   ..setAttribute("download", filename) // Set the filename here
        //   ..click();

        html.Url.revokeObjectUrl(url);

        print(response.body);
        print(idInput);
        return response;
      } else {
        print(response.body);
        throw 'Failed to download file';
      }
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
      showServerDisconnectionAlertDialog(navigatorKey.currentContext!);
      rethrow;
    }
  }
}
