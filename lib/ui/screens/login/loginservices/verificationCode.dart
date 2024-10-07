// original | july 30, 2024
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
//
//
//
// class RegistrationVerificationCode extends StatefulWidget {
//   String code;
//   RegistrationVerificationCode({Key? key, required this.code}) : super(key: key);
//
//   @override
//   State<RegistrationVerificationCode> createState() => _RegistrationVerificationCodeState();
// }
//
// class _RegistrationVerificationCodeState extends State<RegistrationVerificationCode> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController codeController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Container(
//             height: 60,
//             width: 360,
//             alignment: Alignment.center,
//             padding: const EdgeInsets.only(top: 1.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(80),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(1.0),
//               child: TextFormField(
//                 controller: codeController,
//                 //initialValue: UserReg.GetCode(),
//                 onChanged: (code) {
// AddnewUsers.setCode(code);
//                   setState(() {
//                     codeController.text = code;
//                   });
//                   print('Code Typed: $code');
//                 },
//                 textInputAction: TextInputAction.next,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 style: Theme.of(context).textTheme.headline6,
//                 keyboardType: TextInputType.number,
//                 textAlign: TextAlign.center,
//                 inputFormatters: [
//                   LengthLimitingTextInputFormatter(6),
//                   FilteringTextInputFormatter.digitsOnly,
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//edited | july 30, 2024
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';

class RegistrationVerificationCode extends StatefulWidget {
  String code;
  RegistrationVerificationCode({Key? key, required this.code}) : super(key: key);

  @override
  State<RegistrationVerificationCode> createState() => _RegistrationVerificationCodeState();
}

class _RegistrationVerificationCodeState extends State<RegistrationVerificationCode> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  void _submitOtp() {
    String otp = _controllers.map((controller) => controller.text).join();
    // print("Entered OTP: $otp");
    AddnewUsers.setCode(otp);
  }

  Widget _buildOtpTextField(int index) {
    return Container(
      width: 50,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '', // hides the character counter
          border: InputBorder.none, // removes the default underline
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) => _buildOtpTextField(index)),
      ),
    );
  }
}
