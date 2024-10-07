import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// DO NOT ACCEPT 0 AS FIRST INPUT
class ZeroFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.startsWith('0')) {
      return oldValue;
    }
    return newValue;
  }
}

//STAFF ID FORMATTER
class StaffIDFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String enteredHCISID = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (int id = 0; id < enteredHCISID.length; id++) {
      buffer.write(enteredHCISID[id]);
      int index = id + 1;
      if (index % 6 == 0 && enteredHCISID.length != index) {
        buffer.write("-");
      }
    }
    return TextEditingValue(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}

// CAMEL CASE FORMATTER
class CamelCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    // Capitalize the first letter
    String formattedValue = newValue.text[0].toUpperCase() + newValue.text.substring(1);

    // Convert to camel case
    for (int i = 1; i < formattedValue.length; i++) {
      if (formattedValue[i - 1] == ' ') {
        formattedValue = formattedValue.substring(0, i) + formattedValue[i].toUpperCase() + formattedValue.substring(i + 1);
      }
    }
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

class DigitInputFormatter extends TextInputFormatter {
  final String prefix = "09";

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove non-numeric characters from the new value, excluding the prefix
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Ensure the text starts with the prefix
    String updatedText = prefix;

    // Extract the editable part (excluding the fixed prefix)
    String editablePart = newText.length > prefix.length ? newText.substring(prefix.length) : '';

    // Ensure the editable part does not exceed 9 digits
    if (editablePart.length > 9) {
      editablePart = editablePart.substring(0, 9);
    }

    // Combine the prefix with the editable part
    updatedText += editablePart;

    // Return the updated text value with the fixed prefix and editable digits
    return TextEditingValue(
      text: updatedText,
      selection: TextSelection.collapsed(offset: updatedText.length),
    );
  }
}

class TwoDigitInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric characters

    // Ensure the text length does not exceed 11 digits
    if (newText.length > 11) {
      // If the length exceeds 2 digits, truncate it
      return TextEditingValue(
        text: newText.substring(0, 11),
        selection: TextSelection.collapsed(offset: 2),
      );
    }

    // Return the updated text value with only digits
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class NumbersOnlyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Use a regular expression to allow only digits (0-9)
    String formattedValue = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

///PESO FORMATTER
class CurrencyFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // Split text by decimal point to separate integer and decimal parts
    List<String> parts = newText.split('.');
    String integerPart = parts[0].replaceAll(RegExp(r'[^0-9]'), ''); // Filter only digits
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Ensure no leading zero unless it's for a decimal number
    if (integerPart.startsWith('0') && integerPart.length > 1) {
      integerPart = integerPart.substring(1);
    }

    // If the integer part is empty, set it to an empty string instead of "0"
    if (integerPart.isEmpty) {
      return TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Limit the decimal part to a maximum of 2 digits
    if (decimalPart.length > 2) {
      decimalPart = decimalPart.substring(0, 2);
    }

    // Format the integer part with commas
    String formattedIntegerPart = _formatter.format(int.tryParse(integerPart) ?? 0);

    // If there's a decimal point in the original input, we need to preserve it
    String finalText;
    if (newText.contains(".")) {
      // Preserve the decimal part even if it's empty (i.e., the user just typed the decimal point)
      finalText = decimalPart.isNotEmpty ? '$formattedIntegerPart.$decimalPart' : '$formattedIntegerPart.';
    } else {
      // No decimal point present, just use the formatted integer part
      finalText = formattedIntegerPart;
    }

    return TextEditingValue(
      text: finalText,
      selection: TextSelection.collapsed(offset: finalText.length),
    );
  }
}

// ///PESO FORMATTER
// class CurrencyFormatter extends TextInputFormatter {
//   final NumberFormat _formatter = NumberFormat('#,###');
//
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     String newText = newValue.text;
//
//     // Split text by decimal point to separate integer and decimal parts
//     List<String> parts = newText.split('.');
//     String integerPart = parts[0].replaceAll(RegExp(r'[^0-9]'), ''); // Filter only digits
//     String decimalPart = parts.length > 1 ? parts[1] : '';
//
//     // Ensure no leading zero unless it's for a decimal number
//     if (integerPart.startsWith('0') && integerPart.length > 1) {
//       integerPart = integerPart.substring(1);
//     }
//
//     // Limit the decimal part to a maximum of 2 digits
//     if (decimalPart.length > 2) {
//       decimalPart = decimalPart.substring(0, 2);
//     }
//
//     // Format the integer part with commas
//     String formattedIntegerPart = _formatter.format(int.tryParse(integerPart) ?? 0);
//
//     // If there's a decimal point in the original input, we need to preserve it
//     String finalText;
//     if (newText.contains(".")) {
//       // Preserve the decimal part even if it's empty (i.e., the user just typed the decimal point)
//       finalText = decimalPart.isNotEmpty ? '$formattedIntegerPart.$decimalPart' : '$formattedIntegerPart.';
//     } else {
//       // No decimal point present, just use the formatted integer part
//       finalText = formattedIntegerPart;
//     }
//
//     return TextEditingValue(
//       text: finalText,
//       selection: TextSelection.collapsed(offset: finalText.length),
//     );
//   }
// }

