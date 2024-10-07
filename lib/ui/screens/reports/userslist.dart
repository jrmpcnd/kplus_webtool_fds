import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../core/models/user_management/user_model.dart';
import '../../../core/provider/user_provider.dart';
import '../../../core/service/filetype_api.dart';
import '../../../main.dart';
import '../../shared/clock/clock.dart';
import '../../shared/utils/utils_responsive.dart';
import '../../shared/values/colors.dart';
import '../../shared/values/styles.dart';
import '../../shared/widget/scrollable/scrollable_widget.dart';
import '../user_management/ui/screen_bases/header/header.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool isLoading = true;
  String selectedFileType = '';

  TextEditingController _filetypecontroller = TextEditingController();
  TextEditingController rowsPerPageController = TextEditingController();

  List<String> _displayPages = [];
  List<String> _displayFileType = [];

  final userAccessColumns = [
    'Staff ID',
    'Role',
    'Username',
    'Last Name',
    'First Name',
    'Middle Name',
    'Mobile Number',
    'Email',
    'Position',
    'Institution',
    'Account Status',
  ];
  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
          label: Text(
            column,
            style: TextStyles.headingTextStyle,
            textAlign: TextAlign.right,
          ),
        ),
      )
      .toList();

  @override
  void initState() {
    UserProvider userRows = Provider.of<UserProvider>(context, listen: false);
    userRows.fetchAllUsers();
    refreshTableData();
    super.initState();
    // fetchRows();
    updateUrl('/Reports/Users_List');
    fetchFileType((fileType) {
      setState(() {
        _displayFileType = fileType;
      });
    });
    rowsPerPageController.text = '10';
  }

  @override
  void dispose() {
    rowsPerPageController.dispose();
    super.dispose();
  }

  Future<void> generateFile(BuildContext context) async {
    final String url = 'https://dev-chatbot-services.fortress-asya.com:19002/api/public/v1/usermanagement/test/download/user/report?file_type=$selectedFileType';
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
            duration: const Duration(seconds: 10),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: ${responseJson?["message"]}'),
            duration: const Duration(seconds: 10),
          ),
        );
      }
    } catch (error) {
      print('Error downloading file: $error');
    }
  }

  void refreshTableData() {
    UserProvider userRows = Provider.of<UserProvider>(context, listen: false);
    userRows.fetchAllUsers();
  }

  void _updatePageSize(int value) {
    setState(() {
      rowsPerPageController.text = value.toString();
    });
    Provider.of<UserProvider>(context, listen: false).updatePageSize(value);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        // color: AppColors.bgColor,
        padding: const EdgeInsets.only(left: 90),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HeaderBar(screenText: 'USERS LIST'),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(right: 10, top: 5),
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
              const SizedBox(height: 25),
              //THIS IS THE MAIN CONTENT
              Expanded(
                child: userListTable(),
              ),
              const SizedBox(height: 10),
              paginationControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget userListTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
          width: 0.1,
          style: BorderStyle.solid,
        ),
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Consumer<UserProvider>(builder: (context, userProvider, _) {
        if (userProvider.currentUsers.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.loadingColor,
            ),
          );
        } else {
          List<AllUserData> userRows = userProvider.currentUsers;

          return ScrollBarWidget(
            child: DataTableTheme(
              data: const DataTableThemeData(
                dividerThickness: 0.1,
              ),
              child: DataTable(
                columnSpacing: 40,
                border: TableBorder.all(width: 0.1, color: Colors.black54.withOpacity(0.5)),
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.black54.withOpacity(0.2),
                ),
                headingRowHeight: 50,
                dataRowMinHeight: 30,
                dataRowMaxHeight: 50,
                dataTextStyle: TextStyles.dataTextStyle,
                columns: getColumns(userAccessColumns),
                rows: userRows.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final AllUserData userManagement = entry.value;
                  final Color color = index % 2 == 0 ? Colors.transparent : Colors.white;

                  return DataRow(
                    color: MaterialStateProperty.all(color),
                    cells: [
                      DataCell(Text(userManagement.hcisId ?? '')),
                      DataCell(Text(userManagement.role ?? '')),
                      DataCell(Text(userManagement.username ?? '')),
                      DataCell(Text(userManagement.lastName ?? '')),
                      DataCell(Text(userManagement.firstName ?? '')),
                      DataCell(Text(userManagement.middleName ?? '')),
                      DataCell(Text(userManagement.contact ?? '')),
                      DataCell(Text(userManagement.email ?? '')),
                      DataCell(Text(userManagement.position ?? '')),
                      DataCell(Text(userManagement.institution ?? '')),
                      DataCell(Text(userManagement.status ?? '')),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        }
      }),
    );
  }

  Widget paginationControls() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        bool isFirstPage = userProvider.currentPage == 0;
        bool isLastPage = userProvider.currentPage == userProvider.totalPages - 1;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: !isFirstPage ? AppColors.ngoColor : Colors.grey.shade400,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 12,
                ),
                color: Colors.white,
                onPressed: !isFirstPage ? userProvider.previousPage : null,
              ),
            ),
            const SizedBox(width: 30),
            Column(
              children: [
                Consumer<UserProvider>(
                  builder: (context, userProvider, _) {
                    return Text(
                      'PAGE ${userProvider.currentPage + 1} OF ${userProvider.totalPages}',
                      style: const TextStyle(
                        fontFamily: 'RobotoThin',
                        fontSize: 10,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    );
                  },
                ),
                Consumer<UserProvider>(
                  builder: (context, userProvider, _) {
                    return Text(
                      'Total Number of Clients: ${userProvider.totalRecords}',
                      style: const TextStyle(
                        fontFamily: 'RobotoThin',
                        fontSize: 10,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(width: 30),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: !isLastPage ? AppColors.ngoColor : Colors.grey.shade400,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: IconButton(
                color: Colors.white,
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                ),
                onPressed: !isLastPage ? userProvider.nextPage : null,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget rowShowList() {
    return Row(
      children: [
        const Text(
          'Show',
          style: TextStyle(fontFamily: 'RobotoThin', color: Colors.black54, fontSize: 12),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 35,
          height: 30,
          child: TextField(
            style: const TextStyle(fontFamily: 'RobotoThin', fontSize: 11, color: Colors.black54),
            controller: rowsPerPageController,
            textAlignVertical: TextAlignVertical.top,
            cursorColor: AppColors.ngoColor,
            cursorWidth: 1,
            cursorRadius: const Radius.circular(5),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
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
              hintText: rowsPerPageController.text,
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
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
            color: AppColors.ngoColor,
          ),
          child: PopupMenuButton<int>(
            splashRadius: 20,
            icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.white),
            onSelected: _updatePageSize,
            itemBuilder: (BuildContext context) {
              return [10, 20, 30, 40, 50].map((int value) {
                return PopupMenuItem<int>(
                  height: 20,
                  value: value,
                  child: Center(
                    child: Text(
                      value.toString(),
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
          width: 40,
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
                // _initializeData();
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
          margin: EdgeInsets.only(left: 10),
          height: 30,
          width: 100, // Adjust the width as needed
          decoration: const BoxDecoration(
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
