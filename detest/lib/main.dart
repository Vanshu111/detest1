import 'package:detest/config_screen.dart';
import 'package:detest/configure/configure_image.dart';
import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital-entomologist',
      theme: ThemeData.light(),
      home: const Login(),
      // home: const ConfigScreen(
      //   deviceId: 'D0315',
      //   userName: 'milanpreetkaur502@gmail.com',
      // ),
    );
  }
}

// declient/D0315/image/resp
// {
//   "Id": "Policy1669895698219",
//   "Version": "2012-10-17",
//   "Statement": [
//     {
//       "Sid": "Stmt1669895646979",
//       "Action": [
//         "s3:DeleteObject",
//         "s3:GetObject"
//       ],
//       "Effect": "Allow",
//       "Resource": "arn:aws:s3:::de-remote-image/*",
//       "Principal": "*"
//     }
//   ]
// }