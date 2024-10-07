import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../../../core/models/user_management/roles_model.dart';
import '../../../../../core/provider/timer_service_provider.dart';
import '../../../../../core/service/role_api.dart';
import '../../../../../core/service/url_getter_setter.dart';
import '../../../../shared/clock/clock.dart';
import '../../../../shared/formatters/formatter.dart';
import '../../../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/values/styles.dart';
import '../../../../shared/widget/alert_dialog/alert_dialogs.dart';
import '../../../../shared/widget/buttons/button.dart';
import '../../../../shared/widget/containers/container.dart';
import '../../../../shared/widget/containers/dialog.dart';
import '../../../../shared/widget/containers/toast.dart';
import '../../../../shared/widget/fields/textformfield.dart';
import '../../../../shared/widget/scrollable/scrollable_widget.dart';
import '../screen_bases/full_screen.dart';

class AddUserRole extends StatefulWidget {
  final Function() onSuccessSubmission;
  const AddUserRole({super.key, required this.onSuccessSubmission});

  @override
  State<AddUserRole> createState() => _AddUserRoleState();
}

class _AddUserRoleState extends State<AddUserRole> {
  Timer? _timer;
  void _startTimer() {
    final timer = Provider.of<TimerProvider>(context, listen: false);
    timer.startTimer(context);
    timer.buildContext = context;
  }

  void _pauseTimer([_]) {
    _timer?.cancel();
    _startTimer();
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

  List<Dashboard> dashboards = [];
  final formKey = GlobalKey<FormState>();
  TextEditingController roleNameController = TextEditingController();
  TextEditingController roleDescriptionController = TextEditingController();
  List<Map<String, dynamic>> matrix = [];
  bool isButtonEnabled = false;
  bool roleNameHasValue = false;
  bool roleMatrixHasValue = false;

  @override
  void initState() {
    super.initState();
    fetchDashboardsAndUpdateUI();
    roleNameController.addListener(() {
      setState(() {
        roleNameHasValue = roleNameController.text.isNotEmpty;
        // isButtonEnabled = roleNameHasValue;
      });
    });
  }

  @override
  void dispose() {
    roleNameController.dispose();
    roleDescriptionController.dispose();
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

  // void handleSubmit() async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => const Center(
  //       child: SpinKitFadingCircle(color: AppColors.dialogColor),
  //     ),
  //   );
  //
  //   String baseURL = UrlGetter.getURL();
  //   String roleName = roleNameController.text;
  //   String roleDescription = roleDescriptionController.text;
  //   final token = getToken();
  //
  //   for (var dashboard in dashboards) {
  //     List<Map<String, dynamic>> accessMatrix = [];
  //     for (var access in dashboard.access) {
  //       if (access.isSelected) {
  //         // Only include checked items
  //         Map<String, dynamic> accessEntry = {
  //           'menu_title': access.menuTitle,
  //           'sub_menu': access.selectedSubMenus!.isNotEmpty ? access.selectedSubMenus : null,
  //         };
  //         accessMatrix.add(accessEntry);
  //         print('Access added to matrix: $accessEntry');
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
  //
  //   // Check if the matrix is empty
  //   if (matrix.isEmpty) {
  //     Navigator.pop(context); // Close the loading dialog
  //     showBlankMatrixAlertDialog(); // Show the alert dialog for blank matrix
  //     return; // Exit handleSubmit without proceeding to API call
  //   }
  //
  //   final url = Uri.parse('$baseURL/add/role');
  //   final Map<String, dynamic> requestBody = {
  //     'title': roleName,
  //     'description': roleDescription,
  //     'matrix': matrix,
  //   };
  //
  //   final response = await http.post(
  //     url,
  //     headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'},
  //     body: jsonEncode(requestBody),
  //   );
  //
  //   Navigator.pop(context);
  //
  //   if (response.statusCode == 200) {
  //     showRoleAlertDialog(isSuccess: true);
  //   } else {
  //     showRoleAlertDialog(isSuccess: false);
  //   }
  //
  //   // Re-enable the button after submission
  //   setState(() {
  //     isButtonEnabled = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size screenWidth = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Listener(
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
                    'ADD USER ROLE',
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
                          Form(
                            key: formKey,
                            child: Wrap(
                              spacing: 50,
                              runSpacing: 20,
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
                                        validator: (value) {
                                          if (value == null && value!.isEmpty) {
                                            return "Kindly input a role name.";
                                          }
                                          return null;
                                        },
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
                                        controller: roleDescriptionController,
                                        validator: (value) {
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(50.0, 20, 50, 20),
                            child: ScrollableWidget(
                              // scrollDirection: Axis.horizontal,
                              child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //TITLE ROW
                                    Wrap(
                                      spacing: 10,
                                      children: dashboards.map((category) {
                                        return Wrap(
                                          spacing: 10,
                                          children: [
                                            _buildCategoryManagementContainer(category.dashboardTitle),
                                            // const SizedBox(width: 10),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 5),
                                    //LIST ROW
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Wrap(
                                        spacing: 10,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
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
                                                child: Wrap(
                                                  spacing: 10,
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    _buildManagementContainer(category.access),
                                                    // const SizedBox(width: 10),
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
                      CustomColoredButton.primaryButtonWithText(context, 5, () => checkRoleFields(), AppColors.ngoColor, "ADD"),
                    ],
                  ),
                )
              ],
            ),
          ),
          screenText: 'ADD ROLE',
          children: const [Spacer(), Clock()],
        )),
      ),
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

  void checkRoleFields() {
    // Clear the matrix before adding elements
    matrix.clear();

    if (roleNameController.text.isEmpty) {
      showBlankRoleNameAlertDialog();
    } else {
      // Add elements to the matrix
      addElementsToMatrix();

      if (matrix.isEmpty) {
        showBlankMatrixAlertDialog();
      } else {
        isButtonEnabled = true;
        // If matrix is not empty, proceed with adding the role
        if (isButtonEnabled && roleNameHasValue) {
          showAddRoleAlertDialog(context);
        }
      }
    }
  }

  void handleSubmit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitFadingCircle(color: AppColors.dialogColor),
      ),
    );

    // Add elements to the matrix
    await addElementsToMatrix();

    // Check if the matrix is empty
    if (matrix.isEmpty) {
      Navigator.pop(context); // Close the loading dialog
      showBlankMatrixAlertDialog(); // Show the alert dialog for blank matrix
      return; // Exit handleSubmit without proceeding to API call
    }

    // Proceed with calling the API
    String baseURL = UrlGetter.getURL();
    String roleName = roleNameController.text;
    String roleDescription = roleDescriptionController.text;
    final token = getToken();

    final url = Uri.parse('$baseURL/role/test/create/new');
    final Map<String, dynamic> requestBody = {
      'title': roleName,
      'description': roleDescription,
      'matrix': matrix,
    };

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'},
      body: jsonEncode(requestBody),
    );

    Navigator.pop(context);

    if (response.statusCode == 200) {
      showRoleAlertDialog(isSuccess: true);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      showGeneralErrorAlertDialog(context, errorMessage);
    }

    // Re-enable the button after submission
    setState(() {
      isButtonEnabled = false;
    });
  }

