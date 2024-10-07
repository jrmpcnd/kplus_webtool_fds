import 'package:flutter/material.dart';

import '../../values/colors.dart';

class AutocompleteTemplate extends StatefulWidget {
  final TextEditingController controller;
  final bool isTextFieldEnabled;
  final Iterable<String> options;
  final AutocompleteOptionsBuilder<String> optionsBuilder;
  final AutocompleteOnSelected<String> onSelected;
  final void Function(String) onChanged;
  final double? borderRadius;
  final double? height;
  final bool dynamicColor;

  const AutocompleteTemplate({
    Key? key,
    required this.controller,
    required this.isTextFieldEnabled,
    required this.options,
    required this.optionsBuilder,
    required this.onSelected,
    required this.onChanged,
    this.borderRadius,
    this.height,
    this.dynamicColor = true,
  }) : super(key: key);

  @override
  State<AutocompleteTemplate> createState() => _AutocompleteTemplateState();
}

class _AutocompleteTemplateState extends State<AutocompleteTemplate> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: widget.optionsBuilder,
      onSelected: widget.onSelected,
      fieldViewBuilder: (BuildContext context, TextEditingController brCodeController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return TextFormField(
          style: const TextStyle(fontSize: 12),
          enabled: widget.isTextFieldEnabled,
          controller: widget.controller,
          focusNode: focusNode,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            isDense: true,
            hintText: '--Type branch name--',
            contentPadding: const EdgeInsets.all(8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(widget.borderRadius ?? 5.0)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 5.0),
              borderSide: BorderSide(color: widget.dynamicColor ? AppColors.green3 : AppColors.green3, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 5.0),
              borderSide: const BorderSide(color: AppColors.ngoColor),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 5.0),
              borderSide: BorderSide(color: widget.dynamicColor ? Colors.grey : Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 5.0),
              borderSide: const BorderSide(color: AppColors.maroon4),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 5.0),
              borderSide: const BorderSide(color: AppColors.maroon4, width: 2),
            ),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Material(
          elevation: 2,
          child: SizedBox(
            height: widget.height,
            child: ListView(
              padding: EdgeInsets.zero,
              children: options.map((String option) {
                return ListTile(
                  title: Text(option),
                  onTap: () {
                    onSelected(option);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
