import 'native_time_zone_checker_platform_interface.dart';

class NativeTimeZoneChecker {
  Future<String?> getPlatformVersion() {
    return NativeTimeZoneCheckerPlatform.instance.getPlatformVersion();
  }

  Stream<bool?> get timeZone async* {
    yield* NativeTimeZoneCheckerPlatform.instance.timeZone();
  }
}
