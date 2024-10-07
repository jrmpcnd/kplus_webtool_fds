import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';

class FileSelector extends StatelessWidget {
  final TextEditingController fileNameController;
  final String selectedFileName;
  final List<String> displayFileName;
  final Map<String, String> fileBatchUploadMap;
  final Function(String) onFileSelected;
  final Function() onClear;
  final Color borderColor;
  final Color fillColor;
  final Color iconColor;

  const FileSelector({
    Key? key,
    required this.fileNameController,
    required this.selectedFileName,
    required this.displayFileName,
    required this.fileBatchUploadMap,
    required this.onFileSelected,
    required this.onClear,
    this.borderColor = AppColors.maroon2,
    this.fillColor = Colors.transparent,
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: SizedBox(
            height: 35,
            child: TextField(
              style: TextStyles.dataTextStyle,
              controller: fileNameController,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: borderColor,
              cursorWidth: 1,
              cursorRadius: const Radius.circular(5),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                filled: true,
                fillColor: fillColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: borderColor,
                    width: 0.5,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: borderColor,
                    width: 0.5,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: borderColor,
                    width: 0.5,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                suffixIcon: selectedFileName.isNotEmpty
                    ? InkWell(
                        onTap: () => onClear(),
                        child: Icon(Icons.close, size: 20, color: iconColor),
                      )
                    : null,
                hintText: selectedFileName.isEmpty ? 'Select a file' : selectedFileName,
                hintStyle: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
              readOnly: true,
            ),
          ),
        ),
        Container(
          height: 35,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: borderColor, width: 0.1, style: BorderStyle.solid),
              right: BorderSide(color: borderColor, width: 0.1, style: BorderStyle.solid),
              bottom: BorderSide(color: borderColor, width: 0.1, style: BorderStyle.solid),
            ),
            borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
            color: borderColor,
          ),
          child: PopupMenuButton<String>(
            splashRadius: 20,
            icon: Icon(Icons.arrow_drop_down_outlined, size: 15, color: iconColor),
            onSelected: (String selectedItem) {
              onFileSelected(selectedItem);
            },
            itemBuilder: (BuildContext context) {
              if (displayFileName.isEmpty) {
                return [
                  const PopupMenuItem<String>(
                    height: 20,
                    value: null,
                    child: Text(
                      'You have no approved file yet',
                      style: TextStyles.dataTextStyle,
                    ),
                  ),
                ];
              } else {
                return displayFileName.map((String type) {
                  return PopupMenuItem<String>(
                    height: 20,
                    value: type,
                    child: Text(
                      type,
                      style: TextStyles.dataTextStyle,
                    ),
                  );
                }).toList();
              }
            },
            elevation: 8,
          ),
        ),
      ],
    );
  }
}
