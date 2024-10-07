import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/mfi_whitelist_admin_portal/addressModel.dart';

class AddressAPI {
  final String baseUrl = "https://psgc.cloud/api";

  Future<List<RegionData>> fetchRegions() async {
    final response = await http.get(Uri.parse('$baseUrl/regions'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => RegionData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load regions');
    }
  }

  Future<List<ProvinceData>> fetchProvincesByRegionCode(String regionCode) async {
    final response = await http.get(Uri.parse('$baseUrl/regions/$regionCode/provinces'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ProvinceData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load provinces');
    }
  }
}
