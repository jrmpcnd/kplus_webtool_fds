class ClientDataModel {
  final String? cid;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? maidenFName;
  final String? maidenMName;
  final String? maidenLName;
  final String? mobileNumber;
  final String? birthday;
  final String? placeOfBirth;
  final String? religion;
  final String? gender;
  final String? civilStatus;
  final String? citizenship;
  final String? presentAddress;
  final String? permanentAddress;
  final String? city;
  final String? province;
  final String? postalCode;
  final String? memberMaidenFName;
  final String? memberMaidenMName;
  final String? memberMaidenLName;
  final String? email;
  final String? institutionCode;
  final String? unitCode;
  final String? centerCode;
  final String? branchCode;
  final String? clientType;
  final String? memberClassification;
  final String? sourceOfFund;
  final String? employerOrBusinessName;
  final String? employerOrBusinessAddress;
  final String? clientClassification;
  final bool? isWatchlisted;

  ClientDataModel({
    this.cid,
    this.firstName,
    this.middleName,
    this.lastName,
    this.maidenFName,
    this.maidenMName,
    this.maidenLName,
    this.mobileNumber,
    this.birthday,
    this.placeOfBirth,
    this.religion,
    this.gender,
    this.civilStatus,
    this.citizenship,
    this.presentAddress,
    this.permanentAddress,
    this.city,
    this.province,
    this.postalCode,
    this.memberMaidenFName,
    this.memberMaidenMName,
    this.memberMaidenLName,
    this.email,
    this.institutionCode,
    this.unitCode,
    this.centerCode,
    this.branchCode,
    this.clientType = "1872",
    this.memberClassification,
    this.sourceOfFund,
    this.employerOrBusinessName,
    this.employerOrBusinessAddress,
    this.clientClassification,
    this.isWatchlisted,
  });

  // Optional: You can add methods or factory constructors if needed.

  factory ClientDataModel.fromJson(Map<String, dynamic> json) {
    return ClientDataModel(
      cid: json['cid'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      maidenFName: json['maidenFName'],
      maidenMName: json['maidenMName'],
      maidenLName: json['maidenLName'],
      mobileNumber: json['mobileNumber'],
      birthday: json['birthday'],
      placeOfBirth: json['placeOfBirth'],
      religion: json['religion'],
      gender: json['gender'],
      civilStatus: json['civilStatus'],
      citizenship: json['citizenship'],
      presentAddress: json['presentAddress'],
      permanentAddress: json['permanentAddress'],
      city: json['city'],
      province: json['province'],
      postalCode: json['postalCode'],
      memberMaidenFName: json['memberMaidenFName'],
      memberMaidenMName: json['memberMaidenMName'],
      memberMaidenLName: json['memberMaidenLName'],
      email: json['email'],
      institutionCode: json['institutionCode'],
      unitCode: json['unitCode'],
      centerCode: json['centerCode'],
      branchCode: json['branchCode'],
      clientType: json['clientType'],
      memberClassification: json['memberClassification'],
      sourceOfFund: json['sourceOfFund'],
      employerOrBusinessName: json['employerOrBusinessName'],
      employerOrBusinessAddress: json['employerOrBusinessAddress'],
      clientClassification: json['clientClassification'],
      isWatchlisted: json['isWatchlisted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cid': cid,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'maidenFName': maidenFName,
      'maidenMName': maidenMName,
      'maidenLName': maidenLName,
      'mobileNumber': mobileNumber,
      'birthday': birthday,
      'placeOfBirth': placeOfBirth,
      'religion': religion,
      'gender': gender,
      'civilStatus': civilStatus,
      'citizenship': citizenship,
      'presentAddress': presentAddress,
      'permanentAddress': permanentAddress,
      'city': city,
      'province': province,
      'postalCode': postalCode,
      'memberMaidenFName': memberMaidenFName,
      'memberMaidenMName': memberMaidenMName,
      'memberMaidenLName': memberMaidenLName,
      'email': email,
      'institutionCode': institutionCode,
      'unitCode': unitCode,
      'centerCode': centerCode,
      'branchCode': branchCode,
      'clientType': clientType,
      'memberClassification': memberClassification,
      'sourceOfFund': sourceOfFund,
      'employerOrBusinessName': employerOrBusinessName,
      'employerOrBusinessAddress': employerOrBusinessAddress,
      'clientClassification': clientClassification,
      'isWatchlisted': isWatchlisted,
    };
  }
}

///
class ClientTopUpDataModel {
  final String? retCode;
  final String? message;
  final List<ClientTopUpDataModelData>? data;
  final int? totalRecords;
  final int? page;
  final int? perPage;
  final int? totalPages;

  ClientTopUpDataModel({
    this.retCode,
    this.message,
    this.data,
    this.totalRecords,
    this.page,
    this.perPage,
    this.totalPages,
  });

  // Factory constructor for creating an instance from JSON
  factory ClientTopUpDataModel.fromJson(Map<String, dynamic> json) {
    return ClientTopUpDataModel(
      retCode: json['retCode'],
      message: json['message'],
      data: json['data'] != null
          ? List<ClientTopUpDataModelData>.from(
              json['data'].map((v) => ClientTopUpDataModelData.fromJson(v)),
            )
          : null,
      totalRecords: json['totalRecords'],
      page: json['page'],
      perPage: json['perPage'],
      totalPages: json['totalPages'],
    );
  }

  // Method for converting the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'retCode': retCode,
      'message': message,
      'data': data?.map((v) => v.toJson()).toList(),
      'totalRecords': totalRecords,
      'page': page,
      'perPage': perPage,
      'totalPages': totalPages,
    };
  }
}

