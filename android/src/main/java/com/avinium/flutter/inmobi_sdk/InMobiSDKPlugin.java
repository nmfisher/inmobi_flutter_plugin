package com.avinium.flutter.inmobi_sdk;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import org.json.JSONException;
import org.json.JSONObject;

import com.inmobi.sdk.InMobiSdk;

import java.util.ArrayList;
import java.util.Locale;
import java.lang.Long;

/**
 * InMobiSDKPlugin
 */
public class InMobiSDKPlugin implements MethodCallHandler {

    private MethodChannel _channel;
    private Activity _activity;

    private Interstitial _interstitial;

    private final String TAG = InMobiSDKPlugin.class.getSimpleName();


    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "inmobi_sdk");
        channel.setMethodCallHandler(new InMobiSDKPlugin(registrar.activity(), channel));
    }

    private InMobiSDKPlugin(Activity activity, MethodChannel channel) {
      _channel = channel;
      _activity = activity;
    }

    private void configure(String accountId, long placementId) {
      InMobiSdk.setLogLevel(InMobiSdk.LogLevel.DEBUG);
      JSONObject consentObject = new JSONObject();
      try {
        Log.d(TAG, "Configuring InMobiSDK plugin with accountId " + accountId + " and interstitial placement id " + String.valueOf(placementId));
        // Provide correct consent value to sdk which is obtained by User
        consentObject.put(InMobiSdk.IM_GDPR_CONSENT_AVAILABLE, true);
        // Provide 0 if GDPR is not applicable and 1 if applicable 
        consentObject.put("gdpr", "0");
        InMobiSdk.init(_activity, accountId, consentObject);
        _interstitial = new Interstitial(_activity, placementId, _channel);
        Log.d(TAG, "InMobiSDK configuration complete.");
      } catch (JSONException e) {
         e.printStackTrace();
      }
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
      switch (call.method) {
        case "getPlatformVersion":
          result.success("Android " + android.os.Build.VERSION.RELEASE);
          break;
        case "configure":
          if(call.argument("accountId") == null) {
            result.error("ArgumentError", "AccountID must not be null.", null);
          } else if(call.argument("placementId") == null) {
            result.error("ArgumentError", "PlacementID must not be null.", null);
          } else {
            configure(call.argument("accountId").toString(), Long.parseLong(call.argument("placementId").toString()));
            result.success(true);
          }
          break;
        case "interstitial.load":
          _interstitial.load();
          result.success(true);
          break;
        case "interstitial.show":
          try {
            _interstitial.show();
            result.success(true);
          } catch(Exception e) {
            result.error("UnknownException", e.toString(), null);
          }
          break;
        default:
          result.notImplemented();
          break;
      }
    }

    
}