  Future<void> addElementsToMatrix() async {
    for (var dashboard in dashboards) {
      List<Map<String, dynamic>> accessMatrix = [];
      for (var access in dashboard.access) {
        if (access.isSelected) {
          // Only include checked items
          Map<String, dynamic> accessEntry = {
            'menu_title': access.menuTitle,
            'sub_menu': access.selectedSubMenus!.isNotEmpty ? access.selectedSubMenus : null,
          };
          accessMatrix.add(accessEntry);
        }
      }
      if (accessMatrix.isNotEmpty) {
        // Only include dashboard if there are checked items
        matrix.add({
          'dashboard': dashboard.dashboardTitle,
          'access': accessMatrix,
        });
      }
    }
  }

  void showAddRoleAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Adding New Role",
        contentText: "A new role will be added to the records.",
        positiveButtonText: "Proceed",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          setState(() {
            handleSubmit();
            Navigator.of(context).pop();
          });
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  void showRoleAlertDialog({required bool isSuccess}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        titleText: isSuccess ? "Successfully Added" : "Failed to Add",
        contentText: isSuccess ? "A new role was added successfully." : "Sorry! A new role failed to be added.",
        positiveButtonText: isSuccess ? "Done" : "Retry",
        positiveOnPressed: () {
          if (isSuccess) {
            widget.onSuccessSubmission();
            Navigator.pop(context);
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
