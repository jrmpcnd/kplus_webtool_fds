import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/container.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/toast.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/pagination/pagination_button.dart';
import 'package:provider/provider.dart';

import '../../../core/mfi_whitelist_api/dashboard/menu/audit_logs/logs_api.dart';
import '../../../core/models/user_management/user_model.dart';
import '../../../core/provider/user_provider.dart';
import '../../../core/service/url_getter_setter.dart';
import '../../../main.dart';
import '../../shared/clock/clock.dart';
import '../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../shared/utils/utils_responsive.dart';
import '../../shared/values/colors.dart';
import '../../shared/widget/calendar/date_picker.dart';
import '../../shared/widget/containers/dialog.dart';
import '../../shared/widget/fields/multiselection.dart';
import '../../shared/widget/fields/simplified_widget.dart';
import '../user_management/ui/screen_bases/header/header.dart';

class MFIAuditLogs extends StatefulWidget {
  const MFIAuditLogs({Key? key}) : super(key: key);

  @override
  State<MFIAuditLogs> createState() => _MFIAuditLogsState();
}

class _MFIAuditLogsState extends State<MFIAuditLogs> {
  final headers = ['Log ID', 'User ID', 'First Name', 'Last Name', 'Username', 'Branch', 'User Role', 'Date and Time', 'Action', 'Original Values', 'Modified Values'];
  final TextEditingController _rowsPerPageController = TextEditingController();
  final TextEditingController dateToController = TextEditingController();
  final TextEditingController dateFromController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController orderByController = TextEditingController();
  final TextEditingController fileTypeController = TextEditingController();

  List<Map<String, dynamic>> apiData = [];
  int _selectedItem = 10;
  int currentPage = 0;
  String username = '';
  String selectedDateFrom = '';
  String selectedDateTo = '';
  String orderBy = '';
  int totalRecords = 0;
  int totalPages = 0;
  List<String> selectedCategories = [];
  List<String> disabledItems = ['Date To']; // Initially disable "Date To"
  Set<String> distinctUsernames = {};

  bool isLoading = true;

  // Getter for displayPage
  int get displayPage => (totalRecords == 0) ? 0 : (currentPage + 1);

