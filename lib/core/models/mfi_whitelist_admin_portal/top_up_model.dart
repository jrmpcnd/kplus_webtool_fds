class Savings {
  String accountNumber;
  String accountName;

  Savings({
    required this.accountNumber,
    required this.accountName,
  });

  factory Savings.fromJson(Map<String, dynamic> json) {
    return Savings(
      accountNumber: json['accountNumber'],
      accountName: json['accountName'],
    );
  }
}

class Account {
  int id;
  String createdDate;
  int instiCode;
  String instiName;
  int cid;
  bool isDefault;
  bool isEnabled;
  bool isAgent;
  bool isMerchant;
  List<Savings> savings;

  Account({
    required this.id,
    required this.createdDate,
    required this.instiCode,
    required this.instiName,
    required this.cid,
    required this.isDefault,
    required this.isEnabled,
    required this.isAgent,
    required this.isMerchant,
    required this.savings,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      createdDate: json['createdDate'],
      instiCode: json['instiCode'],
      instiName: json['instiName'],
      cid: json['cid'],
      isDefault: json['isDefault'] == 1,
      isEnabled: json['isEnabled'] == 1,
      isAgent: json['isAgent'] == 1,
      isMerchant: json['isMerchant'] == 1,
      savings: List<Savings>.from(json['savings'].map((s) => Savings.fromJson(s))),
    );
  }
}

class TopUpClient {
  String firstName;
  String? middleName;
  String lastName;
  String mobile;
  String birthday;
  int cid;
  String createdDate;
  int instiCode;
  bool isBlocked;
  bool isEnabled;
  List<Account> accounts;

  TopUpClient({
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.mobile,
    required this.birthday,
    required this.cid,
    required this.createdDate,
    required this.instiCode,
    required this.isBlocked,
    required this.isEnabled,
    required this.accounts,
  });

  factory TopUpClient.fromJson(Map<String, dynamic> json) {
    return TopUpClient(
      firstName: json['firstName'],
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'],
      mobile: json['mobile'],
      birthday: json['birthday'],
      cid: json['cid'],
      createdDate: json['createdDate'],
      instiCode: json['instiCode'],
      isBlocked: json['isBlocked'] == 1,
      isEnabled: json['isEnabled'] == 1,
      accounts: List<Account>.from(json['accounts'].map((account) => Account.fromJson(account))),
    );
  }
}

class ClientRetData {
  TopUpClient data;
  String message;
  String retCode;

  ClientRetData({
    required this.data,
    required this.message,
    required this.retCode,
  });

  factory ClientRetData.fromJson(Map<String, dynamic> json) {
    return ClientRetData(
      data: TopUpClient.fromJson(json['data']),
      message: json['message'],
      retCode: json['retCode'],
    );
  }
}

class TopUpData {
  final String accountNumber;
  final double amount; // Use double for amount
  final String cid;
  final String clientFullName;

  TopUpData({
    required this.accountNumber,
    required this.amount,
    required this.cid,
    required this.clientFullName,
  });

  factory TopUpData.fromJson(Map<String, dynamic> json) {
    return TopUpData(
      accountNumber: json['AccountNumber'],
      amount: double.parse(json['Amount']), // Convert String to double
      cid: json['Cid'],
      clientFullName: json['ClientFullName'],
    );
  }

  @override
  String toString() {
    return 'TopUpData(accountNumber: $accountNumber, amount: $amount, cid: $cid, clientFullName: $clientFullName)';
  }
}

class TopUpResult {
  final String accountNumber;
  final double amount;
  final String creditCustomerName;
  final String message;
  final String status;
  final String trxReference;

  TopUpResult({
    required this.accountNumber,
    required this.amount,
    required this.creditCustomerName,
    required this.message,
    required this.status,
    required this.trxReference,
  });

  factory TopUpResult.fromJson(Map<String, dynamic> json) {
    return TopUpResult(
      accountNumber: json['AccountNumber'],
      creditCustomerName: json['creditCustomerName'] ?? '',
      message: json['message'],
      status: json['status'],
      trxReference: json['trxReference'],
      amount: json['Amount'] ?? 0.0, // default to 0 if Amount field is missing
    );
  }
}
