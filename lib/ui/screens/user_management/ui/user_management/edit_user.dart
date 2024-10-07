import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/calendar/date_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../core/models/user_management/code_model.dart';
import '../../../../../core/models/user_management/roles_model.dart';
import '../../../../../core/models/user_management/user_model.dart';
import '../../../../../core/provider/code/code_provider.dart';
import '../../../../../core/provider/role_provider.dart';
import '../../../../../core/provider/timer_service_provider.dart';
import '../../../../../core/provider/user_provider.dart';
import '../../../../../core/service/url_getter_setter.dart';
import '../../../../../core/service/user_api.dart';
import '../../../../shared/formatters/formatter.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/values/styles.dart';
import '../../../../shared/widget/alert_dialog/alert_dialogs.dart';
import '../../../../shared/widget/buttons/button.dart';
import '../../../../shared/widget/containers/container.dart';
import '../../../../shared/widget/containers/dialog.dart';
import '../../../../shared/widget/fields/dropdown.dart';
import '../../../../shared/widget/fields/textformfield.dart';

class EditUserPage extends StatefulWidget {
  final AllUserData user;
  final Function() onSuccessSubmission;
  const EditUserPage({super.key, required this.user, required this.onSuccessSubmission});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
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

  //GENERAL INFO
  final formKey = GlobalKey<FormState>();
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

  @override
  void initState() {
    super.initState();
    initializeUserInfo();
  }

  Future<void> initializeUserInfo() async {
    UserProvider editProvider = Provider.of<UserProvider>(context, listen: false);
    mwapHcisIDcontroller.text = editProvider.mwaphcisID;
    mwapfnamecontroller.text = editProvider.mwapfname;
    mwapmnamecontroller.text = editProvider.mwapmname;
    mwaplnamecontroller.text = editProvider.mwaplname;
    mwappositioncontroller.text = editProvider.mwapposition;
    mwapemailcontroller.text = editProvider.mwapemail;
    mwapusernamecontroller.text = editProvider.mwapusername;
    mwaproleIDcontroller.text = editProvider.mwaproleID;
    mwapcontactcontroller.text = editProvider.mwapcontact;
    mwapinstiIDcontroller.text = editProvider.mwapinstiID;
    mwapbranchcontroller.text = editProvider.mwapbranch;
    mwapunitcontroller.text = editProvider.mwapunit;
    mwapcentercontroller.text = editProvider.mwapcenter;
    mwapbirthdaycontroller.text = editProvider.mwapbirthday;

    int institutionId = await getInstitutionId(editProvider.mwapinstiID);
    UpdateUser.setUpdateInstiID(institutionId);
    print('insti ${editProvider.mwapinstiID}');
    print('center ${editProvider.mwapcenter}');

    int roleId = await getRoleId(editProvider.mwaproleID);
    UpdateUser.setUpdateRoleID(roleId);
    print('store in provider role== ${editProvider.mwaproleID}');
  }

  Future<int> getInstitutionId(String institutionName) async {
    CodeProvider institutionProvider = Provider.of<CodeProvider>(context, listen: false);
    await institutionProvider.fetchAllInsti();

    List<InstitutionData> institutionsList = institutionProvider.institution;
    for (InstitutionData institution in institutionsList) {
      if (institution.institution == institutionName) {
        return institution.id;
      }
    }
    return 0;
  }

  Future<int> getRoleId(String roleTitle) async {
    UserRoleProvider roleProvider = Provider.of<UserRoleProvider>(context, listen: false);
    await roleProvider.fetchAllRoles();

    List<Role> rolesList = roleProvider.userRoles;
    for (Role role in rolesList) {
      if (role.roleTitle == roleTitle) {
        return role.id;
      }
    }
    return 0;
  }

  // Future<String> getCenterCode(String centerCode) async {
  //   CodeProvider centerProvider = Provider.of<CodeProvider>(context, listen: false);
  //   await centerProvider.fetchAllCenter();
  //
  //   List<CenterCodeData> centersList = centerProvider.centers;
  //   for (CenterCodeData center in centersList) {
  //     if (center.centerCode == centerCode) {
  //       return center.description;
  //     }
  //   }
  //   return '';
  // }

  @override
  void dispose() {
    super.dispose();
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
  }

