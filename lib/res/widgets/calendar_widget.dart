import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:real_time_test_app/Utils/color.dart';

class CalendarWidget
    extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  int selectedButtonIndex = 0;
  String formattedDate = DateFormat('d MMM y').format(DateTime.now());
  List<DateTime?> _dialogCalendarPickerValue = [DateTime.now()];
  List<String> weekDayLabels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  DateTime calculateNextMonday() {
    DateTime currentDate = DateTime.now();
    int daysUntilMonday = (DateTime.monday - currentDate.weekday + 7) % 7;
    return currentDate.add(Duration(days: daysUntilMonday));
  }

  DateTime calculateNextTuesday() {
    DateTime currentDate = DateTime.now();
    int daysUntilTuesday = (DateTime.tuesday - currentDate.weekday + 7) % 7;
    return currentDate.add(Duration(days: daysUntilTuesday));
  }

  DateTime calculateNextWeek() {
    DateTime currentDate = DateTime.now();
    return currentDate.add(const Duration(days: 7));
  }

  String formatDate(DateTime date) {
    return DateFormat('d MMM y').format(date);
  }

  void onDateSelected(List<DateTime?> dates) {
    _dialogCalendarPickerValue = dates;
    DateTime? selectedDate = _dialogCalendarPickerValue.first;
    setState(() {
      if (selectedDate != null) {
        formattedDate = formatDate(selectedDate);
      } else {
        formattedDate = "NA";
      }
    });
  }

  void saveButtonClicked() {

    Navigator.pop(context,formattedDate); // Close the dialog when Save is clicked
    // Add any additional save logic here
  }

  void cancelButtonClicked() {
    Navigator.pop(context); // Close the dialog when Cancel is clicked
    // Add any additional cancel logic here
  }

  Widget popUpUIScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  _dialogCalendarPickerValue.clear();
                  setState(() {
                    _dialogCalendarPickerValue.add(DateTime.now());
                    formattedDate = formatDate(DateTime.now());
                    selectedButtonIndex = 0;
                  });
                },
                color: selectedButtonIndex == 0
                    ?  primary
                    : const Color(0xffedf8ff).withOpacity(0.2),
                textColor: selectedButtonIndex == 0
                    ? const Color(0xffedf8ff)
                    :  primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minWidth: 120,
                elevation: 0,
                child: const Text("Today"),
              ),
              const SizedBox(width: 16),
              MaterialButton(
                onPressed: () {
                  _dialogCalendarPickerValue.clear();
                  setState(() {
                    _dialogCalendarPickerValue.add(calculateNextMonday());
                    formattedDate = formatDate(calculateNextMonday());
                    selectedButtonIndex = 1;
                  });
                },
                color: selectedButtonIndex == 1
                    ?  primary
                    : const Color(0xffedf8ff),
                textColor: selectedButtonIndex == 1
                    ? const Color(0xffedf8ff)
                    :  primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minWidth: 120,
                elevation: 0,
                child: const Text("Next Monday"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  _dialogCalendarPickerValue.clear();
                  setState(() {
                    _dialogCalendarPickerValue.add(calculateNextTuesday());
                    formattedDate = formatDate(calculateNextTuesday());
                    selectedButtonIndex = 2;
                  });
                },
                color: selectedButtonIndex == 2
                    ?  primary
                    : const Color(0xffedf8ff),
                textColor: selectedButtonIndex == 2
                    ? const Color(0xffedf8ff)
                    :  primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minWidth: 120,
                elevation: 0,
                child: const Text("Next Tuesday"),
              ),
              const SizedBox(width: 16),
              MaterialButton(
                onPressed: () {
                  _dialogCalendarPickerValue.clear();
                  setState(() {
                    _dialogCalendarPickerValue.add(calculateNextWeek());
                    formattedDate = formatDate(calculateNextWeek());
                    selectedButtonIndex = 3;
                  });
                },
                color: selectedButtonIndex == 3
                    ?  primary
                    : const Color(0xffedf8ff),
                textColor: selectedButtonIndex == 3
                    ? const Color(0xffedf8ff)
                    :  primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minWidth: 120,
                elevation: 0,
                child: const Text("After 1 week"),
              ),
            ],
          ),
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(
                firstDayOfWeek: 1,
                calendarType: CalendarDatePicker2Type.single,
                selectedDayTextStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700),
                selectedDayHighlightColor:  primary,
                centerAlignModePicker: true,
                customModePickerIcon: const SizedBox(),
                weekdayLabels: weekDayLabels,
                weekdayLabelTextStyle:
                const TextStyle(fontWeight: FontWeight.w500)),
            value: _dialogCalendarPickerValue,
            onValueChanged: onDateSelected,
          ),

          Divider(thickness: 0.7,),
          const SizedBox(
            height: 5,
          ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                     Icon(
                      Icons.event_outlined,
                      color: primary,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(formattedDate)
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 2,),
                    MaterialButton(
                      onPressed: cancelButtonClicked,
                      child: const Text("Cancel"),
                      textColor: primary,
                    color: Color(0xffedf8ff),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                     SizedBox(width: 5),
                    MaterialButton(
                      onPressed: saveButtonClicked,
                      child: const Text("Save"),
                      color:  primary,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return popUpUIScreen();
  }
}
