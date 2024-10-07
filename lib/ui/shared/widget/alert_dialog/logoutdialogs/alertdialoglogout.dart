import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';

import '../../../../../core/api/login_logout/logout.dart';
import '../../../values/colors.dart';

void showLogoutAlertDialog(BuildContext context) {
  Widget cancelButton = TextButton(
    child: const Text(
      "Cancel",
      style: TextStyles.dataTextStyle,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget confirmButton = TextButton(
    child: const Text(
      "Logout",
      style: TextStyles.dataTextStyle,
    ),
    onPressed: () {
      logout(getToken(), true);
    },
  );

  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    title: Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: AppColors.maroon2,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Iconsax.logout_copy,
            color: AppColors.whiteColor,
            size: 15,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Log out",
            style: TextStyles.bold14White,
          ),
        ],
      ),
    ),
    titlePadding: const EdgeInsets.all(0),
    content: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Are you sure you want to end the session?",
          style: TextStyles.dataTextStyle,
        ),
      ],
    ),
    actions: [
      cancelButton,
      confirmButton,
    ],
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
