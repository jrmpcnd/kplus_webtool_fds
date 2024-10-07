import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';

import '../../../../../shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import '../../../../../shared/utils/utils_responsive.dart';
import '../../../../../shared/values/colors.dart';
import '../profile_menu.dart';

class HeaderBar extends StatefulWidget {
  final String screenText;
  const HeaderBar({super.key, required this.screenText});

  @override
  State<HeaderBar> createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar> {
  final fname = getFname();
  final lname = getLname();
  final urole = getUrole();
  final insti = getInstitution();
  bool _showInfoBox = false;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //IMAGE&&LABEL
          headerTitle(),
          const Spacer(),
          profileAvatar(),
          const SizedBox(width: 15),
          profileInfo(),
          const SizedBox(width: 10),
          const ProfileMenu()
        ],
      ),
      mobile: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //IMAGE&&LABEL
          headerTitle(),
          const Spacer(),
          InkWell(
            onTap: () {
              // showProfileInfoBox();
            },
            child: profileAvatar(),
          ),
          const ProfileMenu()
        ],
      ),
    );
  }

  Widget showProfileInfoBox() {
    return AlertDialog(
      content: Center(
        child: Text(
          'Profile Info',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  Widget headerTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // GestureDetector(
        //   onTap: () {
        //     Navigator.pushNamed(context, '/Home');
        //   },
        //   child: Image(
        //     height: 40,
        //     width: 150,
        //     image: AssetImage('images/mwap_logo.png'),
        //   ),
        //   // child: Container(
        //   //   height: 30,
        //   //   width: 140,
        //   //   decoration: BoxDecoration(
        //   //     boxShadow: [
        //   //       BoxShadow(
        //   //         color: AppColors.ngoColor.withOpacity(0.35), // Shadow color
        //   //         spreadRadius: 0.5, // Spread radius
        //   //         blurRadius: 4, // Blur radius
        //   //         offset: const Offset(2, 2), // Offset of the shadow
        //   //       ),
        //   //     ],
        //   //     borderRadius: const BorderRadius.all(Radius.circular(5)),
        //   //     color: Colors.white,
        //   //     border: Border.all(
        //   //       color: AppColors.ngoColor,
        //   //       width: .5,
        //   //     ),
        //   //     image: const DecorationImage(
        //   //       image: AssetImage('images/mfi_whitelist_logo.png'),
        //   //     ),
        //   //   ),
        //   // ),
        // ),

        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/Home');
              },
              child: Image(
                height: 40,
                width: 150,
                image: urole == 'AMLA' ? AssetImage('images/amla_colored_logo.png') : AssetImage('images/kplus_webtool_logo.png'),
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.black,
              margin: EdgeInsets.symmetric(horizontal: 10),
            ),
            // Conditional image display
            Image(
              height: 40,
              width: 150,
              image: AssetImage(
                insti == 'CARD, Inc.'
                    ? 'images/CARD_INC.png'
                    : insti == 'FDSAP'
                        ? 'images/fdsap_logo.png'
                        : insti == 'AMLA'
                            ? 'images/amla_logo.png'
                            : 'images/kplus_webtool_logo.png', // Use a default image if none match
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 5,
        ),
        Text(
          widget.screenText,
          style: const TextStyle(color: Colors.black54, fontSize: 10, letterSpacing: 0.1),
        ),
      ],
    );
  }

  Widget profileAvatar() {
    return Container(
      margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.ngoColor, // choose your border color
          width: 0.5, // choose the border width
        ),
        shape: BoxShape.circle,
      ),
      child: const CircleAvatar(
        backgroundImage: AssetImage('images/avatar.webp'),
        maxRadius: 20,
      ),
    );
  }

  Widget profileInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$fname $lname',
          style: const TextStyle(color: Colors.black87, letterSpacing: 0.5, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          '$insti',
          style: TextStyles.dataTextStyle,
        ),
        Text(
          '$urole',
          style: TextStyles.dataTextStyle,
        ),
        // Clock(),
      ],
    );
  }
}
