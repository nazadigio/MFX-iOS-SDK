//
//  GADMMobFoxMediationAdapter.m
//  MFXTester
//
//  Created by Michael Kessler on 04/12/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import "GADMMobFoxMediationAdapter.h"
#import <MFXSDKCore/MobFoxSDK.h>
#import "MFAdNetworkExtras.h"
#import "GADMMobFoxRewardedAd.h"

@interface GADMMobFoxMediationAdapter()
@property (nonatomic, strong) GADMMobFoxRewardedAd *rewardedAd;
@end

@implementation GADMMobFoxMediationAdapter

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration
             completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler {
    [MobFoxSDK sharedInstance];
    completionHandler(nil);
}

/// Returns the adapter version.
+ (GADVersionNumber)version {
    return [GADMMobFoxMediationAdapter GADVersionNumberFromString:[MobFoxSDK sdkVersion]];// TODO: Manage a separate version for the adapter?
}

/// Returns the ad SDK version.
+ (GADVersionNumber)adSDKVersion {
    return [GADMMobFoxMediationAdapter GADVersionNumberFromString:[MobFoxSDK sdkVersion]];
}

+ (GADVersionNumber)GADVersionNumberFromString:(NSString *)vesionString {
    NSArray *versionComponents = [[MobFoxSDK sdkVersion] componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count > 0) {
        version.majorVersion = [versionComponents[0] integerValue];
    }
    if (versionComponents.count > 1) {
        version.minorVersion = [versionComponents[1] integerValue];
    }
    if (versionComponents.count > 2) {
        version.patchVersion = [versionComponents[2] integerValue];
    }
    return version;
}

/// The extras class that is used to specify additional parameters for a request to this ad network.
/// Returns Nil if the network doesn't have publisher provided extras.
+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return [MFAdNetworkExtras class];
}

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    self.rewardedAd = [[GADMMobFoxRewardedAd alloc] init];
    [self.rewardedAd loadRewardedAdForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

@end
