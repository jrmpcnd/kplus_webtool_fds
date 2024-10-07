import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../../../core/models/user_management/code_model.dart';
import '../../../../../core/models/user_management/roles_model.dart';
import '../../../../../core/provider/code/code_provider.dart';
import '../../../../../core/provider/role_provider.dart';
import '../../../../../core/provider/timer_service_provider.dart';
import '../../../../../core/provider/user_provider.dart';
import '../../../../../core/service/url_getter_setter.dart';
import '../../../../../core/service/user_api.dart';
import '../../../../../main.dart';
import '../../../../shared/formatters/formatter.dart';
import '../../../../shared/utils/utils_browser_refresh_handler.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/values/styles.dart';
import '../../../../shared/widget/alert_dialog/alert_dialogs.dart';
import '../../../../shared/widget/buttons/button.dart';
import '../../../../shared/widget/calendar/date_picker.dart';
import '../../../../shared/widget/containers/container.dart';
import '../../../../shared/widget/containers/dialog.dart';
import '../../../../shared/widget/fields/dropdown.dart';
import '../../../../shared/widget/fields/textformfield.dart';

class AddUser extends StatefulWidget {
  final Function() onSuccessSubmission;
  const AddUser({super.key, required this.onSuccessSubmission});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  //GENERAL INFO
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // TextEditingController brCodeController = TextEditingController();
  // TextEditingController unitCodeController = TextEditingController();
  // TextEditingController centerCodeController = TextEditingController();
  // TextEditingController cidController = TextEditingController();
  // TextEditingController firstNameController = TextEditingController();
  // TextEditingController middleNameController = TextEditingController();
  // TextEditingController lastNameController = TextEditingController();
  // TextEditingController mobileNumberController = TextEditingController();
  // TextEditingController staffIDController = TextEditingController();
  // TextEditingController institutionController = TextEditingController();
  // TextEditingController emailAddressController = TextEditingController();
  // TextEditingController positionController = TextEditingController();
  // TextEditingController roleAccessController = TextEditingController();
  // TextEditingController usernameController = TextEditingController();

  //mfi_whitelist_admin_portal
  TextEditingController mwapinstiIDcontroller = TextEditingController();
  TextEditingController mwapHcisIDcontroller = TextEditingController();
  TextEditingController mwaproleIDcontroller = TextEditingController();
  TextEditingController mwapfnamecontroller = TextEditingController();
  TextEditingController mwaplnamecontroller = TextEditingController();
  TextEditingController mwapmnamecontroller = TextEditingController();
  TextEditingController mwappositioncontroller = TextEditingController();
  TextEditingController mwapemailcontroller = TextEditingController();
  TextEditingController mwapusernamecontroller = TextEditingController();
  TextEditingController mwapcontactcontroller = TextEditingController();
  TextEditingController mwapbranchcontroller = TextEditingController();
  TextEditingController mwapunitcontroller = TextEditingController();
  TextEditingController mwapcentercontroller = TextEditingController();
  TextEditingController mwapbirthdaycontroller = TextEditingController();
  //

  //ADDRESS CONTROLLER
  // TextEditingController houseNumberController = TextEditingController();
  // TextEditingController streetController = TextEditingController();
  // TextEditingController barangayController = TextEditingController();
  // TextEditingController cityController = TextEditingController();
  // TextEditingController provinceController = TextEditingController();
  // TextEditingController postalController = TextEditingController();
  bool isTextFieldEnabled = false;
  bool isLoading = false;
  bool isButtonEnabled = false;

