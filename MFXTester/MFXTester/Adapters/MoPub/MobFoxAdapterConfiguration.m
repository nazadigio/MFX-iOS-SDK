//
//  MobFoxAdapterConfiguration.m
//  DemoApp
//
//  
//  Copyright © 2019 Mobfox Ltd. All rights reserved.
//

#import "MobFoxAdapterConfiguration.h"

@implementation MobFoxAdapterConfiguration

- (NSString *)adapterVersion {
    return [MobFoxSDK sdkVersion];
}
    
- (NSString *) biddingToken {
    return nil;
}
    
- (NSString *) moPubNetworkName {
    return @"mobfox";
}

- (NSString *)networkSdkVersion {
    return [MobFoxSDK sdkVersion];
}
    
- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *, id> * _Nullable)configuration
                                  complete:(void(^ _Nullable)(NSError * _Nullable))complete
{
    [MobFoxSDK sharedInstance];
    if (complete != nil) {
        complete(nil);
    }
}
    
@end
