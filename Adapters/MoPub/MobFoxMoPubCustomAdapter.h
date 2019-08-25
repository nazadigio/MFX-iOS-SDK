//
//  MobFoxMoPubCustomAdapter.h
//  DemoApp
//
//  
//  Copyright © 2019 Mobfox Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MoPubSDKFramework/MoPub.h>
#import "MFXSDKCore/MFXSDKCore.h"


@interface MobFoxMoPubCustomAdapter : NSObject <MPNativeAdAdapter>
@property (nonatomic, strong) NSMutableDictionary *localProperties;



- (instancetype)initWithAd:(NSDictionary *)ad;


@end