  @override
  Widget build(BuildContext context) {
    Size screenWidth = MediaQuery.of(context).size;
    return Listener(
      behavior: HitTestBehavior.opaque,
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
          child: const Text('Edit A User', style: TextStyles.bold18White),
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
                                          const Expanded(flex: 2, child: Text('Institution')),
                                          Expanded(
                                              flex: 3,
                                              child: TextFormFieldWidget(
                                                contentPadding: 8,
                                                borderRadius: 3,
                                                enabled: false,
                                                controller: mwapinstiIDcontroller,
                                                // onChanged: (value) {
                                                //   setState(() {
                                                //    AddnewUsers.setFirstname(value);
                                                //   });
                                                // },
                                              )),
                                          // Expanded(
                                          //   flex: 3,
                                          //   child: Consumer<CodeProvider>(
                                          //     builder: (context, instiProvider, _) {
                                          //       if (instiProvider.institution.isEmpty) {
                                          //         instiProvider.fetchAllInsti();
                                          //         return Container();
                                          //       } else {
                                          //         List<String> instiTitles = instiProvider.institution.map((insti) => insti.institution).toList();
                                          //         return DropdownWidget(
                                          //           hintText: '--Select Institution--',
                                          //           contentPadding: 5,
                                          //           borderRadius: 3,
                                          //           controller: mwapinstiIDcontroller,
                                          //           validator: (value) {},
                                          //           onChanged: (String? newValue) {
                                          //             setState(() {
                                          //               if (newValue != null) {
                                          //                 InstitutionData? selectedInsti;
                                          //                 try {
                                          //                   selectedInsti = instiProvider.institution.firstWhere(
                                          //                     (insti) => insti.institution == newValue,
                                          //                   );
                                          //                 } catch (e) {
                                          //                   debugPrint('Error: $e');
                                          //                 }
                                          //                 if (selectedInsti != null) {
                                          //                   int institutionId = selectedInsti.id;
                                          //                   mwapinstiIDcontroller.text = newValue;
                                          //                   UpdateUser.setUpdateInstiID(institutionId);
                                          //                   UpdateUser.setUpdateNewInstitution(newValue);
                                          //                 }
                                          //               } else {
                                          //                 int existingID = UpdateUser.getUpdateInstiID();
                                          //                 mwapinstiIDcontroller.text = UpdateUser.getUpdateNewInstitution();
                                          //                 UpdateUser.setUpdateInstiID(existingID);
                                          //               }
                                          //             });
                                          //           },
                                          //           items: instiTitles,
                                          //         );
                                          //       }
                                          //     },
                                          //   ),
                                          // ),
                                        ]),
                                        const SizedBox(height: 10),
                                        //FIRST NAME
                                        Row(
                                          children: [
                                            const Expanded(flex: 2, child: Text('STAFF ID')),
                                            Expanded(
                                              flex: 3,
                                              child: TextFormFieldWidget(
                                                  contentPadding: 8,
                                                  borderRadius: 3,
                                                  enabled: false,
                                                  controller: mwapHcisIDcontroller,
                                                  // onChanged: (value) {
                                                  //   setState(() {
                                                  //    AddnewUsers.setHcisID(value);
                                                  //   });
                                                  // },
                                                  validator: (value) {
                                                    setState(() {
                                                      print(value);
                                                    });
                                                  },
                                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, StaffIDFormat(), ZeroFormat()]),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        //Role
                                        Row(
                                          children: [
                                            const Expanded(flex: 2, child: Text('Access')),
                                            Expanded(
                                              flex: 3,
                                              child: Consumer<UserRoleProvider>(
                                                builder: (context, userRoleProvider, _) {
                                                  // Check if roles are fetched and available
                                                  if (userRoleProvider.userRoles.isEmpty) {
                                                    // Fetch roles if they haven't been fetched yet
                                                    userRoleProvider.fetchAllRoles();
                                                    return Container();
                                                  } else {
                                                    // Use them in the dropdown
                                                    List<String> roleTitles = userRoleProvider.userRoles.map((role) => role.roleTitle).toList();
                                                    return DropdownWidget(
                                                      hintText: '--Select User Role--',
                                                      contentPadding: 5,
                                                      borderRadius: 3,
                                                      controller: mwaproleIDcontroller,
                                                      validator: (value) {},
                                                      onChanged: (String? newValue) {
                                                        setState(() {
                                                          if (newValue != null) {
                                                            Role? selectedRole;
                                                            try {
                                                              selectedRole = userRoleProvider.userRoles.firstWhere(
                                                                (role) => role.roleTitle == newValue,
                                                              );
                                                            } catch (e) {
                                                              debugPrint('Error: $e');
                                                            }
                                                            if (selectedRole != null) {
                                                              int roleId = selectedRole.id;
                                                              mwaproleIDcontroller.text = newValue;
                                                              UpdateUser.setUpdateRoleID(roleId);
                                                              UpdateUser.setUpdateRole(newValue);
                                                            }
                                                          } else {
                                                            int existingRoleID = UpdateUser.getUpdateRoleID();
                                                            mwaproleIDcontroller.text = UpdateUser.getUpdateRole();
                                                            UpdateUser.setUpdateRoleID(existingRoleID);
                                                          }
                                                        });
                                                      },
                                                      items: roleTitles,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        //LAST NAME
                                        Row(
                                          children: [
                                            const Expanded(flex: 2, child: Text('First Name')),
                                            Expanded(
                                                flex: 3,
                                                child: TextFormFieldWidget(
                                                  contentPadding: 8,
                                                  borderRadius: 3,
                                                  // enabled: false,
                                                  controller: mwapfnamecontroller,
                                                  // onChanged: (value) {
                                                  //   setState(() {
                                                  //    AddnewUsers.setFirstname(value);
                                                  //   });
                                                  // },
                                                )),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        //EMAIL
                                        Row(
                                          children: [
                                            const Expanded(flex: 2, child: Text('Middle Name')),
                                            Expanded(
                                                flex: 3,
                                                child: TextFormFieldWidget(
                                                  contentPadding: 8,
                                                  borderRadius: 3,
                                                  // enabled: false,
                                                  controller: mwapmnamecontroller,
                                                  // onChanged: (value) {
                                                  //   setState(() {
                                                  //   AddnewUsers.setMiddleName(value);
                                                  //   });
                                                  // },
                                                )),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Expanded(flex: 2, child: Text('Last Name')),
                                            Expanded(
                                              flex: 3,
                                              child: TextFormFieldWidget(
                                                //  staffIDField: true,
                                                contentPadding: 8,
                                                borderRadius: 3,
                                                keyboardType: TextInputType.text,
                                                textInputAction: TextInputAction.next,
                                                controller: mwaplnamecontroller,
                                                // onChanged: (value) {
                                                //   setState(() {
                                                //     AddnewUsers.setLastName(value);
                                                //   });
                                                // },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        //FIRST NAME
                                        Row(
                                          children: [
                                            const Expanded(flex: 2, child: Text('Position')),
                                            Expanded(
                                                flex: 3,
                                                child: TextFormFieldWidget(
                                                  contentPadding: 8,
                                                  borderRadius: 3,
                                                  // enabled: false,
                                                  controller: mwappositioncontroller,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      AddnewUsers.setPosition(value);
                                                    });
                                                  },
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
                                    // Spacer(),

                                    Expanded(
                                      flex: 1,
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                        //STAFF ID
                                        // Tooltip(
                                        //message: 'Input the staff ID',
                                        Row(
                                          children: [
                                            const Expanded(flex: 2, child: Text('Email')),
                                            Expanded(
                                              flex: 3,
                                              child: TextFormFieldWidget(
                                                contentPadding: 8,
                                                borderRadius: 3,
                                                enabled: false,
                                                controller: mwapemailcontroller,
                                                // onChanged: (value) {
                                                //   setState(() {
                                                //   AddnewUsers.setEmail(value);
                                                //   });
                                                // },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        //LAST NAME
                                        Row(
                                          children: [
                                            const Expanded(flex: 2, child: Text('Username')),
                                            Expanded(
                                                flex: 3,
                                                child: TextFormFieldWidget(
                                                  contentPadding: 8,
                                                  borderRadius: 3,
                                                  // enabled: false,
                                                  controller: mwapusernamecontroller,
                                                  validator: (value) {
                                                    mwapusernamecontroller.text = value!;
                                                  },
                                                  // onChanged: (value) {
                                                  //   setState(() {
                                                  //     AddnewUsers.setUsername(value);
                                                  //   });
                                                  // },
                                                )),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        //EMAIL
                                        Row(
                                          children: [
                                            const Expanded(flex: 2, child: Text('Contact')),
                                            Expanded(
                                                flex: 3,
                                                child: TextFormFieldWidget(
                                                  contentPadding: 8,
                                                  borderRadius: 3,
                                                  mobileNumberField: true,
                                                  controller: mwapcontactcontroller,
                                                  // onChanged: (value){
                                                  //   setState(() {
                                                  //     AddnewUsers.setContact(value);
                                                  //   });
                                                  // },
                                                  validator: (value) {
                                                    mwapcontactcontroller.text = value!;
                                                  },
                                                  inputFormatters: [DigitInputFormatter()],
                                                )),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Expanded(flex: 2, child: Text('Branch')),
                                            Expanded(
                                                flex: 3,
                                                child: TextFormFieldWidget(
                                                  contentPadding: 8,
                                                  borderRadius: 3,
                                                  // enabled: false,
                                                  controller: mwapbranchcontroller,
                                                  // onChanged: (value){
                                                  //   setState(() {
                                                  //     AddnewUsers.setBranch(value);
                                                  //   });
                                                  // },
                                                )),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Expanded(flex: 2, child: Text('Unit')),
                                            Expanded(
                                                flex: 3,
                                                child: TextFormFieldWidget(
                                                  contentPadding: 8,
                                                  borderRadius: 3,
                                                  // enabled: false,
                                                  controller: mwapunitcontroller,
                                                  // onChanged: (value){
                                                  //   setState(() {
                                                  //     AddnewUsers.setUnit(value);
                                                  //   });
                                                  // },
                                                )),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Expanded(flex: 2, child: Text('Center:')),
                                            Expanded(
                                                flex: 3,
                                                child: TextFormFieldWidget(
                                                  contentPadding: 8,
                                                  borderRadius: 3,
                                                  // enabled: false,
                                                  controller: mwapcentercontroller,
                                                  // onChanged: (value){
                                                  //   setState(() {
                                                  //     AddnewUsers.setCenter(value);
                                                  //   });
                                                  // },
                                                )),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Expanded(flex: 2, child: Text('Birthday')),
                                            Expanded(
                                                flex: 3,
                                                child: TextFormFieldWidget(
                                                  contentPadding: 8,
                                                  borderRadius: 3,
                                                  // enabled: false,
                                                  controller: mwapbirthdaycontroller,
                                                  // onChanged: (value){
                                                  //   AddnewUsers.setBirthday(value);
                                                  // },
                                                  onTap: () {
                                                    DateTime? currentDate;
                                                    if (mwapbirthdaycontroller.text.isNotEmpty) {
                                                      currentDate = DateTime.tryParse(mwapbirthdaycontroller.text);
                                                    }
                                                    final initialDate = currentDate ?? DateTime.now(); // Use the current date if the field is empty or invalid
                                                    showModalDatePicker(context, mwapbirthdaycontroller, initialDate, 'Select Birthdate', false, () {});
                                                  },
                                                )),
                                          ],
                                        ),

                                        // const SizedBox(height: 10),
                                      ]),
                                    ),
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
                    CustomColoredButton.secondaryButtonWithText(context, 5, () => showCancelAlertDialog(context), Colors.white, "CANCEL"),
                    CustomColoredButton.primaryButtonWithText(context, 5, () => showUpdateUserAlertDialog(), AppColors.ngoColor, "SAVE"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void submitUpdateForm() async {
    int id = AddNewUser.getID();
    int instiId = UpdateUser.getUpdateInstiID();
    String hcisId = mwapHcisIDcontroller.text;
    int roleId = UpdateUser.getUpdateRoleID();
    String firstName = mwapfnamecontroller.text;
    String middleName = mwapmnamecontroller.text;
    String lastName = mwaplnamecontroller.text;
    String position = mwappositioncontroller.text;
    String email = mwapemailcontroller.text;
    String username = mwapusernamecontroller.text;
    String? contactType = 'Mobile';
    String contact = mwapcontactcontroller.text;
    String? cid = '0';
    String branch = mwapbranchcontroller.text;
    String unit = mwapunitcontroller.text;
    String center = mwapcentercontroller.text;
    String birthday = mwapbirthdaycontroller.text;

    print('From controller role $roleId');
    print('From controller insti $instiId');
    print('From controller center $center');
    print('From controller branch $branch');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitFadingCircle(color: AppColors.dialogColor),
      ),
    );

    UpdateUserAPI updateUser = UpdateUserAPI();
    // Call the API function with the retrieved data
    final response = await updateUser.updateUserInfo(
      id,
      instiId,
      hcisId,
      roleId,
      firstName,
      middleName,
      lastName,
      position,
      email,
      username,
      contactType,
      contact,
      cid,
      branch,
      unit,
      center,
      birthday,
    );

    Navigator.pop(context); // Dismiss the dialog

    if (response.statusCode == 200) {
      print('From controller role $roleId');
      print('From controller insti $instiId');
      print('From controller center $center');
      print('From controller branch $branch');
      showUserAlertDialog(isSuccess: true);
    } else {
      String errorMessage = jsonDecode(response.body)['message'];
      showGeneralErrorAlertDialog(context, errorMessage);
    }
  }

  void showUpdateUserAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Updating An Existing User",
        contentText: "The user's info will be updated in the records.",
        positiveButtonText: "Update",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          setState(() {
            Navigator.of(context).pop();
            submitUpdateForm();
          });
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
        titleText: isSuccess ? "Successfully Updated" : "Failed to Update",
        contentText: isSuccess ? "An existing user was updated successfully." : "Sorry! The user's info was not updated.",
        positiveButtonText: isSuccess ? "Done" : "Retry",
        positiveOnPressed: () {
          if (isSuccess) {
            widget.onSuccessSubmission();
            Navigator.of(context).pop();
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

//remove excess code last updated: June 21 by lea
