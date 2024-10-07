import 'dart:convert';
import 'package:http/http.dart' as http;


Future<void> fetchFileType(Function(List<String>) updateFileType) async {
  try {
    final response = await http.get(
        Uri.parse('https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/ngo/test/reports/file/type')
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      List<dynamic> fileTypeData = responseData['data'];
      if (fileTypeData.isNotEmpty) {
        List<String> fileType = fileTypeData.map((data) => data.toString()).toList();
        updateFileType(fileType);
      } else {
        print('Error: No file types found');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching file types: $error');
  }
}
