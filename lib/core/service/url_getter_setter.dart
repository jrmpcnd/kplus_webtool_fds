class UrlGetter {
  // static const String _url = 'https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/usermanagement/test';

  // static const String _url = 'http://192.168.120.144:19017/api/public/v1';
  //static const String _url = 'http://127.0.0.1:19017/api/public/v1';
  static const String _url = 'https://dev-api-janus.fortress-asya.com:18021/api/public/v1';
  //https://dev-api-janus.fortress-asya.com:18021/

  static String getURL() {
    return _url;
  }
}

class AddNewUser {
  static int _id = 0;
  static void setID(int newID) {
    _id = newID;
  }

  static getID() {
    return _id;
  }

  static String _cID = '';
  static void setCID(String newcID) {
    _cID = newcID;
  }

  static getCID() {
    return _cID;
  }

  static String _brCode = '';
  static void setBRCode(String newBRCode) {
    _brCode = newBRCode;
  }

  static getBRCode() {
    return _brCode;
  }

  static String _centerCode = '';
  static void setCenterCode(String newCenterCode) {
    _centerCode = newCenterCode;
  }

  static getCenterCode() {
    return _centerCode;
  }

  static String _unitCode = '';
  static void setUnitCode(String newUnitCode) {
    _unitCode = newUnitCode;
  }

  static getUnitCode() {
    return _unitCode;
  }

  static String _hcisID = '';
  static void setHcisID(String newHcisID) {
    _hcisID = newHcisID;
  }

  static getHcisID() {
    return _hcisID;
  }

  static String _LastName = '';
  static void setLastName(String lastname) {
    _LastName = lastname;
  }

  static getLastName() {
    return _LastName;
  }

  static String _firstName = '';
  static setFirstName(String firstname) {
    _firstName = firstname;
  }

  static getFirstName() {
    return _firstName;
  }

  static String _middleName = '';
  static void setMiddleName(String middlename) {
    _middleName = middlename;
  }

  static getMiddleName() {
    return _middleName;
  }

  static String _position = '';
  static void setNewPosition(String position) {
    _position = position;
  }

  static getNewPosition() {
    return _position;
  }

  static String _institution = '';
  static void setNewInstitution(String institution) {
    _institution = institution;
  }

  static getNewInstitution() {
    return _institution;
  }

  static int _instiID = 0;
  static void setInstiID(int instiID) {
    _instiID = instiID;
  }

  static getInstiID() {
    return _instiID;
  }

  static String _mobileNumber = '';
  static void setMobileNumber(String mobilenumber) {
    _mobileNumber = mobilenumber;
  }

  static getMobileNumber() {
    return _mobileNumber;
  }

  static String _emailAddress = '';
  static void setEmailAddress(String emailaddress) {
    _emailAddress = emailaddress;
  }

  static getEmailAddress() {
    return _emailAddress;
  }

  static String _userName = '';
  static void setUsername(String username) {
    _userName = username;
  }

  static getUsername() {
    return _userName;
  }

  static String _role = '';
  static void setRole(String role) {
    _role = role;
  }

  static getRole() {
    return _role;
  }

  static int _roleID = 0;
  static void setRoleID(int roleID) {
    _roleID = roleID;
  }

  static getRoleID() {
    return _roleID;
  }

  static String _houseNumber = '';
  static void setHouseNumber(String housenumber) {
    _buildingNumber = housenumber;
  }

  static getHouseNumber() {
    return _buildingNumber;
  }

  static String _buildingNumber = '';
  static void setBuildingNumber(String buildingnumber) {
    _buildingNumber = buildingnumber;
  }

  static getBuildingNumber() {
    return _buildingNumber;
  }

  static String _streetName = '';
  static void setStreetName(String streetName) {
    _streetName = streetName;
  }

  static getStreetName() {
    return _streetName;
  }

  static String _barangay = '';
  static void setBarangay(String barangay) {
    _barangay = barangay;
  }

  static getBarangay() {
    return _barangay;
  }

  static String _city = '';
  static void setCity(String city) {
    _city = city;
  }

  static getCity() {
    return _city;
  }

  static String _province = '';
  static void setProvince(String province) {
    _province = province;
  }

  static getProvince() {
    return _province;
  }

  static String _postalCode = '';
  static void setPostalCode(String postalcode) {
    _postalCode = postalcode;
  }

  static getPostalCode() {
    return _postalCode;
  }
}

class UpdateUser {
  static int _id = 0;
  static void setUpdateID(int newID) {
    _id = newID;
  }

  static getUpdateID() {
    return _id;
  }

  static String _hcisID = '';
  static void setUpdateHcisID(String newHcisID) {
    _hcisID = newHcisID;
  }

  static getUpdateHcisID() {
    return _hcisID;
  }

  static int _cID = 0;
  static void setUpdateCID(int newcID) {
    _cID = newcID;
  }

  static getUpdateCID() {
    return _cID;
  }

  static String _brCode = '';
  static void setUpdateBRCode(String newBRCode) {
    _brCode = newBRCode;
  }

  static getUpdateBRCode() {
    return _brCode;
  }

  static String _centerCode = '';
  static void setUpdateCenterCode(String newCenterCode) {
    _centerCode = newCenterCode;
  }

  static getUpdateCenterCode() {
    return _centerCode;
  }

  static String _unitCode = '';
  static void setUpdateUnitCode(String newUnitCode) {
    _unitCode = newUnitCode;
  }

  static getUpdateUnitCode() {
    return _unitCode;
  }

