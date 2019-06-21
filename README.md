# inmobi_plugin

A Flutter plugin for the [InMobi] (https://github.com/InMobi) advertising SDK.

## Getting Started

### pubspec.yaml

Add the following to your dependencies:

inmobi_sdk: 
  git:
    url: git://github.com/nmfisher/inmobi_flutter_plugin

### Configure

Currently, only interstitial ads are supported.

When your app loads, you *must* configure the plugin with your InMobi account ID, and the placement ID for your interstitial ad.

```await InMobiPlugin.configure(accountId, interstitialId) ```

To show the interstitial ad, invoke the following:

```await InMobiPlugin.Future showInterstitial();```
