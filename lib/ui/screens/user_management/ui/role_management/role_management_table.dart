import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/provider/role_provider.dart';
import '../../../../../core/service/role_api.dart';
import '../../../../../main.dart';
import '../../../../shared/clock/clock.dart';
import '../../../../shared/sessionmanagement/gettoken/gettoken.dart';
import '../../../../shared/utils/utils_responsive.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/values/image_path.dart';
import '../../../../shared/values/styles.dart';
import '../../../../shared/widget/buttons/button.dart';
import '../../../../shared/widget/containers/container.dart';
import '../../../../shared/widget/containers/dialog.dart';
import '../screen_bases/base_screen.dart';
import 'add_role.dart';
import 'edit_role.dart';

class RoleManagement extends StatefulWidget {
  final VoidCallback pauseTimer;
  const RoleManagement({super.key, required this.pauseTimer});

  @override
  State<RoleManagement> createState() => _RoleManagementState();
}

class _RoleManagementState extends State<RoleManagement> {
  final header = ['ACCESS ROLE', 'DESCRIPTION', 'STATUS', 'ACTION'];
  List<Map<String, dynamic>> roles = [];
  late bool isSwitched = false;
  bool isLoading = true;
  Map<int, bool> switchStatuses = {};

  @override
  void initState() {
    super.initState();
    UserRoleProvider roleRows = Provider.of<UserRoleProvider>(context, listen: false);
    roleRows.fetchAllRoles();
    refreshRoleList();
    updateUrl('/User_Management/Access_Role');
  }

