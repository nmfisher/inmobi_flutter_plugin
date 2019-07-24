import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inmobi_sdk_plugin/inmobi_sdk_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('inmobi_sdk_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await InmobiSdkPlugin.platformVersion, '42');
  });
}
