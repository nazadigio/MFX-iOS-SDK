//
//  MobFoxMoPubNativeAdRendererSettings.h
//  MFXTester
//
//  Created by ofirkariv on 10/07/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#else
#import "MPNativeAdRenderer.h"
#import "MPNativeAdRendererSettings.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface MobFoxMoPubNativeAdRendererSettings : NSObject<MPNativeAdRendererSettings>

 @property (nonatomic, readonly) MPNativeViewSizeHandler viewSizeHandler;

@end

NS_ASSUME_NONNULL_END
