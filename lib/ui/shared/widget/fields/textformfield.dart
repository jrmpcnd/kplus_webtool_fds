import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../values/colors.dart';
import '../../values/styles.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String title;
  final double? borderRadius;
  final double? contentPadding;
  final String? description;
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
  final bool enabled;
  final bool obscureText;
  final bool mpinField;
  final bool mobileNumberField;
  final bool staffIDField;
  final bool nameField;
  final bool emailAddressField;
  final bool enableInteractiveSelection;
  final bool denySpacing;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final List<TextInputFormatter> inputFormatters;
  final FocusNode? focusNode;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Function()? onEditingComplete;
  final Function()? onFieldSubmitted;
  final bool isUsername;
  final bool autofocus;

  const TextFormFieldWidget({
    super.key,
    this.title = '',
    this.borderRadius,
    this.contentPadding,
    this.description,
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
    this.enabled = true,
    this.obscureText = false,
    this.mpinField = false,
    this.mobileNumberField = false,
    this.staffIDField = false,
    this.nameField = false,
    this.emailAddressField = false,
    this.enableInteractiveSelection = true,
    this.denySpacing = false,
    this.textAlign = TextAlign.left,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.onTap,
    this.onSaved,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validator,
    this.inputFormatters = const [],
    this.isUsername = false,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.title == ''
              ? const SizedBox(height: 0.0)
              : Text(
                  ' ${widget.title}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.maroon2,
                  ),
                ),
          TextFormField(
            style: const TextStyle(fontSize: 12),
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            enabled: widget.enabled,
            inputFormatters: widget.inputFormatters,
            maxLength: widget.mobileNumberField
                ? 11
                : widget.staffIDField
                    ? 12
                    : widget.mpinField
                        ? 6
                        : widget.maxLength,
            obscureText: _obscureText,
            textInputAction: TextInputAction.none,
            onFieldSubmitted: (_) {
              FocusScope.of(context).nextFocus();
            },
            decoration: InputDecoration(
              counterText: widget.mobileNumberField
                  ? ''
                  : widget.staffIDField
                      ? ''
                      : widget.mpinField
                          ? ''
                          : widget.counterVisible
                              ? null
                              : '',
              prefixIcon: widget.prefixText != null
                  ? SizedBox(
                      width: 35.0,
                      child: Center(
                        child: Text(
                          widget.prefixText!,
                          style: TextStyles.normal16Green,
                        ),
                      ),
                    )
                  : widget.emailAddressField
                      ? const Icon(
                          Icons.email_outlined,
                          color: AppColors.maroon2,
                          size: 20,
                        )
                      : widget.nameField
                          ? const Icon(
                              Icons.account_box_outlined,
                              color: AppColors.maroon2,
                              size: 20,
                            )
                          : widget.prefixIcon != null
                              ? Icon(
                                  widget.prefixIcon,
                                  color: AppColors.maroon2,
                                )
                              : null,
              suffixIcon: widget.obscureText == true
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: InkWell(
                        onTap: () {
                          _togglePasswordVisibility();
                        },
                        child: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.maroon2,
                        ),
                      ),
                    )
                  : widget.suffixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Icon(
                            widget.suffixIcon,
                            size: 15.0,
                            color: widget.dynamicColor ? AppColors.maroon2 : AppColors.maroon2,
                          ),
                        )
                      : null,
              contentPadding: EdgeInsets.all(widget.contentPadding ?? 16.0),
              filled: widget.filled,
              isDense: true,
              prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
              suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
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
                borderSide: const BorderSide(color: AppColors.maroon4, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 5.0),
                borderSide: const BorderSide(color: AppColors.maroon4, width: 2),
              ),
              labelText: widget.labelText,
              hintText: widget.mobileNumberField
                  ? '09XXXXXXXXX'
                  : widget.emailAddressField
                      ? 'juandelacruz@gmail.com'
                      : widget.hintText,
              hintStyle: TextStyles.hintText,
              errorStyle: const TextStyle(fontSize: 0, height: 0),
            ),
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            onSaved: widget.onSaved,
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
