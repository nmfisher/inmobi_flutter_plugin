import 'dart:async';

import 'package:flutter/services.dart';

class InmobiPlugin {
  static const MethodChannel _channel =
      const MethodChannel('inmobi_plugin');

  static String accountId;
  static String interstitialId;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future configure(String accountId, String interstitialId) async {
    if(accountId != null || interstitialId != null)
      throw Exception("AccountId already configured");
    await _channel.invokeMethod('configure', {"accountId":accountId});
    this.interstitialId = interstitialId;
  }

  static Future showInterstitial() async {
    await _channel.invokeMethod('interstitial.show', {"placementId":this.interstitialId});
  }
}
