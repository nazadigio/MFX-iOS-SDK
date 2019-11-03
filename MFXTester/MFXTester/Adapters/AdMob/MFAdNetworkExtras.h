//
//  MFAdNetworkExtras.h
//  MFXTester
//
//  Created by Shimon Shnitzer on 25/07/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GADAdNetworkExtras.h>

@interface MFAdNetworkExtras : NSObject <GADAdNetworkExtras>

@property (nonatomic, assign) NSNumber* subject_to_gdpr;
@property (nonatomic, strong) NSString* gdpr_consent;

@property (nonatomic, strong) NSNumber* floor_price;

@property (nonatomic, strong) NSString* demo_age;
@property (nonatomic, strong) NSString* demo_gender;

/*
 + (void)setDemoAge:(NSString *)demo_age;
 + (void)setDemoGender:(NSString *)demo_gender;
 + (void)setDemoKeywords:(NSString *)demo_keywords;
 
 + (void)setLongitude:(NSNumber *)longitude;
 + (void)setLatitude:(NSNumber *)latitude;
 */
@end
