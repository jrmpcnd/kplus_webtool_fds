import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/role_provider.dart';
import '../values/colors.dart';
import '../values/styles.dart';

class MenuHelper {
  // Singleton instance
  static final MenuHelper _instance = MenuHelper._internal();

  factory MenuHelper() {
    return _instance;
  }

  MenuHelper._internal();

  static void handleMenuOrSubMenuClick(BuildContext context, String name, List<String> allowedMenuItems, List<String> allowedSubmenuItems, String? selectedMenuOrSubMenuName, [String? subMenuName, Function()? setStateCallback]) {
    // Check if the clicked submenu name or name matches the allowed items
    final screenRestrictionProvider = Provider.of<ScreenRestrictionByRole>(context, listen: false);

    // Access allowed menu and submenu items
    final allowedMenuItems = screenRestrictionProvider.allowedMenuItems;
    final allowedSubmenuItems = screenRestrictionProvider.allowedSubmenuItems;

    bool isAllowed = isMenuItemAllowed(name, allowedMenuItems, allowedSubmenuItems, subMenuName);

    if (isAllowed) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide any existing snack bar
      setStateCallback?.call(); // Call the provided callback to trigger a state update
    } else {
      debugPrint('Clicked menu or submenu is not allowed');
      menuIsNotAllowedSnackBar(context, selectedMenuOrSubMenuName!);
      // Display a message or perform another action if the item is not allowed
    }
  }

  static bool isMenuItemAllowed(String name, List<String> allowedMenuItems, List<String> allowedSubmenuItems, [String? subMenuName]) {
    // Check if the clicked menu or submenu name matches the allowed items
    if (subMenuName != null) {
      // Check if the submenu name is allowed
      bool isAllowed = allowedSubmenuItems.contains(subMenuName);
      if (!isAllowed) {
        debugPrint('Submenu "$subMenuName" is not allowed');
      }
      return isAllowed;
    } else {
      // Check if the menu name is allowed
      bool isAllowed = allowedMenuItems.contains(name);
      if (!isAllowed) {
        debugPrint('Menu "$name" is not allowed');
      }
      return isAllowed;
    }
  }

  static void menuIsNotAllowedSnackBar(BuildContext context, String menuTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AppColors.toastColor.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: AppColors.maroon3.withOpacity(0.2),
            ),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.warning_amber,
              color: Colors.amber,
              size: 30,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Unauthorized Screen Access", style: TextStyles.headingTextStyle),
                Text('You do not have permission to access the $menuTitle page.', style: TextStyles.dataTextStyle),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        width: 600,
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.endToStart,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// bool isMenuItemAllowed(BuildContext context, String name, List<String> allowedMenuItems, List<String> allowedSubmenuItems, [String? subMenuName, Function()? disableWidget]) {
//   // Check if the clicked menu or submenu name matches the allowed items
//   if (subMenuName != null) {
//     // Check if the submenu name is allowed
//     bool isAllowed = allowedSubmenuItems.contains(subMenuName);
//     if (!isAllowed) {
//       debugPrint('Submenu "$subMenuName" is not allowed');
//       menuIsNotAllowedSnackBar(context, subMenuName);
//       disableWidget?.call();
//     }
//     return isAllowed;
//   } else {
//     // Check if the menu name is allowed
//     bool isAllowed = allowedMenuItems.contains(name);
//     if (!isAllowed) {
//       debugPrint('Menu "$name" is not allowed');
//       menuIsNotAllowedSnackBar(context, name);
//       disableWidget?.call();
//     }
//     return isAllowed;
//   }
// }
//
// void menuIsNotAllowedSnackBar(BuildContext context, String menuTitle) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Container(
//         padding: const EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//           color: AppColors.toastColor.withOpacity(0.2),
//           borderRadius: const BorderRadius.all(Radius.circular(10)),
//           border: Border.all(
//             color: AppColors.maroon3.withOpacity(0.2),
//           ),
//         ),
//         child: ListTile(
//           leading: const Icon(
//             Icons.warning_amber,
//             color: Colors.amber,
//             size: 30,
//           ),
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("Unauthorized Screen Access", style: TextStyles.headingTextStyle),
//               Text('You do not have permission to access the $menuTitle page.', style: TextStyles.dataTextStyle),
//             ],
//           ),
//         ),
//       ),
//       backgroundColor: Colors.transparent,
//       behavior: SnackBarBehavior.floating,
//       width: 600,
//       duration: const Duration(seconds: 1),
//       dismissDirection: DismissDirection.endToStart,
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//     ),
//   );
// }
