class ApiResponse {
  final String retCode;
  final String message;
  final List<UploadedLoanDisburseFile> data;
  final int totalRecords;
  final int page;
  final int perPage;
  final int totalPages;

  ApiResponse({
    required this.retCode,
    required this.message,
    required this.data,
    required this.totalRecords,
    required this.page,
    required this.perPage,
    required this.totalPages,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<UploadedLoanDisburseFile> uploadedFiles = dataList.map((i) => UploadedLoanDisburseFile.fromJson(i)).toList();

    return ApiResponse(
      retCode: json['retCode'],
      message: json['message'],
      data: uploadedFiles,
      totalRecords: json['totalRecords'],
      page: json['page'],
      perPage: json['perPage'],
      totalPages: json['totalPages'],
    );
  }
}

class UploadedLoanDisburseFile {
  final int batchLoanDisbursementFileId;
  final String fileName;
  final String dateAndTimeUploaded;
  final String maker;
  final String checker;
  final String status;
  final String remarks;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;
  final String hcisId;
  final String insti;

  UploadedLoanDisburseFile({
    required this.batchLoanDisbursementFileId,
    required this.fileName,
    required this.dateAndTimeUploaded,
    required this.maker,
    required this.checker,
    required this.status,
    required this.remarks,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.hcisId,
    required this.insti,
  });

  factory UploadedLoanDisburseFile.fromJson(Map<String, dynamic> json) {
    return UploadedLoanDisburseFile(
      batchLoanDisbursementFileId: json['batchLoanDisbursementFileId'],
      fileName: json['fileName'],
      dateAndTimeUploaded: json['dateAndTimeUploaded'],
      maker: json['maker'],
      checker: json['checker'] ?? '', // Handle null values
      status: json['status'],
      remarks: json['remarks'] ?? '', // Handle null values
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'] ?? '', // Handle null values
      deletedAt: json['deletedAt'] ?? '', // Handle null values
      hcisId: json['hcisId'],
      insti: json['insti'],
    );
  }
}
