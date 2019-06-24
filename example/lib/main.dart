import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:inmobi_sdk/inmobi_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  String _platformVersion = 'Unknown';
  bool isAvailable = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await InMobiSDK.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
    InMobiSDK.configure("accountId", "placementId");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children:[
            RaisedButton(child:Text('Load interstitial'),onPressed:() async {
              InMobiSDK.loadInterstitial(); 
              isAvailable = await Future.delayed(Duration(seconds:5), () => InMobiSDK.isAvailable);
              setState(() { });
            }),
            RaisedButton(child:Text(isAvailable ? 'Show interstitial' : 'Interstitial not available'),onPressed:() {
              InMobiSDK.showInterstitial(); 
            })
          ]
        ),
      ),
    );
  }
}
