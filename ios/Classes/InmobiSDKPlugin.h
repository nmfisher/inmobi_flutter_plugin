#import <Flutter/Flutter.h>
#import <InMobiSDK/InMobiSDK.h>
@interface InmobiPlugin : NSObject<FlutterPlugin,IMInterstitialDelegate>
@property NSString* accountId;
@property (nonatomic, strong) IMInterstitial *interstitial;

- (void)loadInterstitial;
- (void)showInterstitial;
@end
