import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../core/mfi_whitelist_api/clients/clients_api.dart';
import '../../../../../main.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/widget/containers/dialog.dart';

typedef DisapproveCallback = Future<void> Function(String remarks);

//topup
class ClientTopUpActions {
  // static Future<void> approveClients(int batchUploadID, Function() onSubmission) async {
  //   // Show loading dialog
  //   showDialog(
  //     context: navigatorKey.currentContext!,
  //     barrierDismissible: false,
  //     builder: (context) => const Center(
  //       child: SpinKitFadingCircle(color: AppColors.dialogColor),
  //     ),
  //   );
  //
  //   final approvingResponse = await ApproveClientListAPI().approveClientList(batchUploadID);
  //
  //   Navigator.pop(navigatorKey.currentContext!); // Close the spin kit dialog
  //
  //   if (approvingResponse.statusCode == 200) {
  //     showResponseAlertDialog(
  //       isSuccess: true,
  //       onSuccessSubmission: onSubmission,
  //       successMessage: "The list of pending clients were approved successfully.",
  //     );
  //   } else {
  //     showResponseAlertDialog(
  //       isSuccess: false,
  //       onSuccessSubmission: onSubmission,
  //       failureMessage: "Failed to approved the list of pending clients.\n${jsonDecode(approvingResponse.body)['message']}",
  //     );
  //   }
  // }
  //
  // static Future<void> disapproveClients(int batchUploadID, String remarks, Function() onSubmission) async {
  //   debugPrint('Remarks to be passed to: $remarks');
  //   // Show loading dialog
  //   showDialog(
  //     context: navigatorKey.currentContext!,
  //     barrierDismissible: false,
  //     builder: (context) => const Center(
  //       child: SpinKitFadingCircle(color: AppColors.dialogColor),
  //     ),
  //   );
  //
  //   final disapprovingResponse = await DisapproveClientListAPI().disapproveClientList(batchUploadID, remarks);
  //
  //   Navigator.pop(navigatorKey.currentContext!); // Close the spin kit dialog
  //
  //   if (disapprovingResponse.statusCode == 200) {
  //     showResponseAlertDialog(
  //       isSuccess: true,
  //       onSuccessSubmission: onSubmission,
  //       successMessage: "The list of pending clients were disapproved.",
  //     );
  //   } else {
  //     showResponseAlertDialog(
  //       isSuccess: false,
  //       onSuccessSubmission: onSubmission,
  //       failureMessage: "Failed to disapproved the list of pending clients.\n${jsonDecode(disapprovingResponse.body)['message']}",
  //     );
  //   }
  // }
  //
  // static Future<void> deleteClients(int batchUploadID, String filename, Function() onSubmission) async {
  //   // Show loading dialog
  //   showDialog(
  //     context: navigatorKey.currentContext!,
  //     barrierDismissible: false,
  //     builder: (context) => const Center(
  //       child: SpinKitFadingCircle(color: AppColors.dialogColor),
  //     ),
  //   );
  //
  //   final deletingResponse = await DeleteClientListAPI().deleteClientList(batchUploadID);
  //
  //   Navigator.pop(navigatorKey.currentContext!); // Close the spin kit dialog
  //
  //   if (deletingResponse.statusCode == 200) {
  //     showResponseAlertDialog(
  //       isSuccess: true,
  //       onSuccessSubmission: onSubmission,
  //       successMessage: "The file of $filename were deleted successfully.",
  //     );
  //   } else {
  //     showResponseAlertDialog(
  //       isSuccess: false,
  //       onSuccessSubmission: onSubmission,
  //       failureMessage: "Failed to delete the file of $filename clients.\n${jsonDecode(deletingResponse.body)['message']}",
  //     );
  //   }
  // }

  static Future<void> downloadTopUpClients(int batchTopupFileId, String filename, Function() onSubmission) async {
    // Show loading dialog
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitFadingCircle(color: AppColors.dialogColor),
      ),
    );

    final downloadingResponse = await DownloadClientTopUpListAPI.downloadClientTopUpList(batchTopupFileId, filename);

    Navigator.pop(navigatorKey.currentContext!); // Close the spin kit dialog

    if (downloadingResponse.statusCode == 200) {
      showResponseTopUpAlertDialog(
        isSuccess: true,
        onSuccessSubmission: onSubmission,
        successMessage: '''The file of "$filename" was downloaded successfully.''',
      );
      print('batchID $batchTopupFileId');
      // html.window.open(url, 'whitelist');
    } else {
      showResponseTopUpAlertDialog(
        isSuccess: false,
        onSuccessSubmission: onSubmission,
        failureMessage: "Failed to download the file of $filename \n${jsonDecode(downloadingResponse.body)['message']}",
      );
    }
  }

  static Future<void> downloadLoanDisbursementFile(int batchDisburseFileId, String filename, Function() onSubmission) async {
    // Show loading dialog
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitFadingCircle(color: AppColors.dialogColor),
      ),
    );

    final downloadingResponse = await DownloadClientTopUpListAPI.downloadLoanDisburseFile(batchDisburseFileId, filename);

    Navigator.pop(navigatorKey.currentContext!); // Close the spin kit dialog

    if (downloadingResponse.statusCode == 200) {
      showResponseTopUpAlertDialog(
        isSuccess: true,
        onSuccessSubmission: onSubmission,
        successMessage: '''The file of "$filename" was downloaded successfully.''',
      );
    } else {
      showResponseTopUpAlertDialog(
        isSuccess: false,
        onSuccessSubmission: onSubmission,
        failureMessage: "Failed to download the file of $filename \n${jsonDecode(downloadingResponse.body)['message']}",
      );
    }
  }
}

