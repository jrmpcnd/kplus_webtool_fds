// DISPLAYS USER INFO UPON ENTRY OF STAFF ID IN THE FORM FIELD
class GetUserByHCIS {
  final String retCode;
  final String message;
  final GetUserByStaffID data;

  GetUserByHCIS({
    required this.retCode,
    required this.message,
    required this.data,
  });

  factory GetUserByHCIS.fromJson(Map<String, dynamic> json) {
    return GetUserByHCIS(
      retCode: json['retCode'],
      message: json['message'],
      data: GetUserByStaffID.fromJson(json['data']),
    );
  }
}

class GetUserByStaffID {
  // late final String cid;
  late final String firstName;
  late final String middleName;
  late final String lastName;
  late final String mobileNumber;
  late final String email;
  late final String? birthday;

  //mfi_whitelist_admin_portal
  late final int mwapinstiID;
  late final String mwapHCISiD;
  late final int mwaproleID;
  late final String mwapfname;
  late final String mwapmname;
  late final String mwaplname;
  late final String mwapposition;
  late final String mwapemail;
  late final String mwapusername;
  late final String mwapcontact;
  late final String mwapbranch;
  late final String mwapunit;
  late final String mwapcenter;
  late final String mwapbirthday;
  //

  GetUserByStaffID(
      {
      // required this.cid,
      //required this.firstName, required this.middleName, required this.lastName, required this.mobileNumber, required this.email, this.birthday
      //mfi_whitelist_admin_portal
      required this.mwapinstiID,
      required this.mwapHCISiD,
      required this.mwaproleID,
      required this.mwapfname,
      required this.mwapmname,
      required this.mwaplname,
      required this.mwapposition,
      required this.mwapemail,
      required this.mwapusername,
      required this.mwapcontact,
      required this.mwapbranch,
      required this.mwapunit,
      required this.mwapcenter,
      required this.mwapbirthday
      //
      });

  GetUserByStaffID.fromJson(Map<String, dynamic> json) {
    // cid = json['cid'];
    // firstName = json['firstName'];
    // middleName = json['middleName'];
    // lastName = json['lastName'];
    // mobileNumber = json['mobile'];
    // email = json['emailAddress'];
    // birthday = json['birthday'];

    //mfi_whitelist_admin_portal
    mwapinstiID = json['insti_id'];
    mwapHCISiD = json['hcis_id'];
    mwaproleID = json['role_id'];
    mwapfname = json['first_name'];
    mwapmname = json['middle_name'];
    mwaplname = json['last_name'];
    mwapposition = json['position'];
    mwapemail = json['email'];
    mwapusername = json['username'];
    mwapcontact = json['contact'];
    mwapbranch = json['branch'];
    mwapunit = json['unit'];
    mwapcenter = json['center_code'];
    mwapbirthday = json['birthday'];
    //
  }
}

class User {
  late int? id;
  late int institutionID;
  late String staffID;
  late int roleID;
  late String firstName;
  late String? middleName;
  late String lastName;
  late String position;
  late String emailAddress;
  late String username;
  final String? mpin;
  final String? houseNo;
  final String? buildingNo;
  final String? street;
  final String? barangay;
  final String? city;
  final String? province;
  final String? postalCode;
  final String? contactType;
  final String? contact;
  late String? cid;
  late String? brCode;
  late String? unitCode;
  late String? centerCode;
  late String? birthday;

