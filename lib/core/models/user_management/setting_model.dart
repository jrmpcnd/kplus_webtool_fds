class IdleModel {
  final String retCode;
  final String message;
  final IdleData data;

  IdleModel({
    required this.retCode,
    required this.message,
    required this.data,
  });
  factory IdleModel.fromJson(Map<String, dynamic> json) {
    return IdleModel(
      retCode: json['retCode'],
      message: json['message'],
      data: IdleData.fromJson(json['data']),
    );
  }
}

class IdleData {
  final int? id;
  final int duration;
  final String format;
  final String? description;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;

  IdleData({
    this.id,
    required this.duration,
    required this.format,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory IdleData.fromJson(Map<String, dynamic> json) {
    return IdleData(
      id: json['id'],
      duration: json['duration'] ?? 0,
      format: json['format'] ?? '',
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'format': format,
    };
  }

  @override
  String toString() {
    return 'IdleData(duration: $duration, format: $format)';
  }
}

class SessionModel {
  final String retCode;
  final String message;
  final SessionData data;

  SessionModel({
    required this.retCode,
    required this.message,
    required this.data,
  });
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      retCode: json['retCode'],
      message: json['message'],
      data: SessionData.fromJson(json['data']),
    );
  }
}

class SessionData {
  final int? id;
  final int duration;
  final String format;
  final String? description;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;

  SessionData({
    this.id,
    required this.duration,
    required this.format,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      id: json['id'],
      duration: json['duration'] ?? 0,
      format: json['format'] ?? '',
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'format': format,
    };
  }

  @override
  String toString() {
    return 'SessionData(duration: $duration, format: $format)';
  }
}

class PasswordModel {
  final String retCode;
  final String message;
  final PasswordData data;

  PasswordModel({
    required this.retCode,
    required this.message,
    required this.data,
  });
  factory PasswordModel.fromJson(Map<String, dynamic> json) {
    return PasswordModel(
      retCode: json['retCode'],
      message: json['message'],
      data: PasswordData.fromJson(json['data']),
    );
  }
}

class PasswordData {
  final int? id;
  final int duration;
  final String format;
  final String? description;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;

  PasswordData({
    this.id,
    required this.duration,
    required this.format,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory PasswordData.fromJson(Map<String, dynamic> json) {
    return PasswordData(
      id: json['id'],
      duration: json['duration'] ?? 0,
      format: json['format'] ?? '',
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'format': format,
    };
  }
}

class AccountDeactivationModel {
  final String retCode;
  final String message;
  final AccountDeactivationData data;

  AccountDeactivationModel({
    required this.retCode,
    required this.message,
    required this.data,
  });
  factory AccountDeactivationModel.fromJson(Map<String, dynamic> json) {
    return AccountDeactivationModel(
      retCode: json['retCode'],
      message: json['message'],
      data: AccountDeactivationData.fromJson(json['data']),
    );
  }
}

class AccountDeactivationData {
  final int? id;
  final int duration;
  final String format;
  final String? description;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;

  AccountDeactivationData({
    this.id,
    required this.duration,
    required this.format,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory AccountDeactivationData.fromJson(Map<String, dynamic> json) {
    return AccountDeactivationData(
      id: json['id'],
      duration: json['duration'] ?? 0,
      format: json['format'] ?? '',
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'format': format,
    };
  }
}

//VALIDATE PASSWORD FOR RE-LOGIN UPON IDLE
class ValidatePasswordOnIdleData {
  late String passwordOnIdle;

  ValidatePasswordOnIdleData({
    required this.passwordOnIdle,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['password'] = passwordOnIdle;
    return data;
  }
}
