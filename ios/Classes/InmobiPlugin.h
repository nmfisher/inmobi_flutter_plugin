#import <Flutter/Flutter.h>
#import "InMobiSDK.h"
@interface InmobiPlugin : NSObject<FlutterPlugin,IMInterstitialDelegate>
@property NSString* accountId;
@property (nonatomic, strong) IMInterstitial *interstitial;
@end
