import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/scrollable/scrollable_widget.dart';

import '../../../../shared/values/colors.dart';

class PreviewLoanDisburseFile extends StatefulWidget {
  final String fileName;
  final int batchID;
  final String status;
  final Function() onSuccessSubmission;
  const PreviewLoanDisburseFile({Key? key, required this.fileName, required this.batchID, required this.status, required this.onSuccessSubmission}) : super(key: key);

  @override
  State<PreviewLoanDisburseFile> createState() => _PreviewLoanDisburseFileState();
}

class _PreviewLoanDisburseFileState extends State<PreviewLoanDisburseFile> {
  final urole = getUrole();
  final token = getToken();

  final formKey = GlobalKey<FormState>();
  TextEditingController remarksController = TextEditingController();
  TextEditingController rowPerPageController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController batchUploadIDController = TextEditingController();
  TextEditingController trxController = TextEditingController();

  List<Map<String, dynamic>> apiData = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isLoading = true; // Add this variable to track loading state
  int totalRecords = 0;
  int totalPages = 0;

  final bool _sortAscending = true;
  bool lastPageReached = false;
  final int _sortColumnIndex = 0;

  List<String> displayFileName = [];
  List<String> _displayPages = [];
  String _selectedItem = '10';

  // Getter for displayPage
  int get displayPage => (totalRecords == 0) ? 0 : (currentPage + 1);

