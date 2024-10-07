class VolumeModel {
  List<Response>? response;
  bool? success;

  VolumeModel({this.response, this.success});

  VolumeModel.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
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

class Response {
  String? clientType;
  String? date;
  String? findings;
  String? name;
  String? sourceOfIncome;
  String? status;
  int? transactionAmount;
  int? transactionCount;
  String? transactionType;

  Response(
      {this.clientType,
        this.date,
        this.findings,
        this.name,
        this.sourceOfIncome,
        this.status,
        this.transactionAmount,
        this.transactionCount,
        this.transactionType});

  Response.fromJson(Map<String, dynamic> json) {
    clientType = json['Client Type'];
    date = json['Date'];
    findings = json['Findings'];
    name = json['Name'];
    sourceOfIncome = json['Source Of Income'];
    status = json['Status'];
    transactionAmount = json['Transaction Amount'];
    transactionCount = json['Transaction Count'];
    transactionType = json['Transaction Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Client Type'] = this.clientType;
    data['Date'] = this.date;
    data['Findings'] = this.findings;
    data['Name'] = this.name;
    data['Source Of Income'] = this.sourceOfIncome;
    data['Status'] = this.status;
    data['Transaction Amount'] = this.transactionAmount;
    data['Transaction Count'] = this.transactionCount;
    data['Transaction Type'] = this.transactionType;
    return data;
  }
}



class VolumeRequestModel {
  String? startDate;
  String? endDate;
  String? trnType;

  VolumeRequestModel({this.startDate, this.endDate, this.trnType});

  VolumeRequestModel.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
    trnType = json['trn_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['trn_type'] = this.trnType;
    return data;
  }
}
