//
//  MobFoxMoPubCustomAdapter.h
//  DemoApp
//
//  
//  Copyright © 2019 Mobfox Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#elif __has_include(<MoPub.h>)
#import <MoPub.h>
#else
#import "MPNativeAdAdapter.h"
#endif
#import "MFXSDKCore/MFXSDKCore.h"


@interface MobFoxMoPubCustomAdapter : NSObject <MPNativeAdAdapter>
@property (nonatomic, strong) NSMutableDictionary *localProperties;



- (instancetype)initWithAd:(NSDictionary *)ad;


@end
