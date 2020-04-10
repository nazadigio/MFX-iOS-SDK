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
#elif __has_include(<MoPub.h>)
#import <MoPub.h>
#else
#import "MPBaseAdapterConfiguration"
#endif

#import "MFXSDKCore/MFXSDKCore.h"
#import "MobFoxMoPubUtils.h"
#import <CoreLocation/CoreLocation.h>

@implementation MobFoxMoPubUtils

+ (void)gdprHandler {
    NSString *subjToGDPR = @"0";
    // checks for gdpr appliant via MoPub
    MPBool gdprApplies = [MoPub sharedInstance].isGDPRApplicable;
    if (gdprApplies == MPBoolUnknown) {
        // if unknown, trying to use shared memory
        subjToGDPR = [[NSUserDefaults standardUserDefaults] stringForKey:@"IABConsent_SubjectToGDPR"];
        if ([subjToGDPR isEqualToString:@"1"]){
            [MobFoxSDK setGDPR:YES];
        } else {
            [MobFoxSDK setGDPR:NO];
        }
    } else if (gdprApplies == MPBoolYes) {
        [MobFoxSDK setGDPR:YES];
    } else {
        [MobFoxSDK setGDPR:NO];
    }
}

@end
