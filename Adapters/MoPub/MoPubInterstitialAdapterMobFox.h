
#ifndef MoPubInterstitialAdapterMobFox_h
#define MoPubInterstitialAdapterMobFox_h

#import <MFXSDKCore/MFXSDKCore.h>
#import <MoPubSDKFramework/MoPub.h>

@interface MoPubInterstitialAdapterMobFox : MPInterstitialCustomEvent<MFXInterstitialAdDelegate>

@property (strong, nonatomic) MFXInterstitialAd* mobFoxInterAd;

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info;

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController;

//- (BOOL)enableAutomaticImpressionAndClickTracking;


@end

#endif
