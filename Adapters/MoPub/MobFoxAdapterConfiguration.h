//
//  MobFoxAdapterConfiguration.h
//  DemoApp
//
//  
//  Copyright © 2019 Mobfox Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MoPubSDKFramework/MoPub.h>
#import "MFXSDKCore/MFXSDKCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface MobFoxAdapterConfiguration : MPBaseAdapterConfiguration
    
@property (nonatomic, copy, readonly) NSString * adapterVersion;
@property (nonatomic, copy, readonly) NSString * biddingToken;
@property (nonatomic, copy, readonly) NSString * moPubNetworkName;
@property (nonatomic, copy, readonly) NSString * networkSdkVersion;

@end

NS_ASSUME_NONNULL_END
