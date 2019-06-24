package com.avinium.flutter.inmobi_sdk;

import com.inmobi.ads.InMobiAdRequestStatus;
import com.inmobi.ads.InMobiInterstitial;
import com.inmobi.ads.listeners.InterstitialAdEventListener;
import com.inmobi.sdk.InMobiSdk;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;
import android.app.Activity;

import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

class Interstitial {
  
  private boolean _loaded;
  InMobiInterstitial _interstitial;
  private final String TAG = Interstitial.class.getSimpleName();
  private AtomicInteger forcedRetry = new AtomicInteger(0);
  
  public Interstitial(Activity activity, long placementId) {
    _interstitial = new InMobiInterstitial(
      activity, 
      placementId, 
      new InterstitialAdEventListener() {
        @Override
        public void onAdLoadSucceeded(InMobiInterstitial inMobiInterstitial) {
            super.onAdLoadSucceeded(inMobiInterstitial);
            Log.d(TAG, "onAdLoadSuccessful");
        }

        @Override
        public void onAdLoadFailed(InMobiInterstitial inMobiInterstitial, InMobiAdRequestStatus inMobiAdRequestStatus) {
            super.onAdLoadFailed(inMobiInterstitial, inMobiAdRequestStatus);
            Log.d(TAG, "Unable to load interstitial ad (error message: " +
                    inMobiAdRequestStatus.getMessage());
        }

        @Override
        public void onAdReceived(InMobiInterstitial inMobiInterstitial) {
            super.onAdReceived(inMobiInterstitial);
            Log.d(TAG, "onAdReceived");
        }

        @Override
        public void onAdClicked(InMobiInterstitial inMobiInterstitial, Map<Object, Object> map) {
            super.onAdClicked(inMobiInterstitial, map);
            Log.d(TAG, "onAdClicked " + map.size());
        }

        @Override
        public void onAdWillDisplay(InMobiInterstitial inMobiInterstitial) {
            super.onAdWillDisplay(inMobiInterstitial);
            Log.d(TAG, "onAdWillDisplay " + inMobiInterstitial);
        }

        @Override
        public void onAdDisplayed(InMobiInterstitial inMobiInterstitial) {
            super.onAdDisplayed(inMobiInterstitial);
            Log.d(TAG, "onAdDisplayed " + inMobiInterstitial);
        }

        @Override
        public void onAdDisplayFailed(InMobiInterstitial inMobiInterstitial) {
            super.onAdDisplayFailed(inMobiInterstitial);
            Log.d(TAG, "onAdDisplayFailed " + "FAILED");
        }

        @Override
        public void onAdDismissed(InMobiInterstitial inMobiInterstitial) {
            super.onAdDismissed(inMobiInterstitial);
            Log.d(TAG, "onAdDismissed " + inMobiInterstitial);
        }

        @Override
        public void onUserLeftApplication(InMobiInterstitial inMobiInterstitial) {
            super.onUserLeftApplication(inMobiInterstitial);
            Log.d(TAG, "onUserWillLeaveApplication " + inMobiInterstitial);
        }

        @Override
        public void onRewardsUnlocked(InMobiInterstitial inMobiInterstitial, Map<Object, Object> map) {
            super.onRewardsUnlocked(inMobiInterstitial, map);
            Log.d(TAG, "onRewardsUnlocked " + map.size());
        }
      }
    );
  }

  public void load() {
    _interstitial.load();
    _loaded = true;
  }

  public void show() throws Exception {
    if(!_loaded)
      throw new Exception("No interstitial has been loaded. A single interstitial object cannot be shown more than once, and instances are unloaded after being shown. You must therefore first invoke interstitial.load, then invoke interstitial.show, every time you want to display an interstitial.");
    _interstitial.show();
    _loaded = false;
  }

}