import 'package:flutter_test/flutter_test.dart';
import 'package:native_time_zone_checker/native_time_zone_checker.dart';
import 'package:native_time_zone_checker/native_time_zone_checker_platform_interface.dart';
import 'package:native_time_zone_checker/native_time_zone_checker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNativeTimeZoneCheckerPlatform
    with MockPlatformInterfaceMixin
    implements NativeTimeZoneCheckerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Stream<bool?> timeZone() {
    // TODO: implement timeZone
    throw UnimplementedError();
  }
}

void main() {
  final NativeTimeZoneCheckerPlatform initialPlatform =
      NativeTimeZoneCheckerPlatform.instance;

  test('$MethodChannelNativeTimeZoneChecker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNativeTimeZoneChecker>());
  });

  test('getPlatformVersion', () async {
    NativeTimeZoneChecker nativeTimeZoneCheckerPlugin = NativeTimeZoneChecker();
    MockNativeTimeZoneCheckerPlatform fakePlatform =
        MockNativeTimeZoneCheckerPlatform();
    NativeTimeZoneCheckerPlatform.instance = fakePlatform;

    expect(await nativeTimeZoneCheckerPlugin.getPlatformVersion(), '42');
  });
}
