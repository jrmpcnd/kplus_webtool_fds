import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';

class ShowListWidget extends StatelessWidget {
  final TextEditingController rowsPerPageController;
  final String rowsPerPage;
  final Function(int) onPageSizeChange;

  const ShowListWidget({
    Key? key,
    required this.rowsPerPageController,
    required this.rowsPerPage,
    required this.onPageSizeChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Show',
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 35,
          height: 30,
          child: TextField(
            style: const TextStyle(fontSize: 11, color: Colors.black54),
            controller: rowsPerPageController,
            textAlignVertical: TextAlignVertical.top,
            cursorColor: AppColors.maroon2,
            cursorWidth: 1,
            cursorRadius: const Radius.circular(5),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              filled: true,
              fillColor: Colors.transparent,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.maroon2,
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
                  color: AppColors.maroon2,
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
                  color: AppColors.maroon2,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              hintText: rowsPerPage,
              hintStyle: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
            readOnly: true,
          ),
        ),
        Container(
          height: 30,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
              right: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
              bottom: BorderSide(color: AppColors.maroon2, width: 0.1, style: BorderStyle.solid),
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
            color: AppColors.maroon2,
          ),
          child: PopupMenuButton<int>(
            splashRadius: 20,
            icon: const Icon(Icons.arrow_drop_down_outlined, size: 15, color: Colors.white),
            onSelected: onPageSizeChange,
            itemBuilder: (BuildContext context) {
              return [10, 20, 30, 40, 50].map((int value) {
                return PopupMenuItem<int>(
                  height: 20,
                  value: value,
                  child: Center(
                    child: Text(
                      value.toString(),
                      style: const TextStyle(
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
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }
}
