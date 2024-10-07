// class Dashboard {
//   final int id;
//   final String dashboardTitle;
//   String? status;
//   final List<Access> access;
//
//   Dashboard({
//     required this.id,
//     required this.dashboardTitle,
//     this.status,
//     required this.access,
//   });
//
//   factory Dashboard.fromJson(Map<String, dynamic> json) {
//     return Dashboard(
//       id: json['id'] ?? 0,
//       dashboardTitle: json['dashboard_title'],
//       status: json['status'],
//       access: (json['access'] as List<dynamic>).map((data) => Access.fromJson(data)).toList(),
//     );
//   }
// }
//
// class Access {
//   final String menuTitle;
//   bool isSelected;
//   final List<String?> subMenu;
//   List<String>? selectedSubMenus;
//
//   Access({
//     required this.menuTitle,
//     required this.isSelected,
//     required this.subMenu,
//     List<String>? selectedSubMenus,
//   }) : selectedSubMenus = selectedSubMenus ?? [];
//
//   factory Access.fromJson(Map<String, dynamic> json) {
//     return Access(
//       menuTitle: json['menu_title'],
//       isSelected: false,
//       subMenu: (json['sub_menu'] as List<dynamic>).cast<String?>(),
//       selectedSubMenus: [],
//     );
//   }
// }
class DashboardData {
  final String retCode;
  final String message;
  final Dashboard data;

  DashboardData({
    required this.retCode,
    required this.message,
    required this.data,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      retCode: json['retCode'],
      message: json['message'],
      data: Dashboard.fromJson(json['data']),
    );
  }
}

class Dashboard {
  final int dashboardId;
  final String dashboardTitle;
  String? dashboardIcon;
  // String? status;
  final List<Access> access;

  Dashboard({
    required this.dashboardId,
    required this.dashboardTitle,
    this.dashboardIcon,
    // this.status,
    required this.access,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      dashboardId: json['dashboard_id'] ?? 0,
      dashboardTitle: json['dashboard_title'],
      dashboardIcon: json['dashboard_icon'],
      // status: json['status'],
      access: (json['access'] as List<dynamic>).map((data) => Access.fromJson(data)).toList(),
    );
  }
}

class Access {
  final int menuId;
  final String menuTitle;
  String? menuIcon;
  bool isSelected;
  final List<SubMenu> subMenus;
  List<String>? selectedSubMenus;

  Access({
    required this.menuId,
    required this.menuTitle,
    this.menuIcon,
    required this.isSelected,
    required this.subMenus,
    List<String>? selectedSubMenus,
  }) : selectedSubMenus = selectedSubMenus ?? [];

  factory Access.fromJson(Map<String, dynamic> json) {
    return Access(
      menuId: json['menu_id'] ?? 0,
      menuTitle: json['menu_title'],
      menuIcon: json['menu_icon'],
      isSelected: false,
      subMenus: (json['sub_menus'] as List<dynamic>).map((data) => SubMenu.fromJson(data)).toList(),
      selectedSubMenus: [],
    );
  }
}

class SubMenu {
  final int? subMenuId;
  final String? subMenuName;
  String? subMenuIcon;

  SubMenu({this.subMenuId, this.subMenuName, this.subMenuIcon});

  factory SubMenu.fromJson(Map<String, dynamic> json) {
    return SubMenu(
      subMenuId: json['sub_menu_id'] ?? 0,
      subMenuName: json['sub_menu_name'] ?? '',
      subMenuIcon: json['sub_menu_icon'],
    );
  }
}

class RoleData {
  final String retCode;
  final String message;
  final Role data;

  RoleData({
    required this.retCode,
    required this.message,
    required this.data,
  });

  factory RoleData.fromJson(Map<String, dynamic> json) {
    return RoleData(
      retCode: json['retCode'],
      message: json['message'],
      data: Role.fromJson(json['data']),
    );
  }
}

class Role {
  final int id;
  final String roleTitle;
  final String? roleDescription;
  final List<Matrix> matrix;
  String? status;
  final String? createdAt;
  final String? updatedAt;

  Role({
    required this.id,
    required this.roleTitle,
    this.roleDescription,
    required this.matrix,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    List<Matrix> matrixList = [];
    // if (json['matrix'] != null) {
    //   for (final matrixJson in json['matrix']) {
    //     matrixList.add(Matrix.fromJson(matrixJson));
    //   }
    // }
    if (json['matrix'] != null) {
      matrixList = List<Matrix>.from(json['matrix'].map((x) => Matrix.fromJson(x)));
    }

    return Role(
      id: json['id'] ?? 0,
      roleTitle: json['role_title'] ?? '',
      roleDescription: json['role_description'] ?? '',
      matrix: matrixList,
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Matrix {
  final List<Menu>? access;
  final String dashboard;

  Matrix({
    this.access,
    required this.dashboard,
  });

  factory Matrix.fromJson(Map<String, dynamic> json) {
    List<Menu> accessList = [];
    // if (json['access'] != null) {
    //   json['access'].forEach((access) {
    //     accessList.add(Menu.fromJson(access));
    //   });
    // }
    if (json['access'] != null) {
      accessList = List<Menu>.from(json['access'].map((x) => Menu.fromJson(x)));
    }

    return Matrix(
      access: accessList,
      dashboard: json['dashboard'],
    );
  }
}

class Menu {
  final List<String>? subMenu;
  final String? menuTitle;

  Menu({
    this.subMenu,
    this.menuTitle,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      subMenu: json['sub_menu'] != null ? List<String>.from(json['sub_menu']) : null,
      menuTitle: json['menu_title'],
    );
  }
}
