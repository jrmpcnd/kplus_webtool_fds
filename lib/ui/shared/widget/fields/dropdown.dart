import 'package:flutter/material.dart';

import '../../values/colors.dart';
import '../../values/styles.dart';

class DropdownWidget extends StatefulWidget {
  final String title;
  final double? borderRadius;
  final Color? borderColor;
  final double? contentPadding;
  final bool autoFocus;
  final String? labelText;
  final String? hintText;
  final bool dynamicColor;
  final IconData? prefixIcon;
  final String? prefixText;
  final IconData? suffixIcon;
  final String? suffixText;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final bool counterVisible;
  final bool filled;
  final bool enableInteractiveSelection;
  final bool denySpacing;
  final TextAlign textAlign;
  final TextEditingController controller;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator; //Last change : June 21
  final Function()? onEditingComplete;
  final FocusNode? focusNode;
  final bool autofocus;
  final List<String> items;

  const DropdownWidget({
    Key? key,
    this.title = '',
    this.borderRadius,
    this.borderColor,
    this.contentPadding,
    this.autoFocus = false,
    this.labelText,
    this.hintText,
    this.dynamicColor = true,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.suffixText,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.counterVisible = true,
    this.filled = false,
    this.enableInteractiveSelection = true,
    this.denySpacing = false,
    this.textAlign = TextAlign.left,
    required this.controller,
    this.onTap,
    this.onSaved,
    this.onChanged,
    this.onEditingComplete,
    this.validator,
    this.focusNode,
    this.autofocus = false,
    required this.items,
  }) : super(key: key);

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  late List<DropdownMenuItem<String>> dropdownItems;

  @override
  void initState() {
    super.initState();
    dropdownItems = buildDropdownItems(widget.items);
  }

  List<DropdownMenuItem<String>> buildDropdownItems(List<String> items) {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String item in items) {
      var newItem = DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
      dropdownItems.add(newItem);
    }

    return dropdownItems;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.title == ''
              ? const SizedBox(height: 0.0)
              : Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.maroon2,
                    ),
                  ),
                ),
          DropdownButtonFormField<String>(
            menuMaxHeight: 200,
            iconSize: 20,
            style: const TextStyle(fontSize: 12, overflow: TextOverflow.fade),
            items: widget.items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: widget.onChanged,
            value: widget.controller.text.isNotEmpty ? widget.controller.text : null,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: widget.dynamicColor ? AppColors.maroon2 : AppColors.maroon2,
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(
                        widget.suffixIcon,
                        size: 15.0,
                        color: widget.dynamicColor ? AppColors.maroon2 : AppColors.maroon2,
                      ),
                    )
                  : null,
              contentPadding: EdgeInsets.all(widget.contentPadding ?? 14.0),
              filled: widget.filled,
              isDense: true,
              prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
              suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
                borderSide: BorderSide(color: widget.borderColor ?? AppColors.green3),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
                borderSide: BorderSide(color: widget.dynamicColor ? AppColors.ngoColor : AppColors.ngoColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
                borderSide: const BorderSide(color: AppColors.maroon4, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
                borderSide: const BorderSide(color: AppColors.maroon4, width: 2),
              ),
              hintStyle: TextStyles.hintText,
              errorStyle: const TextStyle(fontSize: 0, height: 0),
            ),
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
