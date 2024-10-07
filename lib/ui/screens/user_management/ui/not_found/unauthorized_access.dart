import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/base_screen.dart';

import '../../../../shared/utils/utils_responsive.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/values/strings.dart';
import '../../../../shared/values/styles.dart';

class UnauthorizedScreenPage extends StatefulWidget {
  const UnauthorizedScreenPage({Key? key}) : super(key: key);

  @override
  State<UnauthorizedScreenPage> createState() => _UnauthorizedScreenPageState();
}

class _UnauthorizedScreenPageState extends State<UnauthorizedScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseScreen(
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Responsive(
              mobile: notFoundPageBody(MediaQuery.of(context).size.width * 0.8, 20),
              desktop: notFoundPageBody(MediaQuery.of(context).size.width * 0.5, 30),
            )),
        screenText: '',
        children: const [],
      ),
    );
  }

  Widget notFoundPageBody(double width, double fontSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image(
          //   image: const AssetImage('images/404.png'),
          //   width: width,
          // ),
          Text(
            StringTexts.unauthorizedScreenTitle,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700, color: CagabayColors.Main),
          ),
          const Text(
            StringTexts.unauthorizedScreenSubTitle,
            style: TextStyles.headingTextStyle,
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