  User({
    this.id,
    required this.institutionID,
    required this.staffID,
    required this.roleID,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.position,
    required this.emailAddress,
    required this.username,
    this.mpin,
    this.houseNo,
    this.buildingNo,
    this.street,
    this.barangay,
    this.city,
    this.province,
    this.postalCode,
    this.contactType,
    this.contact,
    this.cid,
    this.brCode,
    this.unitCode,
    this.centerCode,
    this.birthday,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['insti_id'] = institutionID;
    data['hcis_id'] = staffID;
    data['role_id'] = roleID;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['position'] = position;
    data['email'] = emailAddress;
    data['username'] = username;
    data['mpin'] = mpin;
    data['house_no'] = houseNo;
    data['building_no'] = buildingNo;
    data['street'] = street;
    data['barangay'] = barangay;
    data['city'] = city;
    data['province'] = province;
    data['postal_code'] = postalCode;
    data['contact_type'] = contactType;
    data['contact'] = contact;
    data['cid'] = cid;
    data['branch'] = brCode;
    data['unit'] = unitCode;
    data['center_code'] = centerCode;
    data['birthday'] = birthday;
    return data;
  }
}

class AllUser {
  final String retCode;
  final String message;
  final AllUserData data;

  AllUser({
    required this.retCode,
    required this.message,
    required this.data,
  });

  factory AllUser.fromJson(Map<String, dynamic> json) {
    return AllUser(
      retCode: json['retCode'],
      message: json['message'],
      data: AllUserData.fromJson(json['data']),
    );
  }
}

// class AllUserData {
//   late int? id;
//   late String? staffID;
//   late String? brCode;
//   late String? unitCode;
//   late String? centerCode;
//   late String? cid;
//   late String? firstName;
//   late String? middleName;
//   late String? lastName;
//   late String? position;
//   late String? institution;
//   late String? mobileNumber;
//   String? emailAddress;
//   late String? username;
//   late String? password;
//   late String? userRole;
//   late String? houseNumber;
//   late String? buildingNumber;
//   late String? streetName;
//   late String? barangay;
//   late String? city;
//   late String? province;
//   late String? postalCode;
//   late String? status;
//   late String fullName;
//
//   //mfi_whitelist_admin_portal
//   // late int? instiID;
//   // late String? hcisID;
//   // late int? roleID;
//   // late String? firstname;
//   // late String? middlename;
//   // late String? lastname;
//   // late String? position;
//   // late String? email;
//   // late String? username;
//   // late String? contact;
//   // late String? branch;
//   // late String? unit;
//   // late String? center;
//   // late String? birthday;
//
//   //
//
//   AllUserData({
//     this.id,
//     this.staffID,
//     this.brCode,
//     this.unitCode,
//     this.centerCode,
//     this.cid,
//     this.firstName,
//     this.middleName,
//     this.lastName,
//     this.position,
//     this.institution,
//     this.mobileNumber,
//     this.emailAddress,
//     this.username,
//     this.password,
//     this.userRole,
//     this.houseNumber,
//     this.buildingNumber,
//     this.streetName,
//     this.barangay,
//     this.city,
//     this.province,
//     this.postalCode,
//     this.status,
//
// // mfi_whitelist_admin_portal
// // this.instiID,
// //     this.hcisID,
// //     this.roleID,
// //     this.firstname,
// //     this.middlename,
// //     this.lastname,
// //     this.position,
// //     this.email,
// //     this.username,
// //     this.contact,
// //     this.branch,
// //     this.unit,
// //     this.center,
// //     this.birthday
// //
//   });
//       // : fullName = '$firstname ${middleName != null && middleName.isNotEmpty ? '${middleName[0]}.' : ' '} $lastName'.trim();
//
//   factory AllUserData.fromJson(Map<String, dynamic> json) {
//     return AllUserData(
//       // instiID: json['insti_id'],
//       // hcisID: json['hcis_id'],
//       // roleID: json['role_id'],
//       // firstname: json['first_name'],
//       // middlename: json['middle_name'],
//       // lastname: json['last_name'],
//       // position: json['position'],
//       // email: json['email'],
//       // username: json['username'],
//       // contact: json['contact'],
//       // branch: json['branch'],
//       // unit: json['unit'],
//       // center: json['center'],
//       // birthday: json['birthday']
//       id: json['id'],
//       staffID: json['hcis_id'],
//       brCode: json['branch'],
//       unitCode: json['unit'],
//       centerCode: json['centerCode'],
//       cid: json['cid'],
//       firstName: json['first_name'],
//       middleName: json['middle_name'],
//       lastName: json['last_name'],
//       institution: json['institution'],
//       position: json['position'],
//       mobileNumber: json['contact'],
//       emailAddress: json['email'] ?? '',
//       username: json['username'],
//       password: json['password'],
//       userRole: json['role'],
//       houseNumber: json['house_no'],
//       buildingNumber: json['building_no'],
//       streetName: json['street'],
//       barangay: json['barangay'],
//       city: json['city'],
//       province: json['province'],
//       postalCode: json['postal_code'],
//       status: json['status'],
//     );
//   }
// //
// //   void updateStatus(String newStatus) {
// //     status = newStatus;
// //   }
// }

class AllUserData {
  int? id;
  String? hcisId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? position;
  String? institution;
  String? contact;
  String? email;
  String? username;
  String? password;
  String? role;
  String? houseNo;
  String? buildingNo;
  String? street;
  String? barangay;
  String? city;
  String? province;
  String? postalCode;
  String? cid;
  String? branch;
  String? unit;
  String? centerCode;
  String? birthday;
  String? status;

