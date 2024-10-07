import 'dart:convert';
import 'dart:core';
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

class WhiteListedReport extends StatefulWidget {
  const WhiteListedReport({Key? key}) : super(key: key);

  @override
  State<WhiteListedReport> createState() => _WhiteListedReportState();
}

class _WhiteListedReportState extends State<WhiteListedReport> {
  // Timer? _timer;

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
  final insti = getInstitution();

  TextEditingController _rowsperpagecontroller = TextEditingController();
  TextEditingController _areacontroller = TextEditingController();
  TextEditingController _unitcontroller = TextEditingController();
  TextEditingController _centercontroller = TextEditingController();
  TextEditingController _datefrom = TextEditingController();
  TextEditingController _dateto = TextEditingController();

  final ScrollController controllerOne = ScrollController();
  final ScrollController controllerTwo = ScrollController();
  TextEditingController _filetypecontroller = TextEditingController();

  List<Map<String, dynamic>> apiData = [];
  List<String> _displayFileType = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  String selectedArea = '';
  String selectedUnit = '';
  String selectedCenter = '';
  String selectedFrom = '';
  String selectedTo = '';
  bool isLoading = true; // Add this variable to track loading state
  int totalRecords = 0;
  int totalPages = 1;
  String selectedFileType = '';

  bool _sortAscending = true;
  int _sortColumnIndex = 0;

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
        selectedFrom = formattedDate;
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
        selectedTo = formattedDate;
        _initializeData();
        // _validateFields();
        // AddClientGetSet.setBirthday(_datefrom.text);
      });
    }
  }

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
      final token = getToken();
      final response = await http.get(
        Uri.parse('https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/ngo/test/get/all/clients?page=$page&perPage=$_selectedItem'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept-Charset': 'UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));

        if (jsonData['retCode'] == '200' && jsonData['message'] == 'Clients Found') {
          final data = jsonData['data'];

          if (data is List) {
            setState(() {
              print('Displayed Client List');
              print(jsonData['data']);
              apiData = List<Map<String, dynamic>>.from(data);
              totalRecords = jsonData['totalRecords'];
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
    final String url = 'https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/ngo/test/reports/download/whitelisted?file_type=$selectedFileType&area=$selectedArea&unit=$selectedUnit&center_name=$selectedCenter&date_from=$selectedFrom&date_to=$selectedTo';
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

  List<String> _displayArea = [];
  List<String> _displayUnit = [];
  List<String> _displayCenter = [];
  List<String> _displayPages = [];
  String _selectedItem = '10';

  @override
  void initState() {
    super.initState();
    fetchDistinct();
    fetchDistinctData(1, int.parse(_selectedItem), selectedArea);
    fetchRows();
    updateUrl('/Reports/Whitelisted_Reports');
    fetchFileType((fileType) {
      setState(() {
        _displayFileType = fileType;
      });
    });
  }

  //for reinitializing
  void _initializeData() {
    fetchDistinctData(1, int.parse(_selectedItem), selectedArea);
    fetchRows();
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

  void fetchDistinctData(int page, int perPage, String area) async {
    setState(() {
      isLoading = true;
    });

    try {
      final token = getToken();
      final response = await http.get(
        Uri.parse('https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/ngo/test/get/all/clients/reports?page=$page&perPage=$_selectedItem&area=$selectedArea&unit=$selectedUnit&center_name=$selectedCenter&date_from=$selectedFrom&date_to=$selectedTo'),
        // 'http://127.0.0.1:9999/api/public/v1/ngo/test/get/all/clients/reports?page=$page&perPage=$_selectedItem&area=$selectedArea&unit=$selectedUnit&center_name=$selectedCenter'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept-Charset': 'UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));

        if (jsonData['retCode'] == '200' && jsonData['message'] == 'Clients Found') {
          final data = jsonData['data'];

          if (data is List) {
            setState(() {
              print('Displayed Client List');
              print(jsonData['data']);
              apiData = List<Map<String, dynamic>>.from(data);
              totalRecords = jsonData['totalRecords'];
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

  Future<void> fetchDistinct() async {
    try {
      final token = getToken();
      final response = await http.get(
        Uri.parse('https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/ngo/test/get/all/distinct?area=$selectedArea&unit=$selectedUnit&center_name=$selectedCenter'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept-Charset': 'UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print("1:$selectedArea 2:$selectedUnit 3:$selectedCenter");
        final responseData = json.decode(response.body);
        List<String> area = List<String>.from(responseData['distinctData']['area'] ?? []);
        List<String> unit = List<String>.from(responseData['distinctData']['unit'] ?? []);
        List<String> center = List<String>.from(responseData['distinctData']['center_name'] ?? []);

        // area.sort();
        // unit.sort();
        // center.sort();

        setState(() {
          _displayArea = area;
          _displayUnit = unit;
          _displayCenter = center;
        });

        print('SUCCESS');
        print('____AREA____: $_displayArea');
        print('____UNIT____: $_displayUnit');
        print('____CENTER____: $_displayCenter');
      } else {
        print('FAILED');
        throw Exception('Failed to load menu data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      // Handle exception, maybe show a snackbar or display an error message.
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
            rowData['newcid'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['area'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['newbranchcode'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['unit'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['centername'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['esystemcid'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['contact'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['lastname'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['firstname'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['middlename'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['birthday'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['recognizeddate'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['lengthofmembership']?.toString() ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['dateadded']?.toString() ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['datemodified']?.toString() ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
              color: Colors.black54,
            ),
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
      // color: Colors.grey,
      padding: const EdgeInsets.only(left: 90),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const HeaderBar(screenText: 'WHITELISTED CLIENTS'),
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
            //SEARCH FIELDS
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
                  child: Responsive(
                      desktop: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [areaField(), unitField(), centerField(), dateFrom(), dateTo()],
                      ),
                      tablet: Wrap(
                        runSpacing: 10,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [areaField(), unitField(), centerField()],
                          ),
                          Row(
                            children: [dateFrom(), const SizedBox(width: 10), dateTo()],
                          )
                        ],
                      ),
                      mobile: Wrap(
                        runSpacing: 10,
                        children: [
                          areaField(),
                          unitField(),
                          centerField(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [dateFrom(), const SizedBox(width: 10), dateTo()],
                          )
                        ],
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
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
                                      // border: TableBorder.all(width: 0.1,color: const Color(0xff941c1b)),
                                      border: TableBorder.all(width: 0.1, color: Colors.black54.withOpacity(0.5)),
                                      headingRowColor: MaterialStateColor.resolveWith(
                                        // (states) => const Color(0xff941c1b).withOpacity(0.1),
                                        //     (states) => const Color(0xff941c1b),
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
                                                    'New CID',
                                                    style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Icon(
                                                    _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                                                    color: Colors.black54,
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
                                                  'Area',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
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
                                                  'New Branch Code',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
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
                                                  'Unit',
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
                                        //CENTERNAME
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Center Name',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
                                                      fontWeight: FontWeight.bold),
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
                                                  'Esystem CID',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
                                                      fontWeight: FontWeight.bold),
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
                                                  'Contact',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
                                                      fontWeight: FontWeight.bold),
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
                                                  'Last Name',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
                                                      fontWeight: FontWeight.bold),
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
                                                  'First Name',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
                                                      fontWeight: FontWeight.bold),
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
                                                  'Middle Name',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
                                                      fontWeight: FontWeight.bold),
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
                                                  'Birthday',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
                                                      fontWeight: FontWeight.bold),
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
                                                  'Recognized Date',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //LOM
                                        DataColumn(
                                          label: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Length of Membership',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
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
                                                  'Date Added',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
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
                                                  'Date Modified',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoThin',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      // color: Colors.white,
                                                      color: Colors.black.withOpacity(0.6),
                                                      letterSpacing: .5,
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
        const SizedBox(width: 5),
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
        const SizedBox(
          width: 5,
        ),
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

  Widget areaField() {
    return Row(
      children: [
        //areatextfield
        SizedBox(
          width: 175,
          height: 30,
          child: TextField(
            controller: _areacontroller,
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
              hintText: selectedArea.isEmpty ? 'AREA' : selectedArea,
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
                _unitcontroller.clear();
                _centercontroller.clear();
                selectedUnit = '';
                selectedCenter = '';
                selectedArea = selectedItem;
                fetchDistinct();
                _initializeData();
              });
            },
            itemBuilder: (BuildContext context) {
              return _displayArea.map((String type) {
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
      ],
    );
  }

  Widget unitField() {
    return Row(
      children: [
        //unittextfield
        SizedBox(
          width: 175,
          height: 30,
          child: TextField(
            controller: _unitcontroller,
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
              hintText: selectedUnit.isEmpty ? 'UNIT' : selectedUnit,
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
                selectedUnit = selectedItem;
                fetchDistinct();
                _initializeData();
              });
            },
            itemBuilder: (BuildContext context) {
              return _displayUnit.map((String type) {
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
      ],
    );
  }

  Widget centerField() {
    return Row(
      children: [
        SizedBox(
          width: 175,
          height: 30,
          child: TextField(
            controller: _centercontroller,
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
              hintText: selectedCenter.isEmpty ? 'CENTER' : selectedCenter,
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
                selectedCenter = selectedItem;
                fetchDistinct();
                _initializeData();
              });
            },
            itemBuilder: (BuildContext context) {
              return _displayCenter.map((String type) {
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
      ],
    );
  }

  Widget dateFrom() {
    return Row(
      children: [
        SizedBox(
          width: 80,
          height: 30,
          child: TextField(
            onTap: () {
              _selectDateFrom(context);
              print(_datefrom); // Call the function when the TextField is tapped
            },
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

  Widget dateTo() {
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
