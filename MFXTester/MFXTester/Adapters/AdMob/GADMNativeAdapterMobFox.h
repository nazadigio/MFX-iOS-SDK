//
//  GADMNativeAdapterMobFox.h
//  Adapters
//
//  Created by Shimi Sheetrit on 12/7/16.
//  Copyright © 2016 Matomy Media Group Ltd. All rights reserved.
//

#import <MFXSDKCore/MFXSDKCore.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
//#import "GADMAdNetworkAdapterProtocol.h"

@interface GADMNativeAdapterMobFox : NSObject <GADMAdNetworkAdapter, MFXNativeAdDelegate, GADCustomEventNativeAd>

@property (nonatomic, strong) MFXNativeAd* mfNative;
@property (nonatomic, weak) id <GADMAdNetworkConnector> connector;

- (void)requestNativeAdWithParameter:(NSString *)serverParameter
           request:(GADCustomEventRequest *)request
           adTypes:(NSArray *)adTypes
           options:(NSArray *)options
rootViewController:(UIViewController *)rootViewController;

@end
