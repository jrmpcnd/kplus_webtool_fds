// dialog_utils.dart

import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/utils/utils_responsive.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/buttons/button.dart';

/// REUSABLE preview panel dialog function
void showPreviewPanelDialog({
  required BuildContext context,
  required String title,
  required List<Widget> totalsWidgets,
  required Widget tableWidget,
  required String uploadStatus,
  required String parameterMessage,
  required VoidCallback onUpload,
}) {
  showGeneralDialog(
    context: Navigator.of(context).overlay!.context,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      surfaceTintColor: Colors.white,
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('/images/mwap_header.png'), fit: BoxFit.cover, opacity: 0.5),
          color: AppColors.maroon2,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
        ),
        child: Row(
          children: [
            Text(title, style: TextStyles.bold18White),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.cancel_presentation,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10, top: 5),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  if (uploadStatus != 'SUCCESS')
                    MyButton.buttonWithLabel(
                      context,
                      onUpload,
                      'Upload File',
                      Icons.file_upload,
                      AppColors.maroon2,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Responsive(
              mobile: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: totalsWidgets,
              ),
              tablet: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: totalsWidgets),
              ),
              desktop: const SizedBox.shrink(),
            ),
            Expanded(
              child: Center(
                child: Responsive(
                  mobile: tableWidget,
                  desktop: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(children: totalsWidgets),
                      Expanded(child: tableWidget),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
