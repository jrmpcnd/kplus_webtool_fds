import 'package:flutter/material.dart';

class UserName extends StatefulWidget {
  final TextEditingController controller; // Accept controller as a parameter

  const UserName({Key? key, required this.controller}) : super(key: key);

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 45,
      child: TextFormField(
        style: const TextStyle(fontSize: 12, fontFamily: 'RobotoThin'),
        textInputAction: TextInputAction.next,
        controller: widget.controller,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: const Color(0xff941c1b),
        cursorWidth: 1,
        cursorHeight: 15,
        cursorRadius: const Radius.circular(10),
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
            Icons.person,
            // color: Color(0xff1E5128),
            color: Color(0xff941c1b),
            size: 17,
          ),
          hintText: 'Username',
          hintStyle: const TextStyle(fontSize: 12, fontFamily: 'Robotothin'),
        ),
        validator: (value) {
          print(value);
          if (value == null || value.isEmpty) {
            return 'Please enter your username';
          }
          return null;
        },
      ),
    );
  }
}
