import 'dart:convert';

import 'package:flutter/services.dart';

class RegionData {
  final String name;
  final String regionCode;
  final List<ProvinceData>? provinces;
  final List<CityMunicipalityData>? citiesMunicipalities;

  RegionData({
    required this.name,
    required this.regionCode,
    this.provinces,
    this.citiesMunicipalities,
  });

  factory RegionData.fromJson(Map<String, dynamic> json) {
    return RegionData(
      name: json['name'],
      regionCode: json['regionCode'],
      provinces: (json['provinces'] as List<dynamic>?)?.map((province) => ProvinceData.fromJson(province)).toList(),
      citiesMunicipalities: (json['citiesMunicipalities'] as List<dynamic>?)?.map((city) => CityMunicipalityData.fromJson(city)).toList(),
    );
  }
}

class ProvinceData {
  final String name;
  final String provinceCode;
  final List<CityMunicipalityData>? citiesMunicipalities;

  ProvinceData({
    required this.name,
    required this.provinceCode,
    this.citiesMunicipalities,
  });

  factory ProvinceData.fromJson(Map<String, dynamic> json) {
    return ProvinceData(
      name: json['name'],
      provinceCode: json['provinceCode'],
      citiesMunicipalities: (json['citiesMunicipalities'] as List<dynamic>?)?.map((city) => CityMunicipalityData.fromJson(city)).toList(),
    );
  }
}

class CityMunicipalityData {
  final String name;
  final String cityCode;
  final String zipPostalCode;

  CityMunicipalityData({
    required this.name,
    required this.cityCode,
    required this.zipPostalCode,
  });

  factory CityMunicipalityData.fromJson(Map<String, dynamic> json) {
    return CityMunicipalityData(
      name: json['name'],
      cityCode: json['cityCode'],
      zipPostalCode: json['zipPostalCode'],
    );
  }
}

///PRESENT
Future<List<RegionData>> loadRegions() async {
  final jsonString = await rootBundle.loadString('assets/json/PSGC.json');
  final jsonResponse = json.decode(jsonString);
  final regionsJson = jsonResponse['regions'] as List<dynamic>;
  return regionsJson.map((region) => RegionData.fromJson(region)).toList();
}

Future<List<ProvinceData>> loadProvincesForRegion(String regionCode) async {
  // Load all regions
  final regions = await loadRegions();

  // Find the region with the specified region code
  final region = regions.firstWhere((region) => region.regionCode == regionCode);

  // Return the list of provinces for the found region, or an empty list if not found
  return region.provinces ?? [];
}

Future<List<CityMunicipalityData>> loadCitiesForProvince(String provinceCode) async {
  // Load all regions to access the provinces and cities
  final regions = await loadRegions();

  // Find the province within the loaded regions
  for (var region in regions) {
    final province = region.provinces?.firstWhere(
      (prov) => prov.provinceCode == provinceCode,
      orElse: () => ProvinceData(name: '', provinceCode: '', citiesMunicipalities: []),
    );

    // Return the list of cities for the found province, or an empty list if not found
    return province?.citiesMunicipalities ?? [];
  }

  // If no province found, return an empty list
  return [];
}

///PERMANENT
Future<List<RegionData>> loadRegionsPermanent() async {
  final jsonString = await rootBundle.loadString('assets/json/zipcodes.json');
  final jsonResponse = json.decode(jsonString);
  final regionsJson = jsonResponse['regions'] as List<dynamic>;
  return regionsJson.map((region) => RegionData.fromJson(region)).toList();
}

Future<List<ProvinceData>> loadProvincesForRegionPermanent(String regionCode) async {
  // Load all regions
  final regions = await loadRegionsPermanent();

  // Find the region with the specified region code
  final region = regions.firstWhere((region) => region.regionCode == regionCode);

  // Return the list of provinces for the found region, or an empty list if not found
  return region.provinces ?? [];
}

Future<List<CityMunicipalityData>> loadCitiesForProvincePermanent(String provinceCode) async {
  // Load all regions to access the provinces and cities
  final regions = await loadRegionsPermanent();

  // Find the province within the loaded regions
  for (var region in regions) {
    final province = region.provinces?.firstWhere(
      (prov) => prov.provinceCode == provinceCode,
      orElse: () => ProvinceData(name: '', provinceCode: '', citiesMunicipalities: []),
    );

    // Return the list of cities for the found province, or an empty list if not found
    return province?.citiesMunicipalities ?? [];
  }

  // If no province found, return an empty list
  return [];
}
