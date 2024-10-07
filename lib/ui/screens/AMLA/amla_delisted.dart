import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/provider/mfi/mfi_client_all_provider.dart';
import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/header/header.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/clock/clock.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/utils/utils_responsive.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/container.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/scrollable/scrollable_widget.dart';
import 'package:provider/provider.dart';

import '../../../../../core/models/mfi_whitelist_admin_portal/whitelistModel.dart';
import '../../../../../main.dart';

class AMLADelistedClients extends StatefulWidget {
  const AMLADelistedClients({Key? key}) : super(key: key);

  @override
  State<AMLADelistedClients> createState() => _AMLADelistedClientsState();
}

class _AMLADelistedClientsState extends State<AMLADelistedClients> {
  final token = getToken();
  late RowData rowData;

  final TextEditingController _rowsPerPageController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController batchUploadIDController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List<RowData> apiData = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  int totalRecords = 0;
  int totalPages = 1;
  String selectedFileName = '';
  String selectedUnit = '';
  String selectedCenter = '';
  String selectedFrom = '';
  String selectedTo = '';

  final int _sortColumnIndex = 0;

  List<String> displayFileName = [];
  List<String> _displayPages = [];
  String _selectedItem = '10';

  ///BOOLEAN VALUES
  final bool _sortAscending = true;
  bool isLoading = true; // Add this variable to track loading state

  final List<String> editableFields = [
    'firstName',
    'middleName',
    'lastName',
    'maidenFName',
    'maidenMName',
    'maidenLName',
    'mobileNumber',
    'birthday',
    'placeOfBirth',
    'religion',
    'civilStatus',
    'citizenship',
    'presentAddress',
    'permanentAddress',
    'city',
    'province',
    'postalCode',
    'memberMaidenFName',
    'memberMaidenMName',
    'memberMaidenLName',
    'email',
    'sourceOfFund',
    'employerOrBusinessName',
    'employerOrBusinessAddress',
  ];

  @override
  void initState() {
    super.initState();
    fetchData(1, int.parse(_selectedItem));
    updateUrl('/AMLA/Delisted');
  }

