# inmobi_plugin

A Flutter plugin for the [InMobi](https://github.com/InMobi) advertising SDK.

## Getting Started

### pubspec.yaml

Add the following to your dependencies:

```
inmobi_sdk_plugin: 
  git:
    url: git://github.com/nmfisher/inmobi_flutter_plugin
```
### Configure

Currently, only interstitial ads are supported.

When your app loads, you must configure the plugin with your InMobi account ID, and the placement ID for your interstitial ad.

```await InMobiPlugin.configure(accountId, interstitialId) ```

Note that interstitialId must be provided as an integer literal (i.e. not as a string).

### Load/display an interstitial ad

To *load* an interstitial ad, call the loadInterstitial method:

```await InMobiPlugin.Future loadInterstitial();```

To *show* the ad, you can then invoke the showInterstitial method:

```await InMobiPlugin.Future showInterstitial();```

By keeping ad load and display separate, you can manually manage the round-trip delay when fetching an ad. For example, in a side-scroller game, an ad can be loaded at when the user starts a level, with display deferred until the user completes the level. This avoids a noticeable pause at the end of the level while the API fetches the ad.

Note you need to call loadInterstitial() prior to every invocation of showInterstitial(). Calling showInterstitial() twice (or more) without first invoking loadInterstitial() will throw an exception.


