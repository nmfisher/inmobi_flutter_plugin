import 'dart:async';

import 'package:flutter/services.dart';

class InMobiSDKPlugin {
  
  static const MethodChannel _channel = const MethodChannel('inmobi_sdk');

  static String _accountId;
  static int _interstitialId;

  static bool isAvailable = false;

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

    _channel.setMethodCallHandler(_platformCallHandler);
  }

  static Future loadInterstitial() async {
    isAvailable = false;
    print("Loading interstitial...");
    await _channel.invokeMethod('interstitial.load');
  }

  static Future showInterstitial() async {
    await _channel.invokeMethod('interstitial.show');
    isAvailable = false;
  }

  static Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "interstitial.adLoadSucceeded":
        print("Ad load succeeded");
        isAvailable = true;
        break;
      case "interstitial.adLoadFailed":
        print("Ad load failed");
        isAvailable = false;
        break;
      case "interstitial.adReceived":
        break;
      case "interstitial.adClicked":
        break;
      case "interstitial.adWillDisplay":
        break;
      case "interstitial.adDisplayed":
        break;
      case "interstitial.adDisplayFailed":
        break;
      case "interstitial.adDismissed":
        break;
      case "interstitial.userLeftApplication":
        break;
      case "interstitial.rewardsUnlocked":
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }
}