  static String _LastName = '';
  static void setUpdateLastName(String lastname) {
    _LastName = lastname;
  }

  static getUpdateLastName() {
    return _LastName;
  }

  static String _firstName = '';
  static setUpdateFirstName(String firstname) {
    _firstName = firstname;
  }

  static getUpdateFirstName() {
    return _firstName;
  }

  static String _middleName = '';
  static void setUpdateMiddleName(String middlename) {
    _middleName = middlename;
  }

  static getUpdateMiddleName() {
    return _middleName;
  }

  static String _position = '';
  static void setUpdateNewPosition(String position) {
    _position = position;
  }

  static getUpdateNewPosition() {
    return _position;
  }

  static String _institution = '';
  static void setUpdateNewInstitution(String institution) {
    _institution = institution;
  }

  static getUpdateNewInstitution() {
    return _institution;
  }

  static int _instiID = 0;
  static void setUpdateInstiID(int instiID) {
    _instiID = instiID;
  }

  static getUpdateInstiID() {
    return _instiID;
  }

  static String _mobileNumber = '';
  static void setUpdateMobileNumber(String mobilenumber) {
    _mobileNumber = mobilenumber;
  }

  static getUpdateMobileNumber() {
    return _mobileNumber;
  }

  static String _emailAddress = '';
  static void setUpdateEmailAddress(String emailaddress) {
    _emailAddress = emailaddress;
  }

  static getUpdateEmailAddress() {
    return _emailAddress;
  }

  static String _userName = '';
  static void setUpdateUsername(String username) {
    _userName = username;
  }

  static getUpdateUsername() {
    return _userName;
  }

  static String _role = '';
  static void setUpdateRole(String role) {
    _role = role;
  }

  static getUpdateRole() {
    return _role;
  }

  static int _roleID = 0;
  static void setUpdateRoleID(int roleID) {
    _roleID = roleID;
  }

  static getUpdateRoleID() {
    return _roleID;
  }

  static String _houseNumber = '';
  static void setUpdateHouseNumber(String housenumber) {
    _buildingNumber = housenumber;
  }

  static getUpdateHouseNumber() {
    return _buildingNumber;
  }

  static String _buildingNumber = '';
  static void setUpdateBuildingNumber(String buildingnumber) {
    _buildingNumber = buildingnumber;
  }

  static getUpdateBuildingNumber() {
    return _buildingNumber;
  }

  static String _streetName = '';
  static void setUpdateStreetName(String streetName) {
    _streetName = streetName;
  }

  static getUpdateStreetName() {
    return _streetName;
  }

  static String _barangay = '';
  static void setUpdateBarangay(String barangay) {
    _barangay = barangay;
  }

  static getUpdateBarangay() {
    return _barangay;
  }

  static String _city = '';
  static void setUpdateCity(String city) {
    _city = city;
  }

  static getUpdateCity() {
    return _city;
  }

  static String _province = '';
  static void setUpdateProvince(String province) {
    _province = province;
  }

  static getUpdateProvince() {
    return _province;
  }

  static String _postalCode = '';
  static void setUpdatePostalCode(String postalcode) {
    _postalCode = postalcode;
  }

  static getUpdatePostalCode() {
    return _postalCode;
  }
}

class AddnewUsers {
  static int _instiCode = 0;
  static void setInstiCode(int instiCode) {
    _instiCode = instiCode;
  }

  static getInstiCode() {
    return _instiCode;
  }

  static String _hcisId = '';
  static void setHcisID(String hcisId) {
    _hcisId = hcisId;
  }

  static getHcisID() {
    return _hcisId;
  }

  static int _roleId = 0;
  static void setRoleId(int roleId) {
    _roleId = roleId;
  }

  static getRoleId() {
    return _roleId;
  }

  static String _role = '';
  static void setRole(String role) {
    _role = role;
  }

  static getRole() {
    return _role;
  }

  static String _firstname = '';
  static void setFirstname(String firstname) {
    _firstname = firstname;
  }

  static getFirstname() {
    return _firstname;
  }

  static String _middlename = '';
  static void setMiddleName(String middlename) {
    _middlename = middlename;
  }

  static getMiddleName() {
    return _middlename;
  }

  static String _lastname = '';
  static void setLastName(String lastname) {
    _lastname = lastname;
  }

  static getLastName() {
    return _lastname;
  }

  static String _position = '';
  static void setPosition(String position) {
    _position = position;
  }

  static getPosition() {
    return _position;
  }

  static String _email = '';
  static void setEmail(String email) {
    _email = email;
  }

  static getEmail() {
    return _email;
  }

  static String _username = '';
  static void setUsername(String username) {
    _username = username;
  }

  static getUsername() {
    return _username;
  }

  static String _contact = '';
  static void setContact(String contact) {
    _contact = contact;
  }

  static getContact() {
    return _contact;
  }

  static String _branch = '';
  static void setBranch(String branch) {
    _branch = branch;
  }

  static getBranch() {
    return _branch;
  }

  static String _unit = '';
  static void setUnit(String unit) {
    _unit = unit;
  }

  static getUnit() {
    return _unit;
  }

  static String _center = '';
  static void setCenter(String center) {
    _center = center;
  }

  static getCenter() {
    return _center;
  }

  static String _birthday = '';
  static void setBirthday(String birthday) {
    _birthday = birthday;
  }

  static getBirthday() {
    return _birthday;
  }

  static String _code = '';
  static void setCode(String code) {
    _code = code;
  }

  static getCode() {
    return _code;
  }
}
