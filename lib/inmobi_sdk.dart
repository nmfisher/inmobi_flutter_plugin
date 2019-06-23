import 'dart:async';

import 'package:flutter/services.dart';

class InMobiSDK {
  static const MethodChannel _channel =
      const MethodChannel('inmobi_plugin');

  static String _accountId;
  static int _interstitialId;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void configure(String accountId, int interstitialId) async {
    if(_accountId != null || _interstitialId != null)
      throw Exception("AccountId already configured");
    _accountId = accountId;
    _interstitialId = interstitialId;
    await _channel.invokeMethod('configure', {"accountId":_accountId, "placementId":_interstitialId});

  }

  static Future loadInterstitial() async {
    await _channel.invokeMethod('interstitial.load');
  }

  static Future showInterstitial() async {
    await _channel.invokeMethod('interstitial.show');
  }
}