  AllUserData({this.id, this.hcisId, this.firstName, this.middleName, this.lastName, this.position, this.institution, this.contact, this.email, this.username, this.password, this.role, this.houseNo, this.buildingNo, this.street, this.barangay, this.city, this.province, this.postalCode, this.cid, this.branch, this.unit, this.centerCode, this.birthday, this.status});

  AllUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hcisId = json['hcis_id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    position = json['position'];
    institution = json['institution'];
    contact = json['contact'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    role = json['role'];
    houseNo = json['house_no'];
    buildingNo = json['building_no'];
    street = json['street'];
    barangay = json['barangay'];
    city = json['city'];
    province = json['province'];
    postalCode = json['postal_code'];
    cid = json['cid'];
    branch = json['branch'];
    unit = json['unit'];
    centerCode = json['center_code'];
    birthday = json['birthday'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hcis_id'] = this.hcisId;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['position'] = this.position;
    data['institution'] = this.institution;
    data['contact'] = this.contact;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['role'] = this.role;
    data['house_no'] = this.houseNo;
    data['building_no'] = this.buildingNo;
    data['street'] = this.street;
    data['barangay'] = this.barangay;
    data['city'] = this.city;
    data['province'] = this.province;
    data['postal_code'] = this.postalCode;
    data['cid'] = this.cid;
    data['branch'] = this.branch;
    data['unit'] = this.unit;
    data['center_code'] = this.centerCode;
    data['status'] = this.status;
    return data;
  }
}

Set<String> getDistinctUsernames(List<AllUserData> users) {
  Set<String> distinctUsernames = {};
  for (var user in users) {
    if (user.username != null && user.username!.isNotEmpty) {
      print('Adding username: ${user.username}'); // Debug print
      distinctUsernames.add(user.username!);
    }
  }
  return distinctUsernames;
}

class SendPasswordRecovery {
  late final String message;

  SendPasswordRecovery({required this.message});
  SendPasswordRecovery.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}

//RESET PASSWORD VIA ADMIN ACCOUNT
class AdminChangeUserPassword {
  late String email;
  late String password;

  AdminChangeUserPassword({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}

//RESET PASSWORD VIA USER ACCOUNT
class UserChangePassword {
  late String existingPassword;
  late String password;

  UserChangePassword({
    required this.existingPassword,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oldPassword'] = existingPassword;
    data['password'] = password;
    return data;
  }
}

//RESET PASSWORD VIA EMAIL LINK
class EmailLinkChangePassword {
  late String password;
  late String oldPass;

  EmailLinkChangePassword({required this.password, required this.oldPass});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['password'] = password;
    data['oldPassword'] = oldPass;
    return data;
  }
}
