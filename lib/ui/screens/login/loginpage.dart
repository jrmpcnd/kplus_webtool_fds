import 'dart:js';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/core/api/login_logout/login.dart';
import 'package:mfi_whitelist_admin_portal/core/provider/timer_service_provider.dart';
import 'package:mfi_whitelist_admin_portal/main.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/utils/utils_responsive.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:provider/provider.dart';

import '../../../core/api/login_logout/logout.dart';
import '../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../shared/textfields/login/password.dart';
import '../../shared/textfields/login/username.dart';
import 'images/backdrop.dart';
import 'images/header.dart';
import 'loginservices/loginfunction.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final usercontroller = TextEditingController();
  final passcontroller = TextEditingController();
  TimerProvider timerProvider = TimerProvider();

  _clearToken() async {
    if (getToken() != 'null' && getToken() != '' && getToken() != null) {
      await logout(getToken(), true);
    }
  }

  @override
  void initState() {
    super.initState();
    _clearToken();
    context.callMethod('eval', ['window.history.replaceState(null, "", "/Login");']);
    stopTimer();
  }

  void stopTimer() async {
    await Provider.of<TimerProvider>(navigatorKey.currentContext!, listen: false).stop();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginAPI loginAPI = LoginAPI();
    return PopScope(
      canPop: false,
      child: Material(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            height: 550,
            width: 1000,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(5, 5),
                ),
              ],
            ),
            child: Responsive(
              mobile: Stack(
                children: [
                  imageLogin(),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: 400,
                      height: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: AppColors.whiteColor.withOpacity(0.3),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 1.5,
                                color: AppColors.whiteColor.withOpacity(0.2),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: bodyLogin(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              desktop: Row(
                children: [
                  Expanded(flex: 3, child: imageLogin()),
                  Expanded(
                      flex: 4,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            )),
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            alignment: Alignment.bottomCenter,
                            height: 300,
                            width: 400,
                            child: bodyLogin(context),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imageLogin() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff8D0505),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5),
        ),
      ),
      child: const Center(
        child: BackDrop(),
      ),
    );
  }

  Widget bodyLogin(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ImgHeader(),
          const SizedBox(
            height: 40,
          ),
          UserName(controller: usercontroller),
          const SizedBox(height: 20),
          PassWord(controller: passcontroller),
          const SizedBox(height: 35),
          // const SignIn(),
          SizedBox(
            height: 35,
            width: 400,
            child: ElevatedButton(
              //pag nag succes yung code ang need na basahin ay yung username and password get nalang
              onPressed: () {
                login(context, usercontroller, passcontroller);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                // backgroundColor: const Color(0xff1E5128),
                backgroundColor: AppColors.maroon2,
              ),
              child: const Text(
                'SIGN IN',
                style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 13, fontFamily: 'RobotoThin'),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          // Center(
          //   child: TextButton(
          //     onPressed: () {
          //       setState(() {
          //         navigateToResetPasswordPage(context);
          //
          //         // Navigator.pushReplacementNamed(context, '/MFIResetPass');
          //       });
          //     },
          //     child: Text(
          //       'Forgot Password?',
          //       style: TextStyle(color: const Color(0xff941c1b).withOpacity(0.6), fontFamily: 'RobotoThin', fontSize: 12),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
