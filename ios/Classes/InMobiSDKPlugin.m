#import "InMobiSDKPlugin.h"

@implementation InMobiSDKPlugin

@synthesize accountId;

static FlutterMethodChannel *channel;

+ (FlutterMethodChannel*) channel { return channel; }
+ (void) setChannel:(FlutterMethodChannel*)value { channel = value; }


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    channel = [FlutterMethodChannel methodChannelWithName:@"inmobi_sdk" binaryMessenger:[registrar messenger]];
    InMobiSDKPlugin* instance = [[InMobiSDKPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

/*Indicates that the interstitial is ready to be shown */
- (void)interstitialDidFinishLoading:(IMInterstitial *)interstitial {
    NSLog(@"interstitialDidFinishLoading");
    [channel invokeMethod:@"interstitial.adLoadSucceeded" arguments:nil];
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
    [channel invokeMethod:@"interstitial.adLoadFailed" arguments:nil];
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
    [channel invokeMethod:@"interstitial.adReceived" arguments:nil];
}

- (void)loadInterstitial {
  [self.interstitial load];
}

- (void)showInterstitial {
  if(self.interstitial == nil) {
    [NSException raise:@"InterstitialLoadException" format:@"Interstitial has not been loaded. "];
  } else {
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self.interstitial showFromViewController:viewController withAnimation:kIMInterstitialAnimationTypeCoverVertical];
  }
}

- (void)configureWithAccountId:(NSString *)accountId placementId:(NSNumber*)placementId {
    //consent value needs to be collected from the end user
    NSMutableDictionary *consentdict=[[NSMutableDictionary alloc]init];
    [consentdict setObject:@"true" forKey:IM_GDPR_CONSENT_AVAILABLE];
    [consentdict setObject:@1 forKey:@"gdpr"];  
    
    //Initialize InMobi SDK with your account ID
    self.accountId = accountId;
    [IMSdk initWithAccountID:accountId consentDictionary:consentdict];
    NSLog(@"Initializing with accountId %s and placementId %@", [accountId UTF8String], placementId);
    long long placementId_long = [placementId longValue];
    NSLog(@"Initializing interstitial with placementId: %lld",placementId_long );
    self.interstitial = [[IMInterstitial alloc] initWithPlacementId:placementId_long];
    self.interstitial.delegate = self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    @try {
      if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
      } else if ([@"configure" isEqualToString:call.method]) {
        [self configureWithAccountId:call.arguments[@"accountId"] placementId:call.arguments[@"placementId"]];
        result(nil);
      } else if ([@"interstitial.load" isEqualToString:call.method]) {      
        [self loadInterstitial];
        result(nil);
      } else if ([@"interstitial.show" isEqualToString:call.method]) {
        [self showInterstitial];
        result(nil);  
      } else {
        result(FlutterMethodNotImplemented);
      }
    } @catch (NSException *exception) {
      NSLog(@"NSException : %@", exception.name);
      NSLog(@"Reason : %@", exception.reason);
      result(false);
    }
}

@end
