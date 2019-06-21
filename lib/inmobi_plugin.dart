import 'dart:async';

import 'package:flutter/services.dart';

class InMobiPlugin {
  static const MethodChannel _channel =
      const MethodChannel('inmobi_plugin');

  static String _accountId;
  static String _interstitialId;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future configure(String accountId, String interstitialId) async {
    if(_accountId != null || _interstitialId != null)
      throw Exception("AccountId already configured");
    await _channel.invokeMethod('configure', {"accountId":_accountId});
    _interstitialId = interstitialId;
  }

  static Future showInterstitial() async {
    await _channel.invokeMethod('interstitial.show', {"placementId":_interstitialId});
  }
}