  void refreshRoleList() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserRoleProvider roleRows = Provider.of<UserRoleProvider>(context, listen: false);
      roleRows.fetchAllRoles();
      final fetchedRoles = await FetchRoleAPI.fetchRoles();
      setState(() {
        roles = fetchedRoles;
        initializeSwitchStatus();
        isLoading = false;
      });
    } catch (error) {
      debugPrint('Error fetching posts data: $error');
    }
    isLoading = false;
  }

  void initializeSwitchStatus() {
    final roleProvider = Provider.of<UserRoleProvider>(context, listen: false);
    for (final role in roles) {
      final String roleIdString = role['id'].toString(); // Access 'id' of each role
      final int roleId = int.parse(roleIdString);
      final setStatus = roleProvider.getRoleStatus(roleId);
      bool switchStatus = setStatus?.toLowerCase() == 'active';
      // Store switch status for each role
      switchStatuses[roleId] = switchStatus;
    }
  }

  ///Continue to call setState as usual in your code.
  ///The overridden method ensures that setState is only called when the widget is mounted.
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenWidth = MediaQuery.of(context).size;
    return BaseScreen(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            Row(
              children: [
                const Spacer(),
                // ADD NEW ROLE BUTTON
                MyButton.buttonWithLabel(context, () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddUserRole(onSuccessSubmission: refreshRoleList))), 'Add Role', Icons.add, AppColors.maroon2),
              ],
            ),
            const Divider(),
            Center(
              child: Column(
                children: [
                  const SizedBox(width: 15),
                  ContainerWidget(
                    color: Colors.transparent,
                    borderRadius: 5,
                    borderWidth: 2,
                    borderColor: AppColors.maroon2.withOpacity(0.5),
                    width: screenWidth.width * 0.7,
                    content: HeaderRow(header: header),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                    child: ContainerWidget(
                      color: Colors.transparent,
                      borderRadius: 5,
                      borderWidth: 2,
                      borderColor: AppColors.maroon2.withOpacity(0.5),
                      width: screenWidth.width * 0.7,
                      content: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.maroon2,
                              ),
                            )
                          : roles.isEmpty
                              ? (const Center(
                                  child: Text(
                                    'NO DATA AVAILABLE',
                                    style: TextStyle(
                                      fontFamily: 'RobotoThin',
                                    ),
                                  ),
                                ))
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: roles.length,
                                  itemBuilder: (context, index) {
                                    final role = roles[index];
                                    final roleId = role['id'];
                                    final bool isSwitched = switchStatuses[roleId] ?? false;

                                    return Wrap(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          child: Row(
                                            children: [
                                              //ROLE TITLE
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin: const EdgeInsets.only(left: 20),
                                                  // color: Colors.blueGrey,
                                                  child: Text(
                                                    role['role_title'],
                                                    style: TextStyles.dataTextStyle,
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),

                                              //ROLE DESCRIPTION
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin: const EdgeInsets.only(left: 20),
                                                  child: Text(
                                                    role['role_description'],
                                                    style: TextStyles.dataTextStyle,
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),

                                              //ROLE STATUS
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.only(right: 3),
                                                      decoration: BoxDecoration(
                                                        color: role['status'] == 'Active' ? AppColors.sidePanel4 : AppColors.maroon4,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      width: 8,
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      role['status'],
                                                      style: TextStyles.dataTextStyle,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              //ROLE ACTIONS
                                              Expanded(
                                                flex: 1,
                                                child: Center(
                                                  child: Container(
                                                    // color: Colors.teal,
                                                    child: Row(
                                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          width: 20,
                                                          child: Transform.scale(
                                                            scale: 0.4,
                                                            child: Switch.adaptive(
                                                              activeColor: Colors.green.shade900,
                                                              value: isSwitched,
                                                              onChanged: (value) {
                                                                _showAlertDialog(context, value, role);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Tooltip(
                                                          message: 'Edit access',
                                                          child: InkWell(
                                                            child: Image.asset(
                                                              fit: BoxFit.fitHeight,
                                                              ImagePath.editIcon,
                                                              height: 15,
                                                              width: 15,
                                                            ),
                                                            onTap: () {
                                                              // debugPrint('Clicked Role ID: ${role['id']}, Role Title: ${role['role_title']}');
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => EditUserRole(role: role, onSuccessSubmission: refreshRoleList),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                      ],
                                    );
                                  },
                                ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      screenText: 'USER MANAGEMENT',
      children: const [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Access Role', style: TextStyles.heavyBold16Black),
            Text(
              'Manage roles with preferred configurations.',
              style: TextStyles.dataTextStyle,
              maxLines: 2,
            ),
          ],
        ),
        Spacer(),
        Responsive(desktop: Clock(), mobile: Spacer()),
      ],
    );
  }

  void _showAlertDialog(BuildContext context, bool newValue, Map<String, dynamic> role) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Listener(
        behavior: HitTestBehavior.opaque,
        onPointerHover: (_) {
          widget.pauseTimer!();
        },
        onPointerMove: (_) {
          widget.pauseTimer!();
        },
        child: AlertDialogWidget(
          titleText: "Confirmation",
          contentText: newValue ? "Are you sure you want to activate this role?" : "Are you sure you want to deactivate this role?",
          positiveButtonText: newValue ? "Activate" : "Deactivate",
          negativeButtonText: "Cancel",
          negativeOnPressed: () {
            Navigator.pop(context);
          },
          positiveOnPressed: () {
            Navigator.pop(context);
            activatedDeactivateUser(newValue, role);
            setState(() {
              switchStatuses[role['id']] = newValue; // Update the status of the switch for the specific role
            });
          },
          iconData: newValue ? Icons.info_outline : Icons.warning_amber,
          titleColor: AppColors.infoColor,
          iconColor: Colors.white,
        ),
      ),
    );
  }

  void activatedDeactivateUser(bool newValue, Map<String, dynamic> role) async {
    final roleProvider = Provider.of<UserRoleProvider>(context, listen: false);
    final String roleIdString = role['id'].toString(); // Convert 'id' to string
    final int roleId = int.parse(roleIdString); // Convert the role ID from string to integer
    final token = getToken();
    await roleProvider.setRoleStatus(roleId, token!);

    // Update the status in the UI
    setState(() {
      // Update the status of the specific role in the roles list
      final updatedRoleIndex = roles.indexWhere((r) => r['id'].toString() == roleIdString);
      if (updatedRoleIndex != -1) {
        roles[updatedRoleIndex]['status'] = newValue ? 'Active' : 'Inactive';
      }
    });
  }
}

class HeaderRow extends StatelessWidget {
  final List<String> header;

  const HeaderRow({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    double? w = MediaQuery.sizeOf(context).width;

    double fontSize = (w / 30);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: header
          .map(
            (column) => Expanded(
              flex: column == 'ACTION' ? 1 : 1,
              child: Text(
                column,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize.clamp(12, 16), color: Colors.black87),
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                maxLines: 1,
              ),
            ),
          )
          .toList(),
    );
  }
}
