import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';

class CustomToast {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.5 - 25.0, // Adjust position vertically
        left: MediaQuery.of(context).size.width * 0.5 - 100.0, // Adjust position horizontally
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              style: const TextStyle(color: AppColors.whiteColor),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2)).then((value) {
      overlayEntry.remove();
    });
  }
}

class CustomTopToast {
  static void show(BuildContext context, String message, int time) {
    final overlay = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.1, // Adjust position vertically for top
        left: MediaQuery.of(context).size.width * 0.5 - 100.0, // Adjust position horizontally
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(color: AppColors.toastColor, borderRadius: BorderRadius.circular(5.0), boxShadow: [
              BoxShadow(
                color: AppColors.maroon2.withOpacity(0.2),
                offset: const Offset(2, 2),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ]),
            child: Text(
              message,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: time)).then((value) {
      overlayEntry.remove();
    });
  }
}
