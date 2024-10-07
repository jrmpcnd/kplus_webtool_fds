import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:mfi_whitelist_admin_portal/core/models/user_management/roles_model.dart';
import 'package:mfi_whitelist_admin_portal/core/service/url_getter_setter.dart';
import 'package:mfi_whitelist_admin_portal/main.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/full_screen.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/utils/utils_responsive.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/container.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/dialog.dart';
import 'package:provider/provider.dart';

import '../../../../../core/provider/timer_service_provider.dart';
import '../../../../../core/service/role_api.dart';
import '../../../../shared/clock/clock.dart';
import '../../../../shared/formatters/formatter.dart';
import '../../../../shared/values/styles.dart';
import '../../../../shared/widget/alert_dialog/alert_dialogs.dart';
import '../../../../shared/widget/buttons/button.dart';
import '../../../../shared/widget/containers/toast.dart';
import '../../../../shared/widget/fields/textformfield.dart';

class EditUserRole extends StatefulWidget {
  final Map<String, dynamic> role;
  final Function() onSuccessSubmission;
  const EditUserRole({super.key, required this.role, required this.onSuccessSubmission});

  @override
  State<EditUserRole> createState() => _EditUserRoleState();
}

class _EditUserRoleState extends State<EditUserRole> {
  Timer? _timer;
  void _startTimer() {
    final timer = Provider.of<TimerProvider>(context, listen: false);
    timer.startTimer(context);
    timer.buildContext = context;
  }

