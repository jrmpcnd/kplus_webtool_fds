//responsemodel

class AMLARCMResModel {
  List<RCMResponse>? response;
  bool? success;

  AMLARCMResModel({this.response, this.success});

  AMLARCMResModel.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <RCMResponse>[];
      json['response'].forEach((v) {
        response!.add(new RCMResponse.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class RCMResponse {
  String? address;
  String? birthDate;
  String? cid;
  String? clientType;
  String? email;
  String? firstName;
  String? fullName;
  int? institutionCode;
  String? lastName;
  String? middleName;
  String? mobileNumber;
  String? registeredDate;
  String? sourceOfIncome;
  String? status;

  RCMResponse(
      {this.address,
        this.birthDate,
        this.cid,
        this.clientType,
        this.email,
        this.firstName,
        this.fullName,
        this.institutionCode,
        this.lastName,
        this.middleName,
        this.mobileNumber,
        this.registeredDate,
        this.sourceOfIncome,
        this.status});

  RCMResponse.fromJson(Map<String, dynamic> json) {
    address = json['Address'];
    birthDate = json['Birth Date'];
    cid = json['Cid'];
    clientType = json['Client Type'];
    email = json['Email'];
    firstName = json['First Name'];
    fullName = json['Full Name'];
    institutionCode = json['Institution Code'];
    lastName = json['Last Name'];
    middleName = json['Middle Name'];
    mobileNumber = json['Mobile Number'];
    registeredDate = json['Registered Date'];
    sourceOfIncome = json['Source Of Income'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Address'] = this.address;
    data['Birth Date'] = this.birthDate;
    data['Cid'] = this.cid;
    data['Client Type'] = this.clientType;
    data['Email'] = this.email;
    data['First Name'] = this.firstName;
    data['Full Name'] = this.fullName;
    data['Institution Code'] = this.institutionCode;
    data['Last Name'] = this.lastName;
    data['Middle Name'] = this.middleName;
    data['Mobile Number'] = this.mobileNumber;
    data['Registered Date'] = this.registeredDate;
    data['Source Of Income'] = this.sourceOfIncome;
    data['Status'] = this.status;
    return data;
  }
}


//requestbodymodel
class AMLARCMReqModel {
  String? startDate;
  String? endDate;

  AMLARCMReqModel({this.startDate, this.endDate});

  AMLARCMReqModel.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}


