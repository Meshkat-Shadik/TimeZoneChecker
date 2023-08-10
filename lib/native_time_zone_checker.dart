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

  Future<bool> getIsTimeSetToAutomaticByNetwork() {
    throw UnimplementedError(
        'getIsTimeSetToAutomatic() has not been implemented.');
  }

  Future<bool> getIsTimeZoneSetToAutomaticByNetwork() {
    throw UnimplementedError(
        'getIsTimeZoneSetToAutomatic() has not been implemented.');
  }

  Future<bool> getBothTimeAndZoneSetToAutomaticByNetwork() {
    throw UnimplementedError(
        'getIsTimeZoneSetToAutomaticByNetwork() has not been implemented.');
  }

  Stream<bool?> watchTimeAndZoneAutomaticByNetwork() {
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
  Future<bool> getIsTimeSetToAutomaticByNetwork() async {
    final isTimeSetToAutomaticByNetwork =
        await methodChannel.invokeMethod<bool>('getIsTimeSetToAutomatic');
    return isTimeSetToAutomaticByNetwork!;
  }

  @override
  Future<bool> getIsTimeZoneSetToAutomaticByNetwork() async {
    final isTimeZoneSetToAutomaticByNetwork =
        await methodChannel.invokeMethod<bool>('getIsTimeZoneSetToAutomatic');
    return isTimeZoneSetToAutomaticByNetwork!;
  }

  @override
  Future<bool> getBothTimeAndZoneSetToAutomaticByNetwork() async {
    final isBothTimeAndZoneSetToAutomaticByNetwork = await methodChannel
        .invokeMethod<bool>('getBothTimeAndTimeZoneIsAutomatic');
    return isBothTimeAndZoneSetToAutomaticByNetwork!;
  }

  @override
  Stream<bool?> watchTimeAndZoneAutomaticByNetwork() async* {
    subscription = eventChannel.receiveBroadcastStream().listen((event) {
      _timeController.add(event);
    });
    yield* _timeController.stream;
  }
}

class NativeTimeZoneChecker {
  Future<bool> getIsTimeSetToAutomaticByNetwork() {
    return _NativeTimeZoneCheckerPlatform.instance
        .getIsTimeSetToAutomaticByNetwork();
  }

  Future<bool> getIsTimeZoneSetToAutomaticByNetwork() {
    return _NativeTimeZoneCheckerPlatform.instance
        .getIsTimeZoneSetToAutomaticByNetwork();
  }

  Future<bool> getBothTimeAndZoneSetToAutomaticByNetwork() {
    return _NativeTimeZoneCheckerPlatform.instance
        .getBothTimeAndZoneSetToAutomaticByNetwork();
  }

  Stream<bool?> get watchTimeAndZoneAutomaticByNetwork async* {
    yield* _NativeTimeZoneCheckerPlatform.instance
        .watchTimeAndZoneAutomaticByNetwork();
  }
}
