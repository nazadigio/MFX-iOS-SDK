//
//  ViewController.h
//  MFXTester
//
//  Created by ofirkariv on 24/04/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

#import "MFXSDKCore/MFXSDKCore.h"
#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#elif __has_include(<MoPub.h>)
#import <MoPub.h>
#endif

@interface ViewController : UIViewController <MFXBannerAdDelegate, MFXInterstitialAdDelegate, MFXNativeAdDelegate>

@end
