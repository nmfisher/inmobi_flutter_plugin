#import <Flutter/Flutter.h>
#import <InMobiSDK/InMobiSDK.h>

@interface InMobiSDKPlugin : NSObject<FlutterPlugin,IMInterstitialDelegate>

@property NSString* accountId;

@property (nonatomic, strong) IMInterstitial *interstitial;

- (void)loadInterstitial;
- (void)showInterstitial;
@end
