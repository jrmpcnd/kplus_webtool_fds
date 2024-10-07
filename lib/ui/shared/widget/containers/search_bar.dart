import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';

import '../../values/styles.dart';

class DynamicSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final double searchWidth;
  final double searchHeight;
  final double radius;
  final Color? color;
  final String? hintText;

  const DynamicSearchBar({
    Key? key,
    required this.controller,
    this.onChanged,
    required this.searchWidth,
    required this.searchHeight,
    required this.radius,
    required this.color,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: searchWidth,
      height: searchHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.maroon2, width: 1, style: BorderStyle.solid),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Center(
        child: TextField(
          cursorColor: AppColors.maroon2,
          cursorWidth: 1,
          style: TextStyles.normal12Black,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: const Icon(Iconsax.search_normal_1_copy, color: Colors.blueGrey, size: 15),
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 5.0), // Adjust padding as needed
            isDense: true, // Reduce the height of the TextField
            suffixIcon: IconButton(
              padding: const EdgeInsets.only(bottom: 10, top: 4),
              onPressed: () {
                controller.clear();
                onChanged!('');
              },
              icon: const Icon(Icons.clear, color: Colors.blueGrey, size: 15),
            ),
          ),
        ),
      ),
    );

    // return Container(
    //   width: searchWidth,
    //   height: searchHeight,
    //   decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius), border: Border.all(color: AppColors.maroon2, width: 1, style: BorderStyle.solid)),
    //   padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
    //   child: Center(
    //     child: TextField(
    //       cursorColor: AppColors.maroon2,
    //       cursorWidth: 1,
    //       style: TextStyles.normal12Black,
    //       controller: controller,
    //       onChanged: onChanged,
    //       decoration: InputDecoration(
    //         icon: const Icon(Icons.search_rounded, color: Colors.blueGrey, size: 15),
    //         // contentPadding: EdgeInsets.zero,
    //         hintText: 'Search by file name',
    //         border: InputBorder.none,
    //         suffixIcon: IconButton(
    //           alignment: Alignment.centerRight,
    //           onPressed: () {
    //             controller.clear();
    //             onChanged!('');
    //           },
    //           icon: const Icon(Icons.clear, color: Colors.blueGrey, size: 15),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class DynamicSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final double searchWidth;
  final double searchHeight;
  final double radius;
  final Color? color;
  final String? hintText;
  final IconData icon;
  final Color borderColor;
  final Color iconColor;
  final double iconSize;

  const DynamicSearchBarWidget({
    Key? key,
    required this.controller,
    this.onChanged,
    required this.searchWidth,
    required this.searchHeight,
    required this.radius,
    required this.color,
    this.hintText,
    required this.icon,
    required this.borderColor,
    required this.iconColor,
    required this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: searchWidth,
      height: searchHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: 1, style: BorderStyle.solid),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Center(
        child: TextField(
          cursorColor: Colors.grey,
          cursorWidth: 1,
          style: TextStyles.bold14Black,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: iconColor, size: iconSize),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 9.0,
            ), // Adjust padding as needed
            isDense: true, // Reduce the height of the TextField
          ),
        ),
      ),
    );
  }
}
