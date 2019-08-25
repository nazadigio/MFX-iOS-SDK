 //
//  MobFoxMoPubNativeCustomEvent.h
//  DemoApp
//
//  
//  Copyright © 2019 MobFox. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MoPubSDKFramework/MoPub.h>
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
