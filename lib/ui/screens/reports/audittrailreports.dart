import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../core/service/filetype_api.dart';
import '../../../main.dart';
import '../../shared/clock/clock.dart';
import '../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import '../../shared/utils/utils_responsive.dart';
import '../../shared/values/colors.dart';
import '../../shared/values/styles.dart';
import '../user_management/ui/screen_bases/header/header.dart';

class AuditLogsReports extends StatefulWidget {
  const AuditLogsReports({Key? key}) : super(key: key);

  @override
  State<AuditLogsReports> createState() => _AuditLogsReportsState();
}

class _AuditLogsReportsState extends State<AuditLogsReports> {
  // Timer? _timer;
  //
  // void _startTimer() {
  //   final timer = Provider.of<TimerProvider>(context, listen: false);
  //   timer.startTimer(context)();
  //   timer.buildContext = context;
  // }
  //
  // void _pauseTimer([_]) {
  //   _timer?.cancel();
  //   _startTimer();
  //   debugPrint('flutter-----(time pause!)');
  // }
  //
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       _startTimer();
  //       break;
  //     case AppLifecycleState.inactive:
  //       break;
  //     case AppLifecycleState.detached:
  //       break;
  //     case AppLifecycleState.paused:
  //       _pauseTimer();
  //       break;
  //     case AppLifecycleState.hidden:
  //       break;
  //   }
  // }

  final fname = getFname();
  final lname = getLname();
  final urole = getUrole();

  TextEditingController _rowsperpagecontroller = TextEditingController();
  TextEditingController _datefrom = TextEditingController();
  TextEditingController _dateto = TextEditingController();
  TextEditingController _filetypecontroller = TextEditingController();

  final ScrollController controllerOne = ScrollController();
  final ScrollController controllerTwo = ScrollController();
  List<Map<String, dynamic>> apiData = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isLoading = true; // Add this variable to track loading state
  int totalRecords = 0;
  int totalPages = 1;

