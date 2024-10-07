import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/strings.dart';

class Temporary extends StatelessWidget {
  const Temporary({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/coming_soon.png'),
            width: 400,
          ),
          Text(
            StringTexts.unavailableScreenTitle,
            style: TextStyle(fontSize: 30, color: Colors.black54),
          ),
          Text(StringTexts.unavailableScreenSubTitle),
        ],
      ),
    );
  }
}
