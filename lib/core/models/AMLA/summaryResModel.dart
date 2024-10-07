class SummaryResModel {
  List<SummaryResponse>? response;
  bool? success;

  SummaryResModel({this.response, this.success});

  SummaryResModel.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <SummaryResponse>[];
      json['response'].forEach((v) {
        response!.add(new SummaryResponse.fromJson(v));
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

class SummaryResponse {
  int? numberOfTransaction;
  int? totalAmount;
  String? transactionType;

  SummaryResponse({this.totalAmount, this.transactionType});

  SummaryResponse.fromJson(Map<String, dynamic> json) {
    numberOfTransaction = json['Number of Transaction'];
    totalAmount = json['Total Amount'];
    transactionType = json['Transaction Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Number of Transaction'] = this.numberOfTransaction;
    data['Total Amount'] = this.totalAmount;
    data['Transaction Type'] = this.transactionType;
    return data;
  }
}







class SummaryRequestModel {
  String? startDate;
  String? endDate;

  SummaryRequestModel({this.startDate, this.endDate});

  SummaryRequestModel.fromJson(Map<String, dynamic> json) {
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


