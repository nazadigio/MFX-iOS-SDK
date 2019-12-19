//
//  MobFoxMoPubRewardedVideoCustomEvent.h
//  MFXTester
//
//  Created by Michael Kessler on 09/12/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#else
#import "MPNativeCustomEvent.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface MobFoxMoPubRewardedVideoCustomEvent : MPRewardedVideoCustomEvent

@end

NS_ASSUME_NONNULL_END
