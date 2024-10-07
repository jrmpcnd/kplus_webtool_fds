import 'package:flutter/material.dart';

class BackDrop extends StatelessWidget {
  const BackDrop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/kplus_webtool_login.png'), fit: BoxFit.cover),
          // color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10))),
      // height: 600,
      // width: 700,
      // child: const Center(
      //   child: Image(
      //     // image: AssetImage('images/print2.png'),
      //     image: AssetImage('images/gabay.png'),
      //     fit: BoxFit.contain,
      //   ),
      // )
    );
  }
}
