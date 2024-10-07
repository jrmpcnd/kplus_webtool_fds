import 'package:flutter/material.dart';

class PassWord extends StatefulWidget {
  final TextEditingController controller;
  const PassWord({Key? key, required this.controller}) : super(key: key);

  @override
  State<PassWord> createState() => _PassWordState();
}

class _PassWordState extends State<PassWord> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 45,
      child: TextFormField(
        style: const TextStyle(fontSize: 12, fontFamily: 'RobotoThin'),
        textInputAction: TextInputAction.next,
        controller: widget.controller,
        // cursorColor: const Color(0xff1E5128),
        cursorColor: const Color(0xff941c1b),
        cursorWidth: 1,
        cursorHeight: 15,
        cursorRadius: const Radius.circular(10),
        obscureText: _obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 5, left: 10, right: 15),
          filled: true,
          fillColor: Colors.white10,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              // color: Color(0xff009150),
              color: Color(0xff941c1b),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              // color: Color(0xff1E5128),
              color: Color(0xff941c1b),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              // color: Color(0xff941c1b),
              width: 0.6,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          prefixIcon: const Icon(
            Icons.key,
            // color: Color(0xff1E5128),
            color: Color(0xff941c1b),
            size: 17,
          ),
          hintText: 'Password',
          hintStyle: const TextStyle(fontSize: 12, fontFamily: 'Robotothin'),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              // color: const Color(0xff1E5128),
              color: const Color(0xff941c1b),
              size: 17,
            ),
          ),
        ),
        validator: (value) {
          print(value);
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      ),
    );
  }
}
