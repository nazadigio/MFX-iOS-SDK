//
//  MobFoxMoPubUtils.m
//  MFXTester
//
//  Created by ofirkariv on 20/08/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#else
#import "MPBaseAdapterConfiguration"
#endif

#import "MFXSDKCore/MFXSDKCore.h"
#import "MobFoxMoPubUtils.h"
#import <CoreLocation/CoreLocation.h>

@implementation MobFoxMoPubUtils

+ (void)gdprHandler{
    
    ///////// GDPR //////////
    
    MPBool gdprApplies = [MoPub sharedInstance].isGDPRApplicable;
    if (gdprApplies != MPBoolUnknown ) {
        if(gdprApplies == MPBoolYes) {
            [MobFoxSDK setGDPR:YES];
            NSString *consentString = [[MoPub sharedInstance] canCollectPersonalInfo] ? @"1" : @"0";
            [MobFoxSDK setGDPRConsentString:consentString];
        } else {
            [MobFoxSDK setGDPR:NO];
            [MobFoxSDK setGDPRConsentString:@"0"];
        }
    }
}


@end
