import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_time_zone_checker_method_channel.dart';

abstract class NativeTimeZoneCheckerPlatform extends PlatformInterface {
  /// Constructs a NativeTimeZoneCheckerPlatform.
  NativeTimeZoneCheckerPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeTimeZoneCheckerPlatform _instance =
      MethodChannelNativeTimeZoneChecker();

  /// The default instance of [NativeTimeZoneCheckerPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeTimeZoneChecker].
  static NativeTimeZoneCheckerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeTimeZoneCheckerPlatform] when
  /// they register themselves.
  static set instance(NativeTimeZoneCheckerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Stream<bool?> timeZone() {
    throw UnimplementedError('timeZone() has not been implemented.');
  }
}
