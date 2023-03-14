import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method
// import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

List<Device> deviceData = [];
final fmt = DateFormat("MMM d yyyy hh:mm:ss");
// COLORS
const backgroundColor = Colors.white;

const buttonColor = Colors.green;
// const buttonColor = Colors.black;
const borderColor = Colors.purple;

Future<String> isUserFound(String email, String psw) async {
  var bytes = utf8.encode(psw); // data being hashed
  var digest = md5.convert(bytes);
  // print(digest);
  final response = await http.get(
    Uri.parse('https://fukaqwjsci.execute-api.us-east-1.amazonaws.com/login'),
    headers: {
      'password': "$digest",
      'email': email,
    },
  );
  if (response.statusCode == 200) {
    String res = jsonDecode(response.body).toString();
    // print(res);
    // getData(email);
    return res == 'ok' ? '200' : '400';
  } else {
    throw Exception('Failed to load api');
  }
}

Future<String> getData(String email) async {
  final response = await http.get(
    Uri.parse('https://fukaqwjsci.execute-api.us-east-1.amazonaws.com/data'),
    headers: {
      'email': email,
    },
  );
  if (response.statusCode == 200) {
    DateTime current = DateTime.now().toUtc();
    String now = fmt.format(current);
    // print(now);
    int nowInMS = fmt.parse(now).millisecondsSinceEpoch;

    for (var i in jsonDecode(response.body)) {
      // print(i);
      deviceData.add(Device.fromJson(i, nowInMS));
    }
    // print(deviceData[1].status);

    return deviceData.isEmpty ? '400' : '200';
  } else {
    throw Exception('Failed to load api');
  }
}

class Device {
  final String deviceId;
  final bool registerStatus;
  final String status;

  const Device({
    required this.deviceId,
    required this.registerStatus,
    required this.status,
  });

  factory Device.fromJson(Map<String, dynamic> dvc, nowInMS) {
    if (dvc['status'] == 'empty') {
      return Device(
        deviceId: dvc['device_id'],
        registerStatus: dvc['register_status'],
        status: dvc['status'],
      );
    } else {
      String dt = dvc['status'].split(' ').sublist(1, 5).join(' ');
      int previousDt = fmt.parse(dt).millisecondsSinceEpoch;
      int distance = nowInMS - previousDt;

      if (distance < 300000) {
        return Device(
            deviceId: dvc['device_id'],
            registerStatus: dvc['register_status'],
            status: "active");
      } else {
        return Device(
            deviceId: dvc['device_id'],
            registerStatus: dvc['register_status'],
            status: 'inactive');
      }
    }
  }
}
