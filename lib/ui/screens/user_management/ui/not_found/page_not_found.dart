import 'package:flutter/material.dart';

import '../../../../shared/utils/utils_responsive.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/values/strings.dart';
import '../../../../shared/values/styles.dart';
import '../../../../shared/widget/buttons/button.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Responsive(
              mobile: notFoundPageBody(MediaQuery.of(context).size.width * 0.8, 20),
              desktop: notFoundPageBody(MediaQuery.of(context).size.width * 0.5, 30),
            )),
      ),
    );
  }

  Widget notFoundPageBody(double width, double fontSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: const AssetImage('images/404_page.png'),
          width: width,
        ),
        Text(
          StringTexts.pageNotFoundTitle,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700),
        ),
        const Text(
          StringTexts.pageNotFoundSubTitle,
          style: TextStyles.headingTextStyle,
        ),
        const SizedBox(height: 50),
        SizedBox(width: 200, child: CustomColoredButton.primaryButtonWithText(context, 5, () => Navigator.pushNamed(context, '/Home'), AppColors.maroon2, 'Go To Homepage'))
      ],
    );
  }
}
