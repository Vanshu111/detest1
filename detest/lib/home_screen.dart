import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:detest/device_screen.dart';
import 'package:detest/login.dart';
import 'package:detest/text_input_field.dart';
import 'package:flutter/material.dart';
import 'config_screen.dart';
import 'constant.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<String> response;
  late TextEditingController _serialId;
  late TextEditingController _securityKey;
  @override
  void initState() {
    response = getData(widget.email);
    _serialId = TextEditingController();
    _securityKey = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _serialId.dispose();
    _securityKey.dispose();
    super.dispose();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
              child: Text(
            'Register a new Device ',
            style: TextStyle(color: buttonColor),
          )),
          content: SizedBox(
            height: 140,
            width: 400,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextInputField(
                    initalvalue: 'D0999',
                    controller: _serialId,
                    labelText: 'Device ID',
                    icon: Icons.devices,
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextInputField(
                    initalvalue: '1234',
                    controller: _securityKey,
                    labelText: 'Serial ID',
                    icon: Icons.devices,
                    // isObscure: true,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              textColor: Colors.white,
              color: Colors.red,
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              textColor: Colors.white,
              color: buttonColor,
              child: const Text('Register'),
              onPressed: () async {
                // Future RegistrationUser() async {
                var APIURL =
                    "https://uo1t934012.execute-api.us-east-1.amazonaws.com//addNewDevice";
                // as Uri;

                // Map mapeddate = {
                //   'device_id': _securityKey.text,
                //   'serial_id': _serialId.text
                // };
                var body = jsonEncode({
                  'device_id': _serialId.text,
                  'serial_id': _securityKey.text
                });
                print("JSON DATA: ${body}");

                http.Response response =
                    await http.post(Uri.parse(APIURL), body: body);

                var data = jsonDecode(response.body);

                print("DATA: ${data}");
                // }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// {email: milanpreetkaur502@gmail.com, serialID: D0314, deviceBooted: true, deviceProvisoned: true}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonColor,
        title: Row(
          children: [
            const Icon(
              Icons.person_rounded,
              size: 35,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(widget.email)
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 8, bottom: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Login()));
                setState(() {
                  deviceData = [];
                });
              },
              icon: const Icon(
                Icons.logout,
                color: backgroundColor,
              ),
              label: const Text(
                'LOG OUT',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                  // elevation: 10,
                  backgroundColor: Colors.white10),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          heroTag: 'btn3',
          backgroundColor: buttonColor,
          onPressed: () => _dialogBuilder(context),
          label: const Text('Register a new Device +')),
      body: FutureBuilder<String>(
        future: response,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == '200') {
              // print(data);
              return ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: Table(
                          children: const <TableRow>[
                            TableRow(children: <Widget>[
                              Center(
                                child: Text(
                                  'S.NO',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: backgroundColor),
                                ),
                              ),
                              Center(
                                child: Text(
                                  'DEVICE ID',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: backgroundColor),
                                ),
                              ),
                              Center(
                                child: Text(
                                  'STATUS',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: backgroundColor),
                                ),
                              ),
                              Center(
                                child: Text(
                                  'REGISTERED',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: backgroundColor),
                                ),
                              ),
                              Center(
                                child: Text(
                                  'CONFIGURE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: backgroundColor),
                                ),
                              ),
                              Center(
                                child: Text(
                                  'DOWNLOAD',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: backgroundColor),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                  for (int i = 0; i < deviceData.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          child: Table(
                            children: [
                              TableRow(children: [
                                SizedBox(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(
                                          fontSize: 16, color: backgroundColor),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      deviceData[i].deviceId,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      deviceData[i].status,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      '${deviceData[i].registerStatus}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        // print('CONFIGURE');
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ConfigScreen(
                                              deviceId: deviceData[i].deviceId,
                                              userName: widget.email,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.settings,
                                        color: backgroundColor,
                                      ),
                                      // label: const Text('CONFIGURE'),
                                      style: ElevatedButton.styleFrom(
                                          // elevation: 10,
                                          backgroundColor: Colors.white10),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => DeviceScreen(
                                              deviceId: deviceData[i].deviceId,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.download,
                                        color: backgroundColor,
                                      ),
                                      // label: const Text('DOWNLOAD'),
                                      style: ElevatedButton.styleFrom(
                                          // elevation: 10,
                                          backgroundColor: Colors.white10),
                                    ),
                                  ),
                                )
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }
            return Container();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.green,
          ));
        }),
      ),
    );
  }
}
