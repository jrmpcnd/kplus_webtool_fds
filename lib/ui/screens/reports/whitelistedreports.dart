import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';

import '../../../main.dart';
import '../../shared/clock/clock.dart';
import '../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import '../user_management/ui/screen_bases/header/header.dart';

class WhiteListedReports extends StatefulWidget {
  const WhiteListedReports({Key? key}) : super(key: key);

  @override
  State<WhiteListedReports> createState() => _WhiteListedReportsState();
}

class _WhiteListedReportsState extends State<WhiteListedReports> {
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
  // /}

  final fname = getFname();
  final lname = getLname();
  final urole = getUrole();

  List<String> _displayArea = [];
  List<String> _displayUnit = [];
  List<String> _displayCenter = [];
  TextEditingController _rowsperpagecontroller = TextEditingController();
  TextEditingController _areacontroller = TextEditingController();
  TextEditingController _unitcontroller = TextEditingController();
  TextEditingController _centercontroller = TextEditingController();
  TextEditingController _filetype = TextEditingController();

  final ScrollController controllerOne = ScrollController();
  final ScrollController controllerTwo = ScrollController();
  List<Map<String, dynamic>> apiData = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isLoading = true; // Add this variable to track loading state
  int totalRecords = 0;
  int totalPages = 1;
  List<dynamic> area = [];
  List<dynamic> unit = [];
  List<dynamic> centername = [];

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
      final token = getToken();
      final response = await http.get(
        Uri.parse('https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/ngo/test/get/all/clients?page=$page&perPage=$_selectedItem'),
        //http://127.0.0.1:9999/api/public/v1/ngo/test/get/all/clients/reports?page=1&perPage=10&area=Cagayan 3
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

  void fetchDistinctData(int page, int perPage, String area) async {
    setState(() {
      isLoading = true;
    });

    try {
      final token = getToken();
      final response = await http.get(
        Uri.parse('https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/ngo/test/get/all/clients/reports?page=$page&perPage=$_selectedItem&area=$selectedArea&unit=$selectedUnit&center_name=$selectedCenter'),
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

  List<String> _displayPages = [];
  String _selectedItem = '10';
  String selectedArea = '';
  String selectedUnit = '';
  String selectedCenter = '';

  @override
  void initState() {
    super.initState();
    fetchDistinct();
    fetchDistinctData(1, int.parse(_selectedItem), selectedArea);
    fetchRows();
    updateUrl('/Reports/Whitelisted_Reports');
  }

  //for reinitializing
  void _initializeData() {
    // fetchDistinct();
    fetchDistinctData(1, int.parse(_selectedItem), selectedArea);
    fetchRows();
    // initState();
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
          apiData.indexOf(rowData) % 2 == 0 ? Colors.white : Colors.white;
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
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['area'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['newbranchcode'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['unit'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['centername'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['esystemcid'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['contact'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['lastname'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['firstname'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['middlename'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['birthday'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['recognizeddate'] ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['lengthofmembership']?.toString() ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['dateadded']?.toString() ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
            ),
          ))),
          DataCell(Center(
              child: SelectableText(
            rowData['datemodified']?.toString() ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'RobotoThin',
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
      fetchDistinctData(currentPage + 1, int.parse(_selectedItem), selectedArea); // Fetch the next page of data
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
      // fetchData(currentPage + 1, int.parse(_selectedItem)); // Fetch the previous page of data
      fetchDistinctData(currentPage + 1, int.parse(_selectedItem), selectedArea);
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
            const HeaderBar(screenText: 'WHITELISTED CLIENTS REPORT'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 5,
                    bottom: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: const Color(0xff009150).withOpacity(0.1),
                  ),
                  height: 40,
                  width: 200,
                  child: Row(
                    children: [
                      const Text(
                        'Show',
                        style: TextStyle(
                          fontFamily: 'RobotoThin',
                          color: Color(0xff1E5128),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 45,
                        height: 40,
                        child: TextField(
                          controller: _rowsperpagecontroller,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: const Color(0xff009150),
                          cursorWidth: 1,
                          cursorRadius: const Radius.circular(5),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff009150),
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
                                color: Color(0xff009150),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                              ),
                            ),
                            hintText: _selectedItem,
                            hintStyle: const TextStyle(
                              fontFamily: 'RobotoThin',
                              fontSize: 12,
                            ),
                          ),
                          readOnly: true,
                        ),
                      ),
                      Container(
                        height: 40,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xff1E5128), width: 1, style: BorderStyle.solid),
                            right: BorderSide(color: Color(0xff1E5128), width: 1, style: BorderStyle.solid),
                            bottom: BorderSide(color: Color(0xff1E5128), width: 1, style: BorderStyle.solid),
                            // left: BorderSide(color: Color(0xff1E5128), width: 0, style: BorderStyle.solid),
                          ),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color: Colors.black26,
                        ),
                        child: PopupMenuButton<String>(
                          splashRadius: 20,
                          icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.black),
                          onSelected: (String selectedItem) {
                            setState(() {
                              _selectedItem = selectedItem;
                              _initializeData();
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return _displayPages.map((String type) {
                              return PopupMenuItem<String>(
                                height: 25,
                                value: type,
                                child: Center(
                                  child: Text(
                                    type,
                                    style: const TextStyle(
                                      fontFamily: 'RobotoThin',
                                      color: Color(0xff1E5128),
                                      fontSize: 13,
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
                        width: 10,
                      ),
                      const Text(
                        'List',
                        style: TextStyle(
                          fontFamily: 'RobotoThin',
                          color: Color(0xff1E5128),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 70,
                  height: 30,
                  child: TextField(
                    controller: _rowsperpagecontroller,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: const Color(0xff009150),
                    cursorWidth: 1,
                    cursorRadius: const Radius.circular(5),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff009150),
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
                          color: Color(0xff009150),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                      ),
                      hintText: _selectedItem,
                      hintStyle: const TextStyle(
                        fontFamily: 'RobotoThin',
                        fontSize: 12,
                      ),
                    ),
                    readOnly: true,
                  ),
                ),
                Container(
                  // padding: EdgeInsets.all(5),
                  decoration: const BoxDecoration(),
                  height: 30,
                  // width: 80,
                  child: ElevatedButton(
                    onPressed: () {},
                    // SearchButtonEnabled ? () => GetClient(1, 10) : null,
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
                      backgroundColor: const Color(0xff009150),
                    ),
                    child: const Center(
                      child: Row(
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
                            style: TextStyle(
                              fontFamily: 'RobotoThin',
                              color: Colors.white,
                              // fontFamily: 'Crimson Text',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const Clock(),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  //area
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: TextField(
                      controller: _areacontroller,
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: const Color(0xff009150),
                      cursorWidth: 1,
                      cursorRadius: const Radius.circular(5),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff009150),
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
                            color: Color(0xff009150),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                        // hintText: selectedArea,
                        hintText: selectedArea.isEmpty ? 'AREA' : selectedArea,
                        hintStyle: const TextStyle(
                          fontFamily: 'RobotoThin',
                          fontSize: 12,
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xff1E5128), width: 1, style: BorderStyle.solid),
                        right: BorderSide(color: Color(0xff1E5128), width: 1, style: BorderStyle.solid),
                        bottom: BorderSide(color: Color(0xff1E5128), width: 1, style: BorderStyle.solid),
                        // left: BorderSide(color: Color(0xff1E5128), width: 0, style: BorderStyle.solid),
                      ),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                      color: Colors.black26,
                    ),
                    child: PopupMenuButton<String>(
                      splashRadius: 20,
                      icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.black),
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
                            padding: const EdgeInsets.all(5),
                            height: 25,
                            value: type,
                            child: Center(
                              child: Text(
                                type,
                                style: const TextStyle(
                                  fontFamily: 'RobotoThin',
                                  color: Color(0xff1E5128),
                                  fontSize: 13,
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
                    width: 20,
                  ),
                  //unit
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: TextField(
                      controller: _unitcontroller,
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: const Color(0xff009150),
                      cursorWidth: 1,
                      cursorRadius: const Radius.circular(5),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff009150),
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
                            color: Color(0xff009150),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                        // hintText: selectedUnit,
                        hintText: selectedUnit.isEmpty ? 'UNIT' : selectedUnit,
                        hintStyle: const TextStyle(
                          fontFamily: 'RobotoThin',
                          fontSize: 12,
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xff1E5128), width: 1, style: BorderStyle.solid),
                        right: BorderSide(color: Color(0xff1E5128), width: 1, style: BorderStyle.solid),
                        bottom: BorderSide(color: Color(0xff1E5128), width: 1, style: BorderStyle.solid),
                        // left: BorderSide(color: Color(0xff1E5128), width: 0, style: BorderStyle.solid),
                      ),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                      color: Colors.black26,
                    ),
                    child: PopupMenuButton<String>(
                      splashRadius: 20,
                      icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.black),
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
                            height: 25,
                            value: type,
                            child: Center(
                              child: Text(
                                type,
                                style: const TextStyle(
                                  fontFamily: 'RobotoThin',
                                  color: Color(0xff1E5128),
                                  fontSize: 13,
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
                    width: 20,
                  ),
                  //center
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: TextField(
                      controller: _centercontroller,
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: const Color(0xff009150),
                      cursorWidth: 1,
                      cursorRadius: const Radius.circular(5),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff009150),
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
                            color: Color(0xff009150),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                        // hintText: selectedCenter,
                        hintText: selectedCenter.isEmpty ? 'CENTER NAME' : selectedCenter,
                        hintStyle: const TextStyle(
                          fontFamily: 'RobotoThin',
                          fontSize: 12,
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xff1E5128), width: 1, style: BorderStyle.solid),
                        right: BorderSide(color: Color(0xff1E5128), width: 1, style: BorderStyle.solid),
                        bottom: BorderSide(color: Color(0xff1E5128), width: 1, style: BorderStyle.solid),
                        // left: BorderSide(color: Color(0xff1E5128), width: 0, style: BorderStyle.solid),
                      ),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                      color: Colors.black26,
                    ),
                    child: PopupMenuButton<String>(
                      splashRadius: 20,
                      icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.black),
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
                            height: 25,
                            value: type,
                            child: Center(
                              child: Text(
                                type,
                                style: const TextStyle(
                                  fontFamily: 'RobotoThin',
                                  color: Color(0xff1E5128),
                                  fontSize: 13,
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
                    width: 20,
                  ),
                  SizedBox(
                    height: 35,
                    width: 250,
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      readOnly: true,
                      // controller: RecognizedDatecontroller,
                      // onTap: () => _selectRecDate(context),
                      // onChanged: (value) {
                      //   setState(() {
                      //     _validateFields();
                      //     AddClientGetSet.setRecognizedDate(
                      //         value);
                      //   });
                      // },
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: const Color(0xff941c1b),
                      cursorWidth: 1,
                      cursorHeight: 12,
                      cursorRadius: const Radius.circular(5),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                        filled: true,
                        fillColor: Colors.white10.withOpacity(0.8),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            // color: Color(0xff941c1b),
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff941c1b),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            )),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff941c1b),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        // prefixIcon: IconButton(
                        //   onPressed: () =>
                        //       _selectRecDate(context),
                        //   icon: const Icon(
                        //     Icons.calendar_month_outlined,
                        //     color: Color(0xff941c1b),
                        //     size: 17,
                        //   ),
                        // ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            // RecognizedDatecontroller.clear();
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Color(0xff941c1b),
                            size: 17,
                          ),
                        ),
                        hintText: 'Recognized Date',
                        hintStyle: const TextStyle(fontFamily: 'RobotoThin', fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
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
                      color: Color(0xff1E5128),
                      width: 0.5,
                      style: BorderStyle.solid,
                    ),
                    bottom: BorderSide(
                      color: Color(0xff1E5128),
                      width: 0.5,
                      style: BorderStyle.solid,
                    ),
                    left: BorderSide(
                      color: Color(0xff1E5128),
                      width: 0.5,
                      style: BorderStyle.solid,
                    ),
                    right: BorderSide(
                      color: Color(0xff1E5128),
                      style: BorderStyle.solid,
                      width: 0.5,
                    ),
                  ),
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff009150),
                        ),
                      )
                    : apiData.isEmpty
                        ? (const Center(
                            child: Text(
                              'NO DATA AVAILABLE',
                              style: TextStyle(
                                fontFamily: 'RobotoThin',
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
                                  child: DataTable(
                                    sortColumnIndex: _sortColumnIndex,
                                    sortAscending: _sortAscending,
                                    border: TableBorder.all(width: 0.2),
                                    headingRowColor: MaterialStateColor.resolveWith(
                                      (states) => const Color(0xff009150).withOpacity(0.1),
                                    ),
                                    //COLUMN HEADERS
                                    columns: [
                                      //NEWCID
                                      // DataColumn(
                                      //   label: Expanded(
                                      //     child: Row(
                                      //       mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //       children: [
                                      //         Text(
                                      //           'New CID',
                                      //           style: TextStyle(
                                      //               fontFamily: 'RobotoThin',
                                      //               // fontWeight: FontWeight.bold,
                                      //               fontSize: 15,
                                      //               color: Color(0xff1E5128),
                                      //               fontWeight: FontWeight.bold),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      DataColumn(
                                        label: Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              _sortData(0, !_sortAscending);
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'New CID',
                                                  style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
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
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Area',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //NEWBRANCHCODE
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'New Branch Code',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //UNIT
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Unit',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //CENTERNAME
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Center Name',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //ESYSTEMCID
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Esystem CID',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //CONTACT
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Contact',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //LASTNAME
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Last Name',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //FIRSTNAME
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'First Name',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //MIDDLENAME
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Middle Name',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //BIRTHDAY
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Birthday',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //RD
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Recognized Date',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //LOM
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Length of Membership',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Date Added',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const DataColumn(
                                        label: Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Date Modified',
                                                style: TextStyle(
                                                    fontFamily: 'RobotoThin',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xff1E5128),
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
            const SizedBox(
              height: 10,
            ),
            //PAGINATION BUTTON CODE
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.black12,
                    color: const Color(0xff009150).withOpacity(0.1),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 15,
                    ),
                    color: const Color(0xff1E5128),
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
                      style: const TextStyle(fontFamily: 'RobotoThin', fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w500, color: Color(0xff1E5128)),
                    ),
                    Text(
                      'Total Number of Clients: $totalRecords',
                      style: const TextStyle(fontFamily: 'RobotoThin', fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w500, color: Color(0xff1E5128)),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.black12,
                    color: const Color(0xff009150).withOpacity(0.1),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: IconButton(
                    color: const Color(0xff1E5128),
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
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
