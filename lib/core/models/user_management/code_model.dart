class BranchCodeModel {
  final String retCode;
  final String message;
  final BranchCodeData data;

  BranchCodeModel({
    required this.retCode,
    required this.message,
    required this.data,
  });
  factory BranchCodeModel.fromJson(Map<String, dynamic> json) {
    return BranchCodeModel(
      retCode: json['retCode'],
      message: json['message'],
      data: BranchCodeData.fromJson(json['data']),
    );
  }
}

class BranchCodeData {
  String brCode;
  String description;

  BranchCodeData({required this.brCode, required this.description});
  factory BranchCodeData.fromJson(Map<String, dynamic> json) {
    return BranchCodeData(
      brCode: json['brCode'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

// class UnitCodeModel {
//   final String retCode;
//   final String message;
//   final UnitCodeData data;
//
//   UnitCodeModel({
//     required this.retCode,
//     required this.message,
//     required this.data,
//   });
//   factory UnitCodeModel.fromJson(Map<String, dynamic> json) {
//     return UnitCodeModel(
//       retCode: json['retCode'],
//       message: json['message'],
//       data: UnitCodeData.fromJson(json['data']),
//     );
//   }
// }
//
// class UnitCodeData {
//   String unitCode;
//   String description;
//
//   UnitCodeData({required this.unitCode, required this.description});
//   factory UnitCodeData.fromJson(Map<String, dynamic> json) {
//     return UnitCodeData(
//       unitCode: json['unitCode'] ?? '',
//       description: json['description'] ?? '',
//     );
//   }
// }
//
// class CenterCodeModel {
//   final String retCode;
//   final String message;
//   final CenterCodeData data;
//
//   CenterCodeModel({
//     required this.retCode,
//     required this.message,
//     required this.data,
//   });
//   factory CenterCodeModel.fromJson(Map<String, dynamic> json) {
//     return CenterCodeModel(
//       retCode: json['retCode'],
//       message: json['message'],
//       data: CenterCodeData.fromJson(json['data']),
//     );
//   }
// }
//
// class CenterCodeData {
//   String centerCode;
//   String description;
//
//   CenterCodeData({required this.centerCode, required this.description});
//   factory CenterCodeData.fromJson(Map<String, dynamic> json) {
//     return CenterCodeData(
//       centerCode: json['centerCode'] ?? '',
//       description: json['description'] ?? '',
//     );
//   }
// }
//
class InstitutionModel {
  final String retCode;
  final String message;
  final InstitutionData data;

  InstitutionModel({
    required this.retCode,
    required this.message,
    required this.data,
  });
  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      retCode: json['retCode'],
      message: json['message'],
      data: InstitutionData.fromJson(json['data']),
    );
  }
}

class InstitutionData {
  late int id;
  late String institution;
  late String description;

  InstitutionData({
    required this.id,
    required this.institution,
    required this.description,
  });

  factory InstitutionData.fromJson(Map<String, dynamic> json) {
    return InstitutionData(
      id: json['id'] ?? 0,
      institution: json['insti_title'] ?? '',
      description: json['insti_description'] ?? '',
    );
  }
}
//
// class PositionModel {
//   final String retCode;
//   final String message;
//   final PositionData data;
//
//   PositionModel({
//     required this.retCode,
//     required this.message,
//     required this.data,
//   });
//   factory PositionModel.fromJson(Map<String, dynamic> json) {
//     return PositionModel(
//       retCode: json['retCode'],
//       message: json['message'],
//       data: PositionData.fromJson(json['data']),
//     );
//   }
// }
//
// class PositionData {
//   late int id;
//   late String position;
//   late String description;
//
//   PositionData({required this.id, required this.position, required this.description});
//
//   factory PositionData.fromJson(Map<String, dynamic> json) {
//     return PositionData(
//       id: json['id'] ?? 0,
//       position: json['position'] ?? '',
//       description: json['insti_description'] ?? '',
//     );
//   }
// }
//
// List<PositionData> positions = positionList.map((json) => PositionData.fromJson(json)).toList();
// const positionList = [
//   {'id': 1, 'position': 'Application Administrator', 'description': 'Application Administrator'},
//   {'id': 2, 'position': 'Asst. Application Admin', 'description': 'Asst. Application Admin'},
//   {'id': 3, 'position': 'IT Manager', 'description': 'IT Manager'},
//   {'id': 4, 'position': 'Cluster IT Head', 'description': 'Cluster IT Head'},
//   {'id': 5, 'position': 'Business Analyst', 'description': 'Business Analyst'},
//   {'id': 6, 'position': 'Senior Program Manager', 'description': 'Senior Program Manager'},
//   {'id': 7, 'position': 'Project Manager', 'description': 'Project Manager'},
//   {'id': 8, 'position': 'Project Coordinator', 'description': 'Project Coordinator'},
//   {'id': 9, 'position': 'RIT Officer', 'description': 'RIT Officer'},
// ];
//
// Future<List<PositionData>> loadPositionsFromJson() async {
//   String jsonString = await rootBundle.loadString('assets/json/zipcodes.json');
//   List<dynamic> jsonList = json.decode(jsonString);
//   return jsonList.map((json) => PositionData.fromJson(json)).toList();
// }

class MfiInstiModel {
  String? retCode;
  String? message;
  List<Mfiinsti>? data;

  MfiInstiModel({this.retCode, this.message, this.data});

  MfiInstiModel.fromJson(Map<String, dynamic> json) {
    retCode = json['retCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Mfiinsti>[];
      json['data'].forEach((v) {
        data!.add(new Mfiinsti.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['retCode'] = this.retCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mfiinsti {
  int? id;
  String? roleTitle;
  String? roleDescription;
  List<Matrix>? matrix;
  String? status;
  String? createdAt;
  Null? updatedAt;

  Mfiinsti({this.id, this.roleTitle, this.roleDescription, this.matrix, this.status, this.createdAt, this.updatedAt});

  Mfiinsti.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleTitle = json['role_title'];
    roleDescription = json['role_description'];
    if (json['matrix'] != null) {
      matrix = <Matrix>[];
      json['matrix'].forEach((v) {
        matrix!.add(new Matrix.fromJson(v));
      });
    }
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_title'] = this.roleTitle;
    data['role_description'] = this.roleDescription;
    if (this.matrix != null) {
      data['matrix'] = this.matrix!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Matrix {
  List<Access>? access;
  String? dashboard;

  Matrix({this.access, this.dashboard});

  Matrix.fromJson(Map<String, dynamic> json) {
    if (json['access'] != null) {
      access = <Access>[];
      json['access'].forEach((v) {
        access!.add(new Access.fromJson(v));
      });
    }
    dashboard = json['dashboard'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.access != null) {
      data['access'] = this.access!.map((v) => v.toJson()).toList();
    }
    data['dashboard'] = this.dashboard;
    return data;
  }
}

class Access {
  List<String>? subMenu;
  String? menuTitle;

  Access({this.subMenu, this.menuTitle});

  Access.fromJson(Map<String, dynamic> json) {
    subMenu = json['sub_menu'].cast<String>();
    menuTitle = json['menu_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_menu'] = this.subMenu;
    data['menu_title'] = this.menuTitle;
    return data;
  }
}
