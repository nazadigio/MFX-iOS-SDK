//
//  MFAdNetworkExtras.m
//  MFXTester
//
//  Created by Shimon Shnitzer on 25/07/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import "MFAdNetworkExtras.h"

@implementation MFAdNetworkExtras

- (MFAdNetworkExtras*)init
{
    self = [super init];
    if (self!=nil)
    {
        self.demo_gender     = nil;
        self.demo_age        = nil;
        self.floor_price     = nil;
        self.subject_to_gdpr = nil;
        self.gdpr_consent    = nil;
    }
    return self;
}

@end