class ClientTopUpDataModelData {
  final int? batchTopupFileId;
  final String? fileName;
  final String? cid;
  final String? clientFullName;
  final String? accountNumber;
  final int? amount;
  final String? tlrUid;
  final String? tgtBranchCode;
  final String? tgtStatus;
  final String? tgtMessage;
  final String? tgtTrxReference;
  final String? tgtCreditCustomerName;
  final String? trxDate;

  ClientTopUpDataModelData({
    this.batchTopupFileId,
    this.fileName,
    this.cid,
    this.clientFullName,
    this.accountNumber,
    this.amount,
    this.tlrUid,
    this.tgtBranchCode,
    this.tgtStatus,
    this.tgtMessage,
    this.tgtTrxReference,
    this.tgtCreditCustomerName,
    this.trxDate,
  });

  // Factory constructor for creating an instance from JSON
  factory ClientTopUpDataModelData.fromJson(Map<String, dynamic> json) {
    return ClientTopUpDataModelData(
      batchTopupFileId: json['batchTopupFileId'],
      fileName: json['file_name'],
      cid: json['cid'],
      clientFullName: json['clientFullName'],
      accountNumber: json['accountNumber'],
      amount: json['amount'],
      tlrUid: json['tlrUid'],
      tgtBranchCode: json['tgtBranchCode'],
      tgtStatus: json['tgtStatus'],
      tgtMessage: json['tgtMessage'],
      tgtTrxReference: json['tgtTrxReference'],
      tgtCreditCustomerName: json['tgtCreditCustomerName'],
      trxDate: json['trxDate'],
    );
  }

  // Method for converting the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'batchTopupFileId': batchTopupFileId,
      'file_name': fileName,
      'cid': cid,
      'clientFullName': clientFullName,
      'accountNumber': accountNumber,
      'amount': amount,
      'tlrUid': tlrUid,
      'tgtBranchCode': tgtBranchCode,
      'tgtStatus': tgtStatus,
      'tgtMessage': tgtMessage,
      'tgtTrxReference': tgtTrxReference,
      'tgtCreditCustomerName': tgtCreditCustomerName,
      'trxDate': trxDate,
    };
  }
}

///WITH CONTACT CLASS
///USED FOR GET SINGLE CLIENT
class Client {
  int cid;
  String firstName;
  String middleName;
  String lastName;
  String maidenFName;
  String maidenMName;
  String maidenLName;
  List<Contact> contact;
  String birthday;
  String placeOfBirth;
  String religion;
  String gender;
  String civilStatus;
  String citizenship;
  String presentAddress;
  String permanentAddress;
  String city;
  String province;
  String postalCode;
  String memberMaidenFName;
  String memberMaidenMName;
  String memberMaidenLName;
  String email;
  String institutionCode;
  String unitCode;
  String centerCode;
  String branchCode;
  String clientType;
  String memberClassification;
  String sourceOfFund;
  String employerOrBusinessName;
  String employerOrBusinessAddress;
  int status;
  String riskClassification;
  String watchlistedType;
  bool isWatchlisted;

