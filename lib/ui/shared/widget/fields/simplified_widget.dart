import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/formatters/formatter.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/fields/textformfield.dart';

import '../../values/colors.dart';
import '../../values/styles.dart';
import 'dropdown.dart';

Widget buildTextFormField({
  required String? title,
  required TextEditingController controller,
  String? hintText,
  IconData? prefixIcon,
  bool? nameField,
  bool? mobileNumberField,
  bool? emailAddressField,
  List<TextInputFormatter>? inputFormatters,
  VoidCallback? onTap,
  FormFieldValidator<String>? validator,
  bool? enabled,
  double? width,
  double? height,
  double? contentPadding,
}) {
  return SizedBox(
    height: height ?? 60,
    width: width ?? 350,
    child: TextFormFieldWidget(
      title: title ?? '',
      hintText: hintText,
      prefixIcon: prefixIcon,
      enabled: enabled ?? true,
      nameField: nameField ?? false,
      mobileNumberField: mobileNumberField ?? false,
      emailAddressField: emailAddressField ?? false,
      contentPadding: contentPadding ?? 15,
      borderRadius: 5,
      controller: controller,
      validator: validator,
      onSaved: (value) {
        controller.text = value!;
      },
      inputFormatters: inputFormatters ?? [],
      onTap: onTap,
    ),
  );
}

Widget buildDropDownField({
  required String title,
  required String? hintText,
  IconData? prefixIcon,
  FormFieldValidator<String>? validator,
  required TextEditingController controller,
  required Function(String?)? onChanged,
  required List<String> items,
  double? width,
  double? height,
  double? contentPadding,
}) {
  return Container(
    height: height ?? 60,
    width: width ?? 350,
    child: DropdownWidget(
      hintText: hintText,
      title: title,
      contentPadding: contentPadding ?? 12,
      borderRadius: 5,
      prefixIcon: prefixIcon,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      items: items,
    ),
  );
}

Widget buildRadioButton({
  required String label,
  required String value,
  required String groupValue,
  required ValueChanged<String?> onChanged,
}) {
  return Row(
    children: [
      Radio<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: AppColors.maroon2,
      ),
      Text(label, style: TextStyles.normal12Maroon),
    ],
  );
}

TextFormField buildCurrencyTextField({
  required TextEditingController controller,
  required String hintText,
  required FormFieldValidator<String> validator,
  Function(String)? onChanged,
  bool isEnabled = false,
}) {
  return TextFormField(
    style: const TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Colors.black54, // Color for the currency symbol
    ),
    controller: controller,
    cursorColor: AppColors.maroon2,
    cursorHeight: 25,
    validator: validator,
    onChanged: onChanged,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [CurrencyFormatter()],
    decoration: InputDecoration(
      enabled: isEnabled,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
      prefixIcon: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 2),
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: Text(
            'PHP',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isEnabled == true ? Colors.green : Colors.grey, // Color for the currency symbol
            ),
          ),
        ),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 30, minHeight: 25),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(
          color: Colors.blue, // Border color when focused
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(
          color: Colors.blueAccent, // Border color when not focused
          width: 1.5,
        ),
      ),
      filled: true,
      fillColor: Colors.white24, // Light gray background color
    ),
  );
}