  @override
  void initState() {
    super.initState();
    updateUrl('/Audit_Logs');
    fetchData(1, _selectedItem, '', '', '', '');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchAllUsers();
      setState(() {
        distinctUsernames = userProvider.getDistinctUsernames();
      });
    });
  }

  ///Continue to call setState as usual in your code.
  ///The overridden method ensures that setState is only called when the widget is mounted.
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void refreshLogsData() async {
    // Fetch total records first
    final totalRecords = await fetchTotalRecords();

    // Calculate the maximum number of pages
    final totalPages = (totalRecords / _selectedItem).ceil();

    // If the current display page exceeds the total pages, reset to the first page
    if (displayPage > totalPages && totalPages > 0) {
      setState(() {
        currentPage = 0; // Reset to the first page
        // Ensure currentPage is within bounds
        if (currentPage > totalPages - 1) {
          currentPage = totalPages - 1;
        }
      });
    }

    // Fetch the actual data for the calculated page
    fetchData(currentPage + 1, _selectedItem, username, selectedDateFrom, selectedDateTo, orderBy);
  }

  void onPageSizeChange(int newPageSize) {
    setState(() {
      _selectedItem = newPageSize;
    });
    refreshLogsData();
  }

  void nextPage() {
    if (currentPage < totalPages - 1) {
      setState(() {
        currentPage++;
      });
      refreshLogsData();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      refreshLogsData();
    }
  }

  void _onPageSelected(int page) {
    setState(() {
      currentPage = page;
    });
  }

  // Function to handle go-to-page input
  void _onGoToPage(String value) {
    final int? page = int.tryParse(value);
    if (page != null && page > 0 && page <= totalPages) {
      setState(() {
        currentPage = page;
      });
      refreshLogsData();
    }
  }

  ///FETCH ALL DATA TO BE DISPLAYED IN THE TABLE
  Future<int> fetchTotalRecords() async {
    final token = getToken();
    final url = Uri.parse('${UrlGetter.getURL()}/audit/test/get/all/logs?username=$username&page=1&perPage=1&date_from=$selectedDateFrom&date_to=$selectedDateTo&order_by=$orderBy');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['totalRecords'] as int;
      } else {
        return 0;
      }
    } catch (error) {
      return 0;
    }
  }

  Future<void> fetchData(int page, int perPage, String username, String dateFrom, String dateTo, String orderBy) async {
    setState(() {
      isLoading = true;
    });

    final token = getToken();
    final url = Uri.parse('${UrlGetter.getURL()}/audit/test/get/all/logs?username=$username&page=$page&perPage=$perPage&date_from=$dateFrom&date_to=$dateTo&order_by=$orderBy');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['retCode'] == '200') {
        final data = jsonData['data'] as List<dynamic>;
        final int totalRecords = jsonData['totalRecords'] as int; // Get total records here

        setState(() {
          apiData = List<Map<String, dynamic>>.from(data);
          this.totalRecords = totalRecords; // Save total records to the state
          totalPages = (totalRecords / perPage).ceil(); // Calculate total pages based on perPage
          isLoading = false;
        });

        debugPrint('Request url : $url');
        debugPrint('username : $username');
        debugPrint('dateFrom : $dateFrom');
        debugPrint('dateTo : $dateTo');
        debugPrint('orderBy : $orderBy');
        debugPrint('page : $page');
        debugPrint('per page : $perPage');
        debugPrint('total records: $totalRecords'); // Log total records
        debugPrint('total pages: $totalPages'); // Log total pages
        debugPrint('current page: $currentPage');
        debugPrint('display page: $displayPage');
      } else {
        setState(() {
          apiData = [];
          totalRecords = 0;
          currentPage = 0;
          totalPages = 0;
          isLoading = false;
        });
      }
    }
  }

  Set<String> getDistinctUsernames(List<AllUserData> users) {
    // Create a set to hold distinct usernames
    Set<String> distinctUsernames = {};

    // Iterate through the list of users
    for (var user in users) {
      // Add the username to the set (duplicates will be ignored)
      if (user.username != null && user.username!.isNotEmpty) {
        distinctUsernames.add(user.username!);
      }
    }

    return distinctUsernames;
  }

  ///new line of code: Aug. 29,
  ///FUNCTIONS FOR FILTER SELECTION
  void _selectDateTo(BuildContext context) {
    DateTime? currentDate;
    if (dateToController.text.isNotEmpty) {
      currentDate = DateTime.tryParse(dateToController.text);
    }
    final initialDate = currentDate ?? DateTime.now(); // Use the current date if the field is empty or invalid

    showModalDatePicker(
      context,
      dateToController,
      initialDate,
      'Select Date',
      true,
      () {
        // Fetch data after updating the date
        debugPrint('Date To : ${dateToController.text}');
        selectedDateTo = dateToController.text;
        refreshLogsData();
      },
    );
  }

  void _selectDateFrom(BuildContext context) {
    DateTime? currentDate;
    if (dateFromController.text.isNotEmpty) {
      currentDate = DateTime.tryParse(dateFromController.text);
    }
    final initialDate = currentDate ?? DateTime.now(); // Use the current date if the field is empty or invalid

    showModalDatePicker(
      context,
      dateFromController,
      initialDate,
      'Select Date',
      true,
      () {
        // Fetch data after updating the date
        selectedDateFrom = dateFromController.text;
        refreshLogsData();
      },
    );
  }

  void _selectUsername(BuildContext context) async {
    setState(() {
      // Fetch data after updating the date
      refreshLogsData();
      debugPrint('Username selected $username');
    });
  }

  void _selectOrderBy(BuildContext context) async {
    setState(() {
      // Fetch data after updating the date
      refreshLogsData();
      debugPrint('Order By $orderBy');
    });
  }

  Future<void> generateFile(BuildContext context, String selectedFileType) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 350,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.white, // Replace AppColors.dialogColor with Colors.white or your desired color
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingCircle(color: AppColors.maroon2), // Replace AppColors.maroon2 with Colors.red or your desired color
              SizedBox(width: 10),
              Text('Downloading in progress...')
            ],
          ),
        ),
      ),
    );
    final response = await AuditLogService.downloadAuditLogs(
      fileType: selectedFileType,
      username: username,
      dateFrom: dateFromController.text,
      dateTo: dateToController.text,
    );

    Navigator.pop(navigatorKey.currentContext!);
    if (response.statusCode == 200) {
      showUploadFileAlertDialog(isSuccess: true, titleMessage: 'File Downloaded Successfully', contentMessage: 'You have successfully downloaded the logs.');
    } else {
      showUploadFileAlertDialog(isSuccess: false, titleMessage: 'Failed to Download', contentMessage: 'Sorry, your file was not downloaded.');
    }
  }

  //Compute maximum width required for each column
  List<double> getColumnWidths(List<String> headers, List<Map<String, dynamic>> data) {
    // Create a list to store the width of each column. Initially set all widths to 0.
    final List<double> widths = List.filled(headers.length, 0.0);

    // Measure the width of each header text.
    for (int i = 0; i < headers.length; i++) {
      // Create a TextPainter object to measure the width of the header text.
      final TextPainter painter = TextPainter(
        text: TextSpan(
          text: headers[i], // The text of the header
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Style for the header text
        ),
        textDirection: TextDirection.ltr, // Text direction for measuring
      )..layout(); // Layout the text to calculate its size
      widths[i] = painter.size.width; // Store the width of the header text in the widths list
    }

    // Measure the width of each row's data.
    for (var row in data) {
      // Extract the data for each column from the row and convert it to strings (if necessary).
      final values = [
        row['logid'].toString(),
        row['uid'],
        row['fname'],
        row['lname'],
        row['username'],
        row['branch'],
        row['userrole'],
        row['dateandtime'],
        row['action'],
        json.encode(row['original_values']), // JSON encode complex objects like original values
        json.encode(row['modified_values']),
      ];

      // Measure the width of each data cell and adjust the width of the corresponding column.
      for (int i = 0; i < values.length; i++) {
        // Create a TextPainter to measure the width of the data text in the current column.
        final TextPainter painter = TextPainter(
          text: TextSpan(
            text: values[i], // The text of the data cell
            style: TextStyles.dataTextStyle, // Style for the data text
          ),
          textDirection: TextDirection.ltr, // Text direction for measuring
        )..layout(); // Layout the text to calculate its size
        // Update the column width only if the current text is wider than the previously measured width.
        widths[i] = widths[i] > painter.size.width ? widths[i] : painter.size.width;
      }
    }

    // Add padding to each column width to prevent the text from being too close to the edges.
    const double padding = 100.0; // Padding for each column (can be adjusted)
    for (int i = 0; i < widths.length; i++) {
      widths[i] += padding; // Add padding to each column width
    }

    // Return the calculated widths for all columns.
    return widths;
  }

  //HEADERS
  List<Widget> buildHeaderCells(List<String> headers, List<double> columnWidths) {
    return headers.asMap().entries.map((entry) {
      final index = entry.key;
      final header = entry.value;

      return Container(
        width: columnWidths[index],
        padding: const EdgeInsets.all(8),
        child: Text(
          header,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.6),
            letterSpacing: .5,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList();
  }

  List<Widget> getPaginatedRows(List<double> columnWidths) {
    return apiData.map<Widget>((rowData) {
      final color = apiData.indexOf(rowData) % 2 == 0 ? Colors.transparent : Colors.white;

      return Container(
        padding: const EdgeInsets.only(left: 30),
        decoration: BoxDecoration(
          color: color,
          border: const Border(
            top: BorderSide.none,
            bottom: BorderSide(width: 0.5, color: Colors.black12),
            left: BorderSide(width: 0.5, color: Colors.black12),
            right: BorderSide(width: 0.5, color: Colors.black12),
          ),
        ),
        child: Row(
          children: [
            buildDataCell(rowData['logid'].toString(), columnWidths[0]),
            buildDataCell(rowData['uid'], columnWidths[1]),
            buildDataCell(rowData['fname'], columnWidths[2]),
            buildDataCell(rowData['lname'], columnWidths[3]),
            buildDataCell(rowData['username'], columnWidths[4]),
            buildDataCell(rowData['branch'], columnWidths[5]),
            buildDataCell(rowData['userrole'], columnWidths[6]),
            buildDataCell(rowData['dateandtime'], columnWidths[7]),
            buildDataCell(rowData['action'], columnWidths[8]),
            buildDataCell(json.encode(rowData['original_values']), columnWidths[9]),
            buildDataCell(json.encode(rowData['modified_values']), columnWidths[10]),
          ],
        ),
      );
    }).toList();
  }

  //ROW DATA CELLS
  Widget buildDataCell(String? text, double width) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      width: width,
      // color: Colors.amber,
      height: 40,
      padding: const EdgeInsets.all(10),
      child: Text(
        text ?? '',
        style: TextStyles.dataTextStyle,
        textAlign: TextAlign.left,
      ),
    );
  }

  ///MAIN BODY OF WIDGET
  @override
  Widget build(BuildContext context) {
    final columnWidths = getColumnWidths(headers, apiData);
    return Container(
      padding: const EdgeInsets.only(left: 90),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderBar(screenText: 'AUDIT LOGS'),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.only(right: 10, top: 5),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Wrap(
                    runSpacing: 10,
                    spacing: 20,
                    runAlignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      //rows&clock
                      ///SHOW LIST FILTER
                      // SizedBox(width: 150, child: ShowListWidget(rowsPerPageController: _rowsPerPageController, rowsPerPage: _selectedItem, onPageSizeChange: onPageSizeChange)),
                      SizedBox(
                        child: Stack(
                          alignment: AlignmentDirectional.centerEnd,
                          children: [
                            buildDropDownField(
                              title: '',
                              hintText: 'File Type',
                              width: 200,
                              height: 30,
                              contentPadding: 7,
                              controller: fileTypeController,
                              onChanged: (String? newValue) {
                                setState(() {
                                  if (newValue != null) {
                                    fileTypeController.text = newValue;
                                    debugPrint(newValue);
                                  }
                                });
                              },
                              items: ['pdf', 'csv'],
                            ),
                            Container(
                              height: 28,
                              width: 32,
                              margin: const EdgeInsets.only(right: 1),
                              decoration: BoxDecoration(
                                color: fileTypeController.text.isNotEmpty ? AppColors.maroon2 : Colors.grey,
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.file_download,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  onPressed: () {
                                    fileTypeController.text.isNotEmpty ? generateFile(context, fileTypeController.text) : CustomTopToast.show(context, 'Select a file type', 1);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        // color: Colors.cyan,
                        height: 30,
                        width: 200,
                        child: CustomMultiSelectDropdown(
                          title: "Filter By",
                          items: const [
                            'Date From',
                            'Date To',
                            'Username',
                            'Order By',
                          ],
                          selectedItems: selectedCategories,
                          onItemSelected: (item, isSelected) {
                            setState(() {
                              if (isSelected) {
                                selectedCategories.add(item);

                                if (item == 'Date From') {
                                  // Enable "Date To" when "Date From" is selected
                                  disabledItems.remove('Date To');
                                }
                              } else {
                                selectedCategories.remove(item);

                                if (item == 'Date From') {
                                  // Uncheck and remove "Date To" if it was selected
                                  if (selectedCategories.contains('Date To')) {
                                    selectedCategories.remove('Date To');
                                    dateToController.text = ''; // Clear the value for Date To
                                    selectedDateTo = dateToController.text;
                                  }

                                  // Disable "Date To" if "Date From" is unselected
                                  disabledItems.add('Date To');
                                  dateFromController.text = ''; // Clear the value for Date From
                                  selectedDateFrom = dateFromController.text;
                                }

                                if (item == 'Date To') {
                                  dateToController.text = ''; // Clear the value for Date To
                                  selectedDateTo = dateToController.text;
                                }

                                if (item == 'Username') {
                                  usernameController.text = ''; // Clear the value for Date To
                                  username = usernameController.text;
                                }
                                if (item == 'Order By') {
                                  orderByController.text = ''; // Clear the value for Date To
                                  orderBy = orderByController.text;
                                }
                                refreshLogsData();
                              }
                            });
                          },
                          disabledItems: disabledItems,
                          enforceDateLogic: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Responsive(desktop: Clock(), mobile: Spacer()),
              ],
            ),
            const SizedBox(height: 15),

            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
              child: Wrap(
                spacing: 20,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  if (selectedCategories.contains('Date From'))
                    dateField(
                      'Date From',
                      dateFromController,
                      () {
                        _selectDateFrom(context);
                      },
                    ),
                  if (selectedCategories.contains('Date From') && selectedCategories.contains('Date To'))
                    dateField(
                      'Date To',
                      dateToController,
                      () {
                        _selectDateTo(context);
                      },
                    ),
                  if (selectedCategories.contains('Username'))
                    buildDropDownField(
                      title: '',
                      width: 190,
                      height: 30,
                      contentPadding: 7,
                      hintText: 'Username',
                      controller: usernameController,
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue != null) {
                            usernameController.text = newValue;
                            username = usernameController.text;
                            _selectUsername(context);
                          }
                        });
                      },
                      items: distinctUsernames.toList(),
                    ),
                  if (selectedCategories.contains('Order By'))
                    SizedBox(
                      width: 300,
                      // color: Colors.indigo,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Order By:', style: TextStyles.dataTextStyle),
                          buildRadioButton(
                            label: 'Ascending',
                            value: 'ASC',
                            groupValue: orderBy,
                            onChanged: (String? value) {
                              setState(() {
                                orderBy = value!;
                                _selectOrderBy(context);
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          buildRadioButton(
                            label: 'Descending',
                            value: 'DESC',
                            groupValue: orderBy,
                            onChanged: (String? value) {
                              setState(() {
                                orderBy = value!;
                                _selectOrderBy(context);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            //TABLE BODY
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Frozen Header
                        Container(
                          padding: const EdgeInsets.only(left: 30),
                          decoration: BoxDecoration(color: Colors.black12, border: Border.all(width: 0.5, color: Colors.black12)),
                          height: 50,
                          child: Row(
                            children: buildHeaderCells(headers, columnWidths),
                          ),
                        ),
                        // Scrollable Body
                        if (apiData.isNotEmpty)
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: getPaginatedRows(columnWidths),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    const CircularProgressIndicator(
                      color: AppColors.maroon2,
                    )
                  else if (apiData.isEmpty)
                    const NoRecordsFound()
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            //PAGINATION BUTTON CODE
            PaginationControls(
              currentPage: displayPage,
              totalPages: totalPages,
              totalRecords: totalRecords,
              onPreviousPage: previousPage,
              onNextPage: nextPage,
              title: 'Logs',
            ),
            // PaginationControls(
            //   totalPages: totalPages,
            //   totalRecords: totalRecords,
            //   rowsPerPage: _selectedItem,
            //   onPreviousPage: previousPage,
            //   onNextPage: nextPage,
            //   title: 'Clients',
            // ),
            // PaginationControls(
            //   currentPage: currentPage,
            //   totalPages: totalPages,
            //   totalRecords: totalRecords,
            //   rowsPerPage: _selectedItem,
            //   onPreviousPage: previousPage,
            //   onNextPage: nextPage,
            //   onPageSelected: _onPageSelected,
            //   onRowsPerPageChanged: onPageSizeChange,
            //   onGoToPage: _onGoToPage,
            //   title: 'Logs',
            // ),
          ],
        ),
      ),
    );
  }

  Widget dateField(String hintText, TextEditingController controller, VoidCallback onIconPressed) {
    return SizedBox(
      width: 200,
      child: Row(
        children: [
          SizedBox(
            width: 150,
            height: 30,
            child: TextField(
              style: const TextStyle(fontSize: 11),
              controller: controller,
              textAlignVertical: TextAlignVertical.top,
              cursorColor: AppColors.maroon2,
              cursorWidth: 1,
              cursorRadius: const Radius.circular(5),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.maroon2, width: 0.5),
                  borderRadius: BorderRadius.circular(5).copyWith(
                    topRight: const Radius.circular(0),
                    bottomRight: const Radius.circular(0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.maroon2, width: 0.5),
                  borderRadius: BorderRadius.circular(5).copyWith(
                    topRight: const Radius.circular(0),
                    bottomRight: const Radius.circular(0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.maroon2, width: 0.5),
                  borderRadius: BorderRadius.circular(5).copyWith(
                    topRight: const Radius.circular(0),
                    bottomRight: const Radius.circular(0),
                  ),
                ),
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 11, color: Colors.black54),
                suffixIcon: controller.text.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          controller.clear(); // Clear the text using the controller method
                          // Trigger a rebuild to hide the suffix icon
                          (context as Element).markNeedsBuild();
                          fetchData(1, _selectedItem, username, controller.text, controller.text, orderBy);
                        },
                        child: const Icon(
                          Icons.clear,
                          size: 15,
                        ),
                      )
                    : null, // Hide the suffix icon when the controller is empty
              ),
              readOnly: true,
            ),
          ),
          Container(
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.maroon2,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: IconButton(
              onPressed: onIconPressed,
              icon: const Icon(
                Icons.calendar_month_outlined,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showUploadFileAlertDialog({required bool isSuccess, required String titleMessage, required String contentMessage}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        titleText: titleMessage,
        contentText: contentMessage,
        positiveButtonText: isSuccess ? "Done" : "Retry",
        positiveOnPressed: () async {
          Navigator.of(context).pop();
        },
        iconData: isSuccess ? Icons.check_circle_outline : Icons.error_outline,
        titleColor: isSuccess ? AppColors.ngoColor : AppColors.maroon2,
        iconColor: Colors.white,
      ),
    );
  }
}