  Client({
    required this.cid,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.maidenFName,
    required this.maidenMName,
    required this.maidenLName,
    required this.contact,
    required this.birthday,
    required this.placeOfBirth,
    required this.religion,
    required this.gender,
    required this.civilStatus,
    required this.citizenship,
    required this.presentAddress,
    required this.permanentAddress,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.memberMaidenFName,
    required this.memberMaidenMName,
    required this.memberMaidenLName,
    required this.email,
    required this.institutionCode,
    required this.unitCode,
    required this.centerCode,
    required this.branchCode,
    required this.clientType,
    required this.memberClassification,
    required this.sourceOfFund,
    required this.employerOrBusinessName,
    required this.employerOrBusinessAddress,
    required this.status,
    required this.riskClassification,
    required this.watchlistedType,
    required this.isWatchlisted,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      cid: json['cid'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      maidenFName: json['maidenFName'],
      maidenMName: json['maidenMName'],
      maidenLName: json['maidenLName'],
      contact: List<Contact>.from(json['contact'].map((x) => Contact.fromJson(x))),
      birthday: json['birthday'],
      placeOfBirth: json['placeOfBirth'],
      religion: json['religion'],
      gender: json['gender'],
      civilStatus: json['civilStatus'],
      citizenship: json['citizenship'],
      presentAddress: json['presentAddress'],
      permanentAddress: json['permanentAddress'],
      city: json['city'],
      province: json['province'],
      postalCode: json['postalCode'],
      memberMaidenFName: json['memberMaidenFName'],
      memberMaidenMName: json['memberMaidenMName'],
      memberMaidenLName: json['memberMaidenLName'],
      email: json['email'],
      institutionCode: json['institutionCode'],
      unitCode: json['unitCode'],
      centerCode: json['centerCode'],
      branchCode: json['branchCode'],
      clientType: json['clientType'],
      memberClassification: json['memberClassification'],
      sourceOfFund: json['sourceOfFund'],
      employerOrBusinessName: json['employerOrBusinessName'],
      employerOrBusinessAddress: json['employerOrBusinessAddress'],
      status: json['status'],
      riskClassification: json['riskClassification'],
      watchlistedType: json['watchlistedType'],
      isWatchlisted: json['isWatchlisted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cid': cid,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'maidenFName': maidenFName,
      'maidenMName': maidenMName,
      'maidenLName': maidenLName,
      'contact': contact.map((x) => x.toJson()).toList(),
      'birthday': birthday,
      'placeOfBirth': placeOfBirth,
      'religion': religion,
      'gender': gender,
      'civilStatus': civilStatus,
      'citizenship': citizenship,
      'presentAddress': presentAddress,
      'permanentAddress': permanentAddress,
      'city': city,
      'province': province,
      'postalCode': postalCode,
      'memberMaidenFName': memberMaidenFName,
      'memberMaidenMName': memberMaidenMName,
      'memberMaidenLName': memberMaidenLName,
      'email': email,
      'institutionCode': institutionCode,
      'unitCode': unitCode,
      'centerCode': centerCode,
      'branchCode': branchCode,
      'clientType': clientType,
      'memberClassification': memberClassification,
      'sourceOfFund': sourceOfFund,
      'employerOrBusinessName': employerOrBusinessName,
      'employerOrBusinessAddress': employerOrBusinessAddress,
      'status': status,
      'riskClassification': riskClassification,
      'watchlistedType': watchlistedType,
      'isWatchlisted': isWatchlisted,
    };
  }
}

class Contact {
  int series;
  int contactTypeID;
  String contactType;
  String contactInfo;

  Contact({
    required this.series,
    required this.contactTypeID,
    required this.contactType,
    required this.contactInfo,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      series: json['series'],
      contactTypeID: json['contactTypeID'],
      contactType: json['contactType'],
      contactInfo: json['contact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'series': series,
      'contactTypeID': contactTypeID,
      'contactType': contactType,
      'contact': contactInfo,
    };
  }
}
