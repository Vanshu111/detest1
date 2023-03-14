import 'package:flutter/material.dart';

Future<TimeOfDay?> timePicker(BuildContext context) async {
  TimeOfDay? pickedTime = await showTimePicker(
    initialTime: TimeOfDay.now(),
    context: context,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.green,
            onPrimary: Colors.white,
            onSurface: Colors.purple,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              elevation: 10,
              backgroundColor: Colors.black, // button text color
            ),
          ),
        ),
        // child: child!,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        ),
      );
    },
  );
  return pickedTime;
}
