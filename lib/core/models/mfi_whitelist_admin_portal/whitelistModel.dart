import 'package:flutter/material.dart';

class ClientList {
  String? retCode;
  String? message;
  List<WhitelistModel>? data;
  int? totalRecords;
  int? page;
  int? perPage;
  int? totalPages;

  ClientList({this.retCode, this.message, this.data, this.totalRecords, this.page, this.perPage, this.totalPages});

  ClientList.fromJson(Map<String, dynamic> json) {
    retCode = json['retCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WhitelistModel>[];
      json['data'].forEach((v) {
        data!.add(WhitelistModel.fromJson(v));
      });
    }
    totalRecords = json['totalRecords'];
    page = json['page'];
    perPage = json['perPage'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['retCode'] = this.retCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalRecords'] = this.totalRecords;
    data['page'] = this.page;
    data['perPage'] = this.perPage;
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class WhitelistModel {
  int? batchUploadId;
  String? cid;
  String? firstName;
  String? middleName;
  String? lastName;
  String? maidenFName;
  String? maidenMName;
  String? maidenLName;
  String? mobileNumber;
  String? birthday;
  String? placeOfBirth;
  String? religion;
  String? gender;
  String? civilStatus;
  String? citizenship;
  String? presentAddress;
  String? permanentAddress;
  String? city;
  String? province;
  String? postalCode;
  String? memberMaidenFName;
  String? memberMaidenMName;
  String? memberMaidenLName;
  String? email;
  String? institutionCode;
  String? unitCode;
  String? centerCode;
  String? branchCode;
  String? clientType;
  String? memberClassification;
  String? sourceOfFound;
  String? employerOrBusinessName;
  String? employerOrBusinessAddress;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? fileName;
  String? watchlistedType;

  WhitelistModel({this.batchUploadId, this.cid, this.firstName, this.middleName, this.lastName, this.maidenFName, this.maidenMName, this.maidenLName, this.mobileNumber, this.birthday, this.placeOfBirth, this.religion, this.gender, this.civilStatus, this.citizenship, this.presentAddress, this.permanentAddress, this.city, this.province, this.postalCode, this.memberMaidenFName, this.memberMaidenMName, this.memberMaidenLName, this.email, this.institutionCode, this.unitCode, this.centerCode, this.branchCode, this.clientType, this.memberClassification, this.sourceOfFound, this.employerOrBusinessName, this.employerOrBusinessAddress, this.status, this.createdAt, this.updatedAt, this.deletedAt, this.fileName, this.watchlistedType});

  WhitelistModel.fromJson(Map<String, dynamic> json) {
    batchUploadId = json['batch_upload_id'];
    cid = json['cid'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    maidenFName = json['maidenFName'];
    maidenMName = json['maidenMName'];
    maidenLName = json['maidenLName'];
    mobileNumber = json['mobileNumber'];
    birthday = json['birthday'];
    placeOfBirth = json['placeOfBirth'];
    religion = json['religion'];
    gender = json['gender'];
    civilStatus = json['civilStatus'];
    citizenship = json['citizenship'];
    presentAddress = json['presentAddress'];
    permanentAddress = json['permanentAddress'];
    city = json['city'];
    province = json['province'];
    postalCode = json['postalCode'];
    memberMaidenFName = json['memberMaidenFName'];
    memberMaidenMName = json['memberMaidenMName'];
    memberMaidenLName = json['memberMaidenLName'];
    email = json['email'];
    institutionCode = json['institutionCode'];
    unitCode = json['unitCode'];
    centerCode = json['centerCode'];
    branchCode = json['branchCode'];
    clientType = json['clientType'];
    memberClassification = json['memberClassification'];
    sourceOfFound = json['sourceOfFound'];
    employerOrBusinessName = json['employerOrBusinessName'];
    employerOrBusinessAddress = json['employerOrBusinessAddress'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    fileName = json['file_name'];
    watchlistedType = json['watchlistedType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batch_upload_id'] = this.batchUploadId;
    data['cid'] = this.cid;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['maidenFName'] = this.maidenFName;
    data['maidenMName'] = this.maidenMName;
    data['maidenLName'] = this.maidenLName;
    data['mobileNumber'] = this.mobileNumber;
    data['birthday'] = this.birthday;
    data['placeOfBirth'] = this.placeOfBirth;
    data['religion'] = this.religion;
    data['gender'] = this.gender;
    data['civilStatus'] = this.civilStatus;
    data['citizenship'] = this.citizenship;
    data['presentAddress'] = this.presentAddress;
    data['permanentAddress'] = this.permanentAddress;
    data['city'] = this.city;
    data['province'] = this.province;
    data['postalCode'] = this.postalCode;
    data['memberMaidenFName'] = this.memberMaidenFName;
    data['memberMaidenMName'] = this.memberMaidenMName;
    data['memberMaidenLName'] = this.memberMaidenLName;
    data['email'] = this.email;
    data['institutionCode'] = this.institutionCode;
    data['unitCode'] = this.unitCode;
    data['centerCode'] = this.centerCode;
    data['branchCode'] = this.branchCode;
    data['clientType'] = this.clientType;
    data['memberClassification'] = this.memberClassification;
    data['sourceOfFound'] = this.sourceOfFound;
    data['employerOrBusinessName'] = this.employerOrBusinessName;
    data['employerOrBusinessAddress'] = this.employerOrBusinessAddress;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['file_name'] = this.fileName;
    data['watchlistedType'] = this.watchlistedType;
    return data;
  }
}

class RowData {
  bool isEditing;
  Map<String, dynamic> data;
  Map<String, dynamic> originalData; // Stores the original data
  Map<String, TextEditingController> controllers;
  bool isHovered;

  RowData({
    required this.isEditing,
    required this.data,
    this.isHovered = false,
  })  : originalData = Map.from(data), // Initialize originalData with the current data
        controllers = {for (var key in data.keys) key: TextEditingController(text: data[key]?.toString() ?? '')};
}