  @override
  void initState() {
    super.initState();
    fetchRows();
    fileNameController = TextEditingController(text: widget.fileName);
    batchUploadIDController = TextEditingController(text: widget.batchID.toString());
    final selectedBatchID = batchUploadIDController.text;
    fetchData(currentPage + 1, int.parse(_selectedItem), int.parse(selectedBatchID), widget.status);

    // Update state when page changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (displayPage == totalPages) {
        setState(() {
          lastPageReached = true; // Set flag when on the last page
        });
      }
    });
  }

  @override
  void dispose() {
    remarksController.dispose();
    fileNameController.dispose();
    super.dispose();
  }

  ///Continue to call setState as usual in your code.
  ///The overridden method ensures that setState is only called when the widget is mounted.
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Uri generateUrl(int page, int perPage, int batchUploadID, String status) {
    final baseUrl = UrlGetter.getURL();
    switch (status.toUpperCase()) {
      case 'UPLOADED':
        return Uri.parse('$baseUrl/loan/test/get/all/clients?page=$page&perPage=$perPage&batch_loan_disbursement_file_id=$batchUploadID&batch_loan_disbursement_status=&topup_reference_id=');
      case 'APPROVED':
        return Uri.parse('$baseUrl/clients/test/get/all/approved?page=$page&perPage=$perPage&batch_upload_id=$batchUploadID');
      case 'DISAPPROVED':
        return Uri.parse('$baseUrl/clients/test/get/all/disapproved?page=$page&perPage=$perPage&batch_upload_id=$batchUploadID');
      default:
        throw Exception('Invalid status: $status');
    }
  }

  void fetchData(int page, int perPage, int batchUploadId, String status) async {
    setState(() {
      isLoading = true;
    });

    try {
      final token = getToken();
      final url = generateUrl(page, perPage, batchUploadId, status);
      debugPrint('Request URL $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        if (jsonData['retCode'] == '200') {
          final data = jsonData['data'];

          var batchUploadID = jsonData['data'][0]['batchLoanDisbursementFileId'];
          // batchUploadIDController.text = batchUploadID.toString();
          debugPrint('Fetched batch upload id: $batchUploadID');

          if (data is List) {
            setState(() {
              apiData = List<Map<String, dynamic>>.from(data);
              totalRecords = jsonData['totalRecords'];
              totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
              isLoading = false;
              lastPageReached = (currentPage + 1 >= totalPages);
            });
          } else {
            debugPrint('JSON data is not in the expected format');
            setState(() {
              if (mounted) {
                // Update state variables here
                isLoading = false;
                apiData = []; // Clear existing data or update with new data
              }
            });
          }
        } else {
          debugPrint('NO DATA AVAILABLE');
          setState(() {
            if (mounted) {
              // Update state variables here
              isLoading = false;
              apiData = []; // Clear existing data or update with new data
            }
          });
        }
      } else {
        debugPrint('No data fetched: ${response.body}');
        setState(() {
          if (mounted) {
            // Update state variables here
            isLoading = false;
            apiData = []; // Clear existing data or update with new data
          }
        });
      }
    } catch (error) {
      debugPrint('Error fetching data: $error');
      setState(() {
        if (mounted) {
          // Update state variables here
          isLoading = false;
          apiData = []; // Clear existing data or update with new data
        }
      });
    }
  }

  void _initializeData() {
    fetchData(1, int.parse(_selectedItem), widget.batchID, widget.status);
    fetchRows();
  }

  Future<void> fetchRows() async {
    final response = await http.get(
      Uri.parse('${UrlGetter.getURL()}/filters/test/get/all/displaypage'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['retCode'] == '200') {
        final List<dynamic> displayPageList = data['displaypage'];
        setState(() {
          _displayPages = displayPageList.map((page) => page.toString()).toList();
        });
      } else {
        // Handle the case where the response code in the JSON is not '200'
        debugPrint('Error: ${data['message']}');
      }
    } else {
      // Handle the case where the HTTP status code is not 200
      debugPrint('Error: ${response.statusCode}');
    }
  }

  //========Create templated data cell for PAGINATED ROWS=============//
  List<DataRow> getPaginatedRows() {
    const textStyle = TextStyles.dataTextStyle;

    DataCell buildDataCell(String? text, {bool isWatchlisted = false, String? watchlistedType}) {
      return DataCell(
        Center(
          child: SelectableText(
            text ?? '',
            style: textStyle,
          ),
        ),
      );
    }

    return List<DataRow>.generate(apiData.length, (index) {
      final rowData = apiData[index];
      final color = index % 2 == 0 ? Colors.transparent : Colors.white;

      return DataRow(
        color: MaterialStateProperty.all(color),
        cells: [
          buildDataCell(rowData['cid']),
          buildDataCell(rowData['clientFullName']),
          buildDataCell(rowData['accountNumber']),
          buildDataCell(rowData['amount'].toString()),
          buildDataCell(rowData['tgtMessage']),
          buildDataCell(rowData['tgtTrxReference']),
          buildDataCell(rowData['tgtCreditCustomerName']),
          buildDataCell(rowData['trxDate']),
        ],
      );
    });
  }

  //========Create templated data cell for COLUMNS=============//
  List<DataColumn> buildDataColumns() {
    final textStyle = TextStyle(
      fontSize: 14,
      color: Colors.black.withOpacity(0.6),
      letterSpacing: .5,
      fontWeight: FontWeight.bold,
    );

    //onTap is an optional function
    DataColumn buildDataColumn(String label, {void Function()? onTap}) {
      return DataColumn(
        label: Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: textStyle),
                if (onTap != null)
                  Icon(
                    _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    color: Colors.black54,
                    size: 15,
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return [
      buildDataColumn('CID'),
      buildDataColumn('Client Name'),
      buildDataColumn('Account Number'),
      buildDataColumn('Amount'),
      buildDataColumn('Message'),
      buildDataColumn('Transaction Reference'),
      buildDataColumn('Target Credit Customer Name'),
      buildDataColumn('Transaction Date'),
    ];
  }

  void nextPage() {
    if (currentPage + 1 < totalPages) {
      setState(() {
        currentPage++; // Update currentPage
      });
      // print('nextPage : $currentPage');
      fetchData(displayPage, int.parse(_selectedItem), widget.batchID, widget.status); // Fetch the next page of data
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--; // Update currentPage
      });
      // print('previousPage : $currentPage');
      fetchData(displayPage, int.parse(_selectedItem), widget.batchID, widget.status); // Fetch the previous page of data
    }
  }

  void _onPageSelected(int page) {
    print('Current page selected : $page');
    setState(() {
      currentPage = page;
      fetchData(currentPage, int.parse(_selectedItem), widget.batchID, widget.status);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the buttons should be enabled
    bool areButtonsEnabled = fileNameController.text.isNotEmpty;

    return AlertDialog(
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
            Text('View Uploaded File : ${widget.status} Clients', style: TextStyles.bold18White),
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
                )),
          ],
        ),
      ),
      content: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10, top: 5),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //rows&clock
                  Container(
                    padding: const EdgeInsets.only(left: 3, right: 10, top: 5, bottom: 5),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    height: 40,
                    width: 200,
                    child: Row(
                      children: [
                        const Text(
                          'Show',
                          style: TextStyle(
                              fontFamily: 'RobotoThin',
                              // color: Color(0xff1E5128),
                              color: Colors.black54,
                              fontSize: 12),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: TextField(
                            controller: rowPerPageController,
                            textAlignVertical: TextAlignVertical.top,
                            cursorColor: AppColors.maroon2,
                            cursorWidth: 1,
                            cursorRadius: const Radius.circular(5),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: -20, left: 10),
                              filled: true,
                              fillColor: Colors.transparent,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.maroon2,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  topRight: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.maroon2,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  topRight: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  color: AppColors.maroon2,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  topRight: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                ),
                              ),
                              hintText: _selectedItem,
                              hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 11, color: Colors.black54),
                            ),
                            readOnly: true,
                          ),
                        ),
                        Container(
                          height: 40,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
                              right: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
                              bottom: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
                              // left: BorderSide(color: Color(0xff1E5128), width: 0, style: BorderStyle.solid),
                            ),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                            // color: Colors.black26,
                            color: AppColors.maroon2,
                          ),
                          child: PopupMenuButton<String>(
                            splashRadius: 20,
                            icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.white),
                            onSelected: (String selectedItem) {
                              setState(() {
                                _selectedItem = selectedItem;
                                currentPage = 0;
                                _initializeData();
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return _displayPages.map((String type) {
                                return PopupMenuItem<String>(
                                  height: 20,
                                  value: type,
                                  child: Center(
                                    child: Text(
                                      type,
                                      style: const TextStyle(
                                        fontFamily: 'RobotoThin',
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            elevation: 8,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'List',
                          style: TextStyle(fontFamily: 'RobotoThin', color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),

            //FILE TEXT FIELD AND OTHER CTAs
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 3, right: 10, top: 5, bottom: 5),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  height: 40,
                  child: Row(
                    children: [
                      const Text('File Name : ', style: TextStyles.hintText),
                      //file textfield
                      SizedBox(
                        width: 300,
                        height: 35,
                        child: TextField(
                          style: TextStyles.dataTextStyle,
                          controller: fileNameController,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: AppColors.maroon2,
                          cursorWidth: 1,
                          cursorRadius: const Radius.circular(5),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            filled: true,
                            fillColor: Colors.transparent,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.maroon2,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.maroon2,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: AppColors.maroon2,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            // suffixIcon: InkWell(
                            //     onTap: () {
                            //       setState(() {
                            //         fileNameController.clear();
                            //         selectedFileName = '';
                            //         apiData = [];
                            //       });
                            //     },
                            //     child: const Icon(Icons.close, size: 20)),
                            hintText: widget.fileName,
                            hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 11, color: Colors.black54),
                          ),
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black54,
                        width: 0.1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.maroon2,
                            ),
                          )
                        : apiData.isEmpty
                            ? Center(
                                child: Text(
                                  'NO DATA AVAILABLE',
                                  style: TextStyle(
                                    fontFamily: 'RobotoThin',
                                    color: Colors.black54.withOpacity(0.5),
                                  ),
                                ),
                              )
                            : ScrollBarWidget(
                                child: DataTableTheme(
                                  data: const DataTableThemeData(
                                    dividerThickness: 0.1,
                                  ),
                                  child: DataTable(
                                    sortColumnIndex: _sortColumnIndex,
                                    sortAscending: _sortAscending,
                                    border: TableBorder.all(width: 0.1, color: Colors.black54.withOpacity(0.5)),
                                    headingRowColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.black54.withOpacity(0.2),
                                    ),
                                    headingRowHeight: 50,
                                    columns: buildDataColumns(),
                                    rows: getPaginatedRows(),
                                  ),
                                ),
                              )
                    // : const NoClientsFound()),
                    )),
            const SizedBox(height: 10),

            //PAGINATION BUTTON CODE
            // PaginationControls(currentPage: displayPage, totalPages: totalPages, totalRecords: totalRecords, onPreviousPage: previousPage, onNextPage: nextPage, onPageSelected: _onPageSelected, title: 'Clients')
          ],
        ),
      ),
    );
  }
}
