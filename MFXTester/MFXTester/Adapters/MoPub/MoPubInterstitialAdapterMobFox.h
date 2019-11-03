
#ifndef MoPubInterstitialAdapterMobFox_h
#define MoPubInterstitialAdapterMobFox_h

#import <MFXSDKCore/MFXSDKCore.h>
#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#else
#import "MPInterstitialCustomEvent.h"
#endif

@interface MoPubInterstitialAdapterMobFox : MPInterstitialCustomEvent<MFXInterstitialAdDelegate>

@property (strong, nonatomic) MFXInterstitialAd* mobFoxInterAd;

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info;

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController;

//- (BOOL)enableAutomaticImpressionAndClickTracking;


@end

#endif
