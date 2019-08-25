#ifndef MoPubAdapterMobFox_h
#define MoPubAdapterMobFox_h

#import <MFXSDKCore/MFXSDKCore.h>
#import <MoPubSDKFramework/MoPub.h>

@interface MoPubAdapterMobFox : MPBannerCustomEvent <MFXBannerAdDelegate>

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info;

//- (BOOL)enableAutomaticImpressionAndClickTracking;

@end

#endif
