import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/service/filetype_api.dart';
import '../../../main.dart';
import '../../shared/clock/clock.dart';
import '../../shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import '../../shared/utils/utils_responsive.dart';
import '../../shared/values/colors.dart';
import '../../shared/values/styles.dart';
import '../user_management/ui/screen_bases/header/header.dart';

class OtpLogsReports extends StatefulWidget {
  const OtpLogsReports({Key? key}) : super(key: key);

  @override
  State<OtpLogsReports> createState() => _OtpLogsReportsState();
}

class _OtpLogsReportsState extends State<OtpLogsReports> {
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
  TextEditingController _filetypecontroller = TextEditingController();
  TextEditingController _smsFromcontroller = TextEditingController();

  final ScrollController controllerOne = ScrollController();
  final ScrollController controllerTwo = ScrollController();
  List<Map<String, dynamic>> apiData = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isLoading = true; // Add this variable to track loading state
  int totalRecords = 0;
  int totalPages = 1;
  String selectedFileType = '';
  String selectedSmsFrom = '';
  List<String> _displayFileType = [];

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

  void fetchData(int page, int perPage) async {
    setState(() {
      isLoading = true;
    });

    try {
      // final token = getToken();
      final response = await http.get(
        Uri.parse('https://dev-mercury.fortress-asya.com:17000/api/v1/report/otp/card?perPage=$_selectedItem&page=$page'),
        // Uri.parse('https://dev-mercury.fortress-asya.com:17000/api/v1/report/otp?page=$page&perPage=$_selectedItem'),
        // 'https://dev-mercury.fortress-asya.com:17000/api/v1/report/otp/date?start=2022-03-26&end=2024-02-28&limit=10&offset=1'),
        headers: {
          // 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept-Charset': 'UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));

        if (jsonData['RetCode'] == '200' && jsonData['Message'] == 'Success') {
          final data = jsonData['Data'];
          List<String> sender = List<String>.from(jsonData['distinctData'] ?? []);
          setState(() {
            _displaySmsFrom = sender;
          });

          if (data is List) {
            setState(() {
              print('Displayed Client List');
              print(jsonData['data']);
              apiData = List<Map<String, dynamic>>.from(data);
              totalRecords = jsonData['TotalRecords'];
              // totalPages = (totalRecords / itemsPerPage).ceil();
              totalPages = (totalRecords / int.parse(_selectedItem)).ceil();
              isLoading = false;
            });
          } else {
            print('JSON data is not in the expected format');
            setState(() {
              apiData = [];
              isLoading = false;
            });
          }
        } else {
          print('NO DATA AVAILABLE');
          setState(() {
            apiData = [];
            isLoading = false;
          });
        }
      } else {
        print('HTTP Request failed with status code: ${response.statusCode}');
        setState(() {
          apiData = [];
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        apiData = [];
        isLoading = false;
      });
    }
  }

  Future<void> generateFile(BuildContext context) async {
    final String url = 'https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/ngo/test/download/otp/logs?file_type=$selectedFileType&fromNumber=$selectedSmsFrom';
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

  List<String> _displayPages = [];
  List<String> _displaySmsFrom = [];
  String _selectedItem = '10';

  @override
  void initState() {
    super.initState();
    fetchData(1, int.parse(_selectedItem));
    fetchRows();
    updateUrl('/Reports/Otp_Logs_Reports');
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
              child: SelectableText(
            rowData['status'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['timeSent'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['fromNumber'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['toNumber'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['content'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['channel'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['cid'] ?? '',
            style: const TextStyle(fontSize: 11, fontFamily: 'RobotoThin', color: Colors.black54),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['fullName'] ?? '',
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
            const HeaderBar(screenText: 'OTP LOGS REPORTS'),
            Container(
              padding: const EdgeInsets.only(
                right: 10,
                top: 5,
              ),
              decoration: const BoxDecoration(
                // border: Border.all(
                //   style: BorderStyle.solid,
                //   width: 0.5,
                //   color: const Color(0xff932221),
                //   // color: Colors.transparent,
                // ),
                // color: const Color(0xFFFAF9F6),
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //rows&clock
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
                    child: Responsive(
                      desktop: Row(
                        children: [rowShowList(), const SizedBox(width: 50), rowFileType()],
                      ),
                      tablet: Row(
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.only(
            //         left: 3,
            //         right: 10,
            //         top: 5,
            //         bottom: 5,
            //       ),
            //       decoration: const BoxDecoration(
            //         color: Colors.transparent,
            //       ),
            //       height: 40,
            //       // width: 200,
            //       child: Row(
            //         children: [
            //           // From TextField
            //           SizedBox(
            //             width: 200,
            //             height: 35,
            //             child: TextField(
            //               controller: _smsFromcontroller,
            //               textAlignVertical: TextAlignVertical.top,
            //               cursorColor: AppColors.ngoColor,
            //               cursorWidth: 1,
            //               cursorRadius: const Radius.circular(5),
            //               decoration: InputDecoration(
            //                 contentPadding: const EdgeInsets.only(top: -20, left: 10),
            //                 filled: true,
            //                 fillColor: Colors.transparent,
            //                 focusedBorder: const OutlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: AppColors.ngoColor,
            //                     width: 0.5,
            //                   ),
            //                   borderRadius: BorderRadius.only(
            //                     topLeft: Radius.circular(5),
            //                     bottomLeft: Radius.circular(5),
            //                     topRight: Radius.circular(0),
            //                     bottomRight: Radius.circular(0),
            //                   ),
            //                 ),
            //                 enabledBorder: const OutlineInputBorder(
            //                   borderSide: BorderSide(
            //                     color: AppColors.ngoColor,
            //                     width: 0.5,
            //                   ),
            //                   borderRadius: BorderRadius.only(
            //                     topLeft: Radius.circular(5),
            //                     bottomLeft: Radius.circular(5),
            //                     topRight: Radius.circular(0),
            //                     bottomRight: Radius.circular(0),
            //                   ),
            //                 ),
            //                 border: const OutlineInputBorder(
            //                   borderSide: BorderSide(
            //                     style: BorderStyle.solid,
            //                     color: AppColors.ngoColor,
            //                     width: 0.5,
            //                   ),
            //                   borderRadius: BorderRadius.only(
            //                     topLeft: Radius.circular(5),
            //                     bottomLeft: Radius.circular(5),
            //                     topRight: Radius.circular(0),
            //                     bottomRight: Radius.circular(0),
            //                   ),
            //                 ),
            //                 hintText: selectedSmsFrom.isEmpty ? 'From' : selectedSmsFrom,
            //                 hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 11, color: Colors.black54),
            //               ),
            //               readOnly: true,
            //             ),
            //           ),
            //           Container(
            //             height: 40,
            //             decoration: const BoxDecoration(
            //               border: Border(
            //                 top: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
            //                 right: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
            //                 bottom: BorderSide(color: AppColors.ngoColor, width: 0.1, style: BorderStyle.solid),
            //                 // left: BorderSide(color: Color(0xff1E5128), width: 0, style: BorderStyle.solid),
            //               ),
            //               borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
            //               // color: Colors.black26,
            //               color: AppColors.ngoColor,
            //             ),
            //             child: PopupMenuButton<String>(
            //               splashRadius: 20,
            //               icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.white),
            //               onSelected: (String selectedItem) {
            //                 setState(() {
            //                   selectedSmsFrom = selectedItem;
            //                   _initializeData();
            //                 });
            //               },
            //               itemBuilder: (BuildContext context) {
            //                 return _displaySmsFrom.map((String type) {
            //                   return PopupMenuItem<String>(
            //                     height: 20,
            //                     value: type,
            //                     child: Center(
            //                       child: Text(
            //                         type,
            //                         style: const TextStyle(
            //                           fontFamily: 'RobotoThin',
            //                           color: Colors.black54,
            //                           fontSize: 12,
            //                         ),
            //                       ),
            //                     ),
            //                   );
            //                 }).toList();
            //               },
            //               elevation: 8,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
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
                                            child: GestureDetector(
                                              onTap: () {
                                                _sortData(0, !_sortAscending);
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Status',
                                                    style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      fontSize: 15,
                                                      color: Colors.black.withOpacity(0.6),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Icon(
                                                    _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                                                    color: const Color(0xff1E5128),
                                                    size: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        //AREA
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Time Sent',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.black.withOpacity(0.6),
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //NEWBRANCHCODE
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'From',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.black.withOpacity(0.6),
                                                      fontWeight: FontWeight.bold),
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
                                                  'Sent To',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.black.withOpacity(0.6),
                                                      fontWeight: FontWeight.bold),
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
                                                  'SMS Content',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.black.withOpacity(0.6),
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Channel',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Cid',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Name',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
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
        const SizedBox(
          width: 5,
        ),
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
        const SizedBox(
          width: 5,
        ),
        const Text(
          'List',
          style: TextStyle(fontFamily: 'RobotoThin', color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }

  Widget rowFileType() {
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
        // Button Download text fields
        const SizedBox(width: 5),
        Container(
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
}
