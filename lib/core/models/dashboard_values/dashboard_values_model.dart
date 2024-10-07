class ClientStatusCounts {
  final int approvedCount;
  final int disapprovedCount;
  final int pendingCount;

  ClientStatusCounts({
    required this.approvedCount,
    required this.disapprovedCount,
    required this.pendingCount,
  });

  factory ClientStatusCounts.fromJson(Map<String, dynamic> json) {
    return ClientStatusCounts(
      approvedCount: json['ApprovedCount'],
      disapprovedCount: json['DisapprovedCount'],
      pendingCount: json['PendingCount'],
    );
  }
}

class UserStatusCounts {
  final int makerCount;
  final int checkerCount;
  final int allUsersCount;

  UserStatusCounts({
    required this.makerCount,
    required this.checkerCount,
    required this.allUsersCount,
  });

  factory UserStatusCounts.fromJson(Map<String, dynamic> json) {
    return UserStatusCounts(
      makerCount: json['MakerCount'],
      checkerCount: json['CheckerCount'],
      allUsersCount: json['AllUserCount'],
    );
  }
}

class AMLAStatusCounts {
  final int amlaCount;
  final int amlaDelistedCount;

  AMLAStatusCounts({
    required this.amlaCount,
    required this.amlaDelistedCount,
  });

  factory AMLAStatusCounts.fromJson(Map<String, dynamic> json) {
    return AMLAStatusCounts(
      amlaCount: json['ApprovedCount'],
      amlaDelistedCount: json['DisapprovedCount'],
    );
  }
}
