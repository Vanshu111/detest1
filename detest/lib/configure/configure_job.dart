import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../constant.dart';
import '../device_status.dart';
import '../widget/input_field_decoration.dart';
import '../widget/time_picker.dart';

class ConfigureJob extends StatefulWidget {
  final String deviceId;
  const ConfigureJob({super.key, required this.deviceId});

  @override
  State<ConfigureJob> createState() => _ConfigureJobState();
}

class _ConfigureJobState extends State<ConfigureJob> {
  late TextEditingController deviceOnTime;
  late TextEditingController deviceOffTime;

  static const List<String> list = <String>[
    ' NOT SELECTED TIME ZONE',
    ' (GMT +01:00) Europe/Berlin',
    ' (GMT +05:30) Asia/Kolkata',
    ' (GMT -08:00) USA'
  ];
  String dropdownValue = list.first;
  String apiResponse = '';
  String jobId = '';

  @override
  void initState() {
    deviceOnTime = TextEditingController();
    deviceOffTime = TextEditingController();

    super.initState();
  }

  Future<void> sendDataToApi() async {
    setState(() {
      apiResponse = 'wait';
    });
    String message = '';
    if (deviceOnTime.text != '' && deviceOffTime.text != '') {
      String onTime = deviceOnTime.text.substring(0, 5);
      String offTime = deviceOffTime.text.substring(0, 5);
      String timeZone = dropdownValue.split(' ').last;

      Map<String, dynamic> device = {
        "Device-On-Time": onTime,
        "Device-Off-Time": offTime
      };
      if (timeZone != 'ZONE') {
        device['Time-Zone'] = timeZone;
      }
      Map<String, dynamic> payload = {
        "deviceId": widget.deviceId,
        "from": "client",
        "device": device,
        "cloud": {},
        "camera": {},
        "getLogs": {}
      };

      final response = await http.post(
        Uri.parse(
            'https://k5cisafbzh.execute-api.us-east-1.amazonaws.com/sendJob'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        message = jsonDecode(response.body);
        setState(() {
          apiResponse = 'ok';
          jobId = message.split(',').last;
        });
      } else {
        setState(() {
          apiResponse = '';
        });

        message = 'Something went wrong!';
        throw Exception('Failed ');
      }
    } else {
      setState(() {
        apiResponse = '';
      });
      message = 'Please Enter Everythings! ';
    }
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    deviceOnTime.dispose();
    deviceOffTime.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 700,
              // height: 500,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: apiResponse == 'ok'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: BackButton(
                                color: borderColor,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            DeviceStatus(
                              deviceId: widget.deviceId,
                              deviceOffTime: deviceOffTime.text.substring(0, 5),
                              deviceOnTime: deviceOnTime.text.substring(0, 5),
                              jobId: jobId,
                              timeZone: dropdownValue,
                            ),
                            const SizedBox(height: 30),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Device Id : ${widget.deviceId}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: buttonColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 0),
                              child: Row(
                                children: [
                                  const Text(
                                    'Set Time Zone : ',
                                    style: TextStyle(
                                        fontSize: 22, color: buttonColor),
                                  ),
                                  Container(
                                    // padding: const EdgeInsets.only(left: 8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: borderColor),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Icon(
                                          Icons.arrow_downward,
                                          color: buttonColor,
                                        ),
                                      ),
                                      elevation: 16,
                                      style: const TextStyle(
                                          color: Colors.deepPurple),
                                      underline: Container(
                                        height: 0,
                                      ),
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.

                                        setState(() {
                                          dropdownValue = value!;
                                        });
                                      },
                                      items: list.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                '*Add this to job card to set the timezone of the device.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 0),
                              child: TextField(
                                controller: deviceOnTime,
                                decoration: inputDecoration(
                                    'Device On Time', Icons.timer),
                                onTap: () async {
                                  TimeOfDay? pickedTime =
                                      await timePicker(context);
                                  if (pickedTime != null) {
                                    DateTime parsedTime = DateFormat.jm().parse(
                                        pickedTime.format(context).toString());

                                    String formattedTime =
                                        DateFormat('HH:mm:ss')
                                            .format(parsedTime);

                                    setState(() {
                                      deviceOnTime.text = formattedTime;
                                      // print(formattedTime);
                                    });
                                  } else {
                                    // print("Time is not selected");
                                  }
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                '*Takes the numeric value in hours(1hr-22hr) for which device is going to remain on and camera will work.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 0),
                              child: TextField(
                                controller: deviceOffTime,
                                decoration: inputDecoration(
                                    'Device Off Time', Icons.alarm),
                                onTap: () async {
                                  TimeOfDay? pickedTime =
                                      await timePicker(context);
                                  if (pickedTime != null) {
                                    DateTime parsedTime = DateFormat.jm().parse(
                                        pickedTime.format(context).toString());

                                    String formattedTime =
                                        DateFormat('HH:mm:ss')
                                            .format(parsedTime);

                                    setState(() {
                                      deviceOffTime.text = formattedTime;
                                      // print(formattedTime);
                                    });
                                  } else {
                                    // print("Time is not selected");
                                  }
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                '*Takes only 24hr format time, ranging from 1-24.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            apiResponse == 'wait'
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: borderColor,
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: buttonColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: sendDataToApi,
                                      child: const Center(
                                        child: Text(
                                          'Send',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
