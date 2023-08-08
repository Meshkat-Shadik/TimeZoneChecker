import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_time_zone_checker_platform_interface.dart';

/// An implementation of [NativeTimeZoneCheckerPlatform] that uses method channels.
class MethodChannelNativeTimeZoneChecker extends NativeTimeZoneCheckerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_time_zone_checker');
  final eventChannel =
      const EventChannel('com.example.native_time_zone_checker/event');

  final StreamController<bool> _timeController =
      StreamController<bool>.broadcast();
  Stream<bool> get time => _timeController.stream;
  StreamSubscription? subscription;

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Stream<bool?> timeZone() async* {
    subscription = eventChannel.receiveBroadcastStream().listen((event) {
      _timeController.add(event);
    });
    yield* _timeController.stream;
  }
}