///DASH-SEPARATED BANK ACCOUNT
class BankAccountNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Get the input text from the new value
    String newText = newValue.text;

    // Remove any non-digit characters
    newText = newText.replaceAll(RegExp(r'[^0-9]'), '');

    // Format the input into groups of 4-4-4-3
    StringBuffer formattedText = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      // Add a dash after every 4 characters, except at the end
      if (i > 0 && (i % 4 == 0) && (i < newText.length)) {
        formattedText.write('-');
      }
      formattedText.write(newText[i]);
    }

    // Create the new text value
    return TextEditingValue(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: formattedText.length), // Move cursor to the end
    );
  }
}

class BirthdayInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // Ensure that only numbers and dashes are allowed
    newText = newText.replaceAll(RegExp(r'[^0-9-]'), '');

    // Automatically insert dashes
    if (newText.length > 4 && newText[4] != '-') {
      newText = newText.substring(0, 4) + '-' + newText.substring(4);
    }
    if (newText.length > 7 && newText[7] != '-') {
      newText = newText.substring(0, 7) + '-' + newText.substring(7);
    }

    // Validate year
    if (newText.length >= 4) {
      String year = newText.substring(0, 4);
      int yearValue = int.tryParse(year) ?? 0;
      int currentYear = DateTime.now().year;
      if (yearValue < 1500 || yearValue > currentYear) {
        newText = ''; // Reset to empty string if year is invalid
      }
    }

    // Validate month
    if (newText.length >= 7) {
      String month = newText.substring(5, 7);
      int monthValue = int.tryParse(month) ?? 0;
      if (monthValue < 1 || monthValue > 12) {
        newText = newText.substring(0, 5); // Remove invalid month
      }
    }

    // Validate day
    if (newText.length >= 10) {
      String day = newText.substring(8, 10);
      int dayValue = int.tryParse(day) ?? 0;
      if (dayValue < 1 || dayValue > 31) {
        newText = newText.substring(0, 8); // Remove invalid day
      }
    }

    // Ensure that the length doesn't exceed 10 (YYYY-MM-DD)
    if (newText.length > 10) {
      newText = newText.substring(0, 10);
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

// PAGINATION
class PaginationUtils {
  static int defaultRowPage = 0;
  static int currentPage = 1;
  static int rowsPerPage = 15;

  static bool isPrevButtonEnabled() {
    return currentPage > 1;
  }

  static bool isNextButtonEnabled(List<dynamic> data) {
    return (currentPage * rowsPerPage) < data.length;
  }

  static void decrementPage(Function setStateCallback, Function decrementDataCallback) {
    setStateCallback(() {
      currentPage--;
      decrementDataCallback();
    });
  }

  static void incrementPage(Function setStateCallback, Function incrementDataCallback) {
    setStateCallback(() {
      currentPage++;
      incrementDataCallback();
    });
  }

  static void rowPaginate(String row, Function setStateCallback, Function rowDataCallback) {
    setStateCallback(() {
      rowsPerPage = row.isNotEmpty ? int.tryParse(row) ?? defaultRowPage : defaultRowPage;
      currentPage = 1;
      rowDataCallback(); // Call the provided function
    });
  }

  static String numberDisplayWeb(List<dynamic> data) {
    return '${(currentPage - 1) * rowsPerPage + 1} - ${(currentPage * rowsPerPage) > data.length ? data.length : (currentPage * rowsPerPage)} of ${data.length}';
  }
}

// PAGE VIEW NEXT PAGE
void goToNextPage(PageController pageController, int currentPage) {
  // Check if it's not the last page
  if (currentPage < pageController.position.maxScrollExtent) {
    pageController.animateToPage(
      currentPage + 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class StaffID1 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanedText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String formattedText = '';

    int chunk1Length = cleanedText.length >= 5 ? 6 : cleanedText.length;
    formattedText += cleanedText.substring(0, chunk1Length);

    if (cleanedText.length >= 2) {
      formattedText += '-';
    }

    int chunk2Length = cleanedText.length >= 6 ? 5 : cleanedText.length - chunk1Length;
    formattedText += cleanedText.substring(chunk1Length, chunk1Length + chunk2Length);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
