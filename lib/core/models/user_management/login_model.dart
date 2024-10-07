class Login {
  final String retCode;
  final String message;
  final LoginData data;

  Login({
    required this.retCode,
    required this.message,
    required this.data,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      retCode: json['retCode'],
      message: json['message'],
      data: LoginData.fromJson(json['data']),
    );
  }
}

class LoginData {
  final String firstName;
  final String lastName;
  final String insti;
  final String token;
  final String uid;
  final String userrole;

  LoginData({
    required this.firstName,
    required this.lastName,
    required this.insti,
    required this.token,
    required this.uid,
    required this.userrole,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      firstName: json['fname'],
      lastName: json['lname'],
      insti: json['insti'],
      token: json['token'],
      uid: json['uid'],
      userrole: json['userrole'],
    );
  }
}