  void _pauseTimer([_]) {
    _timer?.cancel();
    _startTimer();
    // debugPrint('flutter-----(time pause!)');
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        _startTimer();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.paused:
        _pauseTimer();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  TextEditingController roleNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isLoading = true;
  List<Dashboard> dashboards = [];
  List<Map<String, dynamic>> matrix = [];
  List<Map<String, dynamic>>? roleMatrix;
  bool roleNameHasValue = false;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    roleNameController.text = widget.role['role_title'];
    descriptionController.text = widget.role['role_description'];
    fetchDashboardsAndUpdateUI();
    fetchRoleMatrix();
    roleNameHasValue = roleNameController.text.isNotEmpty;
    // isButtonEnabled = roleNameHasValue;
    roleNameController.addListener(() {
      setState(() {
        roleNameHasValue = roleNameController.text.isNotEmpty;
        // isButtonEnabled = roleNameHasValue;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchDashboardsAndUpdateUI() async {
    DisplayAccess displayAccess = DisplayAccess();
    try {
      List<Dashboard> fetchedDashboards = await displayAccess.fetchDashboards();
      // Sort the dashboards based on their id
      fetchedDashboards.sort((a, b) => a.dashboardId.compareTo(b.dashboardId));

      setState(() {
        dashboards = fetchedDashboards;
      });
    } catch (e) {
      debugPrint('Error fetching dashboards: $e');
    }
  }

  Future<void> fetchRoleMatrix() async {
    String baseURL = UrlGetter.getURL();
    final roleUrl = Uri.parse('$baseURL/role/test/access/${widget.role['role_title']}');
    final token = getToken();
    final roleResponse = await http.get(roleUrl, headers: {'Authorization': 'Bearer $token'});
    final responseData = jsonDecode(roleResponse.body);
    // debugPrint('MATRIX FROM JSON: $responseData');
    if (roleResponse.statusCode == 200) {
      var matrixData = responseData['data']['matrix'];

      setState(() {
        roleMatrix = List<Map<String, dynamic>>.from(matrixData);

        // debugPrint('ROLE MATRIX: $roleMatrix');
        // Update checkbox state based on fetched data
        updateCheckBoxesState();
      });
    } else {
      throw Exception('Failed to load role matrix');
    }
  }

  void updateCheckBoxesState() {
    for (var dashboard in dashboards) {
      var selectedAccess = roleMatrix?.firstWhere(
        (element) => element['dashboard'] == dashboard.dashboardTitle,
        orElse: () => <String, dynamic>{}, // Return an empty map
      );

      if (selectedAccess != null) {
        for (var access in dashboard.access) {
          access.isSelected = isAccessSelected(access.menuTitle, null, selectedAccess);
          access.selectedSubMenus = [];

          for (var subMenu in access.subMenus) {
            // Iterate over subMenu instead of selectedSubMenus
            if (subMenu != null) {
              if (isAccessSelected(access.menuTitle, subMenu.subMenuName, selectedAccess)) {
                access.selectedSubMenus?.add(subMenu.subMenuName ?? '');
              }
            }
          }
        }
      }
    }
  }

  bool isAccessSelected(String menuTitle, String? subMenu, Map<String, dynamic> selectedAccess) {
    if (selectedAccess.isEmpty) return false;
    final accesses = selectedAccess['access'] as List<dynamic>;
    for (var access in accesses) {
      if (access['menu_title'] == menuTitle) {
        if (subMenu == null) {
          return true;
        } else {
          final subMenus = access['sub_menu'] as List<dynamic>?;
          return subMenus != null && subMenus.contains(subMenu);
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size screenWidth = MediaQuery.of(context).size;
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerHover: _pauseTimer,
      onPointerMove: _pauseTimer,
      child: Scaffold(
          body: FullScreen(
        content: SingleChildScrollView(
          child: Column(
            children: [
              ContainerWidget(
                color: Colors.white,
                borderRadius: 5,
                borderWidth: 2,
                borderColor: AppColors.maroon2.withOpacity(0.5),
                width: screenWidth.width * 0.9,
                content: const Center(
                    child: Text(
                  'UPDATE USER ROLE',
                  style: TextStyles.heavyBold16Black,
                )),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                  child: Center(
                child: ContainerWidget(
                  color: Colors.white,
                  borderRadius: 5,
                  borderWidth: 1.5,
                  borderColor: AppColors.maroon2.withOpacity(0.5),
                  width: screenWidth.width * 0.9,
                  content: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          spacing: 50,
                          runSpacing: 20,
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.start,
                          children: [
                            Wrap(
                              spacing: 20,
                              children: [
                                const Text('Role: '),
                                Container(
                                  width: screenWidth.width * 0.2,
                                  margin: const EdgeInsets.only(right: 20),
                                  child: TextFormFieldWidget(
                                    contentPadding: 8,
                                    borderRadius: 3,
                                    enabled: true,
                                    controller: roleNameController,
                                    inputFormatters: [CamelCaseFormatter()],
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 20,
                              children: [
                                const Text('Role Description: '),
                                Container(
                                  width: screenWidth.width * 0.3,
                                  margin: const EdgeInsets.only(right: 20),
                                  child: TextFormFieldWidget(
                                    contentPadding: 8,
                                    borderRadius: 3,
                                    enabled: true,
                                    controller: descriptionController,
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50.0, 20, 50, 20),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //TITLE ROW
                                  Row(
                                    children: dashboards.map((category) {
                                      return Row(
                                        children: [
                                          _buildCategoryManagementContainer(category.dashboardTitle),
                                          const SizedBox(width: 10),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 5),
                                  //LIST ROW
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        for (final category in dashboards)
                                          GestureDetector(
                                            onTap: () {
                                              if (!roleNameHasValue) {
                                                CustomToast.show(context, 'Set a role name first');
                                              }
                                            },
                                            child: AbsorbPointer(
                                              absorbing: !roleNameHasValue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  _buildManagementContainer(category.access),
                                                  const SizedBox(width: 10),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 25, 40, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomColoredButton.secondaryButtonWithText(context, 5, () => Navigator.of(context).pop(), Colors.white, "CANCEL"),
                    CustomColoredButton.primaryButtonWithText(context, 5, () => isButtonEnabled ? showUpdateRoleAlertDialog(context) : checkRoleFields(), AppColors.ngoColor, "SAVE"),
                  ],
                ),
              )
            ],
          ),
        ),
        screenText: 'EDIT ROLE',
        children: const [
          // MyButton.buttonWithLabel(context, () => Navigator.pop(context), 'BACK', Icons.chevron_left),
          Spacer(),
          Responsive(
            desktop: Clock(),
            mobile: Spacer(),
          ),
        ],
      )),
    );
  }

  // TITLE WIDGET
  Widget _buildCategoryManagementContainer(String title) {
    Size screenWidth = MediaQuery.of(context).size;
    return ContainerWidget(
      color: Colors.white,
      borderRadius: 3,
      borderWidth: 1,
      borderColor: Colors.black54,
      width: screenWidth.width * 0.15,
      content: Text(
        title.toUpperCase(),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ACCESS LIST WIDGET
  Widget _buildManagementContainer(List<Access> accessItems) {
    Size screenWidth = MediaQuery.of(context).size;
    return ContainerWidget(
      color: Colors.white,
      borderRadius: 3,
      borderWidth: 1,
      borderColor: Colors.black54,
      width: screenWidth.width * 0.15,
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: accessItems.map((access) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                    // Menu checkbox
                    child: CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      activeColor: AppColors.ngoColor,
                      controlAffinity: ListTileControlAffinity.leading,
                      side: const BorderSide(width: 1),
                      value: access.isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          access.isSelected = value ?? false;
                          if (value != null && access.subMenus.isNotEmpty) {
                            for (SubMenu subMenu in access.subMenus) {
                              if (value) {
                                access.selectedSubMenus?.add(subMenu.subMenuName!);
                              } else {
                                access.selectedSubMenus?.remove(subMenu.subMenuName);
                              }
                            }
                          }
                        });
                      },
                      title: Text(access.menuTitle ?? '', style: TextStyles.dataTextStyle),
                    ),
                  ),
                  // Submenu checkboxes
                  if (access.subMenus.isNotEmpty)
                    Column(
                      children: access.subMenus.map((subMenu) {
                        return subMenu.subMenuId != null && subMenu.subMenuName != null && subMenu.subMenuId != 0 && subMenu.subMenuName!.isNotEmpty
                            ? SizedBox(
                                height: 35,
                                child: CheckboxListTile(
                                  activeColor: AppColors.ngoColor,
                                  side: const BorderSide(width: 1),
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  title: Text(subMenu.subMenuName!, style: TextStyles.dataTextStyle),
                                  value: access.selectedSubMenus!.contains(subMenu.subMenuName),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value!) {
                                        access.selectedSubMenus!.add(subMenu.subMenuName!);
                                        // Update the menu checkbox if any submenu is selected
                                        access.isSelected = true;
                                      } else {
                                        access.selectedSubMenus!.remove(subMenu.subMenuName!);
                                        // Update the menu checkbox if all submenus are deselected
                                        access.isSelected = access.selectedSubMenus!.isNotEmpty;
                                      }
                                    });
                                  },
                                ),
                              )
                            : Container();
                      }).toList(),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // Future<void> addElementsToMatrix() async {
  //   for (var dashboard in dashboards) {
  //     List<Map<String, dynamic>> accessMatrix = [];
  //     for (var access in dashboard.access) {
  //       if (access.isSelected) {
  //         // Only include checked items
  //         Map<String, dynamic> accessItem = {
  //           'menu_title': access.menuTitle,
  //           'sub_menu': access.selectedSubMenus!.isNotEmpty ? access.selectedSubMenus : null,
  //         };
  //         accessMatrix.add(accessItem);
  //       }
  //     }
  //     if (accessMatrix.isNotEmpty) {
  //       // Only include dashboard if there are checked items
  //       matrix.add({
  //         'dashboard': dashboard.dashboardTitle,
  //         'access': accessMatrix,
  //       });
  //     }
  //   }
  // }

  Future<void> addElementsToMatrix() async {
    matrix.clear(); // Clear matrix to avoid duplications

    for (var dashboard in dashboards) {
      List<Map<String, dynamic>> accessMatrix = [];
      for (var access in dashboard.access) {
        if (access.isSelected) {
          Map<String, dynamic> accessItem = {
            'menu_title': access.menuTitle,
            'sub_menu': access.selectedSubMenus?.isNotEmpty == true ? access.selectedSubMenus : null,
          };
          accessMatrix.add(accessItem);
        }
      }

      if (accessMatrix.isNotEmpty) {
        bool dashboardExists = matrix.any((item) => item['dashboard'] == dashboard.dashboardTitle);
        if (!dashboardExists) {
          matrix.add({
            'dashboard': dashboard.dashboardTitle,
            'access': accessMatrix,
          });
        }
      }
    }

    // print('Matrix after adding elements: $matrix'); // Debugging output
  }

  Future<void> updateRoleAccess(int roleId) async {
    // Clear the matrix before adding new elements
    matrix.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitFadingCircle(color: AppColors.dialogColor),
      ),
    );

    // Add elements to the matrix
    await addElementsToMatrix();

    // Print the matrix content before checking if it is empty
    // print('Matrix before API call: $matrix');

    // Check if the matrix is empty
    if (matrix.isEmpty) {
      Navigator.pop(navigatorKey.currentContext!); // Close the loading dialog
      showBlankMatrixAlertDialog(); // Show the alert dialog for blank matrix
      return; // Exit handleSubmit without proceeding to API call
    }

    // Proceed with calling the API
    String baseURL = UrlGetter.getURL();
    final updateUrl = Uri.parse('$baseURL/role/test/update/$roleId');
    final token = getToken();

    // Construct the payload
    final Map<String, dynamic> requestBody = {
      'title': roleNameController.text,
      'description': descriptionController.text,
      'matrix': matrix,
    };

    // Print the request body
    // print('Request Body: ${jsonEncode(requestBody)}');

    final response = await http.put(
      updateUrl,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(requestBody),
    );

    // Print the matrix content after the API call
    // print('Matrix after API call: $matrix');

    Navigator.pop(context); // Close spinkit

    if (response.statusCode == 200) {
      showUserAlertDialog(isSuccess: true);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      showGeneralErrorAlertDialog(context, errorMessage);
    }
  }

  void checkRoleFields() {
    // Clear the matrix before adding elements
    matrix.clear();

    if (roleNameController.text.isEmpty) {
      showBlankRoleNameAlertDialog();
    } else {
      // Add elements to the matrix
      addElementsToMatrix();

      if (matrix.isEmpty) {
        // debugPrint('Matrix is empty');
        isButtonEnabled = false;
        showBlankMatrixAlertDialog();
      } else {
        // debugPrint('Matrix is not empty');
        isButtonEnabled = true;
        // If matrix is not empty, proceed with adding the role

        if (isButtonEnabled && roleNameHasValue) {
          showUpdateRoleAlertDialog(context);
        }
      }
    }
  }

  void showUpdateRoleAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Update A Role",
        contentText: "A user role will be updating its access.",
        positiveButtonText: "Update",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          setState(() {
            Navigator.of(context).pop();
            updateRoleAccess(widget.role['id']);
          });
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  void showUserAlertDialog({required bool isSuccess}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        titleText: isSuccess ? "Success" : "Failed",
        contentText: isSuccess ? "The user role was updated successfully." : "Sorry! Failed to update the user role.",
        positiveButtonText: isSuccess ? "Done" : "Retry",
        positiveOnPressed: () {
          if (isSuccess) {
            Navigator.pop(context);
            // Navigator.pop(context);
            // Navigator.pushNamed(navxigatorKey.currentContext!, '/User_Management/Access_Role');
            widget.onSuccessSubmission();
          }
          Navigator.pop(context);
        },
        iconData: isSuccess ? Icons.check_circle_outline : Icons.error_outline,
        titleColor: isSuccess ? AppColors.ngoColor : AppColors.maroon2,
        iconColor: Colors.white,
      ),
    );
  }
}
