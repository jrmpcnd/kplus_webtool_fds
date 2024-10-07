import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/utils/utils_responsive.dart';

class ImgHeader extends StatelessWidget {
  const ImgHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Responsive(
            mobile: Container(
              margin: const EdgeInsets.only(left: 10),
              child: const Image(
                // image: AssetImage('/images/kplus_webtool_logo.png'),
                image: AssetImage('/images/kplus.png'),
                height: 50,
                width: 150,
              ),
            ),
            desktop: Container()),
        Responsive(
          desktop: const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Column(
              children: [
                //Image(image: AssetImage('/images/kplus_icon.png'), width: 100,height: 100,),
                Text(
                  'WEBTOOL',
                  style: TextStyle(color: Colors.black, fontFamily: 'RobotoThin', fontWeight: FontWeight.bold, fontSize: 25, letterSpacing: 2),
                ),
                Text(
                  'MANAGEMENT SYSTEM',
                  style: TextStyle(color: Colors.black, fontFamily: 'RobotoThin', fontSize: 10, letterSpacing: 1),
                ),
              ],
            ),
          ),
          mobile: Container(),
        ),
      ],
    );
  }
}