  @override
  void dispose() {
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

  ///FETCH DATA FROM API
  void fetchData(int page, int perPage) async {
    setState(() {
      isLoading = true;
    });

    try {
      final token = getToken();
      final url = Uri.parse('${UrlGetter.getURL()}/amla/test/get/all/delisted?page=$page&perPage=$_selectedItem&batch_upload_id=');
      // fileNameController.text = selectedFileName;

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        if (jsonData['retCode'] == '200') {
          final data = jsonData['data'];

          if (data is List) {
            setState(() {
              apiData = List<RowData>.from(data.map((item) => RowData(
                    isEditing: false,
                    data: Map<String, dynamic>.from(item),
                  )));
              totalRecords = jsonData['totalRecords'];
              totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
              isLoading = false;
            });
          } else {
            debugPrint('JSON data is not in the expected format');
            setState(() {
              if (mounted) {
                isLoading = false;
                apiData = []; // Clear existing data or update with new data
              }
            });
          }
        } else {
          debugPrint('NO DATA AVAILABLE');
          setState(() {
            if (mounted) {
              isLoading = false;
              apiData = []; // Clear existing data or update with new data
            }
          });
        }
      } else {
        debugPrint('No data fetched: ${response.body}');
        debugPrint('HTTP Request failed with status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        setState(() {
          if (mounted) {
            isLoading = false;
            apiData = []; // Clear existing data or update with new data
          }
        });
      }
    } catch (error) {
      debugPrint('Error fetching data: $error');
      setState(() {
        if (mounted) {
          isLoading = false;
          apiData = []; // Clear existing data or update with new data
        }
      });
    }
  }

  Future<void> fetchDistinct() async {
    try {
      final token = getToken();
      final response = await http.get(
        Uri.parse('${UrlGetter.getURL()}/filters/test/get/all/distinct/approved'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        debugPrint(responseData.toString());

        List<String> file = [];
        if (responseData['distinctData'] != null) {
          for (var item in responseData['distinctData']) {
            if (item['fileName'] != null) {
              file.add(item['fileName']);
            }
          }
        }

        setState(() {
          displayFileName = file;
        });

        debugPrint('SUCCESS');
        debugPrint('FILE: $displayFileName');
      } else {
        debugPrint('FAILED');

        debugPrint(response.body);
        throw Exception('Failed to load menu data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
    }
  }

  //for reinitializing
  void _initializeData() {
    fetchData(currentPage, int.parse(_selectedItem));
    fetchRows();
    initState();
    currentPage = 0;
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

  //NEW LINE OF CODE : AUG 22
  //========Create templated data cell for PAGINATED ROWS=============//

  List<DataRow> getPaginatedRows() {
    const textStyle = TextStyles.dataTextStyle;

    //BUILD EDITABLE DATA CELL USING TEXTFORMFIELD
    DataCell buildDataCell(String key, RowData rowData, {Alignment alignment = Alignment.centerLeft}) {
      return DataCell(
        Align(
          alignment: alignment,
          child: SelectableText(
            rowData.data[key] ?? '',
            style: textStyle,
          ),
        ),
      );
    }

    //GENERATE THE ROW DATA FROM THE API
    return List<DataRow>.generate(apiData.length, (index) {
      final rowData = apiData[index];
      final color = index % 2 == 0 ? Colors.transparent : Colors.white;

      return DataRow(
        color: MaterialStateProperty.all(color),
        cells: [
          buildDataCell('cid', rowData),
          buildDataCell('firstName', rowData),
          buildDataCell('middleName', rowData),
          buildDataCell('lastName', rowData),
          buildDataCell('maidenFName', rowData),
          buildDataCell('maidenMName', rowData),
          buildDataCell('maidenLName', rowData),
          buildDataCell('mobileNumber', rowData),
          buildDataCell('birthday', rowData),
          buildDataCell('placeOfBirth', rowData),
          buildDataCell('religion', rowData),
          buildDataCell('gender', rowData),
          buildDataCell('civilStatus', rowData),
          buildDataCell('citizenship', rowData),
          buildDataCell('presentAddress', rowData),
          buildDataCell('permanentAddress', rowData),
          buildDataCell('city', rowData),
          buildDataCell('province', rowData),
          buildDataCell('postalCode', rowData),
          buildDataCell('memberMaidenFName', rowData),
          buildDataCell('memberMaidenMName', rowData),
          buildDataCell('memberMaidenLName', rowData),
          buildDataCell('email', rowData),
          buildDataCell('institutionCode', rowData),
          buildDataCell('unitCode', rowData),
          buildDataCell('centerCode', rowData),
          buildDataCell('branchCode', rowData),
          buildDataCell('clientClassification', rowData),
          buildDataCell('sourceOfFund', rowData),
          buildDataCell('employerOrBusinessName', rowData),
          buildDataCell('employerOrBusinessAddress', rowData),
          buildDataCell('status', rowData),
          buildDataCell('deletedAt', rowData),
        ],
      );
    });
  }

  //========Create templated data cell for PAGINATED COLUMNS=============//
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
      // buildDataColumn('CID', onTap: () => _sortData(0, !_sortAscending)),
      buildDataColumn('CID'),
      buildDataColumn('First Name'),
      buildDataColumn('Middle Name'),
      buildDataColumn('Last Name'),
      buildDataColumn('Spouse First Name'),
      buildDataColumn('Spouse Middle Name'),
      buildDataColumn('Spouse Last Name'),
      buildDataColumn('Mobile Number'),
      buildDataColumn('Birthday'),
      buildDataColumn('Place of Birth'),
      buildDataColumn('Religion'),
      buildDataColumn('Gender'),
      buildDataColumn('Civil Status'),
      buildDataColumn('Citizenship'),
      buildDataColumn('Present Address'),
      buildDataColumn('Permanent Address'),
      buildDataColumn('Present City'),
      buildDataColumn('Present Province'),
      buildDataColumn('Present Postal Code'),
      buildDataColumn('Client Maiden First Name'),
      buildDataColumn('Client Maiden Middle Name'),
      buildDataColumn('Client Maiden Last Name'),
      buildDataColumn('Email'),
      buildDataColumn('Institution Name'),
      buildDataColumn('Unit Name'),
      buildDataColumn('Center Name'),
      buildDataColumn('Branch Name'),
      buildDataColumn('Client Classification'),
      buildDataColumn('Source of Fund'),
      buildDataColumn('Employer/Business Name'),
      buildDataColumn('Employer/Business Address'),
      buildDataColumn('Status'),
      buildDataColumn('Deleted Date'),
    ];
  }

  void nextPage() {
    if (currentPage + 1 < totalPages) {
      setState(() {
        currentPage++; // Update currentPage
      });
      fetchData(currentPage + 1, int.parse(_selectedItem)); // Fetch the next page of data
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--; // Update currentPage
      });
      fetchData(currentPage + 1, int.parse(_selectedItem)); // Fetch the previous page of data
    }
  }

  ///SEARCH FUNCTION FOR ALL CLIENT DATA
  void _onFetchDataSearchChanged() {
    final query = searchController.text;
    debugPrint('Fetch Data Search query: $query');
    Provider.of<MFIClientProvider>(context, listen: false).searchClient(query);
  }

  ///SEARCH FUNCTION FOR DISTINCT FILE
  void _onFetchDistinctSearchChanged() {
    final query = searchController.text;
    debugPrint('Fetch Data Search query: $query');
    // Assuming you have a method in the provider to handle searches within distinct data.
    Provider.of<MFIClientProvider>(context, listen: false).searchClient(query);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 90),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const HeaderBar(screenText: 'DELISTED WATCHLIST CLIENTS'),
            Container(
              padding: const EdgeInsets.only(
                right: 10,
                top: 5,
              ),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //rows&clock

                  ///SHOW LIST FILTER
                  Container(
                    padding: const EdgeInsets.only(
                      left: 3,
                      right: 10,
                      top: 5,
                      bottom: 5,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    height: 40,
                    width: 200,
                    child: Row(
                      children: [
                        const Text(
                          'Show',
                          style: TextStyles.dataTextStyle,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: TextField(
                            controller: _rowsPerPageController,
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
                              hintStyle: const TextStyle(fontSize: 11, color: Colors.black54),
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
                                _initializeData();
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return _displayPages.map((String type) {
                                return PopupMenuItem<String>(
                                  height: 20,
                                  value: type,
                                  child: Center(
                                    child: Text(type, style: TextStyles.dataTextStyle),
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
                          style: TextStyles.dataTextStyle,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Responsive(desktop: Clock(), mobile: Spacer()),
                ],
              ),
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
                        ? const Center(
                            child: NoRecordsFound(),
                          )
                        : Column(
                            children: [
                              Expanded(
                                child: ScrollBarWidget(
                                  child: DataTableTheme(
                                    data: const DataTableThemeData(
                                      dividerThickness: 0.1,
                                    ),
                                    child: DataTable(
                                      sortColumnIndex: _sortColumnIndex,
                                      sortAscending: _sortAscending,
                                      border: TableBorder.all(width: 0.1, color: Colors.black54.withOpacity(0.5)),
                                      headingRowColor: MaterialStateColor.resolveWith(
                                        (states) => Colors.black12,
                                      ),
                                      headingRowHeight: 50,
                                      columns: buildDataColumns(),
                                      rows: getPaginatedRows(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
              ),
            ),
            const SizedBox(height: 10),

            //PAGINATION BUTTON CODE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.maroon2,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 12,
                    ),
                    color: Colors.white,
                    onPressed: previousPage,
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      'PAGE ${currentPage + 1} OF $totalPages',
                      style: const TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                    Text(
                      'Total Number of Delisted: $totalRecords',
                      style: const TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.maroon2,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                    ),
                    onPressed: nextPage,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
