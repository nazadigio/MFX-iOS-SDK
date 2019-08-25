//
//  MobFoxMoPubNativeAdRendererSettings.h
//  MFXTester
//
//  Created by ofirkariv on 10/07/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MoPubSDKFramework/MoPub.h>

NS_ASSUME_NONNULL_BEGIN

@interface MobFoxMoPubNativeAdRendererSettings : NSObject<MPNativeAdRendererSettings>

 @property (nonatomic, readonly) MPNativeViewSizeHandler viewSizeHandler;

@end

NS_ASSUME_NONNULL_END