  // String instiCode = '' ;
  // String staffId = '';
  // String role = '';
  // String firstname = '';
  // String middlename = '';
  // String position = '';
  // String email = '';
  // String username = '';
  // String contact = '';
  // String branch = '';
  // String unit = '';
  // String center = '';
  // String birthday = '';
  // bool areButtonsEnabled =  ;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _startTimer();
      print('flutter=====(Time, Start!)');
    });
    super.initState();
    // staffIDController.addListener(onStaffIDChanged);

    // Adding web lifecycle listeners
    html.document.addEventListener('visibilitychange', _handleVisibilityChange);
    // debugPrint('document addEventListener called in initState of SideMenu');
  }

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

  void _handleVisibilityChange(html.Event event) {
    if (html.document.visibilityState == 'visible') {
      if (BrowserRefreshHandler.isAlertDialogShown) {
        final timer = Provider.of<TimerProvider>(navigatorKey.currentContext!, listen: false);
        timer.stop(); // Stop the timer if the alert dialog is shown
      }
    } else if (html.document.visibilityState == 'hidden') {
      if (BrowserRefreshHandler.isAlertDialogShown) {
        final timer = Provider.of<TimerProvider>(navigatorKey.currentContext!, listen: false);
        timer.stop(); // Stop the timer if the alert dialog is shown
      }
    }
  }

  void onStaffIDChanged() {
    // final staffID = staffIDController.text;
    //
    // if (staffID.length < 12) {
    //   _clearFields();
    // }
    //
    // setState(() {
    //   isTextFieldEnabled = staffID.isNotEmpty && staffID.length == 12;
    //   isButtonEnabled = isTextFieldEnabled;
    // });
    //
    // // Fetch user data when the staff ID reaches the desired length
    // if (isTextFieldEnabled) {
    //   // _fetchAndHandleUserData(context, staffID);
    // }
    // if (isTextFieldEnabled) {
    //   Provider.of<UserByStaffIDProvider>(context, listen: false).fetchUserDataByStaffID(staffID);
    //   hcisData();
    // }
  }

  void _clearFields() {
    Provider.of<UserByStaffIDProvider>(context, listen: false).clearAllData();
  }

  @override
  void dispose() {
    //date edited | june 15 2024
    // staffIDController.removeListener(onStaffIDChanged);
    // staffIDController.dispose();
    // cidController.dispose();
    // brCodeController.dispose();
    // unitCodeController.dispose();
    // centerCodeController.dispose();
    // firstNameController.dispose();
    // middleNameController.dispose();
    // lastNameController.dispose();
    // positionController.dispose();
    // emailAddressController.dispose();
    // usernameController.dispose();
    // roleAccessController.dispose();
    // mobileNumberController.dispose();
    // institutionController.dispose();

    //mfi_whitelist_admin_portal
    mwapinstiIDcontroller.dispose();
    mwaproleIDcontroller.dispose();
    mwapfnamecontroller.dispose();
    mwapmnamecontroller.dispose();
    mwaplnamecontroller.dispose();
    mwappositioncontroller.dispose();
    mwapemailcontroller.dispose();
    mwapusernamecontroller.dispose();
    mwapcontactcontroller.dispose();
    mwapbranchcontroller.dispose();
    mwapunitcontroller.dispose();
    mwapcentercontroller.dispose();
    mwapbirthdaycontroller.dispose();
    //

    // Removing web lifecycle listeners
    html.document.removeEventListener('visibilitychange', _handleVisibilityChange);
    super.dispose();
  }
  //
  // Future<void> hcisData() async {
  //   UserByStaffIDProvider staffDataFromHCIS = Provider.of<UserByStaffIDProvider>(context, listen: false);
  //   // await staffDataFromHCIS.fetchUserDataByStaffID(staffIDController.text);
  //   // Populate the text form fields with the user data
  //   // cidController.text = staffDataFromHCIS.cid;
  //   firstNameController.text = staffDataFromHCIS.fname;
  //   middleNameController.text = staffDataFromHCIS.mname;
  //   lastNameController.text = staffDataFromHCIS.lname;
  //   emailAddressController.text = staffDataFromHCIS.email;
  //   mobileNumberController.text = staffDataFromHCIS.contact;
  //
  //   final firstNameInitial = firstNameController.text.isNotEmpty ? firstNameController.text[0].toLowerCase() : '';
  //   final middleNameInitial = middleNameController.text.isNotEmpty ? middleNameController.text[0].toLowerCase() : '';
  //   final lastNameInitial = lastNameController.text.isNotEmpty ? lastNameController.text.toLowerCase() : '';
  //   const dot = '.';
  //   final initials = '$firstNameInitial$middleNameInitial$dot$lastNameInitial';
  //
  //   if (firstNameInitial == '') {
  //     usernameController.text = '';
  //   } else {
  //     usernameController.text = initials;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size screenWidth = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerHover: _pauseTimer,
        onPointerMove: _pauseTimer,
        child: AlertDialog(
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
            child: const Text('Add New User', style: TextStyles.bold18White),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(width: 15),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 500),
                  child: ContainerWidget(
                    color: Colors.white,
                    borderRadius: 5,
                    borderWidth: 1.5,
                    borderColor: AppColors.ngoColor.withOpacity(0.5),
                    width: screenWidth.width * 0.8,
                    content: Padding(
                      padding: const EdgeInsets.fromLTRB(50.0, 20, 0, 20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      //PERSONAL DETAILS - AUTOFILL
                                      Expanded(
                                        flex: 1,
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                          // INSTITUTION
                                          Row(children: [
                                            Expanded(
                                                flex: 2,
                                                child: RichText(
                                                  text: const TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Institution ',
                                                      ),
                                                      TextSpan(
                                                        text: '*',
                                                        style: TextStyle(
                                                          color: CagabayColors.Main,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            Expanded(
                                              flex: 3,
                                              child: Consumer<CodeProvider>(
                                                builder: (context, instiProvider, _) {
                                                  if (instiProvider.institution.isEmpty) {
                                                    instiProvider.fetchAllInsti();
                                                    return const TextFormFieldWidget(
                                                      hintText: 'Fetching data',
                                                      contentPadding: 8,
                                                      borderRadius: 3,
                                                    );
                                                  } else {
                                                    // Use them in the dropdown
                                                    List<String> instiTitles = instiProvider.institution.map((insti) => insti.institution).toList();
                                                    return DropdownWidget(
                                                      hintText: '--Select Institution--',
                                                      contentPadding: 5,
                                                      borderRadius: 3,
                                                      controller: mwapinstiIDcontroller,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return '';
                                                        }
                                                        return null;
                                                      },
                                                      onChanged: (String? newValue) {
                                                        setState(() {
                                                          if (newValue != null) {
                                                            InstitutionData? selectedInsti;
                                                            try {
                                                              selectedInsti = instiProvider.institution.firstWhere(
                                                                (insti) => insti.institution == newValue,
                                                              );
                                                            } catch (e) {
                                                              debugPrint('Error: $e');
                                                            }
                                                            if (selectedInsti != null) {
                                                              int institutionId = selectedInsti.id;
                                                              mwapinstiIDcontroller.text = newValue;
                                                              AddnewUsers.setInstiCode(institutionId);
                                                              debugPrint('Selected Insti ID: $institutionId');
                                                            }
                                                          }
                                                        });
                                                      },
                                                      items: instiTitles,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ]),
                                          const SizedBox(height: 10),
                                          //STAFF ID
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: RichText(
                                                    text: const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Staff ID ',
                                                        ),
                                                        TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                            color: CagabayColors.Main,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                flex: 3,
                                                child: SizedBox(
                                                  height: 28,
                                                  child: TextFormFieldWidget(
                                                      hintText: '000000-00000',
                                                      contentPadding: 8,
                                                      borderRadius: 3,
                                                      staffIDField: true,
                                                      controller: mwapHcisIDcontroller,
                                                      onSaved: (value) {
                                                        setState(() {
                                                          mwapHcisIDcontroller.text = value!;
                                                        });
                                                      },
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return '';
                                                        }
                                                        return null;
                                                      },
                                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, StaffIDFormat(), ZeroFormat()]),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          //Role
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: RichText(
                                                    text: const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Role ',
                                                        ),
                                                        TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                            color: CagabayColors.Main,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              //REMOVE EXCESS CODE : LAST UPDATED JUNE 21
                                              Expanded(
                                                flex: 3,
                                                child: Consumer<UserRoleProvider>(
                                                  builder: (context, userRoleProvider, _) {
                                                    // Check if roles are fetched and available
                                                    if (userRoleProvider.userRoles.isEmpty) {
                                                      // Fetch roles if they haven't been fetched yet
                                                      userRoleProvider.fetchAllRoles();
                                                      return const TextFormFieldWidget(
                                                        hintText: 'Fetching data',
                                                        contentPadding: 8,
                                                        borderRadius: 3,
                                                      );
                                                    } else {
                                                      // Use them in the dropdown
                                                      List<String> roleTitles = userRoleProvider.userRoles.map((role) => role.roleTitle).toList();
                                                      return DropdownWidget(
                                                        hintText: '--Select User Role--',
                                                        contentPadding: 5,
                                                        borderRadius: 3,
                                                        controller: mwaproleIDcontroller,
                                                        validator: (value) {
                                                          if (value == null || value.isEmpty) {
                                                            return '';
                                                          }
                                                          return null;
                                                        },
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            debugPrint('Role clicked in items: $newValue');
                                                            // Find the selected role by title
                                                            Role? selectedRole;
                                                            try {
                                                              selectedRole = userRoleProvider.userRoles.firstWhere(
                                                                (role) => role.roleTitle == newValue,
                                                              );
                                                            } catch (e) {
                                                              debugPrint('Error: $e');
                                                            }
                                                            if (selectedRole != null) {
                                                              // Assign the selected role's ID to a variable
                                                              int roleId = selectedRole.id;
                                                              // Update the roleAccessController with the selected role title
                                                              mwaproleIDcontroller.text = newValue!;
                                                              // Use roleId as needed, e.g., pass it to the API
                                                              AddnewUsers.setRoleId(roleId);
                                                              debugPrint('Selected Role ID: $roleId');
                                                            }
                                                            AddnewUsers.setRole(newValue!);
                                                          });
                                                        },
                                                        items: roleTitles,
                                                      );
                                                    }
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          //FIRST NAME
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: RichText(
                                                    text: const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'First Name',
                                                        ),
                                                        TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                            color: CagabayColors.Main,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 3,
                                                  child: SizedBox(
                                                    height: 28,
                                                    child: TextFormFieldWidget(
                                                      hintText: 'Juana',
                                                      contentPadding: 8,
                                                      borderRadius: 3,
                                                      // enabled: false,
                                                      controller: mwapfnamecontroller,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return '';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        setState(() {
                                                          mwapfnamecontroller.text = value!;
                                                        });
                                                      },
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          //MIDDLE NAME
                                          Row(
                                            children: [
                                              Expanded(flex: 2, child: Text('Middle Name')),
                                              Expanded(
                                                  flex: 3,
                                                  child: SizedBox(
                                                    height: 28,
                                                    child: TextFormFieldWidget(
                                                      hintText: 'Del Rosario',
                                                      contentPadding: 8,
                                                      borderRadius: 3,
                                                      // enabled: false,
                                                      controller: mwapmnamecontroller,
                                                      onSaved: (value) {
                                                        setState(() {
                                                          mwapmnamecontroller.text = value!;
                                                        });
                                                      },
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          //LAST NAME
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: RichText(
                                                    text: const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Last Name ',
                                                        ),
                                                        TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                            color: CagabayColors.Main,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                flex: 3,
                                                child: SizedBox(
                                                  height: 28,
                                                  child: TextFormFieldWidget(
                                                    hintText: 'Dela Cruz',
                                                    contentPadding: 8,
                                                    borderRadius: 3,
                                                    keyboardType: TextInputType.text,
                                                    textInputAction: TextInputAction.next,
                                                    controller: mwaplnamecontroller,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return '';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      setState(() {
                                                        mwaplnamecontroller.text = value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          //Postion
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: RichText(
                                                    text: const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Position ',
                                                        ),
                                                        TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                            color: CagabayColors.Main,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 3,
                                                  child: SizedBox(
                                                    height: 28,
                                                    child: TextFormFieldWidget(
                                                      hintText: 'MFI Staff/Officer',
                                                      contentPadding: 8,
                                                      borderRadius: 3,
                                                      // enabled: false,
                                                      controller: mwappositioncontroller,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return '';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        setState(() {
                                                          mwappositioncontroller.text = value!;
                                                        });
                                                      },
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          //MIDDLE NAME

                                          // const SizedBox(height: 10),
                                        ]),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 70, right: 70),
                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                          //Email
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: RichText(
                                                    text: const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Email ',
                                                        ),
                                                        TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                            color: CagabayColors.Main,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                flex: 3,
                                                child: SizedBox(
                                                  height: 28,
                                                  child: TextFormFieldWidget(
                                                    hintText: 'juana.delacruz@gmail.com',
                                                    contentPadding: 8,
                                                    borderRadius: 3,
                                                    // enabled: false,
                                                    controller: mwapemailcontroller,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return '';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      setState(() {
                                                        mwapemailcontroller.text = value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          //USERNAME
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: RichText(
                                                    text: const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Username ',
                                                        ),
                                                        TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                            color: CagabayColors.Main,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 3,
                                                  child: SizedBox(
                                                    height: 28,
                                                    child: TextFormFieldWidget(
                                                      hintText: 'Juana',
                                                      contentPadding: 8,
                                                      borderRadius: 3,
                                                      // enabled: false,
                                                      controller: mwapusernamecontroller,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return '';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        setState(() {
                                                          mwapusernamecontroller.text = value!;
                                                        });
                                                      },
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          //CONTACT
                                          Row(
                                            children: [
                                              const Expanded(flex: 2, child: Text('Contact')),
                                              Expanded(
                                                  flex: 3,
                                                  child: SizedBox(
                                                    height: 28,
                                                    child: TextFormFieldWidget(
                                                      contentPadding: 8,
                                                      borderRadius: 3,
                                                      mobileNumberField: true,
                                                      controller: mwapcontactcontroller,
                                                      validator: (value) {
                                                        if (mwapcontactcontroller.text.length != 11) {
                                                          return '';
                                                        }
                                                      },
                                                      onSaved: (value) {
                                                        setState(() {
                                                          mwapcontactcontroller.text = value!;
                                                        });
                                                      },
                                                      inputFormatters: [DigitInputFormatter()],
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: RichText(
                                                    text: const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Branch ',
                                                        ),
                                                        TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                            color: CagabayColors.Main,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 3,
                                                  child: SizedBox(
                                                    height: 28,
                                                    child: TextFormFieldWidget(
                                                      hintText: 'CMDI',
                                                      contentPadding: 8,
                                                      borderRadius: 3,
                                                      // enabled: false,
                                                      controller: mwapbranchcontroller,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return '';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        setState(() {
                                                          mwapbranchcontroller.text = value!;
                                                        });
                                                      },
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              //date edited | june 20
                                              // const Expanded(flex: 2, child: Text('Unit:')),
                                              Expanded(
                                                  flex: 2,
                                                  child: RichText(
                                                    text: const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Unit ',
                                                        ),
                                                        TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                            color: CagabayColors.Main,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 3,
                                                  child: SizedBox(
                                                    height: 28,
                                                    child: TextFormFieldWidget(
                                                      hintText: 'CFI',
                                                      contentPadding: 8,
                                                      borderRadius: 3,
                                                      // enabled: false,
                                                      controller: mwapunitcontroller,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return '';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        setState(() {
                                                          mwapunitcontroller.text = value!;
                                                        });
                                                      },
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              // date edited | june 20
                                              // const Expanded(flex: 2, child: Text('Center:')),
                                              //date added | june 20
                                              Expanded(
                                                  flex: 2,
                                                  child: RichText(
                                                    text: const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Center ',
                                                        ),
                                                        TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                            color: CagabayColors.Main,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 3,
                                                  child: SizedBox(
                                                    height: 28,
                                                    child: TextFormFieldWidget(
                                                      hintText: 'CMDI',
                                                      contentPadding: 8,
                                                      borderRadius: 3,
                                                      // enabled: false,
                                                      controller: mwapcentercontroller,
                                                      validator: (value) {
                                                        if (value == null || value!.isEmpty) {
                                                          return '';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        setState(() {
                                                          mwapcentercontroller.text = value!;
                                                        });
                                                      },
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              //date edited | june 20
                                              // const Expanded(flex: 2, child: Text('Birthday:')),
                                              //date added | june 20
                                              Expanded(
                                                  flex: 2,
                                                  child: RichText(
                                                    text: const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Birthday ',
                                                        ),
                                                        TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                            color: CagabayColors.Main,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 3,
                                                  child: SizedBox(
                                                    height: 28,
                                                    child: TextFormFieldWidget(
                                                      hintText: 'yyyy-mm-dd',
                                                      contentPadding: 8,
                                                      borderRadius: 3,
                                                      // enabled: false,
                                                      controller: mwapbirthdaycontroller,
                                                      validator: (value) {
                                                        if (value == null || value!.isEmpty) {
                                                          return '';
                                                        }
                                                        return null;
                                                      },
                                                      onTap: () {
                                                        DateTime? currentDate;
                                                        if (mwapbirthdaycontroller.text.isNotEmpty) {
                                                          currentDate = DateTime.tryParse(mwapbirthdaycontroller.text);
                                                        }
                                                        final initialDate = currentDate ?? DateTime.now(); // Use the current date if the field is empty or invalid
                                                        showModalDatePicker(context, mwapbirthdaycontroller, initialDate, 'Select Birthdate', false, () {});
                                                      },
                                                      // inputFormatters: [BirthdayInputFormatter()],
                                                      onSaved: (value) {
                                                        setState(() {
                                                          mwapbirthdaycontroller.text = value!;
                                                        });
                                                      },
                                                    ),
                                                  )),
                                            ],
                                          ),

                                          // const SizedBox(height: 10),
                                        ]),
                                      ),
                                      //Remove excess code : updated by lea - June 21
                                      Container(
                                        margin: const EdgeInsets.only(right: 70),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomColoredButton.secondaryButtonWithText(context, 5, () => cancelFunction(), Colors.white, "CANCEL"),
                      CustomColoredButton.primaryButtonWithText(context, 5, () => validateField(), AppColors.ngoColor, "ADD"),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> getEmptyFields() {
    List<String> emptyFields = [];

    if (mwaproleIDcontroller.text.isEmpty) emptyFields.add('Role');
    if (mwapinstiIDcontroller.text.isEmpty) emptyFields.add('Institution');
    if (mwapHcisIDcontroller.text.isEmpty) emptyFields.add('Staff ID');
    if (mwapfnamecontroller.text.isEmpty) emptyFields.add('First Name');
    if (mwaplnamecontroller.text.isEmpty) emptyFields.add('Last Name');
    if (mwapemailcontroller.text.isEmpty) emptyFields.add('Email');
    if (mwapusernamecontroller.text.isEmpty) emptyFields.add('Username');
    if (mwapbirthdaycontroller.text.isEmpty) emptyFields.add('Birthday');
    if (mwappositioncontroller.text.isEmpty) emptyFields.add('Position');
    if (mwapbranchcontroller.text.isEmpty) emptyFields.add('Branch');
    if (mwapunitcontroller.text.isEmpty) emptyFields.add('Unit');
    if (mwapcentercontroller.text.isEmpty) emptyFields.add('Center');

    return emptyFields;
  }

  void validateField() {
    formKey.currentState!.validate();
    List<String> emptyFields = getEmptyFields();

    if (emptyFields.isNotEmpty) {
      showRequiredFieldsAlertDialog(context);
    } else {
      showAddUserAlertDialog(context);
    }
  }

  bool allFieldsAreEmpty() {
    return mwaproleIDcontroller.text.isEmpty && mwapinstiIDcontroller.text.isEmpty && mwapHcisIDcontroller.text.isEmpty && mwapfnamecontroller.text.isEmpty && mwaplnamecontroller.text.isEmpty && mwapemailcontroller.text.isEmpty && mwapusernamecontroller.text.isEmpty && mwapbirthdaycontroller.text.isEmpty && mwappositioncontroller.text.isEmpty && mwapbranchcontroller.text.isEmpty && mwapunitcontroller.text.isEmpty && mwapcentercontroller.text.isEmpty;
  }

  void cancelFunction() {
    formKey.currentState!.validate();

    if (allFieldsAreEmpty()) {
      Navigator.pop(context);
    } else {
      showCancelAlertDialog(context);
    }
  }

  void submitForm() async {
    //mfi_whitelist_admin_portal

    int instiId = AddnewUsers.getInstiCode();
    String hcisId = mwapHcisIDcontroller.text;
    int roleId = AddnewUsers.getRoleId();
    String firstName = mwapfnamecontroller.text;
    String middleName = mwapmnamecontroller.text;
    String lastName = mwaplnamecontroller.text;
    String position = mwappositioncontroller.text;
    String email = mwapemailcontroller.text;
    String username = mwapusernamecontroller.text;
    String contact = mwapcontactcontroller.text;
    String branch = mwapbranchcontroller.text;
    String unit = mwapunitcontroller.text;
    String center = mwapcentercontroller.text;
    String birthday = mwapbirthdaycontroller.text;
    //date edited | june 15, 2024
    String? contactType;

    print(hcisId);
    print(instiId);
    print(roleId);
    print(firstName);
    print(middleName);
    print(lastName);
    print(position);
    print(email);
    print(username);
    print(contact);
    print(branch);
    print(unit);
    print(center);
    print(birthday);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitFadingCircle(color: AppColors.dialogColor),
      ),
    );

    AddUserAPI addUserAPI = AddUserAPI();
    // Call the API function with the retrieved data
    final response = await addUserAPI.createUser(instiId, hcisId, roleId, firstName, middleName, lastName, position, email, username, contact, branch, unit, center, birthday, contactType);

    Navigator.pop(context);

    if (response.statusCode == 200) {
      showUserAlertDialog(isSuccess: true);
    } else if (response.statusCode == 400 && jsonDecode(response.body)["message"] == false) {
      String errorMessage = jsonDecode(response.body)['message'];
      showGeneralErrorAlertDialog(context, errorMessage);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      showGeneralErrorAlertDialog(context, errorMessage);
    }
  }

  void showAddUserAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Adding New User",
        contentText: "A new user will be added to the record.",
        positiveButtonText: "Proceed",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          Navigator.of(context).pop();
          submitForm();
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  void showRequiredFieldsAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Missing Information",
        contentText: "Kindly complete filling out the required info.",
        positiveButtonText: "Proceed",
        positiveOnPressed: () {
          Navigator.of(context).pop();
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
      ),
    );
  }

  void showCancelAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Confirmation",
        contentText: "This will discard all the changes made so far.",
        positiveButtonText: "Proceed",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          _clearFields();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
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
        contentText: isSuccess ? "A new user was added to the whitelist successfully." : "Sorry! Failed to add a user.",
        positiveButtonText: isSuccess ? "Done" : "Retry",
        positiveOnPressed: () {
          if (isSuccess) {
            formKey.currentState?.reset();
            _clearFields();

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

//================Date Added : 6-17 ; Lea===================//
//Remove other version
