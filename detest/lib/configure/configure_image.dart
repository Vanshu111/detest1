import 'dart:convert';
// import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../constant.dart';
import 'package:http/http.dart' as http;

class ConfigureImage extends StatefulWidget {
  final String deviceId;
  final String userName;

  const ConfigureImage(
      {super.key, required this.deviceId, required this.userName});

  @override
  State<ConfigureImage> createState() => _ConfigureImageState();
}

class _ConfigureImageState extends State<ConfigureImage> {
  String apiResponse = '';
  String imageUrl = '';

  Future<void> getImage() async {
    setState(() {
      apiResponse = 'wait';
    });
    final response = await http.get(
      Uri.parse(
          'https://4k5m4b6lha.execute-api.us-east-1.amazonaws.com/image?deviceid=${widget.deviceId}&user=${widget.userName}'),
    );
    if (response.statusCode == 200) {
      // print(response.body);

      int count = 0;
      String result = '';

      while (count < 5) {
        // print('=======count========$count');
        await Future<void>.delayed(const Duration(seconds: 10));
        result = await getImageUrl();

        if (result != 'NotFound') {
          setState(() {
            apiResponse = 'urlFound';
            imageUrl = result;
          });
          break;
        }
        count++;
      }
      if (count >= 5) {
        setState(() {
          apiResponse = '';
          imageUrl = result;
        });
      }
    } else {
      throw Exception('Failed to load api');
    }
  }

  Future<String> getImageUrl() async {
    final response = await http.get(
      Uri.parse(
          'https://2ph5cnqbn4.execute-api.us-east-1.amazonaws.com/image?deviceId=${widget.deviceId}'),
    );
    if (response.statusCode == 200) {
      // imageUrl
      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load api');
    }
  }

  Widget imageStatus(BuildContext context) {
    if (apiResponse == '' && imageUrl == '') {
      return SizedBox(
        child: Icon(
          Icons.linked_camera_rounded,
          size: 200,
          color: Colors.grey[800],
        ),
      );
    } else if (imageUrl == 'NotFound') {
      return Stack(
        children: [
          Image.asset(
            'assets/images/capture.jpg',
          ),
          Positioned(
              bottom: 15,
              left: 15,
              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.error,
                      color: borderColor,
                    ),
                  ),
                  Text(
                    'F a i l e d',
                    style: TextStyle(fontSize: 22, color: backgroundColor),
                  ),
                ],
              ))
        ],
      );
    } else if (apiResponse == 'wait') {
      return Stack(
        children: [
          // Image.asset('images/capture.jpg'),
          Image.asset('assets/images/capture.jpg'),
          const Positioned(
              bottom: 15,
              left: 15,
              child: Text(
                'C a p t u r i n g ... ',
                style: TextStyle(fontSize: 22, color: backgroundColor),
              ))
        ],
      );
    } else if (imageUrl != 'NotFound' && imageUrl != '') {
      // print(imageUrl);
      imageCache.clear();
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.network(
          imageUrl,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: Text('Loading...'));
          },
        ),
      );
    }
    return const Center(
      child: Text('Something went wrrong!'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: imageUrl == '' || apiResponse == 'wait' ? 450 : 750,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                child: Card(
                  color: Colors.green[50],
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        'Device Id : ${widget.deviceId}',
                        style: const TextStyle(
                          fontSize: 22,
                          color: buttonColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 20),
                      imageStatus(context),
                      const SizedBox(height: 20),
                      apiResponse == 'wait'
                          ? const CircularProgressIndicator(color: borderColor)
                          : MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: buttonColor,
                              onPressed: getImage,
                              child: const Text('G E T   I M A G E',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: backgroundColor,
                                    fontWeight: FontWeight.w900,
                                  )),
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