void showResponseTopUpAlertDialog({required bool isSuccess, String? successMessage, String? failureMessage, required Function() onSuccessSubmission}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => AlertDialogWidget(
      titleText: isSuccess ? "Success" : "Failed",
      contentText: isSuccess ? successMessage ?? '' : failureMessage ?? '',
      positiveButtonText: isSuccess ? "Done" : "Retry",
      positiveOnPressed: () {
        if (isSuccess) {
          Navigator.pop(context);
          onSuccessSubmission();
          //Reload the window on success
          // html.window.location.reload();
        } else {
          Navigator.pop(context);
        }
      },
      iconData: isSuccess ? Icons.check_circle_outline : Icons.error_outline,
      titleColor: isSuccess ? AppColors.ngoColor : AppColors.maroon2,
      iconColor: Colors.white,
    ),
  );
}

// void showDeleteButtonAlertDialog(String filename, VoidCallback deleteClientsButton) {
//   showDialog(
//     context: navigatorKey.currentContext!,
//     barrierDismissible: false,
//     builder: (context) => AlertDialogWidget(
//       titleText: "Deleting Client List",
//       contentText: "You will be deleting the list of clients from $filename",
//       positiveButtonText: "Proceed",
//       negativeButtonText: "Cancel",
//       negativeOnPressed: () {
//         Navigator.of(context).pop();
//       },
//       positiveOnPressed: () async {
//         Navigator.of(context).pop();
//         deleteClientsButton();
//       },
//       iconData: Icons.info_outline,
//       titleColor: AppColors.infoColor,
//       iconColor: Colors.white,
//     ),
//   );
// }
//
// void showDownloadButtonAlertDialog(String filename, VoidCallback downloadClientsButton) {
//   showDialog(
//     context: navigatorKey.currentContext!,
//     barrierDismissible: false,
//     builder: (context) => AlertDialogWidget(
//       titleText: "Downloading Client List",
//       contentText: "You will be downloading the list of clients from $filename",
//       positiveButtonText: "Proceed",
//       negativeButtonText: "Cancel",
//       negativeOnPressed: () {
//         Navigator.of(context).pop();
//       },
//       positiveOnPressed: () async {
//         Navigator.of(context).pop();
//         downloadClientsButton();
//       },
//       iconData: Icons.info_outline,
//       titleColor: AppColors.infoColor,
//       iconColor: Colors.white,
//     ),
//   );
// }
//
// void showApproveButtonAlertDialog(String filename, VoidCallback approvedClientsButton) {
//   showDialog(
//     context: navigatorKey.currentContext!,
//     barrierDismissible: false,
//     builder: (context) => AlertDialogWidget(
//       titleText: "Approving Client List",
//       contentText: "You will be approving the list of clients from $filename",
//       positiveButtonText: "Proceed",
//       negativeButtonText: "Cancel",
//       negativeOnPressed: () {
//         Navigator.of(context).pop();
//       },
//       positiveOnPressed: () async {
//         Navigator.of(context).pop();
//         approvedClientsButton();
//       },
//       iconData: Icons.info_outline,
//       titleColor: AppColors.infoColor,
//       iconColor: Colors.white,
//     ),
//   );
// }
//
// void showDisapproveButtonAlertDialog(String filename, DisapproveCallback disapprovedClientsButton) {
//   final formKey = GlobalKey<FormState>();
//   TextEditingController remarksController = TextEditingController();
//   showDialog(
//     barrierDismissible: false,
//     context: navigatorKey.currentContext!,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5),
//             ),
//             title: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: const BoxDecoration(
//                 color: AppColors.infoColor,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(5.0),
//                   topRight: Radius.circular(5.0),
//                 ),
//               ),
//               child: const Text("Disapproving Client List", style: TextStyles.bold18White),
//             ),
//             titlePadding: const EdgeInsets.all(0),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text("You will be disapproving the list of clients from $filename", style: TextStyles.normal14Black),
//                 const SizedBox(height: 20),
//                 Form(
//                   key: formKey,
//                   child: TextFormField(
//                     controller: remarksController,
//                     onChanged: (value) {
//                       setState(() {});
//                     },
//                     textInputAction: TextInputAction.next,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     style: Theme.of(context).textTheme.labelSmall,
//                     keyboardType: TextInputType.text,
//                     textAlign: TextAlign.center,
//                     maxLength: 100,
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyles.normal14Black,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       if (remarksController.text.isNotEmpty) {
//                         String remarks = remarksController.text; // Get remarks from the controller
//                         debugPrint('Remarks from dialog: $remarks');
//                         disapprovedClientsButton(remarks); // Call the disapprove function passed as a parameter
//                         Navigator.pop(context); // Close the dialog
//                       } else {
//                         CustomToast.show(context, 'Kindly write your disapproval remarks.');
//                       }
//                     },
//                     child: const Text(
//                       "Proceed",
//                       style: TextStyles.normal14Black,
//                     ), // Disable button when remarksController is empty
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }
