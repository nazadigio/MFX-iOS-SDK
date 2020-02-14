 //
//  MobFoxMoPubNativeCustomEvent.h
//  DemoApp
//
//  
//  Copyright © 2019 MobFox. All rights reserved.
//


#import <Foundation/Foundation.h>
#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#elif __has_include(<MoPub.h>)
#import <MoPub.h>
#else
#import "MPNativeCustomEvent.h"
#endif
#import "MFXSDKCore/MFXSDKCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface MobFoxMoPubNativeCustomEvent : MPNativeCustomEvent <MFXNativeAdDelegate>

@property (nonatomic, strong) MFXNativeAd* ad;
@property (nonatomic, strong) NSString *adUnit;

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info;

- (void)nativeAdLoadFailed:(MFXNativeAd *_Nullable)native withError:(NSString*)error;
- (void)nativeAdLoaded:(MFXNativeAd *)native;
- (void)nativeAdImagesReady:(MFXNativeAd *)native;
- (void)nativeAdClicked:(MFXNativeAd *)native;



NS_ASSUME_NONNULL_END

@end
