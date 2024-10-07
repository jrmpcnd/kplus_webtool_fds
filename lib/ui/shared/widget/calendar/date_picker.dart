import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../values/colors.dart';

class DatePickerModal extends StatelessWidget {
  final TextEditingController dateController;
  final DateTime initialDate;
  final String dataText;
  final bool includeTime;
  final VoidCallback? onDone; // Optional function parameter

  DatePickerModal({
    required this.dateController,
    required this.initialDate,
    required this.dataText,
    this.includeTime = false,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = initialDate;
    final DateTime minDate = DateTime(1500);
    final DateTime maxDate = DateTime.now();

    TimeOfDay selectedTime = TimeOfDay.fromDateTime(initialDate);
    DateTime currentDateTime = DateTime.now();

    DateTime effectiveMaxDate = DateTime(
      maxDate.year,
      maxDate.month,
      maxDate.day,
      currentDateTime.hour,
      currentDateTime.minute,
    );

    return SizedBox(
      height: 400.0,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dataText,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold), // Update with your TextStyle
                ),
                ElevatedButton(
                  onPressed: () {
                    // If includeTime is false, ignore time and only format the date
                    if (!includeTime) {
                      dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                    } else {
                      // Combine the selected date and time if includeTime is true
                      DateTime finalDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      // Ensure time does not exceed the current time if the date is today
                      if (selectedDate.isAtSameMomentAs(currentDateTime) && finalDateTime.isAfter(currentDateTime)) {
                        finalDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          currentDateTime.hour,
                          currentDateTime.minute,
                        );
                      }

                      dateController.text = DateFormat('yyyy-MM-dd HH:mm').format(finalDateTime);
                    }

                    Navigator.pop(context);
                    // Call the optional function if provided
                    if (onDone != null) {
                      onDone!();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: AppColors.maroon2, // Update with your AppColors.maroon2
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     // Combine the selected date and time
                //     DateTime finalDateTime = DateTime(
                //       selectedDate.year,
                //       selectedDate.month,
                //       selectedDate.day,
                //       selectedTime.hour,
                //       selectedTime.minute,
                //     );
                //
                //     // Ensure time does not exceed the current time if the date is today
                //     if (selectedDate.isAtSameMomentAs(currentDateTime) && finalDateTime.isAfter(currentDateTime)) {
                //       finalDateTime = DateTime(
                //         selectedDate.year,
                //         selectedDate.month,
                //         selectedDate.day,
                //         currentDateTime.hour,
                //         currentDateTime.minute,
                //       );
                //     }
                //
                //     dateController.text = DateFormat('yyyy-MM-dd HH:mm').format(finalDateTime);
                //     Navigator.pop(context);
                //     // Call the optional function if provided
                //     if (onDone != null) {
                //       onDone!();
                //     }
                //   },
                //   style: ElevatedButton.styleFrom(
                //     shape: const StadiumBorder(),
                //     backgroundColor: AppColors.maroon2, // Update with your AppColors.maroon2
                //   ),
                //   child: const Text(
                //     'Done',
                //     style: TextStyle(
                //       fontSize: 15.0,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 300,
                      child: CupertinoDatePicker(
                        initialDateTime: initialDate.isAfter(maxDate) ? maxDate : initialDate,
                        mode: CupertinoDatePickerMode.date,
                        minimumDate: minDate,
                        maximumDate: maxDate,
                        onDateTimeChanged: (date) {
                          if (date.isBefore(minDate)) {
                            selectedDate = minDate;
                          } else if (date.isAfter(maxDate)) {
                            selectedDate = maxDate;
                          } else {
                            selectedDate = date;
                          }
                        },
                      ),
                    ),
                    if (includeTime) // Conditional rendering of time picker
                      Container(
                        width: 300,
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: CupertinoDatePicker(
                            initialDateTime: DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            ).isAfter(effectiveMaxDate)
                                ? effectiveMaxDate
                                : DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedTime.hour,
                                    selectedTime.minute,
                                  ),
                            mode: CupertinoDatePickerMode.time,
                            onDateTimeChanged: (dateTime) {
                              TimeOfDay newSelectedTime = TimeOfDay.fromDateTime(dateTime);

                              // Check if the time exceeds the current time
                              if (selectedDate.isAtSameMomentAs(currentDateTime) && (newSelectedTime.hour > currentDateTime.hour || (newSelectedTime.hour == currentDateTime.hour && newSelectedTime.minute > currentDateTime.minute))) {
                                newSelectedTime = TimeOfDay.fromDateTime(currentDateTime);
                              }

                              selectedTime = newSelectedTime;
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showModalDatePicker(BuildContext context, TextEditingController dateController, DateTime initialDate, String dataText, bool includeTime, VoidCallback? onDone) {
  FocusScope.of(context).requestFocus(FocusNode());
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(10.0),
      ),
    ),
    builder: (BuildContext context) {
      return DatePickerModal(
        dateController: dateController,
        initialDate: initialDate,
        dataText: dataText,
        includeTime: includeTime, // Pass the time selection option
        onDone: onDone,
      );
    },
  );
}
