class AllUploadedFiles {
  String? retCode;
  String? message;
  List<AllUploadedFileData>? data;
  int? totalRecords;
  int? page;
  int? perPage;
  int? totalPages;

  AllUploadedFiles({this.retCode, this.message, this.data, this.totalRecords, this.page, this.perPage, this.totalPages});

  AllUploadedFiles.fromJson(Map<String, dynamic> json) {
    retCode = json['retCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllUploadedFileData>[];
      json['data'].forEach((v) {
        data!.add(AllUploadedFileData.fromJson(v));
      });
    }
    totalRecords = json['totalRecords'];
    page = json['page'];
    perPage = json['perPage'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['retCode'] = retCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalRecords'] = totalRecords;
    data['page'] = page;
    data['perPage'] = perPage;
    data['totalPages'] = totalPages;
    return data;
  }
}

class AllUploadedFileData {
  int? batchUploadId;
  String? fileName;
  String? dateAndTimeUploaded;
  String? maker;
  String? checker;
  String? status;
  String? remarks;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? hcisId;

  AllUploadedFileData({this.batchUploadId, this.fileName, this.dateAndTimeUploaded, this.maker, this.checker, this.status, this.remarks, this.createdAt, this.updatedAt, this.deletedAt, this.hcisId});

  AllUploadedFileData.fromJson(Map<String, dynamic> json) {
    batchUploadId = json['batchUploadId'];
    fileName = json['fileName'];
    dateAndTimeUploaded = json['dateAndTimeUploaded'];
    maker = json['maker'];
    checker = json['checker'];
    status = json['status'];
    remarks = json['remarks'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    hcisId = json['hcisId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['batchUploadId'] = batchUploadId;
    data['fileName'] = fileName;
    data['dateAndTimeUploaded'] = dateAndTimeUploaded;
    data['maker'] = maker;
    data['checker'] = checker;
    data['status'] = status;
    data['remarks'] = remarks;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['hcisId'] = hcisId;
    return data;
  }
}




class AllTopUpUploadedFiles {
  String? retCode;
  String? message;
  List<AllTopUpUploadedFilesData>? data;
  int? totalRecords;
  int? page;
  int? perPage;
  int? totalPages;

  AllTopUpUploadedFiles(
      {this.retCode,
        this.message,
        this.data,
        this.totalRecords,
        this.page,
        this.perPage,
        this.totalPages});

  AllTopUpUploadedFiles.fromJson(Map<String, dynamic> json) {
    retCode = json['retCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllTopUpUploadedFilesData>[];
      json['data'].forEach((v) {
        data!.add(new AllTopUpUploadedFilesData.fromJson(v));
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

class AllTopUpUploadedFilesData {
  int? batchTopupFileId;
  String? fileName;
  String? dateAndTimeUploaded;
  String? maker;
  String? checker;
  String? status;
  String? remarks;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? hcisId;
  String? insti;

  AllTopUpUploadedFilesData(
      {this.batchTopupFileId,
        this.fileName,
        this.dateAndTimeUploaded,
        this.maker,
        this.checker,
        this.status,
        this.remarks,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.hcisId,
        this.insti});

  AllTopUpUploadedFilesData.fromJson(Map<String, dynamic> json) {
    batchTopupFileId = json['batchTopupFileId'];
    fileName = json['fileName'];
    dateAndTimeUploaded = json['dateAndTimeUploaded'];
    maker = json['maker'];
    checker = json['checker'];
    status = json['status'];
    remarks = json['remarks'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    hcisId = json['hcisId'];
    insti = json['insti'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batchTopupFileId'] = this.batchTopupFileId;
    data['fileName'] = this.fileName;
    data['dateAndTimeUploaded'] = this.dateAndTimeUploaded;
    data['maker'] = this.maker;
    data['checker'] = this.checker;
    data['status'] = this.status;
    data['remarks'] = this.remarks;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['hcisId'] = this.hcisId;
    data['insti'] = this.insti;
    return data;
  }
}
