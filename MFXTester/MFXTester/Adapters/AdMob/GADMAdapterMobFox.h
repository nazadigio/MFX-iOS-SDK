//
//  GADMAdapterMobFox.h
//  DemoApp
//
//  Created by Shimi Sheetrit on 6/22/16.
//  Copyright © 2016 Matomy Media Group Ltd. All rights reserved.
//

#import <MFXSDKCore/MFXSDKCore.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
//#import "GADMAdNetworkAdapterProtocol.h"

@interface GADMAdapterMobFox : NSObject <GADMAdNetworkAdapter, MFXBannerAdDelegate, MFXInterstitialAdDelegate>

@property (nonatomic, strong) MFXBannerAd* banner;
@property (nonatomic, strong) MFXInterstitialAd* interstitial;
@property (nonatomic, weak) id <GADMAdNetworkConnector> connector;

@end
