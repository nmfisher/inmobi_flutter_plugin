#import "InmobiPlugin.h"

@implementation InmobiPlugin

@synthesize accountId;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"inmobi_plugin"
            binaryMessenger:[registrar messenger]];
  InmobiPlugin* instance = [[InmobiPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

/*Indicates that the interstitial is ready to be shown */
- (void)interstitialDidFinishLoading:(IMInterstitial *)interstitial {
    NSLog(@"interstitialDidFinishLoading");
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self.interstitial showFromViewController:viewController withAnimation:kIMInterstitialAnimationTypeCoverVertical];
    NSLog(@"shown");
}

/* Indicates that the interstitial has failed to receive an ad. */
- (void)interstitial:(IMInterstitial *)interstitial didFailToLoadWithError:(IMRequestStatus *)error {
    NSLog(@"Interstitial failed to load ad");
    NSLog(@"Error : %@",error.description);
}
/* Indicates that the interstitial has failed to present itself. */
- (void)interstitial:(IMInterstitial *)interstitial didFailToPresentWithError:(IMRequestStatus *)error {
    NSLog(@"Interstitial didFailToPresentWithError");
    NSLog(@"Error : %@",error.description);
}
/* indicates that the interstitial is going to present itself. */
- (void)interstitialWillPresent:(IMInterstitial *)interstitial {
    NSLog(@"interstitialWillPresent");
}
/* Indicates that the interstitial has presented itself */
- (void)interstitialDidPresent:(IMInterstitial *)interstitial {
    NSLog(@"interstitialDidPresent");
}
/* Indicates that the interstitial is going to dismiss itself. */
- (void)interstitialWillDismiss:(IMInterstitial *)interstitial {
    NSLog(@"interstitialWillDismiss");
}
/* Indicates that the interstitial has dismissed itself. */
- (void)interstitialDidDismiss:(IMInterstitial *)interstitial {
    NSLog(@"interstitialDidDismiss");
}
/* Indicates that the user will leave the app. */
- (void)userWillLeaveApplicationFromInterstitial:(IMInterstitial *)interstitial {
    NSLog(@"userWillLeaveApplicationFromInterstitial");
}
/* interstitial:didInteractWithParams: Indicates that the interstitial was interacted with. */
- (void)interstitial:(IMInterstitial *)interstitial didInteractWithParams:(NSDictionary *)params {
    NSLog(@"InterstitialDidInteractWithParams");
}

- (void)interstitialDidReceiveAd:(IMInterstitial *)interstitial {
    NSLog(@"interstitialDidReceiveAd");
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"configure" isEqualToString:call.method]) {
      NSMutableDictionary *consentdict=[[NSMutableDictionary alloc]init];
      //consent value needs to be collected from the end user
      [consentdict setObject:@"true" forKey:IM_GDPR_CONSENT_AVAILABLE];
      [consentdict setObject:@1 forKey:@"gdpr"];
      //Initialize InMobi SDK with your account ID
      accountId = call.arguments[@"accountId"];
      [IMSdk initWithAccountID:accountId consentDictionary:consentdict];
      NSNumber* placementId = call.arguments[@"placementId"];
      NSLog(@"Initializing with accountId %s and placementId %@", [accountId UTF8String], placementId);
      long long placementId_long = [placementId longValue];
      NSLog(@"Initializing interstitial with placementId: %lld",placementId_long );
      self.interstitial = [[IMInterstitial alloc] initWithPlacementId:placementId_long];
      self.interstitial.delegate = self;
      result(nil);
  } else if ([@"interstitial.show" isEqualToString:call.method]) {
      @try {
	    [self.interstitial load];
          result(nil);
          //if ([viewController isKindOfClass:[UINavigationController class]]) {
      //        [((UINavigationController*)viewController) popViewControllerAnimated:NO];
       //   }
        } @catch (NSException *exception) {
              NSLog(@"NSException : %@", exception.name);
              NSLog(@"Reason : %@", exception.reason);
              result(false);
        }
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
