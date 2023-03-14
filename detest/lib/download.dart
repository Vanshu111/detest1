import 'package:detest/constant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Download extends StatefulWidget {
  final List<dynamic> data;
  const Download({super.key, required this.data});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  bool downloadAll = false;
  List<dynamic> data = [];

  // String get url => null;
  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Column(
          children: [
            const Text(
              'Select to download! ',
              style: TextStyle(
                fontSize: 25,
                color: buttonColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, right: 15, bottom: 8),
                  child: !downloadAll
                      ? FloatingActionButton.extended(
                          backgroundColor: buttonColor,
                          onPressed: () async {
                            setState(() {
                              downloadAll = true;
                            });

                            for (int i = 0; i < data.length; i++) {
                              await downloadFile(data[i], true);
                            }
                          },
                          label: const Text('Download All'))
                      : const SizedBox(height: 0, width: 0),
                ),
              ],
            ),
          ],
        ),
        downloadAll
            ? const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                  child: Text(
                    'You Selected Download All ',
                    style: TextStyle(
                      fontSize: 25,
                      color: buttonColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                itemCount: data.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: Container(
                      height: 55,
                      decoration: const BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12, right: 18),
                            child: Text(
                              '${index + 1} )',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: backgroundColor),
                            ),
                          ),
                          Expanded(
                              child: Text(
                            '${data[index]}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              // fontSize: 16,
                            ),
                          )),
                          Padding(
                            padding: const EdgeInsets.only(left: 12, right: 25),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white10,
                              ),
                              label: const Text('Download',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              onPressed: () async {
                                await downloadFile(data[index], false);
                                setState(() {
                                  data.removeAt(index);
                                });
                                // ElevatedButton.styleFrom()
                              },
                              icon: const Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ))
      ],
    );
  }
}

Future downloadFile(url, bool all) async {
  if (await canLaunchUrlString(url)) {
    if (all) {
      await launchUrlString(url);
    } else {
      await launchUrlString(url, webOnlyWindowName: '_self');
    }
  } else {
    throw 'Could not launch $url';
  }
}


// import 'package:detest/constant.dart';
// import 'package:flutter/material.dart';
// import 'dart:js' as js;

// class Download extends StatefulWidget {
//   final List<dynamic> data;
//   const Download({super.key, required this.data});

//   @override
//   State<Download> createState() => _DownloadState();
// }

// class _DownloadState extends State<Download> {
//   bool downloadAll = false;
//   List<dynamic> data = [];

//   // String get url => null;
//   @override
//   void initState() {
//     data = widget.data;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(
//           height: 50,
//         ),
//         Column(
//           children: [
//             const Text(
//               'Select to download! ',
//               style: TextStyle(
//                 fontSize: 25,
//                 color: buttonColor,
//                 fontWeight: FontWeight.w900,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 15, right: 15, bottom: 8),
//                   child: !downloadAll
//                       ? FloatingActionButton.extended(
//                           backgroundColor: buttonColor,
//                           onPressed: () async {
//                             setState(() {
//                               downloadAll = true;
//                             });

//                             for (int i = 0; i < data.length; i++) {
//                               js.context.callMethod('open', [data[i]]);
//                             }
//                             // js.context.callMethod('close');
//                           },
//                           label: const Text('Download All'))
//                       : const SizedBox(height: 0, width: 0),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         downloadAll
//             ? const Padding(
//                 padding: EdgeInsets.only(top: 50),
//                 child: Center(
//                   child: Text(
//                     'You Selected Download All ',
//                     style: TextStyle(
//                       fontSize: 25,
//                       color: buttonColor,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                 ),
//               )
//             : Expanded(
//                 child: ListView.builder(
//                 itemCount: data.length,
//                 itemBuilder: ((context, index) {
//                   return Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//                     child: Container(
//                       height: 55,
//                       decoration: const BoxDecoration(
//                         color: buttonColor,
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 12, right: 18),
//                             child: Text(
//                               '${index + 1} )',
//                               style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: backgroundColor
//                                   // fontSize: 16,
//                                   ),
//                             ),
//                           ),
//                           Expanded(
//                               child: Text(
//                             '${data[index]}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                               // fontSize: 16,
//                             ),
//                           )),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 12, right: 25),
//                             child: ElevatedButton.icon(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white10,
//                               ),
//                               label: const Text('Download',
//                                   style:
//                                       TextStyle(fontWeight: FontWeight.bold)),
//                               onPressed: () async {
//                                 js.context.callMethod('open', [data[index]]);
//                                 // js.context.callMethod('close');
//                                 setState(() {
//                                   data.removeAt(index);
//                                 });
//                               },
//                               icon: const Icon(
//                                 Icons.download,
//                                 color: backgroundColor,
//                                 size: 25,
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//               ))
//       ],
//     );
//   }
// }
