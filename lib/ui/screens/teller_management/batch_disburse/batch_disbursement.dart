import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/main.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/teller_management/batch_disburse/batch_disbursement_body.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/header/header.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/header/header_CTA.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/clock/clock.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/utils/utils_responsive.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';

typedef TellerVoidCallback = void Function();

class LoanBatchUpload extends StatefulWidget {
  const LoanBatchUpload({Key? key}) : super(key: key);

  @override
  State<LoanBatchUpload> createState() => _LoanBatchUploadState();
}

class _LoanBatchUploadState extends State<LoanBatchUpload> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? uploadStatus = '';
  String fileName = '';
  String timeStamp = '';
  String firstName = '';
  String lastName = '';
  int total = 0;
  String selectedFileName = '';
  Blob? selectedFile;
  int duplicateCount = 0;
  List<String> duplicates = [];
  List<String> pepsFound = [];
  String existingCIDs = '';

  //get the specific message to parameterize the UI
  String parameterMessage = '';
  String dataMessage = '';
  Color uploadStatusColor = Colors.transparent;

  TextEditingController rowPerPageController = TextEditingController();
  List<Map<String, dynamic>> apiData = [];
  List<String> pepListData = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isLoading = true; // Add this variable to track loading state
  bool hasPepList = false;
  int totalRecords = 0;
  int totalPages = 1;
  String _selectedItem = '10';

  @override
  void initState() {
    super.initState();
    updateUrl('/Access/Loan_Disbursement/Batch_Disbursement');

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // Reset values when the tab changes
      if (_tabController.indexIsChanging) {
        resetFileUploadState();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void resetFileUploadState() {
    setState(() {
      selectedFileName = '';
      firstName = '';
      lastName = '';
      timeStamp = '';
      duplicateCount = 0;
      total = 0;
      duplicates = [];
      existingCIDs = '';
      parameterMessage = '';
      uploadStatus = '';
      uploadStatusColor = Colors.transparent;
      dataMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    bool areButtonsEnabled = selectedFileName.isNotEmpty && (selectedFileName.endsWith('.xlsm'));

    return Container(
      padding: const EdgeInsets.only(left: 90),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const HeaderBar(screenText: 'BATCH LOAN DISBURSEMENT'),
            const HeaderCTA(children: [
              Spacer(),
              Responsive(desktop: Clock(), mobile: Spacer()),
            ]),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9, maxHeight: MediaQuery.of(context).size.height * 0.),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colors.grey.shade50,
                  shape: BoxShape.rectangle,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade200, spreadRadius: 0.0, blurRadius: 3, offset: const Offset(3.0, 3.0)),
                    BoxShadow(color: Colors.grey.shade300, spreadRadius: 0.0, blurRadius: 3 / 2.0, offset: const Offset(3.0, 3.0)),
                    const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3, offset: Offset(-3.0, -3.0)),
                    const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3 / 2, offset: Offset(-3.0, -3.0)),
                  ],
                ),
                child: Responsive(
                  desktop: Row(
                    children: [imageBatchUpload(), bodyBatchUpload(areButtonsEnabled)],
                  ),
                  mobile: Column(
                    children: [
                      bodyBatchUpload(areButtonsEnabled),
                    ],
                  ),
                  tablet: Column(
                    children: [
                      bodyBatchUpload(areButtonsEnabled),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyBatchUpload(bool areButtonsEnabled) {
    double fontSize = (MediaQuery.sizeOf(context).width / 30);
    return Expanded(
      flex: 6,
      child: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LOAN DISBURSEMENT',
                  style: TextStyle(color: AppColors.maroon2, fontSize: fontSize.clamp(25, 40), fontWeight: FontWeight.bold),
                ),
                const Text(
                  'MANAGEMENT SYSTEM',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 10),
                // TabBar(
                //   controller: _tabController,
                //   labelColor: AppColors.maroon3,
                //   dividerColor: Colors.transparent,
                //   indicator: BoxDecoration(
                //     border: const Border(top: BorderSide(color: AppColors.maroon2, width: 3)),
                //     shape: BoxShape.rectangle,
                //     gradient: LinearGradient(
                //       colors: [Colors.red.withOpacity(0.1), AppColors.maroon5.withOpacity(0.01)], // Gradient colors
                //       begin: Alignment.topCenter, // Alignment for the start of the gradient
                //       end: Alignment.bottomCenter, // Alignment for the end of the gradient
                //     ),
                //   ),
                //   unselectedLabelColor: Colors.black54, // Color for unselected tab text
                //   tabs: [
                //     _buildTab("Disbursement", Iconsax.money_send_copy),
                //     _buildTab("Top Up", Iconsax.wallet_money_copy),
                //   ],
                // ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: BatchDisbursement(),
            ),
            // Expanded(
            //   child: TabBarView(
            //     physics: NeverScrollableScrollPhysics(),
            //     controller: _tabController,
            //     children: [
            //       BatchDisbursement(), // Content for "Disbursement" tab
            //       BatchTopUp(), // Content for "Top Up" tab
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, IconData icon) {
    return Tab(
      child: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20), // Icon with specified size
            const SizedBox(width: 8), // Add space between icon and text
            Responsive(
              mobile: const SizedBox.shrink(),
              desktop: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageBatchUpload() {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.maroon1.withOpacity(0.9), AppColors.maroon2, AppColors.maroon3, AppColors.maroon4], // Gradient colors
              begin: Alignment.topCenter, // Alignment for the start of the gradient
              end: Alignment.bottomCenter, // Alignment for the end of the gradient
            ),
            // color:  const Color(0xff941c1b),
            borderRadius: const BorderRadius.all(Radius.zero),
            image: const DecorationImage(
              image: AssetImage('/images/kplus_webtool.png'),
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
