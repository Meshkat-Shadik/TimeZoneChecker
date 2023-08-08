import 'package:flutter/material.dart';
import 'package:native_time_zone_checker/native_time_zone_checker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _nativeTimeZoneCheckerPlugin = NativeTimeZoneChecker();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              StreamBuilder<bool?>(
                stream: _nativeTimeZoneCheckerPlugin.timeZone,
                builder: (context, snapshot) {
                  return Text('Running on: ${snapshot.data}\n');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
