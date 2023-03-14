 import 'dart:convert';
import 'package:detest/constant.dart';
import 'package:detest/download.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DeviceScreen extends StatefulWidget {
  final String deviceId;

  const DeviceScreen({
    super.key,
    required this.deviceId,
  });

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  late TextEditingController dateController;
  late TextEditingController timeinput;
  bool apiWait = false;
  List<dynamic> videLinks = [];
  String dataStatus = '';
  String? file = 'video';

  Future<void> getData() async {
    setState(() {
      apiWait = true;
    });
    if (dateController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please Select Date',
          ),
        ),
      );
      setState(() {
        setState(() {
          apiWait = false;
        });
      });
    } else {
      String deviceId = widget.deviceId;
      String dt = dateController.text;
      // print('${timeinput.text}');
      if (timeinput.text != '') {
        dt = '${dt}_${timeinput.text.substring(0, 2)}';
        // print('${timeinput.text.substring(0, 2)}');
      }

      // String tm = timeinput.text.substring(0, 2);
      // _
      final response = await http.get(
        Uri.parse(
          // 'https://jsezk8d2qa.execute-api.us-east-1.amazonaws.com/file?file-type=video&deviceid=D1002&date=2022-10-15_17',
          // 'https://jsezk8d2qa.execute-api.us-east-1.amazonaws.com/file?file-type=video&deviceid=D1002&date=2022-10-15',
          'https://jsezk8d2qa.execute-api.us-east-1.amazonaws.com/file?file-type=$file&deviceid=$deviceId&date=$dt',
        ),
      );
      if (response.statusCode == 200) {
        // videLinks = jsonDecode(response.body)['videos'];
        if (file == 'video') {
          videLinks = jsonDecode(response.body)['videos'];
        } else {
          videLinks = jsonDecode(response.body)['files'];
        }
        // print(jsonDecode(response.body));

        // print(videLinks);

        // print(videLinks);
        if (videLinks.isEmpty) {
          setState(() {
            dataStatus = 'empty';
            apiWait = false;
          });
        } else {
          setState(() {
            dataStatus = 'ok';
            apiWait = false;
          });
        }
      } else {
        throw Exception('Failed to load api');
      }
    }
  }

  @override
  void initState() {
    dateController = TextEditingController();
    timeinput = TextEditingController();
    timeinput.text = "";
    super.initState();
  }

  Widget returnScreen(BuildContext context, Size size) {
    if (dataStatus == 'ok') {
      return Download(data: videLinks);
    } else if (dataStatus == 'empty') {
      return const Center(
        child: Text(
          'SORRY WE HAVE NO FILE !',
          style: TextStyle(
            fontSize: 25,
            color: buttonColor,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }
    return getVideoFileForm(size);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonColor,
      ),
      body: returnScreen(context, size),
    );
  }

  SingleChildScrollView getVideoFileForm(Size size) {
    double wdt = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            // width: 400, // 700
            width: wdt > 720 ? wdt * 0.35 : wdt * 0.9, // 700
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: 50),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Download',
                      style: TextStyle(
                        fontSize: 35,
                        color: buttonColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Device Id : ${widget.deviceId}',
                      style: const TextStyle(
                        fontSize: 22,
                        color: buttonColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: 'Select Date',
                          prefixIcon: const Icon(Icons.calendar_month),
                          labelStyle: const TextStyle(fontSize: 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: borderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: borderColor,
                            ),
                          ),
                        ),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:
                                DateTime(2000), // allow to choose before today.
                            lastDate: DateTime(2101),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors.green,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      elevation: 10,
                                      backgroundColor:
                                          Colors.black, // button text color
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            // DateFormat('dd-MM-yyyy').format(pickedDate);

                            setState(() {
                              dateController.text = formattedDate;
                              // print(dateController.text);
                            });
                          } else {
                            // print("Date is not selected");
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: TextField(
                        controller: timeinput,
                        decoration: InputDecoration(
                          labelText: 'Select Hours',
                          prefixIcon: const Icon(Icons.calendar_month),
                          labelStyle: const TextStyle(fontSize: 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: borderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: borderColor,
                            ),
                          ),
                        ),
                        onTap: () async {
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
                                      backgroundColor:
                                          Colors.black, // button text color
                                    ),
                                  ),
                                ),
                                // child: child!,
                                child: MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: true),
                                  child: child ?? Container(),
                                ),
                              );
                            },
                          );

                          if (pickedTime != null) {
                            DateTime parsedTime = DateFormat.jm()
                                .parse(pickedTime.format(context).toString());

                            String formattedTime =
                                DateFormat('HH:mm:ss').format(parsedTime);

                            setState(() {
                              timeinput.text = formattedTime;
                              // print(timeinput.text);
                            });
                          } else {
                            // print("Time is not selected");
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Text(
                            "What is your file?",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        RadioListTile(
                          activeColor: Colors.purple,
                          title: const Text("weather"),
                          value: "weather",
                          groupValue: file,
                          onChanged: (value) {
                            setState(() {
                              file = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          activeColor: Colors.purple,
                          title: const Text("video"),
                          value: "video",
                          groupValue: file,
                          onChanged: (value) {
                            setState(() {
                              file = value.toString();
                            });
                          },
                        ),
                      ],
                    ),
                    !apiWait
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            height: 50,
                            decoration: const BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: InkWell(
                              onTap: getData,
                              child: const Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.purple,
                            ),
                          ),
                    const SizedBox(height: 30),
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