  bool _sortAscending = true;
  int _sortColumnIndex = 0;

//for sorting function
  void _sortData(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      apiData.sort((a, b) {
        dynamic aValue = a.values.toList()[columnIndex];
        dynamic bValue = b.values.toList()[columnIndex];

        if (aValue is String && bValue is String) {
          return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        } else if (aValue is int && bValue is int) {
          return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        } else if (aValue is DateTime && bValue is DateTime) {
          return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        } else {
          // Handle other types as needed
          return 0;
        }
      });
    });
  }

  void _selectDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: AppColors.ngoColor,
                hintColor: AppColors.ngoColor,
                colorScheme: const ColorScheme.light(
                  primary: AppColors.ngoColor,
                ),
                buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                textTheme: const TextTheme(
                  bodySmall: TextStyle(fontSize: 10, fontFamily: 'RobotoThin', color: AppColors.ngoColor),
                  titleMedium: TextStyle(fontSize: 50, fontFamily: 'RobotoThin', color: AppColors.ngoColor),
                ),
              ),
              child: child!);
        });
    if (picked != null && picked != DateTime.now()) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        _datefrom.text = formattedDate;
        selectedDateFrom = formattedDate;
        _initializeData();
        // _validateFields();
        // AddClientGetSet.setBirthday(_datefrom.text);
      });
    }
  }

  void _selectDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: AppColors.ngoColor,
                hintColor: AppColors.ngoColor,
                colorScheme: const ColorScheme.light(
                  primary: AppColors.ngoColor,
                ),
                buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                textTheme: const TextTheme(
                  bodySmall: TextStyle(fontSize: 10, fontFamily: 'RobotoThin', color: AppColors.ngoColor),
                  titleMedium: TextStyle(fontSize: 50, fontFamily: 'RobotoThin', color: AppColors.ngoColor),
                ),
              ),
              child: child!);
        });
    if (picked != null && picked != DateTime.now()) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        _dateto.text = formattedDate;
        selectedDateTo = formattedDate;
        _initializeData();
        // _validateFields();
        // AddClientGetSet.setBirthday(_datefrom.text);
      });
    }
  }

  void fetchData(int page, int perPage) async {
    setState(() {
      isLoading = true; // Set loading to true when making the request
      print(page);
      print(perPage);
    });

    try {
      final token = getToken(); // Replace with your actual token
      final response = await http.get(
        Uri.parse('https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/audit/test/ngo/get/all/audit/logs?page=$page&perPage=$perPage&date_from=$selectedDateFrom&date_to=$selectedDateTo'),
        headers: {
          'Authorization': 'Bearer $token', // Add your token to the headers
          'Content-Type': 'application/json', // Add any other headers you need.
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['retCode'] == '200' && jsonData['message'] == 'Retrieved Audit Logs Successfully') {
          final data = jsonData['data']['records'] as Iterable<dynamic>;

          if (data is List) {
            setState(() {
              print('AUDIT LOGS');
              print(jsonData['data']['records']);
              apiData = List<Map<String, dynamic>>.from(data);
              totalRecords = jsonData['data']['totalRecords'];
              totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
              isLoading = false; // Set loading to false when data is fetched
              // print('totalrecords:$totalRecords');
              // currentPage = page - 1;
            });
          } else {
            print('JSON data is not in the expected format');
          }
        } else {
          print('NO DATA AVAILABLE');
          setState(() {
            apiData = []; // Clear the existing data
            isLoading = false; // Set loading to false on error
          });
        }
      } else {
        print('HTTP Request failed with status code: ${response.statusCode}');
        // Update the UI to display an error message
        setState(() {
          apiData = []; // Clear the existing data
          isLoading = false; // Set loading to false on error
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      // Handle the scenario when the API is turned off or not accessible
      // Update the UI to display an error message
      setState(() {
        apiData = []; // Clear the existing data
        isLoading = false; // Set loading to false on error
      });
    }
  }

  List<String> _displayPages = [];
  List<String> _displayFileType = [];
  String _selectedItem = '10';
  String selectedDateFrom = '';
  String selectedDateTo = '';
  String selectedFileType = '';

  @override
  void initState() {
    super.initState();
    fetchData(1, int.parse(_selectedItem));
    fetchRows();
    updateUrl('/Reports/Audit_Trail_Reports');
    fetchFileType((fileType) {
      setState(() {
        _displayFileType = fileType;
      });
    });
  }

  //for reinitializing
  void _initializeData() {
    fetchData(1, int.parse(_selectedItem));
    fetchRows();
    initState();
  }

  Future<void> generateFile(BuildContext context) async {
    final String url = 'https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/audit/test/download/audit/logs?file_type=$selectedFileType&date_from=$selectedDateFrom&date_to=$selectedDateTo';
    try {
      Map<String, dynamic>? responseJson;
      final response = await http.get(Uri.parse(url));

      if (response.headers['content-type'] == 'application/json') {
        responseJson = json.decode(response.body);
      }

      if (response.statusCode == 200 && response.headers['content-type'] != 'application/json') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Downloading file'),
            duration: Duration(seconds: 3),
          ),
        );
        html.window.open(url, 'whitelist');
      } else if (response.statusCode == 200 && responseJson?["retCode"] == "404") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: ${responseJson?["message"]}'),
            duration: Duration(seconds: 10),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: ${responseJson?["message"]}'),
            duration: Duration(seconds: 10),
          ),
        );
      }
    } catch (error) {
      print('Error downloading file: $error');
    }
  }

  Future<void> fetchRows() async {
    final response = await http.get(Uri.parse('https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/ngo/test/get/all/displaypage'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['retCode'] == '200') {
        final List<dynamic> displayPageList = data['displaypage'];
        setState(() {
          _displayPages = displayPageList.map((page) => page.toString()).toList();
        });
      } else {
        // Handle error or show a default set of items
        print('Error: ${data['message']}');
      }
    } else {
      // Handle error or show a default set of items
      print('Error: ${response.statusCode}');
    }
  }

  List<DataRow> getPaginatedRows() {
    return apiData.map<DataRow>((rowData) {
      final color =
          // apiData.indexOf(rowData) % 2 == 0 ? Colors.grey[200] : Colors.white;
          apiData.indexOf(rowData) % 2 == 0 ? Colors.transparent : Colors.white;
      // apiData.indexOf(rowData) % 2 == 0 ? Colors.black54.withOpacity(0.1) : Colors.white;
      bool rememberMe = false;
      return DataRow(
        color: MaterialStateProperty.all(color),
        cells: [
          DataCell(Center(
              child: Text(
            rowData['logid'].toString(),
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: Text(
            rowData['uid'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: Text(
            rowData['fname'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: Text(
            rowData['lname'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: Text(
            rowData['username'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: Text(
            rowData['branch'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: Text(
            rowData['userrole'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: Text(
            rowData['dateandtime'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: Text(
            rowData['action'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: Text(
            rowData['original_values'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: Text(
            rowData['modified_values'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
        ],
      );
    }).toList();
  }

  void nextPage() {
    if (currentPage + 1 < totalPages) {
      setState(() {
        currentPage++; // Update currentPage
      });
      print("Next Page: $currentPage"); // Add a debug print
      // fetchData(currentPage + 1, itemsPerPage
      fetchData(currentPage + 1, int.parse(_selectedItem)); // Fetch the next page of data
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--; // Update currentPage
      });
      print("Previous Page: $currentPage"); // Add a debug print
      print(getPaginatedRows());
      // fetchData(currentPage + 1, itemsPerPage
      fetchData(currentPage + 1, int.parse(_selectedItem)); // Fetch the previous page of data
    }
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
            const HeaderBar(screenText: 'AUDIT LOGS'),
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
              //SHOW LIST AND EXPORT BUTTON
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //rows&clock
                  Container(
                    // color: Colors.blue,
                    width: MediaQuery.of(context).size.width * 0.65,
                    padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
                    child: Responsive(
                      desktop: Row(
                        children: [rowShowList(), const SizedBox(width: 50), rowFileType()],
                      ),
                      mobile: Wrap(
                        runSpacing: 10,
                        children: [rowShowList(), rowFileType()],
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Responsive(desktop: Clock(), mobile: Spacer()),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // color: Colors.amber,
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
                  child: Row(
                    children: [dateFromField(), const SizedBox(width: 10), dateToField()],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              // flex: 9,
              child: Container(
                // padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  // color: Colors.grey,
                  border: Border(
                    top: BorderSide(
                      // color: Color(0xff941c1b),
                      color: Colors.black54,
                      width: 0.1,
                      style: BorderStyle.solid,
                    ),
                    bottom: BorderSide(
                      // color: Color(0xff941c1b),
                      color: Colors.black54,
                      width: 0.1,
                      style: BorderStyle.solid,
                    ),
                    left: BorderSide(
                      // color: Color(0xff941c1b),
                      color: Colors.black54,
                      width: 0.1,
                      style: BorderStyle.solid,
                    ),
                    right: BorderSide(
                      // color: Color(0xff941c1b),
                      color: Colors.black54,

                      style: BorderStyle.solid,
                      width: 0.1,
                    ),
                  ),
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.ngoColor,
                        ),
                      )
                    : apiData.isEmpty
                        ? (Center(
                            child: Text(
                              'NO DATA AVAILABLE',
                              style: TextStyle(
                                fontFamily: 'RobotoThin',
                                color: Colors.black54.withOpacity(0.5),
                              ),
                            ),
                          ))
                        : Scrollbar(
                            // thickness: 15,
                            radius: const Radius.circular(3),
                            thumbVisibility: true,
                            scrollbarOrientation: ScrollbarOrientation.bottom,
                            controller: controllerOne,
                            child: SingleChildScrollView(
                              controller: controllerOne,
                              scrollDirection: Axis.horizontal,
                              child: Scrollbar(
                                radius: const Radius.circular(3),
                                thumbVisibility: true,
                                scrollbarOrientation: ScrollbarOrientation.right,
                                controller: controllerTwo,
                                child: SingleChildScrollView(
                                  controller: controllerTwo,
                                  scrollDirection: Axis.vertical,
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
                                      //COLUMN HEADERS
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  ' Log ID',
                                                  style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    fontSize: 14,
                                                    // color: Colors.white,
                                                    color: Colors.black.withOpacity(0.6),
                                                    letterSpacing: .5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ), //NEWBRANCHCODE
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'User ID',
                                                  style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    fontSize: 14,
                                                    // color: Colors.white,
                                                    color: Colors.black.withOpacity(0.6),
                                                    letterSpacing: .5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //UNIT
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'First Name',
                                                  style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    fontSize: 14,
                                                    // color: Colors.white,
                                                    color: Colors.black.withOpacity(0.6),
                                                    letterSpacing: .5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //CENTERNAME
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Last Name',
                                                  style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    fontSize: 14,
                                                    // color: Colors.white,
                                                    color: Colors.black.withOpacity(0.6),
                                                    letterSpacing: .5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //ESYSTEMCID
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Username',
                                                  style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    fontSize: 14,
                                                    // color: Colors.white,
                                                    color: Colors.black.withOpacity(0.6),
                                                    letterSpacing: .5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //CONTACT
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Branch',
                                                  style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    fontSize: 14,
                                                    // color: Colors.white,
                                                    color: Colors.black.withOpacity(0.6),
                                                    letterSpacing: .5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //LASTNAME
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'User Role',
                                                  style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    fontSize: 14,
                                                    // color: Colors.white,
                                                    color: Colors.black.withOpacity(0.6),
                                                    letterSpacing: .5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //FIRSTNAME
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Date and Time',
                                                  style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    fontSize: 14,
                                                    // color: Colors.white,
                                                    color: Colors.black.withOpacity(0.6),
                                                    letterSpacing: .5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //MIDDLENAME
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Action',
                                                  style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    fontSize: 14,
                                                    // color: Colors.white,
                                                    color: Colors.black.withOpacity(0.6),
                                                    letterSpacing: .5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //BIRTHDAY
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Original Values',
                                                  style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    fontSize: 14,
                                                    // color: Colors.white,
                                                    color: Colors.black.withOpacity(0.6),
                                                    letterSpacing: .5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //RD
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Modified Values',
                                                  style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    fontSize: 14,
                                                    // color: Colors.white,
                                                    color: Colors.black.withOpacity(0.6),
                                                    letterSpacing: .5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //LOM
                                        // DataColumn(
                                        //   label: Text(
                                        //     'Length of Membership',
                                        //     style: TextStyle(
                                        //       // fontWeight: FontWeight.bold,
                                        //       fontSize: 15,
                                        //       fontFamily: 'Crimson Text',
                                        //       color: Colors.white,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                      rows: getPaginatedRows(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //PAGINATION BUTTON CODE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    // color: Colors.black12,
                    // color: Colors.black54.withOpacity(0.1),
                    color: AppColors.ngoColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 12,
                    ),
                    // color: const Color(0xff941c1b),
                    color: Colors.white,
                    onPressed: previousPage,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    Text(
                      'PAGE ${currentPage + 1} OF $totalPages',
                      style: const TextStyle(fontFamily: 'RobotoThin', fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                    Text(
                      'Total Number of Clients: $totalRecords',
                      style: const TextStyle(fontFamily: 'RobotoThin', fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    // color: Colors.black12,
                    // color:  Colors.black54.withOpacity(0.1),
                    color: AppColors.ngoColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: IconButton(
                    // color: const Color(0xff941c1b),
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

  Widget rowShowList() {
    return Row(
      children: [
        const Text(
          'Show',
          style: TextStyle(
              fontFamily: 'RobotoThin',
              // color: Color(0xff1E5128),
              color: Colors.black54,
              fontSize: 12),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 35,
          height: 30,
          child: TextField(
            controller: _rowsperpagecontroller,
            textAlignVertical: TextAlignVertical.top,
            cursorColor: AppColors.ngoColor,
            cursorWidth: 1,
            cursorRadius: const Radius.circular(5),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: -20, left: 10),
              filled: true,
              fillColor: Colors.transparent,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.ngoColor,
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
                  color: AppColors.ngoColor,
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
                  color: AppColors.ngoColor,
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
          height: 30,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
              right: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
              bottom: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
              // left: BorderSide(color: Color(0xff1E5128), width: 0, style: BorderStyle.solid),
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
            // color: Colors.black26,
            color: AppColors.ngoColor,
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
        const SizedBox(width: 5),
        const Text(
          'List',
          style: TextStyle(fontFamily: 'RobotoThin', color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }

  Widget rowFileType() {
    // file type Textfield
    return Row(
      children: [
        SizedBox(
          width: 70,
          height: 30,
          child: TextField(
            controller: _filetypecontroller,
            textAlignVertical: TextAlignVertical.top,
            cursorColor: AppColors.ngoColor,
            cursorWidth: 1,
            cursorRadius: const Radius.circular(5),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: -20, left: 10),
              filled: true,
              fillColor: Colors.transparent,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.ngoColor,
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
                  color: AppColors.ngoColor,
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
                  color: AppColors.ngoColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              hintText: selectedFileType.isEmpty ? 'File Type' : selectedFileType,
              hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 11, color: Colors.black54),
            ),
            readOnly: true,
          ),
        ),
        Container(
          height: 30,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
              right: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
              bottom: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
              // left: BorderSide(color: Color(0xff1E5128), width: 0, style: BorderStyle.solid),
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
            // color: Colors.black26,
            color: AppColors.ngoColor,
          ),
          child: PopupMenuButton<String>(
            splashRadius: 20,
            icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.white),
            onSelected: (String selectedItem) {
              setState(() {
                selectedFileType = selectedItem;
                _initializeData();
              });
            },
            itemBuilder: (BuildContext context) {
              return _displayFileType.map((String type) {
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
        Container(
          margin: const EdgeInsets.only(left: 10),
          height: 30,
          width: 100, // Adjust the width as needed
          decoration: const BoxDecoration(
            // color: Colors.black12,
            // color:  Colors.black54.withOpacity(0.1),
            color: AppColors.ngoColor,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: TextButton(
            onPressed: () {
              setState(() {
                generateFile(context);
              });
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Export',
                  // style: TextStyle(
                  //   color: Colors.white,
                  // ),
                  style: TextStyles.normal12White,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget dateFromField() {
    return Row(
      children: [
        SizedBox(
          width: 80,
          height: 30,
          child: TextField(
            style: const TextStyle(fontSize: 12),
            controller: _datefrom,
            textAlignVertical: TextAlignVertical.top,
            cursorColor: AppColors.ngoColor,
            cursorWidth: 1,
            cursorRadius: const Radius.circular(5),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 10),
              filled: true,
              fillColor: Colors.transparent,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.ngoColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.ngoColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  color: AppColors.ngoColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              hintText: 'DATE FROM',
              hintStyle: TextStyle(fontFamily: 'RobotoThin', fontSize: 11, color: Colors.black54),
            ),
            readOnly: true,
          ),
        ),
        Container(
          height: 30,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
              right: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
              bottom: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
              // left: BorderSide(color: Color(0xff1E5128), width: 0, style: BorderStyle.solid),
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
            // color: Colors.black26,
            color: AppColors.ngoColor,
          ),
          child: IconButton(
            onPressed: () => _selectDateFrom(context),
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget dateToField() {
    return Row(
      children: [
        SizedBox(
          width: 80,
          height: 30,
          child: TextField(
            style: const TextStyle(fontSize: 12),
            controller: _dateto,
            textAlignVertical: TextAlignVertical.top,
            cursorColor: AppColors.ngoColor,
            cursorWidth: 1,
            cursorRadius: const Radius.circular(5),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 10),
              filled: true,
              fillColor: Colors.transparent,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.ngoColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.ngoColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  color: AppColors.ngoColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              hintText: 'DATE TO',
              hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 11, color: Colors.black54),
            ),
            readOnly: true,
          ),
        ),
        Container(
          height: 30,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
              right: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
              bottom: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
              // left: BorderSide(color: Color(0xff1E5128), width: 0, style: BorderStyle.solid),
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
            // color: Colors.black26,
            color: AppColors.ngoColor,
          ),
          child: IconButton(
            onPressed: () => _selectDateTo(context),
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: 12,
            ),
          ),
        ),
      ],
    );
  }
}
