import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/alert_dialog/alert_dialogs.dart';

import '../../../../core/api/login_logout/logout.dart';
import '../../../../core/service/url_getter_setter.dart';
import '../../../shared/values/colors.dart';
import '../../../shared/values/styles.dart';
import '../../../shared/widget/containers/toast.dart';

class EmailVerificationDialog extends StatefulWidget {
  final bool invalidCode;

  EmailVerificationDialog({this.invalidCode = false});

  @override
  _EmailVerificationDialogState createState() => _EmailVerificationDialogState();
}

class _EmailVerificationDialogState extends State<EmailVerificationDialog> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  late bool _invalidCode;

  @override
  void initState() {
    super.initState();
    _invalidCode = widget.invalidCode;
  }

  void _submitOtp() {
    String otp = _controllers.map((controller) => controller.text).join();
    // print("Entered OTP: $otp");
    AddnewUsers.setCode(otp);
    showResponse(context);
  }

  Widget _buildOtpTextField(int index) {
    // Request focus for the first OTP field when the widget is built
    if (index == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[index].requestFocus();
      });
    }

    return Container(
      width: 45,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: _invalidCode ? AppColors.maroon4 : AppColors.maroon2, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          counterText: '', // hides the character counter
          border: InputBorder.none, // removes the default underline
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: AppColors.maroon4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: AppColors.maroon2, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.9), width: 2),
          ),
        ),
        style: Theme.of(context).textTheme.headline6,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.length == 1 && index < _focusNodes.length - 1) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          } else if (value.length == 1 && index == _focusNodes.length - 1) {
            _focusNodes[index].unfocus();
            _submitOtp();
          }
          // if (value.length == 1 && index < _focusNodes.length - 1) {
          //   _focusNodes[index + 1].requestFocus();
          // } else if (value.isEmpty && index > 0) {
          //   _focusNodes[index - 1].requestFocus();
          // } else if (value.length == 1 && index == _focusNodes.length - 1) {
          //   _focusNodes[index].unfocus();
          //   _submitOtp();
          // }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.maroon2,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
        ),
        child: const Text("Verification Code", style: TextStyles.bold18White),
      ),
      titlePadding: const EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Please check your email for the verification code and enter it below.",
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) => _buildOtpTextField(index)),
            ),
          ),
        ],
      ),
    );
  }

  void showResponse(BuildContext context) async {
    if (AddnewUsers.getCode() != null) {
      try {
        http.Response response = await configReg.configReg(AddnewUsers.getCode());

        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (response.statusCode == 200 && responseBody['success'] == true) {
          html.window.localStorage['idlePopup'] = ''; // do not delete, tracking variable for idle
          html.window.localStorage['Path'] = '/Home';
          // print('success pass');
          Navigator.pushNamed(context, '/Home');
        } else {
          CustomTopToast.show(context, '${responseBody['message']}', 2);
          if (responseBody['message'] == 'The code expired.') {
            clearLocalStorage();
            await Future.delayed(Duration(seconds: 3));
            CustomTopToast.show(context, 'Kindly re-login to request a new code', 2);
            Navigator.pop(context);
          } else if (responseBody['message'] == 'Invalid Code') {
            setState(() {
              _invalidCode = true;
            });
          }
        }
      } catch (e) {
        debugPrint('error : $e');
      }
    } else {
      debugPrint("this should not be empty");
    }
  }
}

void showEmailVerificationCode(BuildContext context, {bool invalidCode = false}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return EmailVerificationDialog(invalidCode: invalidCode);
    },
  );
}
