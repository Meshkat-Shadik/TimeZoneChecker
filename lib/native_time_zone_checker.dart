import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class _NativeTimeZoneCheckerPlatform extends PlatformInterface {
  /// Constructs a NativeTimeZoneCheckerPlatform.
  _NativeTimeZoneCheckerPlatform() : super(token: _token);

  static final Object _token = Object();

  static final _NativeTimeZoneCheckerPlatform _instance =
      _MethodChannelNativeTimeZoneChecker();

  /// The default instance of [NativeTimeZoneCheckerPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeTimeZoneChecker].
  static _NativeTimeZoneCheckerPlatform get instance => _instance;

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Stream<bool?> timeZone() {
    throw UnimplementedError('timeZone() has not been implemented.');
  }
}

class _MethodChannelNativeTimeZoneChecker
    extends _NativeTimeZoneCheckerPlatform {
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

class NativeTimeZoneChecker {
  Future<String?> getPlatformVersion() {
    return _NativeTimeZoneCheckerPlatform.instance.getPlatformVersion();
  }

  Stream<bool?> get timeZone async* {
    yield* _NativeTimeZoneCheckerPlatform.instance.timeZone();
  }
}
