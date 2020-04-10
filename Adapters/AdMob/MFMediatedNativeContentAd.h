//
//  MFMediatedNativeContentAd.h
//  Adapters
//
//  Created by Shimi Sheetrit on 1/1/17.
//  Copyright © 2017 Matomy Media Group Ltd. All rights reserved.
//

#import <MFXSDKCore/MFXSDKCore.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface MFMediatedNativeContentAd : NSObject <GADMediatedUnifiedNativeAd>

- (instancetype)initWithMFNativeContentAd:(MFXNativeAd*)mfNative;

@end
