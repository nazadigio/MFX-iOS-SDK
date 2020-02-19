//
//  MobFoxAdapterConfiguration.h
//  DemoApp
//
//  
//  Copyright © 2019 Mobfox Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#elif __has_include(<MoPub.h>)
#import <MoPub.h>
#else
#import "MPBaseAdapterConfiguration.h"
#endif
#import "MFXSDKCore/MFXSDKCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface MobFoxAdapterConfiguration : MPBaseAdapterConfiguration
    
@property (nonatomic, copy, readonly) NSString * adapterVersion;
@property (nonatomic, copy, readonly) NSString * biddingToken;
@property (nonatomic, copy, readonly) NSString * moPubNetworkName;
@property (nonatomic, copy, readonly) NSString * networkSdkVersion;

- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *, id> * _Nullable)configuration
                                  complete:(void(^ _Nullable)(NSError * _Nullable))complete;

@end

NS_ASSUME_NONNULL_END
