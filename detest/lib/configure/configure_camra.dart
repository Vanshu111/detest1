import 'package:flutter/material.dart';

class ConfigureCamera extends StatelessWidget {
  final String deviceId;

  const ConfigureCamera({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Camera'),
    );
  }
}
